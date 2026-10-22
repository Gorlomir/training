from web.model.board import GameBoardWeb
from domain.model.board import GameBoard


class GameBoardMapper:
    @staticmethod
    def domain_to_web(game_board: GameBoard) -> GameBoardWeb:
        state = game_board.state
        state_copy = [row[:] for row in state]
        return GameBoardWeb(state_copy)

    @staticmethod
    def web_to_domain(game_board_web: GameBoardWeb) -> GameBoard:
        state = game_board_web.state
        state_copy = [row[:] for row in state]
        return GameBoard(state_copy)