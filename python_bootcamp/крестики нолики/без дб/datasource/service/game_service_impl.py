from domain.model.board import EMPTY, CROSS, NOUGHT, SIZE
from domain.model.game import Game
from domain.model.board import Board
from domain.service.game_service import GameService
from datasource.repository.game_repository import GameRepository
from datasource.mapper import game_mapper
import uuid


class GameServiceImpl(GameService):
    # конкретная реализация доменного сервиса; репозиторий приходит извне (через di)

    def __init__(self, repository: GameRepository) -> None:
        self._repository = repository

    # --- публичные методы интерфейса ---
    def create_game(self) -> uuid.UUID:
        """Создает новую игру с пустой доской"""
        game_id = uuid.uuid4()
        empty_board = Board(self._empty_board())
        game = Game(id=game_id, board=empty_board)
        self._repository.save_game(game_mapper.to_entity(game))
        return game_id

    def get_game(self, game_id: uuid.UUID) -> Game | None:
        """Получает игру по ID"""
        entity = self._repository.get_game(game_id)
        if entity is None:
            return None
        return game_mapper.to_domain(entity)

    def next_move(self, game: Game) -> Game:
        result = game
        if self.is_over(game):
            self._repository.save_game(game_mapper.to_entity(result))
            return result
        # считает лучший ход компьютера (NOUGHT) минимаксом и возвращает НОВУЮ игру с этим ходом
        cells = [row[:] for row in game.board.cells]  # работаем на копии, вход не трогаем

        best_score = float("-inf")
        best_move: tuple[int, int] | None = None
        for r, c in self._empty_cells(cells):
            cells[r][c] = NOUGHT  # пробуем поставить нолик
            score = self._minimax(cells, is_computer_turn=False)
            cells[r][c] = EMPTY  # откатываем — backtracking
            if score > best_score:
                best_score = score
                best_move = (r, c)

        if best_move is not None:  # None только если ходить некуда
            r, c = best_move
            cells[r][c] = NOUGHT

        result = Game(board=Board(cells=cells), id=game.id)
        self._repository.save_game(game_mapper.to_entity(result))
        return result

    def validate(self, game: Game) -> bool:
        # проверяем, что игрок добавил ровно один свой ход к последнему известному состоянию
        new_cells = game.board.cells
        if not self._has_valid_shape(new_cells):
            return False

        previous = self._repository.get_game(game.id)
        # нет записи -> партия только началась, сравниваем с пустым полем
        prev_cells = previous.board.cells if previous else self._empty_board()

        diffs = []
        for r in range(SIZE):
            for c in range(SIZE):
                if prev_cells[r][c] != new_cells[r][c]:
                    diffs.append((r, c))

        if len(diffs) != 1:  # изменена не ровно одна клетка
            return False

        r, c = diffs[0]
        # единственное допустимое изменение: пустая клетка стала крестиком игрока
        return prev_cells[r][c] == EMPTY and new_cells[r][c] == CROSS

    def is_over(self, game: Game) -> bool:
        # игра закончена, если есть победитель или не осталось пустых клеток (ничья)
        cells = game.board.cells
        return self._winner(cells) != EMPTY or not self._empty_cells(cells)

    # --- вспомогательная игровая логика ---

    def _minimax(self, cells: list[list[int]], is_computer_turn: bool) -> int:
        # рекурсивная оценка позиции: +1 победа компьютера, -1 победа игрока, 0 ничья
        winner = self._winner(cells)
        if winner == NOUGHT:
            return 1
        if winner == CROSS:
            return -1
        if not self._empty_cells(cells):
            return 0  # клеток нет и победителя нет — ничья

        if is_computer_turn:  # MAX: компьютер тянет к максимуму
            best = float("-inf")
            for r, c in self._empty_cells(cells):
                cells[r][c] = NOUGHT
                best = max(best, self._minimax(cells, is_computer_turn=False))
                cells[r][c] = EMPTY
            return int(best)

        best = float("inf")  # MIN: игрок тянет к минимуму
        for r, c in self._empty_cells(cells):
            cells[r][c] = CROSS
            best = min(best, self._minimax(cells, is_computer_turn=True))
            cells[r][c] = EMPTY
        return int(best)

    @staticmethod
    def _winner(cells: list[list[int]]) -> int:
        # возвращает CROSS/NOUGHT если кто-то собрал линию, иначе EMPTY
        lines: list[list[int]] = []
        lines.extend(cells)  # строки
        lines.extend([cells[r][c] for r in range(SIZE)] for c in range(SIZE))  # столбцы
        lines.append([cells[i][i] for i in range(SIZE)])  # главная диагональ
        lines.append([cells[i][SIZE - 1 - i] for i in range(SIZE)])  # побочная диагональ

        for line in lines:
            if line[0] != EMPTY and all(v == line[0] for v in line):
                return line[0]
        return EMPTY

    @staticmethod
    def _empty_cells(cells: list[list[int]]) -> list[tuple[int, int]]:
        # координаты всех пустых клеток
        return [(r, c) for r in range(SIZE) for c in range(SIZE) if cells[r][c] == EMPTY]

    @staticmethod
    def _empty_board() -> list[list[int]]:
        # пустое поле для сравнения, когда прошлого состояния ещё нет
        return [[EMPTY for _ in range(SIZE)] for _ in range(SIZE)]

    @staticmethod
    def _has_valid_shape(cells: list[list[int]]) -> bool:
        # поле должно быть SIZE x SIZE и содержать только допустимые значения клеток
        if len(cells) != SIZE:
            return False
        allowed = {EMPTY, CROSS, NOUGHT}
        return all(
            len(row) == SIZE and all(v in allowed for v in row)
            for row in cells
        )
