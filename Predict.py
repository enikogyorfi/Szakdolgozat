import pickle

from sklearn.model_selection import (train_test_split, KFold,GridSearchCV,
                                     StratifiedKFold, RandomizedSearchCV, TimeSeriesSplit)
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import mlflow
import os
import seaborn as sns
import shap
from sklearn.inspection import permutation_importance
from sklearn.model_selection import cross_val_predict
from sklearn.base import clone
plt.rcParams["figure.facecolor"] = "white"
plt.rcParams["axes.facecolor"] = "white"
plt.rcParams["savefig.facecolor"] = "white"
plt.rcParams.update({
    "figure.facecolor": "white",
    "axes.facecolor": "white",
    "savefig.facecolor": "white"})

FEATURE_NAME_HU = {
    "Year": "Év",
    "Community Area": "Közösségi terület",
    "counts_1": "Bűnesetszám 1 év késleltetéssel",
    "counts_2": "Bűnesetszám 2 év késleltetéssel",
    "counts_3": "Bűnesetszám 3 év késleltetéssel",
    "counts_1_rollingmean": "1 éves mozgóátlag",
    "counts_2_rollingmean": "2 éves mozgóátlag",
    "counts_3_rollingmean": "3 éves mozgóátlag",
    "total_pop": "Teljes népesség",
    "poverty_rate": "Szegénységi ráta",
    "male_15_34_rate": "15-34 éves férfiak aránya",
    "employment_rate": "Foglalkoztatottsági ráta",
    "unemployment_rate": "Munkanélküliségi ráta",
    "no_hs_25plus_rate": "Érettségi nélküliek aránya",
    "per_capita_income": "Egy főre jutó jövedelem",
    "weighted_avg_income": "Súlyozott átlagjövedelem",
}


def feature_display_names(feature_names):
    return [FEATURE_NAME_HU.get(feature, feature) for feature in feature_names]


def train_test_split(data, features, target, test_year):
    df = data.copy()
    df["Year"] = pd.to_numeric(df["Year"], errors="coerce")

    train_mask = df["Year"] < test_year
    test_mask  = df["Year"] == test_year

    X_train = df.loc[train_mask, features]
    y_train = df.loc[train_mask, target]

    X_test  = df.loc[test_mask, features]
    y_test  = df.loc[test_mask, target]

    return X_train, y_train, X_test, y_test



def hyperparameter_tuning(model, name,X_train, y_train):
    model_dir = "Models"
    os.makedirs(model_dir, exist_ok=True)
    tscsv = TimeSeriesSplit(n_splits=5)
    param_random = {
        'criterion': ['absolute_error', 'squared_error'],
        'n_estimators': [int(x) for x in np.linspace(start=100, stop=1000, num=20)],
        'min_samples_split': [2, 5, 10, 20],
        'min_samples_leaf': [1, 2, 4, 8],
        'max_features': ["sqrt", "log2", 0.3, 0.5, 0.7, None],
        'max_depth': [int(x) for x in np.linspace(1, 50, num=10)],
        'bootstrap': [True, False]
    }

    random_search = RandomizedSearchCV(model, param_random,
                                       cv=tscsv,
                                       n_iter=50,
                                       verbose=2,
                                       random_state=42,
                                       n_jobs=4,
                                       scoring='neg_mean_squared_error')
    with mlflow.start_run(run_name=f'{name}_Hyperparameter_Tuning'):
        random_search.fit(X_train, y_train)
        best_model = random_search.best_estimator_
        best_model_path = os.path.join(model_dir, f'{name}_model.pkl')
        pickle.dump(best_model, open(best_model_path, 'wb'))
        mlflow.log_params(random_search.best_params_)
    return best_model

def wmape(y_true, y_pred):
    y_true = np.array(y_true)
    y_pred = np.array(y_pred)

    numerator = np.sum(np.abs(y_true - y_pred))
    denominator = np.sum(np.abs(y_true))

    if denominator == 0:
        return np.nan  # nincs esemény az egész tesztben

    return numerator / denominator * 100

def predict(model, name, X_test, y_test, WMAPE=False):
    with mlflow.start_run(run_name=f'{name}_Predictions'):
        y_pred = model.predict(X_test)

        Results = pd.DataFrame({'Community Area': X_test['Community Area'],
                               'Actual': y_test, 'Predicted': y_pred})
        Results["error"] = Results["Actual"] - Results["Predicted"]
        errors = Results["error"].abs()
        MSE = np.mean(errors**2)
        RMSE = np.sqrt(MSE)

        if WMAPE:
            wmape_score = wmape(y_test, y_pred)
        else:
            MAPE = np.mean(errors / y_test) * 100
            Accuracy = 100-MAPE
            MAE = np.mean(abs(errors))

        Max_Error = max(errors)
        metrics = {
            'MSE': MSE,
            'RMSE': RMSE,
            'WMAPE': wmape_score if WMAPE else 0,
            'MAPE': MAPE if not WMAPE else 0,
            'Accuracy': Accuracy if not WMAPE else 0,
            'MAE': MAE if not WMAPE else 0,
            'Max_Error': Max_Error
        }
        mlflow.log_metrics(metrics)

    return Results, Max_Error, metrics

def Scatter_plot(Results):
    plt.figure(figsize=(10, 6))
    plt.scatter(Results['Actual'], Results['Predicted'], alpha=0.5)
    plt.plot([Results['Actual'].min(), Results['Actual'].max()], [Results['Actual'].min(), Results['Actual'].max()], 'r--')
    plt.title('Valós vs Predikált értékek', color = 'black')
    plt.xlabel('Valós értékek', color = 'black', fontsize = 15)
    plt.ylabel('Predikált értékek', color = 'black', fontsize = 15)
    ax = plt.gca()
    ax.set_axisbelow(True)
    ax.grid(True, linestyle="--", linewidth=0.6, alpha=0.5)


def Histogram(Results, area_col, target_col):

    top = Results.nlargest(10, target_col)[[area_col, target_col]]
    bottom = Results.nsmallest(10, target_col)[[area_col, target_col]]
    # összefűzés (bottom + top)
    plot_df = np.concatenate([bottom.values, top.values], axis=0)
    llabels = plot_df[:, 0]
    values = plot_df[:, 1].astype(float)
    plt.figure(figsize=(10, 6))
    plt.bar(range(len(values)), values)
    plt.axhline(0)
    plt.xticks(range(len(values)), llabels, rotation=45, ha="right")
    plt.ylabel("Predicted - Actual")
    plt.title("Top and Bottom 10 Errors by Community Area")
    plt.tight_layout()

def feature_importance(model, X_train):
    importances = model.feature_importances_
    feature_names = feature_display_names(X_train.columns)
    plt.figure(figsize=(12, 8))
    feature_importances = pd.Series(importances, index=feature_names).sort_values(ascending=False)
    sns.set_style("white")
    ax =sns.barplot(x=feature_importances, y=feature_importances.index)
    ax.set_title("Változók fontossága", color="black")
    ax.set_xlabel("Fontossági érték", color="black")
    ax.set_ylabel("Változó", color="black")
    ax.tick_params(axis="y", labelsize=20)
    ax.tick_params(axis='x', labelsize=20)

def shap_summary(model, X_test):
    explainer = shap.TreeExplainer(model)
    shap_values = explainer.shap_values(X_test)
    X_test_display = X_test.copy()
    X_test_display.columns = feature_display_names(X_test.columns)
    shap.summary_plot(shap_values, X_test_display, show=False)
    shap.summary_plot(shap_values, X_test_display, plot_type="bar", show=False)
    plt.title('SHAP összefoglaló')



def permutation_importance_plot(model, X_test, y_test, feature_names):
    perm = permutation_importance(model, X_test, y_test, n_repeats=10, random_state=42)
    perm_importance = pd.DataFrame({
        'Feature': feature_display_names(feature_names),
        'Importance': perm.importances_mean,
        'Type': 'Validation (Permutation)'
    }).sort_values(by='Importance', ascending=False)
    plt.figure(figsize=(12, 8))
    ax = sns.barplot(x=perm_importance['Importance'], y=perm_importance['Feature'])
    ax.set_title('Permutációs változófontosság', color = 'black')
    ax.set_xlabel('Átlagos fontosság', color = 'black')
    ax.set_ylabel('Változó', color = 'black')
    ax.tick_params(axis='y', labelsize=20)
    ax.tick_params(axis='x', labelsize=20)

def permutation_importance_table(model, name, X_test, y_test, feature_names):
    Result_tables_dir = "Results_tables"
    os.makedirs(Result_tables_dir, exist_ok=True)
    with mlflow.start_run(run_name=f'{name}_Permutation_Importance'):
        perm = permutation_importance(model, X_test, y_test, n_repeats=10, random_state=42)
        perm_importance_table = pd.DataFrame({
            'Feature': feature_names,
            'Importance_Mean': perm.importances_mean,
            'Importance_Std': perm.importances_std,
            'Type': 'Test (Permutation)'
        }).sort_values(by='Importance_Mean', ascending=False)
        table_path = os.path.join(Result_tables_dir, f'{name}_permutation_importance.csv')
        perm_importance_table.to_csv(table_path, index=False)
        mlflow.log_artifact(table_path, artifact_path="Result_tables")
    return perm_importance_table

def shap_table(model,name, X_train):
    Result_tables_dir = "Results_tables"
    os.makedirs(Result_tables_dir, exist_ok=True)
    with mlflow.start_run(run_name=f'{name}_SHAP_values'):
        explainer = shap.TreeExplainer(model)
        shap_values = explainer.shap_values(X_train)
        shap_df = pd.DataFrame({
            "Feature": feature_display_names(X_train.columns),
            "Mean_ABS_SHAP_Value": np.abs(shap_values).mean(axis=0),
            "Mean_SHAP": shap_values.mean(axis=0)
            }).sort_values(by="Mean_ABS_SHAP_Value",  ascending=False)
        table_path = os.path.join(Result_tables_dir, f'{name}_shap_values.csv')
        shap_df.to_csv(table_path, index=False)
        mlflow.log_artifact(table_path, artifact_path="Result_tables")
    return shap_df


def visualitzacio(Results, name, model, X_train, X_test, y_test):
    images_dir = "Images"
    os.makedirs(images_dir, exist_ok=True)
    with mlflow.start_run(run_name=f'{name}_Visualizations'):
        Scatter_plot(Results)
        full_path = os.path.join(images_dir, f'{name}_Results_scatter.png')
        plt.tight_layout()
        plt.savefig(full_path,  dpi=300, bbox_inches='tight')
        plt.close()
        mlflow.log_artifact(full_path, artifact_path="plots")
        plt.show()
        Histogram(Results, "Community Area", "error")
        full_path = os.path.join(images_dir, f'{name}_Results_histogram.png')
        plt.tight_layout()
        plt.savefig(full_path,  dpi=300, bbox_inches='tight')
        plt.close()
        mlflow.log_artifact(full_path, artifact_path="plots")
        plt.show()
        feature_importance(model, X_train)
        full_path = os.path.join(images_dir, f'{name}_Feature_importance.png')
        plt.tight_layout()
        plt.savefig(full_path,  dpi=300, bbox_inches='tight')
        plt.close()
        mlflow.log_artifact(full_path, artifact_path="plots")
        plt.show()
        shap_summary(model, X_test)
        full_path = os.path.join(images_dir, f'{name}_shap_summary.png')
        plt.tight_layout()
        plt.savefig(full_path,  dpi=300, bbox_inches='tight')
        plt.close()
        mlflow.log_artifact(full_path, artifact_path="plots")
        plt.show()
        permutation_importance_plot(model, X_test, y_test, X_train.columns)
        full_path = os.path.join(images_dir, f'{name}_permutation_importance.png')
        plt.tight_layout()
        plt.savefig(full_path,  dpi=300, bbox_inches='tight')
        plt.close()
        mlflow.log_artifact(full_path, artifact_path="plots")


def prediction(data, features,path_name, name, target, test_year, model, WMAPE=False):
    X_train, y_train, X_test, y_test = train_test_split(data, features, target, test_year)
    #try to load the saved model from the previous run
    try:
        with open(path_name, 'rb') as f:
            best_model = pickle.load(f)
    except FileNotFoundError:
        best_model = hyperparameter_tuning(model, name, X_train, y_train)
    Results, Max_Error, metrics = predict(best_model, name, X_test, y_test, WMAPE)
    visualitzacio(Results, name, best_model, X_train, X_test, y_test)
    Permutation_table = permutation_importance_table(best_model, name, X_test, y_test, features)
    SHAP_table = shap_table(best_model, name, X_train)
    return Results, Max_Error, metrics, best_model, Permutation_table, SHAP_table

def residual_model(data, name, rolling_features, demo_features, target, test_year, model):
    X_train, y_train, X_test, y_test = train_test_split(data, rolling_features, target, test_year)
    X_train_demo, y_train_demo, X_test_demo, y_test_demo = train_test_split(data, demo_features, target, test_year)
    best_model = hyperparameter_tuning(model,name, X_train, y_train)
    y_train_pred = best_model.predict(X_train)
    y_test_pred = best_model.predict(X_test)
    residuals_train = (y_train - y_train_pred)
    residuals_test = y_test - y_test_pred
    name_residuals = f'{name}_residuals'

    best_model_residuals = hyperparameter_tuning(model, name_residuals, X_train_demo, residuals_train)
    Results_test_pred, Max_Error_res, metrics_res = predict(best_model_residuals, name_residuals, X_test_demo, residuals_test, WMAPE=True)
    visualitzacio(Results_test_pred, name_residuals, best_model_residuals, X_train_demo, X_test_demo, residuals_test)
    y_pred_final = y_test_pred + Results_test_pred['Predicted']
    with mlflow.start_run(run_name=f'{name}_final'):
        Results_final = pd.DataFrame({'Community Area': X_test['Community Area'],
                                      'Actual': y_test, 'Predicted': y_pred_final})
        Results_final["error"] = Results_final["Actual"] - Results_final["Predicted"]
        errors = Results_final["error"].abs()
        MSE = np.mean(errors ** 2)
        RMSE = np.sqrt(MSE)
        MAPE = np.mean(errors / y_test) * 100
        Accuracy = 100 - MAPE

        Max_Error = max(errors)
        metrics_final = {
            'MSE': MSE,
            'RMSE': RMSE,
            'MAPE': MAPE,
            'Accuracy': Accuracy,
            'Max_Error': Max_Error
        }
        mlflow.log_metrics(metrics_final)

    return Results_test_pred, metrics_res, Results_final, metrics_final
