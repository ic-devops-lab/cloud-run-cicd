from collections.abc import AsyncIterator
from logging import Logger
import re

from sqlalchemy.ext.asyncio import AsyncEngine, create_async_engine, async_sessionmaker
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlmodel import select

from ..core.config import settings
from ..core.logging import get_logger

logger: Logger = get_logger(__name__)
safe_url: str = re.sub(r"(?<=://)(.*?)(?=@)", "****", settings.postgres_url)

# Initialize one engine per process
try:
    logger.debug(f"Creating database engine with URL: {safe_url}")
    engine: AsyncEngine = create_async_engine(
        settings.postgres_url,
        echo=(settings.app_env != settings.app_prod_env_name),
        pool_pre_ping=True,
    )
    logger.info(f"Database engine created successfully for URL: {safe_url}")
except Exception as e:
    logger.error(f"Error creating the database engine: for URL {safe_url}:\n{str(e)}")
    logger.debug(f"Full error details: {e}", exc_info=True)
    raise


# One session factory per process
SessionLocal: async_sessionmaker[AsyncSession] = async_sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
    autoflush=False,
    autocommit=False,
)


# one AsyncSession per request
async def get_session() -> AsyncIterator[AsyncSession]:
    async with SessionLocal() as session:
        try:
            yield session
        except Exception as _:
            logger.error("Error occurred during database session.")
            await session.rollback()
            raise


async def init_db() -> None:
    """Initialize the database connection."""
    logger.debug(f"Initializing database connection with URL: {safe_url}")
    try:
        async with SessionLocal() as session:
            await session.exec(select(1))
            logger.info("Database connection initialized successfully.")
    except Exception as e:
        logger.error(f"Error initializing the database: {e}")
        raise


async def close_db() -> None:
    """Close the database connection."""
    try:
        await engine.dispose()
    except Exception as e:
        logger.error(f"Error closing the database connection: {e}")
        raise
