from fastapi import FastAPI
from generator_and_blob import router as image_router
from auth import router as auth_router
import uvicorn
from pyngrok import ngrok
import nest_asyncio

app = FastAPI()

# Include the routers
app.include_router(auth_router, prefix="/auth")
app.include_router(image_router, prefix="/generator")

if __name__ == "__main__":
    # Set up ngrok
    ngrok_tunnel = ngrok.connect(8000)
    print('Public URL:', ngrok_tunnel.public_url)

    # Nest asyncio allows us to run async code in Jupyter notebooks
    nest_asyncio.apply()

    # Run the FastAPI app
    uvicorn.run(app, port=8000)