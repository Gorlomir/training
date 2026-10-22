from flask import Blueprint, jsonify, request, g
from uuid import UUID

from di.container import get_container
from web.mapper.game_mapper import CurrentGameMapper, State
from web.mapper.board_mapper import GameBoardMapper, GameBoardWeb
from web.model.new_game import NewGameWeb
from web.mapper.user_mapper import UserMapper
from web.route.exceptions import GameNotFoundException, InvalidGameException, GameOverException, NotYourTurnException, \
    NoAvailableGames, UserNotFoundException, GameUnavailableException

bp = Blueprint("game", __name__)


@bp.route("/game", methods=["POST"])
def create_game():
    container = get_container()
    user_uuid = g.current_user
    user_input = request.get_json(silent=False)
    if (not user_input or "opponent" not in user_input):
        return jsonify({"error": "Invalid input format"}), 400
    try:
        new_game_request = NewGameWeb(user_input["opponent"])
        game = container.get_repo_service().create_game(user_uuid, new_game_request.opponent)
        response = CurrentGameMapper.domain_to_web(game).__dict__
        response["your symbol"] = 1 if g.current_user == game.player1 else 2
        return jsonify(response), 200
    except ValueError:
        return jsonify({"error": "Invalid input format"}), 400
    except Exception:
        return jsonify({"error": "Invalid input format"}), 400


@bp.route("/game/<current_game_UUID>/join", methods=["POST"])
def join_game(current_game_UUID: UUID):
    container = get_container()
    try:
        game = container.get_repo_service().join_game(current_game_UUID, g.current_user)
        response = CurrentGameMapper.domain_to_web(game).__dict__
        response["your symbol"] = 1 if g.current_user == game.player1 else 2
        return jsonify(response), 200
    except GameNotFoundException:
        return jsonify({"error": f"Game <{current_game_UUID}> not found"}), 400
    except GameUnavailableException:
        return jsonify({"error": f"Game <{current_game_UUID}> not available"}), 400


@bp.route("/game/<current_game_UUID>", methods=["POST"])
def update_game(current_game_UUID: UUID):
    container = get_container()
    user_input = request.get_json(silent=True)
    if (not user_input or "state" not in user_input):
        return jsonify({"error": "Invalid input format"}), 400
    board_web = GameBoardWeb(user_input["state"])
    board = GameBoardMapper.web_to_domain(board_web)
    try:
        upd_game = container.get_repo_service().update_game(current_game_UUID, g.current_user, board)
    except GameNotFoundException:
        return jsonify({"error": f"Game <{current_game_UUID}> not found"}), 400
    except InvalidGameException:
        return jsonify({"error": "Invalid board submitted"}), 400
    except NotYourTurnException:
        return jsonify({"message": "Wait for your turn"})
    except GameOverException:
        final_game = container.get_repo_service().get_game(current_game_UUID)
        response = CurrentGameMapper.domain_to_web(final_game).__dict__
        if (final_game.game_state == State.PLAYER_WON and final_game.winner is None):
            response["winner"] = "COMPUTER"
        return jsonify(response), 200
    final_response = CurrentGameMapper.domain_to_web(upd_game).__dict__
    final_response["your symbol"] = 1 if g.current_user == upd_game.player1 else 2
    return jsonify(final_response), 200


@bp.route("/games/available", methods=["GET"])
def get_available_games():
    container = get_container()
    try:
        games = container.get_repo_service().get_available_games(g.current_user)
        game_uuids = [str(game.uuid) for game in games]
        return jsonify(game_uuids), 200
    except NoAvailableGames:
        return jsonify({"error": "No available games"}), 500


@bp.route("/games/<current_game_UUID>", methods=["GET"])
def get_current_game(current_game_UUID: UUID):
    container = get_container()
    try:
        game = container.get_repo_service().get_game(current_game_UUID)
        if g.current_user not in [game.player1, game.player2]:
            return jsonify({"error": "Not authorized"}), 403
        return jsonify(CurrentGameMapper.domain_to_web(game).__dict__), 200
    except GameNotFoundException:
        return jsonify({"error": f"Game <{current_game_UUID}> not found"}), 400


@bp.route("/users/<user_UUID>", methods=["GET"])
def get_user(user_UUID: UUID):
    container = get_container()
    try:
        user = container.get_repo_service().get_user(user_UUID)
        return jsonify(UserMapper.domain_to_web(user).__dict__), 200
    except UserNotFoundException:
        return jsonify({"error": f"User <{user_UUID}> not found"}), 400