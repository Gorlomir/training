from domain.model.game import Game
from datasource.model.game import GameEntity
from datasource.mapper import board_mapper


def to_entity(game: Game) -> GameEntity:
    # domain -> datasource; поле маппим отдельным board-маппером, id переносим как есть
    return GameEntity(board=board_mapper.to_entity(game.board), id=game.id)


def to_domain(entity: GameEntity) -> Game:
    # datasource -> domain
    return Game(board=board_mapper.to_domain(entity.board), id=entity.id)
