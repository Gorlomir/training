from domain.model.board import Board
from datasource.model.board import BoardEntity


def to_entity(board: Board) -> BoardEntity:
    # domain -> datasource; копируем строки, чтобы хранилище не делило матрицу с domain-объектом
    return BoardEntity(cells=[row[:] for row in board.cells])


def to_domain(entity: BoardEntity) -> Board:
    # datasource -> domain; тоже с копией строк, чтобы правки в одном слое не текли в другой
    return Board(cells=[row[:] for row in entity.cells])
