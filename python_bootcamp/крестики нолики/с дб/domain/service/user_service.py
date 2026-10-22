from datasource.repository.user_repository import UserRepository, User


class UserService:
    def __init__(self, user_repo: UserRepository):
        self.repository = user_repo

    def create_user(self, user: User) -> None:
        self.repository.save_user(user)

    def find_user(self, login: str) -> User | None:
        return self.repository.find_user(login)