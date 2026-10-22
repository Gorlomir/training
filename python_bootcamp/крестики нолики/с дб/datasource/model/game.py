from uuid import UUID
from sqlalchemy import String, Integer, Column, ForeignKey
from sqlalchemy.orm import relationship

from datasource.model.board import GameBoardDs
from datasource.db.base import Base

class CurrentGameDs(Base):
    __tablename__ = "games"
    uuid = Column(String, primary_key=True)
    board_id = Column(Integer, ForeignKey("game_boards.id"), nullable=False)
    game_state = Column(Integer, nullable=False)
    player1 = Column(String)
    player2 = Column(String)
    current_player = Column(String)
    winner = Column(String)

    board = relationship(GameBoardDs)

    def __init__(self, uuid: UUID, state: list[list[int]], game_state: int,
                 player1: UUID | None, player2: UUID | None,
                 current: UUID | None, winner: UUID | None):
        self.uuid = str(uuid)
        self.board = GameBoardDs(state)
        self.game_state = game_state
        self.player1 = str(player1)
        self.player2 = str(player2) if player2 is not None else None
        self.current_player = str(current) if current is not None else None
        self.winner = str(winner) if winner is not None else None