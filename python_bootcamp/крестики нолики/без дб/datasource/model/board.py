from dataclasses import dataclass, field


def _empty_cells() -> list[list[int]]:
    # своя фабрика пустого поля, чтобы каждая запись хранилища держала свою матрицу
    return [[0 for _ in range(3)] for _ in range(3)]


@dataclass
class BoardEntity:
    # модель поля на уровне хранилища — намеренно отдельная от domain.Board
    cells: list[list[int]] = field(default_factory=_empty_cells)
