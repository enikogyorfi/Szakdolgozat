import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
def extrapolacio(data, feature, col, col_area, degree, target_year):
    data = data.sort_values(by=col)
    rows = []
    areas = data[col_area].unique()
    for i in areas:
        data_area = data[data[col_area] == i].sort_values(by=col)
        x = data_area[col].to_numpy()
        row = {
            'Year': target_year,
            'Community Area': i
        }

        for r in feature:
            y = data_area[r].to_numpy()
            coef = np.polyfit(x, y, degree)
            poly_fn = np.poly1d(coef)
            y_pred = poly_fn(target_year)
            row[r] = y_pred
        rows.append(row)
    Results = pd.DataFrame(rows)
    return Results

def visualitzacio_extrapolacio(data, feature, col, col_area):
    for i in col_area:
        data_area = data[data["Community Area"] == i]
        for j in feature:
            plt.figure(figsize=(10, 6))
            plt.plot(data_area[col], data_area[j], marker='o')
            plt.title(f'{j} in Community Area {i} over Years')
            plt.xlabel('Year')
            plt.ylabel(j)
            plt.grid()
            plt.show()