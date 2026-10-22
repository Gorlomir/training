from typing import cast
from uuid import UUID

from datasource.model.game import CurrentGameDs
from domain.model.game import CurrentGame, State
from datasource.mapper.board_mapper import GameBoardMapper


class CurrentGameMapper:
    @staticmethod
    def domain_to_datasource(current_game: CurrentGame) -> CurrentGameDs:
        uuid = current_game.uuid
        state = current_game.board.state
        game_state = current_game.game_state.value
        player1 = current_game.player1
        player2 = current_game.player2
        current = current_game.current_player
        winner = current_game.winner
        return CurrentGameDs(uuid, state, game_state, player1, player2, current, winner)

    @staticmethod
    def datasource_to_domain(current_game_ds: CurrentGameDs) -> CurrentGame:
        uuid = cast(UUID, current_game_ds.uuid)
        board = GameBoardMapper.datasource_to_domain(current_game_ds.board)
        game_state = State(current_game_ds.game_state)
        player1 = cast(UUID, current_game_ds.player1)
        player2 = cast(UUID, current_game_ds.player2)
        current = cast(UUID, current_game_ds.current_player)
        winner = cast(UUID, current_game_ds.winner)
        return CurrentGame(uuid, board, game_state, player1, player2, current, winner)