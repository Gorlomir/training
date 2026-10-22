from uuid import UUID

from dataclasses import dataclass

@dataclass
class User:
    uuid: UUID
    login: str
    hashed_pswd: str