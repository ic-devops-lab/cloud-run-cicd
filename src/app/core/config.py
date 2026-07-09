from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    app_name: str = "cloud-run-cicd"
    app_version: str = "0.1.0"
    env: str = "dev"

    class Config:
        env_file: str = ".env"


settings = Settings()
