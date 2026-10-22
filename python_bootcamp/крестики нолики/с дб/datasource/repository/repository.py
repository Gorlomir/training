from uuid import UUID
from sqlalchemy.orm import Session
from sqlalchemy import select

from datasource.db.connection import SessionFactory
from datasource.mapper.game_mapper import CurrentGameMapper, CurrentGameDs, CurrentGame
from datasource.mapper.user_mapper import User, UserDs, UserMapper


class Repository:
    def __init__(self):
        self.SessionFactory = SessionFactory

    def save_game(self, current_game: CurrentGame) -> None:
        with self.SessionFactory() as session:
            current_game_ds = CurrentGameMapper.domain_to_datasource(current_game)
            game_found = self._find_game(str(current_game_ds.uuid), session)
            if game_found:
                game_found.board.state = current_game_ds.board.state
                game_found.game_state = current_game_ds.game_state
                game_found.player1 = current_game_ds.player1
                game_found.player2 = current_game_ds.player2
                game_found.current_player = current_game_ds.current_player
                game_found.winner = current_game_ds.winner
            else:
                session.add(current_game_ds)
            session.commit()

    def retrieve_game(self, uuid: UUID) -> CurrentGame | None:
        with self.SessionFactory() as session:
            current_game_ds = self._find_game(str(uuid), session)
            if current_game_ds is None:
                return None
            current_game = CurrentGameMapper.datasource_to_domain(current_game_ds)
            return current_game

    def retrieve_available_games(self, current_user_uuid: UUID) -> list[CurrentGame]:
        with self.SessionFactory() as session:
            statement = select(CurrentGameDs).where(
                (CurrentGameDs.game_state == 1) & (CurrentGameDs.player1 != current_user_uuid))  # type: ignore
            res = session.execute(statement).scalars().all()
            final_res = [CurrentGameMapper.datasource_to_domain(game_ds) for game_ds in res]
            return final_res

    def retrieve_user(self, user_uuid: UUID) -> User | None:
        with self.SessionFactory() as session:
            statement = select(UserDs).where(UserDs.uuid == str(user_uuid))  # type: ignore
            user_ds = session.execute(statement).scalar_one_or_none()
            user = UserMapper.datasource_to_domain(user_ds) if user_ds is not None else None
            return user

    def _find_game(self, uuid: str, session: Session) -> CurrentGameDs | None:
        statement = select(CurrentGameDs).where(CurrentGameDs.uuid == uuid)  # type: ignore
        res = session.execute(statement).scalar_one_or_none()
        return res