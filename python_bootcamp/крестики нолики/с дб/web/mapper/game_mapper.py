from uuid import UUID

from web.model.game import CurrentGameWeb
from domain.model.game import CurrentGame, State
from web.mapper.board_mapper import GameBoardMapper


class CurrentGameMapper:
    @staticmethod
    def domain_to_web(current_game: CurrentGame) -> CurrentGameWeb:
        uuid = current_game.uuid
        board = GameBoardMapper.domain_to_web(current_game.board)
        game_state = current_game.game_state
        player1 = current_game.player1
        player2 = current_game.player2
        current = current_game.current_player
        winner = str(current_game.winner) if current_game.winner is not None else None
        return CurrentGameWeb(uuid, board, game_state.name, player1, player2, current, winner)

    @staticmethod
    def web_to_domain(current_game_web: CurrentGameWeb) -> CurrentGame:
        uuid = current_game_web.game_uuid
        board = GameBoardMapper.web_to_domain(current_game_web.board)
        game_state = current_game_web.game_state
        player1 = current_game_web.player1
        player2 = current_game_web.player2
        current = current_game_web.current_player
        winner = UUID(current_game_web.winner) if current_game_web.winner is not None else None
        return CurrentGame(uuid, board, State(game_state), player1, player2, current, winner)