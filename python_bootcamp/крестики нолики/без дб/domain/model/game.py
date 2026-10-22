from dataclasses import dataclass, field
from uuid import UUID, uuid4

from domain.model.board import Board


@dataclass
class Game:
    # текущая игра: уникальный идентификатор + игровое поле
    board: Board = field(default_factory=Board)
    id: UUID = field(default_factory=uuid4)