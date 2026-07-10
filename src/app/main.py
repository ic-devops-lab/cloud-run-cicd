from contextlib import asynccontextmanager
from logging import Logger

from fastapi import FastAPI, Depends
from sqlalchemy import ScalarResult
from sqlmodel import select
from sqlmodel.ext.asyncio.session import AsyncSession

from .core.config import settings
from .core.logging import get_logger
from .db.connector import init_db, close_db, get_session

logger: Logger = get_logger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Lifespan context manager for the FastAPI application."""
    logger.info("Starting up the application...")

    logger.info("Initializing the database connection...")
    await init_db()
    logger.info("Database connection initialized successfully.")

    yield

    logger.info("Closing the database connection...")
    await close_db()
    logger.info("Database connection closed successfully.")

    logger.info("Shutting down the application...")


app: FastAPI = FastAPI(
    title=settings.app_name, version=settings.app_version, lifespan=lifespan
)


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
async def readiness_probe(
    session: AsyncSession = Depends(get_session),
) -> dict[str, str]:
    """Readiness probe endpoint."""

    app_check: bool = True  # Placeholder for actual app health check logic

    db_check_result: ScalarResult[int] = await session.exec(select(1))
    db_check: bool = db_check_result.first() is not None

    return {
        "global_status": "ok" if (app_check and db_check) else "failed",
        "app": "ok" if app_check else "failed",
        "db": "ok" if db_check else "failed",
    }
