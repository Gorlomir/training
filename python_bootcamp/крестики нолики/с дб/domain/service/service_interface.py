from abc import ABC, abstractmethod
from uuid import UUID
from enum import Enum

from domain.model.game import CurrentGame

class Opponent(Enum):
    HUMAN = 1
    COMPUTER = 2

class GameResult(Enum):
    PLAYER1 = 1
    PLAYER2 = 2
    DRAW = 3
    IN_PROGRESS = 4

class ServiceInterface(ABC):
    @abstractmethod
    def next_move(self, current_game: CurrentGame) -> tuple[int, int]:
        pass

    @abstractmethod
    def validate_current_game_board(self, user_uuid: UUID, game: CurrentGame, user_game: CurrentGame) -> bool:
        pass

    @abstractmethod
    def game_over_check(self, current_game: CurrentGame) -> GameResult:
        pass

    @abstractmethod
    def new_game(self, player_uuid: UUID, op: Opponent) -> CurrentGame:
        pass

    @abstractmethod
    def join_game(self, player_uuid: UUID, game: CurrentGame) -> None:
        pass

    @abstractmethod
    def apply_changes(self, current_game: CurrentGame, move: tuple[int, int]) -> None:
        pass