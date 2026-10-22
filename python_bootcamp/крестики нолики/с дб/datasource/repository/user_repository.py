from sqlalchemy import select

from domain.model.user import User
from datasource.model.user import UserDs
from datasource.db.connection import SessionFactory
from datasource.mapper.user_mapper import UserMapper

class UserRepository:
    def __init__(self):
        self.SessionFactory = SessionFactory

    def save_user(self, user: User) -> None:
        with self.SessionFactory() as session:
            user_ds = UserMapper.domain_to_datasource(user)
            session.add(user_ds)
            session.commit()

    def find_user(self, login: str) -> User | None:
        with self.SessionFactory() as session:
            statement = select(UserDs).where(UserDs.login == login) # type: ignore
            user_found = session.execute(statement).scalar_one_or_none()
            if user_found is None:
                return None
            user = UserMapper.datasource_to_domain(user_found)
            return user