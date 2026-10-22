from web.model.board import BoardWeb


class GameWeb:
    def __init__(self, board: BoardWeb, id: str):
        self.board = board
        self.id = id
