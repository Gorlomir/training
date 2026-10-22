from uuid import UUID, uuid4
import bcrypt

from domain.service.user_service import UserService, User
from web.model.sign_up_req import SignUpRequest

class AuthService:
    def __init__(self, user_service: UserService):
        self.user_service = user_service

    def registartion(self, sign_up_request: SignUpRequest) -> bool:
        user_found = self.user_service.find_user(sign_up_request.login)
        if user_found is None:
            hashed_pswd = self._hash_pswd(sign_up_request.pswd)
            new_user = User(uuid4(), sign_up_request.login, hashed_pswd)
            self.user_service.create_user(new_user)
            return True
        return False

    def authorization(self, login: str, pswd: str) -> UUID | None:
        user_found = self.user_service.find_user(login)
        if user_found is None:
            return None
        valid_pswd = bcrypt.checkpw(pswd.encode(), user_found.hashed_pswd.encode())
        if valid_pswd:
            return user_found.uuid
        return None

    # Helper methods
    def _hash_pswd(self, pswd: str) -> str:
        salt = bcrypt.gensalt()
        hashed_pswd = bcrypt.hashpw(pswd.encode(), salt)
        return hashed_pswd.decode()