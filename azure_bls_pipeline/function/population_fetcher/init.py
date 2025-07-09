import logging
import os
import requests
import json
import pandas as pd
from datetime import datetime
from azure.storage.blob import BlobServiceClient, ContentSettings
import azure.functions as func

#### function that calls population API and writes results to blob storage as json file

def main(mytimer: func.TimerRequest) -> None:
    logging.info("Azure Function triggered to fetch population data.")

    # Load environment variables
    storage_account = os.getenv("STORAGE_ACCOUNT_NAME")
    storage_key = os.getenv("STORAGE_ACCOUNT_KEY")
    population_url = os.getenv("POPULATION_URL")
    container_name = os.getenv("BLOB_CONTAINER", "bls")
    blob_name = f"population_{datetime.utcnow().strftime('%Y%m%d')}.json"
    blob = 'output'

    # Step 1: Fetch population data
    response = requests.get(population_url)
    response.raise_for_status()
    population_data = response.json()

    # Step 2: Convert to DataFrame
    population_string = json.dumps(population_data)
    population_list = [json.loads(population_string)]
    population_pdf = pd.DataFrame(population_list)

    # Step 3: Convert DataFrame to JSON string
    json_output = population_pdf.to_json(orient="records", indent=2)

    # Step 4: Upload to Azure Blob Storage
    blob_service_client = BlobServiceClient(
        account_url=f"https://{storage_account_name}.blob.core.windows.net",
        credential=storage_key
    )
    blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_name)

    blob_client.upload_blob(
        json_output,
        overwrite=True,
        content_settings=ContentSettings(content_type="application/json")
    )

    logging.info(f"✅ Population data written to blob: {container_name}/{blob_name}")
