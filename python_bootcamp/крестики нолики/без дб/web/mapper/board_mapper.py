from domain.model.board import Board
from web.model.board import BoardWeb


def to_domain(board_web: BoardWeb) -> Board:
    return Board(cells=[row[:] for row in board_web.cells])

def to_web(board: Board) -> BoardWeb:
    return BoardWeb(cells=[row[:] for row in board.cells])
