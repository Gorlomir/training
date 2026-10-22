from dataclasses import dataclass, field
from uuid import UUID, uuid4

from datasource.model.board import BoardEntity


@dataclass
class GameEntity:
    # модель текущей игры в хранилище: UUID + поле, отдельная от domain.Game
    board: BoardEntity = field(default_factory=BoardEntity)
    id: UUID = field(default_factory=uuid4)
