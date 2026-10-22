from uuid import UUID, uuid4

from domain.service.service_interface import ServiceInterface, Opponent, GameResult
from domain.model.game import CurrentGame, GameBoard, State


class ServiceImpl(ServiceInterface):
    SZ: int = 3
    PLAYER1: int = 1
    PLAYER2: int = 2
    EMPTY: int = 0

    def next_move(self, current_game: CurrentGame) -> tuple[int, int]:
        res = (-1, -1)
        val = 1000
        state = [row[:] for row in current_game.board.state]
        for i in range(ServiceImpl.SZ):
            for j in range(ServiceImpl.SZ):
                if state[i][j] == ServiceImpl.EMPTY:
                    state[i][j] = ServiceImpl.PLAYER2
                    temp = self._minimax(state, 0, True)
                    state[i][j] = ServiceImpl.EMPTY
                    if temp < val:
                        res = (i, j)
                        val = temp
        return res

    def validate_current_game_board(self, user_uuid: UUID, game: CurrentGame, user_game: CurrentGame) -> bool:
        state = [row[:] for row in user_game.board.state]
        prev_state = [row[:] for row in game.board.state]
        my_symbol = ServiceImpl.PLAYER1 if user_game.player1 == user_uuid else ServiceImpl.PLAYER2

        cnt_changes = 0
        for i in range(ServiceImpl.SZ):
            for j in range(ServiceImpl.SZ):
                if (prev_state[i][j] == ServiceImpl.PLAYER1 and state[i][j] != ServiceImpl.PLAYER1):
                    return False
                if (prev_state[i][j] == ServiceImpl.PLAYER2 and state[i][j] != ServiceImpl.PLAYER2):
                    return False
                if (prev_state[i][j] == ServiceImpl.EMPTY):
                    if state[i][j] == my_symbol:
                        cnt_changes += 1
                    elif state[i][j] != ServiceImpl.EMPTY:
                        return False
        return cnt_changes == 1

    def game_over_check(self, current_game: CurrentGame) -> GameResult:
        state = [row[:] for row in current_game.board.state]
        eval_res = self._evaluate(state)
        if eval_res == 10:
            return GameResult.PLAYER1
        if eval_res == -10:
            return GameResult.PLAYER2
        if not self._moves_left(state):
            return GameResult.DRAW
        return GameResult.IN_PROGRESS

    def new_game(self, player_uuid: UUID, op: Opponent) -> CurrentGame:
        state = [[0 for _ in range(ServiceImpl.SZ)] for _ in range(ServiceImpl.SZ)]
        new_board = GameBoard(state)
        player1 = player_uuid
        if op == Opponent.COMPUTER:
            game_state = State.PLAYERS_TURN
            current_player = player_uuid
        else:
            game_state = State.WAITING_FOR_PLAYERS
            current_player = None
        return CurrentGame(uuid=uuid4(), board=new_board, game_state=game_state,
                           player1=player1, current_player=current_player)

    def join_game(self, player_uuid: UUID, game: CurrentGame) -> None:
        game.player2 = player_uuid
        game.current_player = game.player1
        game.game_state = State.PLAYERS_TURN

    def apply_changes(self, current_game: CurrentGame, move: tuple[int, int]) -> None:
        x, y = move
        current_game.board.state[x][y] = ServiceImpl.PLAYER2

    # Helper methods
    def _evaluate(self, state: list[list[int]]) -> int:
        for row in range(ServiceImpl.SZ):
            if (state[row][0] == state[row][1] and state[row][1] == state[row][2]):
                if state[row][0] == ServiceImpl.PLAYER1:
                    return 10
                elif state[row][0] == ServiceImpl.PLAYER2:
                    return -10
        for col in range(ServiceImpl.SZ):
            if (state[0][col] == state[1][col] and state[1][col] == state[2][col]):
                if state[0][col] == ServiceImpl.PLAYER1:
                    return 10
                elif state[0][col] == ServiceImpl.PLAYER2:
                    return -10
        if (state[0][0] == state[1][1] and state[1][1] == state[2][2]):
            if state[0][0] == ServiceImpl.PLAYER1:
                return 10
            elif state[0][0] == ServiceImpl.PLAYER2:
                return -10
        if (state[0][2] == state[1][1] and state[1][1] == state[2][0]):
            if state[1][1] == ServiceImpl.PLAYER1:
                return 10
            elif state[1][1] == ServiceImpl.PLAYER2:
                return -10
        return 0

    def _moves_left(self, state: list[list[int]]) -> bool:
        for i in range(ServiceImpl.SZ):
            for j in range(ServiceImpl.SZ):
                if state[i][j] == ServiceImpl.EMPTY:
                    return True
        return False

    def _minimax(self, state: list[list[int]], depth: int, is_max: bool) -> int:
        score = self._evaluate(state)
        if (score == 10 or score == -10):
            return score
        if not self._moves_left(state):
            return 0
        if is_max:
            best = -1000
            for i in range(ServiceImpl.SZ):
                for j in range(ServiceImpl.SZ):
                    if state[i][j] == ServiceImpl.EMPTY:
                        state[i][j] = ServiceImpl.PLAYER1
                        best = max(best, self._minimax(state, depth + 1, not is_max))
                        state[i][j] = ServiceImpl.EMPTY
        else:
            best = 1000
            for i in range(ServiceImpl.SZ):
                for j in range(ServiceImpl.SZ):
                    if state[i][j] == ServiceImpl.EMPTY:
                        state[i][j] = ServiceImpl.PLAYER2
                        best = min(best, self._minimax(state, depth + 1, not is_max))
                        state[i][j] = ServiceImpl.EMPTY
        return best