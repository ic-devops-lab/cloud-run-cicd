import logging

from .config import settings

LogLevel = int | None


def get_logger(name: str, level: str = settings.log_level) -> logging.Logger:
    """Get a logger instance with the specified name."""
    log_level: LogLevel = getattr(logging, level.upper(), logging.INFO)

    logging.basicConfig(
        level=log_level,
        format="%(asctime)s [%(levelname)-8s] %(name)s %(lineno)d: %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )

    logger: logging.Logger = logging.getLogger(name)

    efferctive_log_level: str = logging.getLevelName(logger.getEffectiveLevel())
    logger.info(f"Logger initialized for {name} with level {efferctive_log_level}")
    logger.debug(
        f"Desired log level: {level}, resolved log level: {efferctive_log_level}"
    )

    return logger
