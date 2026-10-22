from flask import Flask, request, jsonify, g
import base64

from web.route.game_route import bp
from web.route.auth_route import auth_bp
from di.container import get_container


def create_app() -> Flask:
    app = Flask(__name__)
    app.register_blueprint(bp)
    app.register_blueprint(auth_bp)

    PUBLIC_ENDPOINTS = {
        "auth.sign_up",
        "auth.log_in"
    }

    @app.before_request
    def user_authenticator():
        if request.endpoint not in PUBLIC_ENDPOINTS:
            container = get_container()
            auth_header = request.headers.get("Authorization")
            if (not auth_header or not auth_header.startswith("Basic ")):
                return jsonify({"error": "Authorization header invalid"}), 400
            encoded_credentials = auth_header.split()[1]
            credentials = base64.b64decode(encoded_credentials).decode()
            login, pswd = credentials.split(":")
            user_uuid = container.get_auth_service().authorization(login, pswd)
            if not user_uuid:
                return jsonify({"error": "Invalid login or password"}), 401
            g.current_user = user_uuid

    return app