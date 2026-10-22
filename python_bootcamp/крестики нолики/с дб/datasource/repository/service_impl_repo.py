from uuid import UUID

from datasource.repository.service_interface import ServiceInterfaceDs, Opponent
from datasource.repository.repository import Repository
from domain.model.game import CurrentGame, GameBoard
from domain.service.service_impl import ServiceInterface, GameResult, State
from domain.model.user import User
from web.route.exceptions import GameNotFoundException, InvalidGameException, GameOverException, NotYourTurnException, \
    NoAvailableGames, UserNotFoundException, GameUnavailableException


class ServiceImplDs(ServiceInterfaceDs):
    def __init__(self, repo: Repository, service: ServiceInterface):
        self.repository = repo
        self.service = service

    def create_game(self, player_uuid: UUID, op: Opponent) -> CurrentGame:
        new_game = self.service.new_game(player_uuid, op)
        self.repository.save_game(new_game)
        return new_game

    def join_game(self, game_uuid: UUID, user_uuid: UUID) -> CurrentGame:
        game = self.get_game(game_uuid)
        if (game.player2 is not None or game.player1 == user_uuid):
            raise GameUnavailableException
        game.game_state = State.PLAYERS_TURN
        game.player2 = user_uuid
        game.current_player = game.player1
        self.repository.save_game(game)
        return game

    def update_game(self, game_uuid: UUID, user_uuid: UUID, user_board: GameBoard) -> CurrentGame:
        saved_game = self.get_game(game_uuid)
        if (saved_game.game_state.name == "DRAW" or saved_game.game_state.name == "PLAYER_WON"):
            raise GameOverException
        if saved_game.current_player != user_uuid:
            raise NotYourTurnException
        user_game = CurrentGame(game_uuid, user_board, saved_game.game_state, saved_game.player1, saved_game.player2,
                                saved_game.current_player)
        if not self.service.validate_current_game_board(user_uuid, saved_game, user_game):
            raise InvalidGameException
        game_res = self.service.game_over_check(user_game)
        if game_res != GameResult.IN_PROGRESS:
            self._update_game_state(game_res, user_game)
            self.repository.save_game(user_game)
            raise GameOverException
        if user_game.player2 is not None:
            if user_uuid == user_game.player1:
                user_game.current_player = user_game.player2
            else:
                user_game.current_player = user_game.player1
            self.repository.save_game(user_game)
        else:
            next_move = self.service.next_move(user_game)
            self.service.apply_changes(user_game, next_move)
            res = self.service.game_over_check(user_game)
            if res != GameResult.IN_PROGRESS:
                self._update_game_state(res, user_game)
                self.repository.save_game(user_game)
                raise GameOverException
            self.repository.save_game(user_game)
        return user_game

    def get_game(self, uuid: UUID) -> CurrentGame:
        saved_game = self.repository.retrieve_game(uuid)
        if saved_game is None:
            raise GameNotFoundException
        return saved_game

    def get_available_games(self, current_user_uuid: UUID) -> list[CurrentGame]:
        available_games = self.repository.retrieve_available_games(current_user_uuid)
        if len(available_games) == 0:
            raise NoAvailableGames
        return available_games

    def get_user(self, user_uuid: UUID) -> User:
        user = self.repository.retrieve_user(user_uuid)
        if user is None:
            raise UserNotFoundException
        return user

    def _update_game_state(self, game_res: GameResult, user_game: CurrentGame) -> None:
        if game_res == GameResult.PLAYER1:
            user_game.winner = user_game.player1
            user_game.game_state = State.PLAYER_WON
        elif game_res == GameResult.PLAYER2:
            user_game.winner = user_game.player2
            user_game.game_state = State.PLAYER_WON
        else:
            user_game.game_state = State.DRAW