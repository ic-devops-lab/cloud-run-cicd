-- Set up default values
\set app_db 'app_db'
\set app_user 'app_user'
\set app_pw 'app_pass'

-- Try to read environment variables
\getenv app_db POSTGRES_DB
\getenv app_user POSTGRES_USER
\getenv app_pw POSTGRES_PASSWORD

-- Create db user
CREATE USER :app_user WITH PASSWORD :'app_pw';

-- Create db
CREATE DATABASE :app_db;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE :app_db TO :app_user;