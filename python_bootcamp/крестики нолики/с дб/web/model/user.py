from uuid import UUID

from dataclasses import dataclass

@dataclass
class UserWeb:
    uuid: UUID
    login: str