from uuid import UUID

from datasource.model.game import GameEntity
from datasource.repository.storage import GameStorage


class GameRepository:
    # репозиторий поверх хранилища; прячет детали хранения за парой методов

    def __init__(self, storage: GameStorage) -> None:
        # хранилище приходит извне (через di), сам его не создаёт
        self._storage = storage

    def save_game(self, game: GameEntity) -> None:
        # сохранить текущую игру
        self._storage.put(game)

    def get_game(self, game_id: UUID) -> GameEntity | None:
        # получить текущую игру по id
        return self._storage.get(game_id)
