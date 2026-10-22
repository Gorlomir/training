import sys
import os
import time
import random
import math
from multiprocessing import Manager, Process

PHI = (1 + 5 ** 0.5) / 2

BREAK_INTERVAL = 30.0
BREAK_MIN, BREAK_MAX = 12.0, 18.0
QUESTIONS_PER_STUDENT = 3
REFRESH_INTERVAL = 0.2


# --------------------------------------------------------------------------
# Чтение входных файлов
# --------------------------------------------------------------------------

def read_people(path):
    """Читает файл вида 'Имя М' / 'Имя Ж' построчно."""
    people = []
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            parts = line.rsplit(maxsplit=1)
            if len(parts) != 2:
                continue
            name, gender = parts
            gender = gender.upper()
            people.append((name, gender))
    return people


def read_questions(path):
    questions = []
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                questions.append(line)
    return questions


# --------------------------------------------------------------------------
# Логика "золотого сечения"
# --------------------------------------------------------------------------

def golden_probs(n):
    if n <= 0:
        return []
    if n == 1:
        return [1.0]
    probs = []
    remaining = 1.0
    for _ in range(n - 1):
        p = remaining / PHI
        probs.append(p)
        remaining -= p
    probs.append(remaining)
    return probs


def choose_word_index(n_words, gender, excluded=None):
    """
    Выбирает индекс слова
    """
    excluded = excluded or set()
    available = [i for i in range(n_words) if i not in excluded]
    if not available:
        return None

    probs = golden_probs(n_words)
    if gender == "М":
        order = list(range(n_words))            # p[i] -> слово i
    else:
        order = list(range(n_words - 1, -1, -1))  # p[i] -> слово (n-1-i)

    weight_by_index = {idx: probs[i] for i, idx in enumerate(order)}
    weights = [weight_by_index[i] for i in available]
    total = sum(weights)
    weights = [w / total for w in weights]
    return random.choices(available, weights=weights, k=1)[0]


def examiner_correct_set(n_words, gender):
    """Множество индексов слов, которые экзаменатор считает верными."""
    chosen = set()
    while True:
        idx = choose_word_index(n_words, gender, excluded=chosen)
        if idx is None:
            break
        chosen.add(idx)
        if len(chosen) == n_words:
            break
        if random.random() < 1 / 3:
            continue
        break
    return chosen


def conduct_exam(questions, student_gender, examiner_gender, k=QUESTIONS_PER_STUDENT):
    """Возвращает (правильных, неправильных, [(вопрос, верно?), ...])."""
    k = min(k, len(questions))
    chosen_questions = random.sample(questions, k) if k > 0 else []
    correct, wrong = 0, 0
    answered = []
    for q in chosen_questions:
        words = q.split()
        n = len(words)
        student_idx = choose_word_index(n, student_gender)
        correct_idxs = examiner_correct_set(n, examiner_gender)
        ok = student_idx in correct_idxs
        if ok:
            correct += 1
        else:
            wrong += 1
        answered.append((q, ok))
    return correct, wrong, answered


# --------------------------------------------------------------------------
# Процесс одного экзаменатора
# --------------------------------------------------------------------------

def examiner_worker(name, gender, queue, qlock, students_info,
                     examiners_info, questions, question_stats, qstat_lock,
                     exam_start):
    name_len = len(name)
    dur_lo = max(0.1, name_len - 1)
    dur_hi = name_len + 1

    total_break = 0.0
    next_break_threshold = BREAK_INTERVAL

    while True:
        with qlock:
            if len(queue) == 0:
                break
            student_name = queue.pop(0)

        examiners_info[name]["current"] = student_name

        student_gender = students_info[student_name]["gender"]
        correct, wrong, answered = conduct_exam(questions, student_gender, gender)

        duration = random.uniform(dur_lo, dur_hi)
        time.sleep(duration)

        roll = random.random()
        if roll < 1 / 8:
            passed = False
        elif roll < 1 / 8 + 1 / 4:
            passed = True
        else:
            passed = correct > wrong

        finish_time = time.time()

        with qstat_lock:
            for q, ok in answered:
                if ok:
                    question_stats[q] = question_stats.get(q, 0) + 1

        srec = students_info[student_name]
        srec["status"] = "Сдал" if passed else "Провалил"
        srec["finish_time"] = finish_time
        srec["duration"] = duration
        srec["examiner"] = name

        erec = examiners_info[name]
        erec["current"] = "-"
        erec["total"] = erec["total"] + 1
        if not passed:
            erec["failed"] = erec["failed"] + 1

        elapsed_active = (time.time() - exam_start) - total_break
        if elapsed_active >= next_break_threshold:
            break_dur = random.uniform(BREAK_MIN, BREAK_MAX)
            time.sleep(break_dur)
            total_break += break_dur
            next_break_threshold += BREAK_INTERVAL

    erec = examiners_info[name]
    erec["current"] = "-"
    erec["finished"] = True
    erec["finish_time"] = time.time()


# --------------------------------------------------------------------------
# Отрисовка консоли
# --------------------------------------------------------------------------

def clear_screen():
    print("\033[H\033[J", end="")


def fmt_row(cols, widths):
    return " | ".join(str(c).ljust(w) for c, w in zip(cols, widths))


def render_live(students_order, students_info, examiners_order, examiners_info,
                 queue, exam_start, total_students):
    clear_screen()
    elapsed = time.time() - exam_start

    print("=== СТУДЕНТЫ ===")
    widths = [20, 10]
    print(fmt_row(["Студент", "Статус"], widths))
    print("-" * (sum(widths) + 3))

    group = {"Очередь": [], "Сдал": [], "Провалил": []}
    for nm in students_order:
        st = students_info[nm]["status"]
        group.setdefault(st, []).append(nm)

    for nm in group["Очередь"]:
        print(fmt_row([nm, "Очередь"], widths))
    for nm in group["Сдал"]:
        print(fmt_row([nm, "Сдал"], widths))
    for nm in group["Провалил"]:
        print(fmt_row([nm, "Провалил"], widths))

    print()
    print("=== ЭКЗАМЕНАТОРЫ ===")
    widths_e = [15, 18, 14, 10, 12]
    print(fmt_row(["Экзаменатор", "Текущий студент", "Всего студентов",
                   "Завалил", "Время работы"], widths_e))
    print("-" * (sum(widths_e) + 3 * 4))
    for nm in examiners_order:
        e = examiners_info[nm]
        if e.get("finished"):
            work_time = e["finish_time"] - exam_start
        else:
            work_time = time.time() - exam_start
        print(fmt_row([nm, e["current"], e["total"], e["failed"],
                        f"{work_time:.1f} c"], widths_e))

    print()
    remaining = len(queue)
    print(f"В очереди осталось: {remaining} из {total_students}")
    print(f"Время с начала экзамена: {elapsed:.1f} c")


def render_final(students_info, examiners_info, question_stats, exam_start,
                  exam_end, total_students):
    clear_screen()

    passed = [(nm, info) for nm, info in students_info.items() if info["status"] == "Сдал"]
    failed = [(nm, info) for nm, info in students_info.items() if info["status"] == "Провалил"]
    passed.sort(key=lambda x: x[1]["finish_time"])
    failed.sort(key=lambda x: x[1]["finish_time"])

    print("=== ИТОГ: СТУДЕНТЫ ===")
    widths = [20, 10]
    print(fmt_row(["Студент", "Статус"], widths))
    print("-" * (sum(widths) + 3))
    for nm, _ in passed:
        print(fmt_row([nm, "Сдал"], widths))
    for nm, _ in failed:
        print(fmt_row([nm, "Провалил"], widths))

    print()
    print("=== ИТОГ: ЭКЗАМЕНАТОРЫ ===")
    widths_e = [15, 16, 10, 12]
    print(fmt_row(["Экзаменатор", "Всего студентов", "Завалил", "Время работы"], widths_e))
    print("-" * (sum(widths_e) + 3 * 3))
    for nm, e in examiners_info.items():
        work_time = e["finish_time"] - exam_start
        print(fmt_row([nm, e["total"], e["failed"], f"{work_time:.1f} c"], widths_e))

    print()
    print(f"Время с начала и до завершения экзамена: {exam_end - exam_start:.1f} c")

    # лучшие студенты
    if passed:
        min_dur = min(info["duration"] for _, info in passed)
        best_students = [nm for nm, info in passed if abs(info["duration"] - min_dur) < 1e-9]
    else:
        best_students = []
    print("Лучшие студенты: " + (", ".join(best_students) if best_students else "нет"))

    # лучшие экзаменаторы (минимальный процент заваленных, у кого total>0)
    eligible = [(nm, e) for nm, e in examiners_info.items() if e["total"] > 0]
    if eligible:
        pct = {nm: e["failed"] / e["total"] for nm, e in eligible}
        min_pct = min(pct.values())
        best_examiners = [nm for nm, p in pct.items() if abs(p - min_pct) < 1e-9]
    else:
        best_examiners = list(examiners_info.keys())
    print("Лучшие экзаменаторы: " + (", ".join(best_examiners) if best_examiners else "нет"))

    # отчислят
    if failed:
        min_finish = min(info["finish_time"] for _, info in failed)
        expelled = [nm for nm, info in failed if abs(info["finish_time"] - min_finish) < 1e-9]
    else:
        expelled = []
    print("Будут отчислены: " + (", ".join(expelled) if expelled else "нет"))

    # лучшие вопросы
    if question_stats:
        max_count = max(question_stats.values())
        best_questions = [q for q, c in question_stats.items() if c == max_count]
    else:
        best_questions = []
    print("Лучшие вопросы: " + (", ".join(best_questions) if best_questions else "нет"))

    total_passed = len(passed)
    success = total_students > 0 and (total_passed / total_students) > 0.85
    print()
    if success:
        print(f"ЭКЗАМЕН УДАЛСЯ (сдали {total_passed} из {total_students})")
    else:
        print(f"ЭКЗАМЕН НЕ УДАЛСЯ (сдали {total_passed} из {total_students})")


# --------------------------------------------------------------------------
# main
# --------------------------------------------------------------------------

def main():
    examiners_path = sys.argv[1] if len(sys.argv) > 1 else "examiners.txt"
    students_path = sys.argv[2] if len(sys.argv) > 2 else "students.txt"
    questions_path = sys.argv[3] if len(sys.argv) > 3 else "questions.txt"

    examiners_raw = read_people(examiners_path)
    students_raw = read_people(students_path)
    questions = read_questions(questions_path)

    if not examiners_raw or not students_raw or not questions:
        print("Не удалось прочитать входные файлы (проверьте пути и содержимое).")
        return

    manager = Manager()

    students_order = [nm for nm, _ in students_raw]
    examiners_order = [nm for nm, _ in examiners_raw]

    students_info = manager.dict()
    for nm, g in students_raw:
        students_info[nm] = manager.dict(gender=g, status="Очередь",
                                          finish_time=None, duration=None,
                                          examiner=None)

    examiners_info = manager.dict()
    for nm, g in examiners_raw:
        examiners_info[nm] = manager.dict(gender=g, current="-", total=0,
                                           failed=0, finished=False,
                                           finish_time=None)

    queue = manager.list(students_order)
    qlock = manager.Lock()
    question_stats = manager.dict()
    qstat_lock = manager.Lock()

    exam_start = time.time()

    procs = []
    for nm, g in examiners_raw:
        p = Process(target=examiner_worker,
                    args=(nm, g, queue, qlock, students_info, examiners_info,
                          questions, question_stats, qstat_lock, exam_start))
        p.start()
        procs.append(p)

    total_students = len(students_order)

    try:
        while True:
            render_live(students_order, students_info, examiners_order,
                        examiners_info, queue, exam_start, total_students)
            all_done = all(examiners_info[nm]["finished"] for nm in examiners_order)
            if all_done and len(queue) == 0:
                break
            time.sleep(REFRESH_INTERVAL)
    finally:
        for p in procs:
            p.join()

    exam_end = max(examiners_info[nm]["finish_time"] for nm in examiners_order)
    render_final(students_info, examiners_info, question_stats, exam_start,
                 exam_end, total_students)


if __name__ == "__main__":
    main()
