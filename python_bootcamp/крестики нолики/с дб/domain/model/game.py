from uuid import UUID
from dataclasses import dataclass
from enum import Enum

from domain.model.board import GameBoard

class State(Enum):
    WAITING_FOR_PLAYERS = 1
    PLAYERS_TURN = 2
    DRAW = 3
    PLAYER_WON = 4

@dataclass
class CurrentGame:
    uuid: UUID
    board: GameBoard
    game_state: State
    player1: UUID | None = None
    player2: UUID | None = None
    current_player: UUID | None = None
    winner: UUID | None = None