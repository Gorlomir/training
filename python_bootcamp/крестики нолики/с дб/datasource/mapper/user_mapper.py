from uuid import UUID
from typing import cast

from domain.model.user import User
from datasource.model.user import UserDs


class UserMapper:
    @staticmethod
    def domain_to_datasource(user: User) -> UserDs:
        uuid = user.uuid
        login = user.login
        hashed_pswd = user.hashed_pswd
        return UserDs(uuid, login, hashed_pswd)

    @staticmethod
    def datasource_to_domain(user_ds: UserDs) -> User:
        uuid = cast(UUID, user_ds.uuid)
        login = str(user_ds.login)
        hashed_pswd = str(user_ds.hashed_pswd)
        return User(uuid, login, hashed_pswd)