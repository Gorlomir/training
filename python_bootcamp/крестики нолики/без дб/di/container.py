from datasource.repository.storage import GameStorage
from datasource.repository.game_repository import GameRepository
from datasource.service.game_service_impl import GameServiceImpl

class Container:
    def __init__(self):
        self._storage = GameStorage()
        self._repository = GameRepository(self._storage)
        self._service = GameServiceImpl(self._repository)

    @property
    def service(self):
        return self._service