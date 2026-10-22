from sqlalchemy import String, Integer, Column
import json

from datasource.db.base import Base

class GameBoardDs(Base):
    __tablename__ = "game_boards"

    id = Column(Integer, primary_key=True, autoincrement=True)
    state = Column(String, nullable=False)

    def __init__(self, state: list[list[int]]):
        self.state = json.dumps(state)