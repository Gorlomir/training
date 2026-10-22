from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

DB_USER = "postgres"
DB_PASS = "12345"
DB_HOST = "localhost"
DB_PORT = 5432
DB_NAME = "tictactoe"

engine = create_engine(
    f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

SessionFactory = sessionmaker(engine)