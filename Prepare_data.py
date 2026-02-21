def clean_data(data, col_year, col_feature, col_area,col_target, begin_year, end_year):
    """
    Prepare the data by selecting relevant columns and removing rows with missing values.
    Parameters:
    data (pd.DataFrame): The input DataFrame containing the data.
    col_year (str): The name of the column representing years.
    col_feature (list): A list of feature column names to be retained.
    col_area (str): The name of the column representing area.

    Returns:
    pd.DataFrame: A cleaned DataFrame with specified columns and no missing values.
    """
    # Select relevant columns
    relevant_columns = [col_year] + col_feature + [col_area]
    cleaned_data = data[relevant_columns]
    cleaned_data = cleaned_data[(cleaned_data[col_year] >= begin_year) & (cleaned_data[col_year] <= end_year)]

    # Drop rows with any missing values
    cleaned_data = cleaned_data.dropna()

    # Reset index
    cleaned_data = cleaned_data.reset_index(drop=True)
    Results_per_target = cleaned_data.groupby([col_area, col_year, col_target]).size().reset_index(name='counts')
    Results_per_year = cleaned_data.groupby([col_area, col_year]).size().reset_index(name='counts')
    return Results_per_target, Results_per_year

def create_lagged_feature(data, col_feature, lag_period):
    df_lagged = data.copy()
    for i in range(1, lag_period+1):
        df_lagged[f'{col_feature}_{i}'] = df_lagged.groupby('Community Area')[col_feature].shift(i)
    df_lagged = df_lagged.dropna()
    return df_lagged

def rolling_mean(data, col_feature, window_size):
    rolling_mean = data.copy()
    for i in range(1, window_size+1):
        rolling_mean[f'{col_feature}_{i}_rollingmean'] = (rolling_mean.groupby('Community Area')[col_feature]
                                    .shift(1)
                                    .rolling(window=i)
                                    .mean()
                                    .reset_index(level=0, drop=True))
    rolling_mean = rolling_mean.dropna()
    return rolling_mean

def fill_missing_year_area_combinations(data,primary_type, all_year, all_area, year_col='Year', area_col='Community Area', count_col='counts'):
    """
    Kitölti a hiányzó Year-Community Area kombinációkat 0-val vagy interpolációval.

    Parameters:
    data (pd.DataFrame): Bemeneti adatok
    year_col (str): Az év oszlop neve
    area_col (str): A community area oszlop neve
    count_col (str): A count oszlop neve

    Returns:
    pd.DataFrame: Kitöltött adatok
    """
    import pandas as pd

    # Összes lehetséges év és community area kombináció
    all_years = all_year
    all_areas = all_area
    primary_type = primary_type

    # Teljes grid létrehozása
    full_grid = pd.MultiIndex.from_product(
        [all_areas, all_years, primary_type],
        names=[area_col, year_col, 'Primary Type']
    ).to_frame(index=False)

    # Merge az eredeti adatokkal
    filled_data = full_grid.merge(data, on=[area_col, year_col, 'Primary Type'], how='left')

    # Counts oszlop kitöltése 0-val ahol hiányzik
    filled_data[count_col] = filled_data[count_col].fillna(0)

    # Egyéb numerikus oszlopok kitöltése forward fill + backward fill módszerrel community area-nként
    numeric_cols = filled_data.select_dtypes(include=['float64', 'int64']).columns
    numeric_cols = [col for col in numeric_cols if col not in [year_col, area_col, count_col, 'Primary Type']]

    if len(numeric_cols) > 0:
        filled_data[numeric_cols] = (filled_data.groupby(area_col)[numeric_cols]
                                     .ffill()
                                     .bfill())

    # Rendezés
    filled_data = filled_data.sort_values([area_col, year_col]).reset_index(drop=True)

    return filled_data
