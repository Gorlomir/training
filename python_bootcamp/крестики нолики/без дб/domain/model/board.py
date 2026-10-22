from dataclasses import dataclass, field

# значения клеток игрового поля
EMPTY = 0
CROSS = 1   # ход человека
NOUGHT = 2  # ход компьютера
SIZE = 3

def _empty_cells() -> list[list[int]]:
    # свежее пустое поле, каждый вызов — новая матрица, чтобы игры не делили одну и ту же
    return [[EMPTY for _ in range(SIZE)] for _ in range(SIZE)]


@dataclass
class Board:
    # игровое поле как целочисленная матрица SIZE x SIZE
    cells: list[list[int]] = field(default_factory=_empty_cells)