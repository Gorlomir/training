import threading
from uuid import UUID

from datasource.model.game import GameEntity


class GameStorage:
    # класс-хранилище текущих игр; несколько партий идут одновременно, поэтому доступ под замком

    def __init__(self) -> None:
        # игры по их UUID
        self._games: dict[UUID, GameEntity] = {}
        # один замок на всё хранилище — делает операции потокобезопасными
        self._lock = threading.Lock()

    def put(self, game: GameEntity) -> None:
        # кладём/перезаписываем игру под её id
        with self._lock:
            self._games[game.id] = game

    def get(self, game_id: UUID) -> GameEntity | None:
        # достаём игру по id или None, если такой ещё нет
        with self._lock:
            return self._games.get(game_id)
