from flask import Blueprint, request, jsonify

from web.mapper import game_mapper
from web.model.board import BoardWeb
from web.model.game import GameWeb


def create_game_blueprint(service):
    bp = Blueprint("game", __name__)

    @bp.route("/", methods=["GET"])
    def index():
        return jsonify({
            "api": "Крестики-нолики",
            "endpoints": {
                "POST /game ": "создать игру",
                "GET /game/<uuid:game_id> ": "статус игры",
                "POST /game/<uuid:game_id> ": "сделать ход"
            }
        })

    @bp.route("/game", methods=["POST"])
    def create_game():
        game_id = service.create_game()
        return jsonify({
            "id": str(game_id),
            "message": "Игра создана успешно"
        }), 201

    @bp.route("/game/<uuid:game_id>", methods=["GET"])
    def get_game(game_id):
        game = service.get_game(game_id)
        if game is None:
            return jsonify({"error": "Game not found"}), 404

        game_web = game_mapper.to_web(game)
        return jsonify({
            "id": str(game_web.id),
            "board": game_web.board.cells,
            "is_over": service.is_over(game)
        })
    @bp.route("/game/<uuid:game_id>", methods=["POST"])
    def play(game_id):

        body = request.get_json(silent=True)  # silent -> None вместо 415/BadRequest на кривой content-type
        if body is None:
            return jsonify({"error": "Request body must be JSON with a 'board' 3x3 matrix"}), 400

        try:
            game_web = GameWeb(board=BoardWeb(body["board"]), id=None)
            game = game_mapper.to_domain(game_web, game_id)
        except (KeyError, TypeError):
            return jsonify({"error": "Request body must contain a 'board' 3x3 matrix"}), 400

        if not service.validate(game):
            return jsonify({"error": "Submitted board is not a single legal move over the previous state"}), 400

        result = game_mapper.to_web(service.next_move(game))

        return jsonify({"id": result.id, "board": result.board.cells}), 200

    return bp
