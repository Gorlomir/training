from dataclasses import dataclass

@dataclass
class SignUpRequest:
    login: str
    pswd: str