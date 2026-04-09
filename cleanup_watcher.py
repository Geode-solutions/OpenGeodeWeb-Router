import os
import time
import requests
from google.cloud import run_v2

PROJECT = os.getenv("GOOGLE_CLOUD_PROJECT")
REGION = os.getenv("GOOGLE_CLOUD_REGION", "us-central1")
SERVICE_NAME = os.getenv("K_SERVICE")

HEARTBEAT_URL = "http://127.0.0.1:5000/health"


def delete_service():
    if not PROJECT or not SERVICE_NAME:
        print("Cannot delete: missing env vars")
        return
    client = run_v2.ServicesClient()
    name = f"projects/{PROJECT}/locations/{REGION}/services/{SERVICE_NAME}"
    try:
        print(f"Flask appears down → Deleting service {name}")
        client.delete_service(name=name)
    except Exception as e:
        print(f"Delete failed: {e}")


while True:
    time.sleep(60)
    delete_service()
    break
    # try:
    #     r = requests.get(HEARTBEAT_URL, timeout=5)
    #     if r.status_code != 200:
    #         raise Exception("Bad status")
    # except Exception:
    #     delete_service()
    #     break
