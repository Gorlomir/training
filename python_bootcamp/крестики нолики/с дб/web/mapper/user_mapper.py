from web.model.user import UserWeb
from domain.model.user import User

class UserMapper:
    @staticmethod
    def domain_to_web(user: User) -> UserWeb:
        return UserWeb(user.uuid, user.login)