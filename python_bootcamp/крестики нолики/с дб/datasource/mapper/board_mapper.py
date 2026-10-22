from datasource.model.board import GameBoardDs
from domain.model.board import GameBoard
import json


class GameBoardMapper:
    @staticmethod
    def domain_to_datasource(game_board: GameBoard) -> GameBoardDs:
        state = game_board.state
        state_copy = [row[:] for row in state]
        return GameBoardDs(state_copy)

    @staticmethod
    def datasource_to_domain(game_board_ds: GameBoardDs) -> GameBoard:
        state = json.loads(str(game_board_ds.state))
        return GameBoard(state)