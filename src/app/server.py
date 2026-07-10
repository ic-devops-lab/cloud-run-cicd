from logging import Logger

import uvicorn

from .core.config import settings
from .core.logging import get_logger

logger: Logger = get_logger(__name__)


def start() -> None:
    logger.info("Starting the FastAPI application...")

    reload: bool = settings.app_env != settings.app_prod_env_name

    uvicorn.run("app.main:app", host="0.0.0.0", port=settings.port, reload=reload)


if __name__ == "__main__":
    start()
