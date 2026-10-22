from flask import Flask
from web.route.game_route import create_game_blueprint


def create_app(service):
    app = Flask(__name__)
    app.register_blueprint(create_game_blueprint(service))
    return app