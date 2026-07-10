from pydantic import computed_field
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "cloud-run-cicd"
    app_version: str = "0.1.0"
    app_env: str = "dev"  # use 'prod' for production
    app_prod_env_name: str = "prod"

    log_level: str = "INFO"

    port: int = 8080

    postgres_host: str = "localhost"
    postgres_port: int = 5432
    postgres_db: str = "app_db"
    postgres_user: str = "app_user"
    postgres_password: str = "app_pass"

    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    @computed_field
    @property
    def postgres_url(self) -> str:
        """Construct the PostgreSQL URL from individual components."""
        return (
            f"postgresql+asyncpg://{self.postgres_user}:{self.postgres_password}"
            f"@{self.postgres_host}:{self.postgres_port}/{self.postgres_db}"
        )


settings = Settings()
