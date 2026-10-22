class BoardWeb:
    def __init__(self, cells: list[list[int]]):
        self.cells = cells

    def __eq__(self, other: object) -> bool:
        if not isinstance(other, BoardWeb):
            return NotImplemented
        return self.cells == other.cells