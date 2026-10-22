from datasource.repository.service_impl_repo import ServiceImplDs, Repository
from domain.service.service_impl import ServiceImpl
from domain.service.auth_service import AuthService
from domain.service.user_service import UserService, UserRepository


class Container:
    def __init__(self):
        self.repository = Repository()
        self.service = ServiceImpl()
        self.repo_service = ServiceImplDs(self.repository, self.service)
        self.user_service = UserService(UserRepository())
        self.auth_service = AuthService(self.user_service)

    def get_service(self) -> ServiceImpl:
        return self.service

    def get_repo_service(self) -> ServiceImplDs:
        return self.repo_service

    def get_repository(self) -> Repository:
        return self.repository

    def get_user_service(self) -> UserService:
        return self.user_service

    def get_auth_service(self) -> AuthService:
        return self.auth_service


container_instance = Container()


def get_container() -> Container:
    return container_instance