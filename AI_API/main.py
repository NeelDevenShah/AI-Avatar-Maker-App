from __future__ import annotations
from fastapi import FastAPI, HTTPException
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
from pyngrok import ngrok

app = FastAPI()

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

def randomize_seed_fn(seed, randomize_seed):
    if randomize_seed:
        return random.randint(0, 2**32 - 1)
    return seed

class ImageRequest(BaseModel):
    user_id: str = "none"
    instruction: str = "Eiffel tower"
    steps: int = 8
    randomize_seed: bool = False
    seed: int = 25
    width: int = 1024
    height: int = 1024
    guidance_scale: float = 6.2
    use_resolution_binning: bool = True

@app.post("/generate-image")
async def generate_image(request: ImageRequest):
    try:
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

        # Generate a unique filename
        filename = f"user_{request.user_id}_{random.randint(0, 100000)}.png"

        # Create the path to the tmp folder
        tmp_folder = "/tmp"

        # Save the image to the tmp folder with the unique filename
        output_image.save(os.path.join(tmp_folder, filename))

        # Convert the image to base64
        with open(os.path.join(tmp_folder, filename), "rb") as f:
            img_bytes = f.read()
        img_str = base64.b64encode(img_bytes).decode()

        return {"image": img_str}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/generate-dummy-image")
async def generate_dummy(request: ImageRequest):
    return {"image": "/tmp/dummy.png"}

if __name__ == "__main__":
    # Set up ngrok
    ngrok_tunnel = ngrok.connect(8000)
    print('Public URL:', ngrok_tunnel.public_url)

    # Nest asyncio allows us to run async code in Jupyter notebooks
    nest_asyncio.apply()

    # Run the FastAPI app
    uvicorn.run(app, port=8000)