from flask import Blueprint, request, jsonify
import base64

from di.container import get_container
from web.model.sign_up_req import SignUpRequest

auth_bp = Blueprint("auth", __name__)

@auth_bp.route("/register", methods=["POST"])
def sign_up():
    container = get_container()
    user_input = request.get_json(silent=True)
    if ((not user_input) or ("login" not in user_input) or ("pswd" not in user_input)):
        return jsonify({"error": "Invalid input format"}), 400
    sign_up_req = SignUpRequest(user_input["login"], user_input["pswd"])
    success_status = container.get_auth_service().registartion(sign_up_req)
    if success_status:
        return jsonify({"message": "Successful registation"}), 200
    return jsonify({"error": "Registration failed"}), 400

@auth_bp.route("/login", methods=["POST"])
def log_in():
    container = get_container()
    auth_header = request.headers.get("Authorization")
    if (not auth_header or not auth_header.startswith("Basic ")):
        return jsonify({"error": "Authorization header invalid"}), 400
    encoded_credentials = auth_header.split()[1]
    credentials = base64.b64decode(encoded_credentials).decode()
    login, pswd = credentials.split(":")
    user_uuid = container.get_auth_service().authorization(login, pswd)
    if user_uuid:
        return jsonify({"message": "Successful log in"}), 200
    return jsonify({"error": "Invalid login or password"}), 400