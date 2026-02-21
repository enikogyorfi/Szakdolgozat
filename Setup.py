import mlflow
from dotenv import load_dotenv
import os
def setup_environment(repo_name: str):
    # MLflow és .env betöltése
    load_dotenv()

    # MLflow URI beállítása (ugyanaz a logika, mint korábban)
    MLFLOW_TRACKING_URI = os.getenv("MLFLOW_TRACKING_URI")
    if MLFLOW_TRACKING_URI:
        mlflow.set_tracking_uri(MLFLOW_TRACKING_URI)
        os.environ['MLFLOW_TRACKING_USERNAME'] = os.getenv("MLFLOW_TRACKING_USERNAME")
        os.environ['MLFLOW_TRACKING_PASSWORD'] = os.getenv("MLFLOW_TRACKING_PASSWORD")
        mlflow.set_experiment(repo_name)
    else:
        print("MLflow URI nincs beállítva.")