from uuid import UUID
from sqlalchemy import Column, String

from datasource.db.base import Base

class UserDs(Base):
    __tablename__ = "users"
    uuid = Column(String, primary_key=True)
    login = Column(String, unique=True, nullable=False)
    hashed_pswd = Column(String, nullable=False)

    def __init__(self, uuid: UUID, login: str, hashed_pswd: str):
        self.uuid = str(uuid)
        self.login = login
        self.hashed_pswd = hashed_pswd