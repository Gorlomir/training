from abc import ABC, abstractmethod
from domain.model.game import Game
import uuid

class GameService(ABC):
    @abstractmethod
    def create_game(self) -> uuid.UUID:
        """Создает новую игру и возвращает ее ID"""
        ...

    @abstractmethod
    def get_game(self, game_id: uuid.UUID) -> Game | None:
        """Получает игру по ID или None, если игра не найдена"""
        ...
    # интерфейс доменного сервиса игры — реализация появится в datasource-слое
    @abstractmethod
    def next_move(self, game: Game) -> Game:
        # считает следующий ход компьютера алгоритмом минимакс и возвращает обновлённую игру
        ...
    @abstractmethod
    def validate(self, game: Game) -> bool:
        # проверяет, что игрок добавил ровно один допустимый ход и не переписал предыдущие
        ...
    @abstractmethod
    def is_over(self, game: Game) -> bool:
        # проверяет, закончена ли игра (есть победитель или ничья)
        ...