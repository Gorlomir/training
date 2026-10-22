from dataclasses import dataclass

from domain.service.service_interface import Opponent

@dataclass
class NewGameWeb:
    opponent: Opponent

    def __init__(self, num: int):
        if (num == 1 or num == 2):
            self.opponent = Opponent(num)
        else:
            raise ValueError