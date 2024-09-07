from __future__ import annotations
from fastapi import APIRouter, HTTPException, Request, Depends
from azure.storage.blob import BlobServiceClient
from pydantic import BaseModel
from typing import Optional
import torch
import math
import numpy as np
import torch
import os
import random
import base64
from io import BytesIO
import zipfile
from PIL import Image
from diffusers import StableDiffusionXLPipeline, EulerAncestralDiscreteScheduler
import io
from auth import get_current_active_user

# Initialize the router
router = APIRouter()

# Azure Blob Storage connection string
connect_str = ''
container_name = "madprojectcontainer"

# Create a BlobServiceClient
blob_service_client = BlobServiceClient.from_connection_string(connect_str)
container_client = blob_service_client.get_container_client(container_name)

# Load the model (you might want to do this outside the FastAPI app in a production setting)
device = "cuda:0" if torch.cuda.is_available() else "cpu"
pipe = StableDiffusionXLPipeline.from_pretrained(
        "fluently/Fluently-XL-v4",
        torch_dtype=torch.float16,
        use_safetensors=True,
    )
pipe.scheduler = EulerAncestralDiscreteScheduler.from_config(pipe.scheduler.config)
pipe.load_lora_weights("ehristoforu/dalle-3-xl-v2", weight_name="dalle-3-xl-lora-v2.safetensors", adapter_name="dalle")
pipe.set_adapters("dalle")
pipe.to(device)

def randomize_seed_fn(seed, randomize_seed):
    if randomize_seed:
        return random.randint(0, 2**32 - 1)
    return seed

class CustomImageRequest(BaseModel):
    user_id: str = "none"
    instruction: str = "Eiffel tower"
    steps: int = 8
    randomize_seed: bool = False
    seed: int = 25
    width: int = 1024
    height: int = 1024
    guidance_scale: float = 6.2
    use_resolution_binning: bool = True

class ParameterizedImageRequest(BaseModel):
    user_id: str = "none"
    gender: str = "male"
    skinTone: str = "white"
    bodyType: str = "slim"
    hairColor: str = "black"
    clothingTop: str = "shirt"
    clothingBottom: str = "short"
    steps: int = 8
    randomize_seed: bool = False
    seed: int = 25
    width: int = 1024
    height: int = 1024
    guidance_scale: float = 6.2
    use_resolution_binning: bool = True

@router.post("/generate-custom-image")
async def generate_and_store_custom_image(request: CustomImageRequest, current_user: str = Depends(get_current_active_user)):
    try:
        # Get userId from the request
        user_id = request.user_id
        
        seed = int(randomize_seed_fn(request.seed, request.randomize_seed))
        generator = torch.Generator().manual_seed(seed)

        options = {
            "prompt": request.instruction,
            "width": request.width,
            "height": request.height,
            "guidance_scale": request.guidance_scale,
            "num_inference_steps": request.steps,
            "generator": generator,
            "use_resolution_binning": request.use_resolution_binning,
            "output_type": "pil",
        }

        output_image = pipe(**options).images[0]

        # List blobs in the user's folder to determine the next number
        user_folder = f"{user_id}/"
        blobs = list(container_client.list_blobs(name_starts_with=user_folder))
        next_number = len(blobs) + 1

        # Generate a unique filename
        filename = f"{user_id}/image_{next_number}.png"

        # Convert the image to bytes
        img_byte_arr = io.BytesIO()
        output_image.save(img_byte_arr, format='PNG')
        img_byte_arr = img_byte_arr.getvalue()

        # Upload the image to Azure Blob Storage
        blob_client = container_client.get_blob_client(filename)
        blob_client.upload_blob(img_byte_arr, overwrite=True)
        
        # Get the URL of the uploaded image
        image_url = blob_client.url
        
        return {"image_url": image_url}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@router.post("/generate-parameterized-image")
async def generate_and_store_parameterized_image(request: ParameterizedImageRequest, current_user: str = Depends(get_current_active_user)):
    try:
        # Get userId from the request
        user_id = request.user_id
        
        seed = int(randomize_seed_fn(request.seed, request.randomize_seed))
        generator = torch.Generator().manual_seed(seed)

        prompt = f"""Generate a photorealistic image of a person with the following characteristics:
                    
                    Gender: {request.gender}
                    Skin tone: {request.skinTone}
                    Body type: {request.bodyType}
                    Hair color: {request.hairColor}
                    Top clothing: {request.clothingTop}
                    Bottom clothing: {request.clothingBottom}

                    The person should be standing in a neutral pose against a plain background. Ensure the lighting is even and flattering, highlighting the specified features. The image should be high-resolution and detailed."""

        options = {
            "prompt": prompt,
            "width": request.width,
            "height": request.height,
            "guidance_scale": request.guidance_scale,
            "num_inference_steps": request.steps,
            "generator": generator,
            "use_resolution_binning": request.use_resolution_binning,
            "output_type": "pil",
        }

        output_image = pipe(**options).images[0]

        # Create a BlobServiceClient
        blob_service_client = BlobServiceClient.from_connection_string(connect_str)
        container_client = blob_service_client.get_container_client(container_name)

        # List blobs in the user's folder to determine the next number
        user_folder = f"{user_id}/"
        blobs = list(container_client.list_blobs(name_starts_with=user_folder))
        next_number = len(blobs) + 1

        # Generate a unique filename
        filename = f"{user_id}/image_{next_number}.png"

        # Convert the image to bytes
        img_byte_arr = io.BytesIO()
        output_image.save(img_byte_arr, format='PNG')
        img_byte_arr = img_byte_arr.getvalue()

        # Upload the image to Azure Blob Storage
        blob_client = container_client.get_blob_client(filename)
        blob_client.upload_blob(img_byte_arr, overwrite=True)
        
        # Get the URL of the uploaded image
        image_url = blob_client.url
        
        return {"image_url": image_url}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/get-user-gallery")
async def get_user_gallery_urls(user_id: str, current_user: str = Depends(get_current_active_user)):
    try:
        # Create a BlobServiceClient
        blob_service_client = BlobServiceClient.from_connection_string(connect_str)
        container_client = blob_service_client.get_container_client(container_name)

        # List blobs in the user's folder
        user_folder = f"{user_id}/"
        blobs = container_client.list_blobs(name_starts_with=user_folder)

        # Get the URLs for all blobs
        image_urls = []
        for blob in blobs:
            blob_client = container_client.get_blob_client(blob.name)
            image_urls.append(blob_client.url)

        return image_urls

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred: {str(e)}")