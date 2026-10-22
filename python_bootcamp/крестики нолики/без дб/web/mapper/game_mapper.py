from domain.model.game import Game
from web.model.game import GameWeb
from web.mapper import board_mapper
from uuid import UUID

def to_web(game: Game) -> GameWeb:
    return GameWeb(board=board_mapper.to_web(game.board), id=str(game.id))

def to_domain(game_web: GameWeb, game_id: UUID) -> Game:
    return Game(board=board_mapper.to_domain(game_web.board), id=game_id)