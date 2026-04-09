import os
import time
import requests
from google.cloud import run_v2


PARENT = os.getenv("PARENT")
SERVICE_NAME = os.getenv("K_SERVICE")


def delete_service():
    print("Deleting service")
    client = run_v2.ServicesClient()
    name = f"{PARENT}/services/{SERVICE_NAME}"
    try:
        print(f"Flask appears down → Deleting service {name}")
        client.delete_service(name=name)
    except Exception as e:
        print(f"Delete failed: {e}")


while True:
    time.sleep(30)
    try:
        response = requests.get("http://127.0.0.1/geode/health", timeout=5)
        print("response", response, flush=True)
        if response.status_code != 200:
            raise Exception("Bad status")
    except Exception:
        delete_service()
        break
