from abc import ABC, abstractmethod
from uuid import UUID

from domain.model.game import CurrentGame, GameBoard
from domain.service.service_interface import Opponent
from domain.model.user import User

class ServiceInterfaceDs(ABC):
    @abstractmethod
    def create_game(self, player_uuid: UUID, op: Opponent) -> CurrentGame:
        pass

    @abstractmethod
    def join_game(self, game_uuid: UUID, user_uuid: UUID) -> CurrentGame:
        pass

    @abstractmethod
    def update_game(self, game_uuid: UUID, user_uuid: UUID, user_board: GameBoard) -> CurrentGame:
        pass

    @abstractmethod
    def get_game(self, uuid: UUID) -> CurrentGame:
        pass

    @abstractmethod
    def get_available_games(self, current_user_uuid: UUID) -> list[CurrentGame]:
        pass

    @abstractmethod
    def get_user(self, user_uuid: UUID) -> User:
        pass