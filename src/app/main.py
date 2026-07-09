from fastapi import FastAPI


from .core.config import settings


app: FastAPI = FastAPI(title=settings.app_name, version=settings.app_version)


@app.get("/")
async def root() -> dict[str, str]:
    """App root endpoint."""
    return {
        "message": f"Welcome to {settings.app_name} running on {settings.app_env} environment!"
    }


@app.get("/health")
async def liveness_probe() -> dict[str, str]:
    """Liveness probe endpoint."""
    return {"status": "ok"}


@app.get("/status")
async def readiness_probe() -> dict[str, str]:
    """Readiness probe endpoint."""
    return {"status": "ok", "app": "ok", "db": "ok"}
