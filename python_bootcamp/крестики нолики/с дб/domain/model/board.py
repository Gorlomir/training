from dataclasses import dataclass

@dataclass
class GameBoard:
    state: list[list[int]]