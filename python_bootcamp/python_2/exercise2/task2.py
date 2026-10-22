import os
from urllib.parse import urlparse
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError
from pathlib import Path

while True:
    folder_input = input("Введите путь к существующей папке (например, ./img): ")
    output_folder = Path(folder_input)

    if not output_folder.exists() or not output_folder.is_dir():
        print("Ошибка: Такой папки не существует. Попробуйте снова.")
        continue

    if not os.access(output_folder, os.W_OK):
        print("Ошибка: Нет прав на запись в эту папку. Выберите другую.")
        continue

    break

download_history = []

while True:
    url = input("Введите прямую ссылку на изображение (или пустую строку для выхода): ").strip()

    if not url:
        print("Завершение работы программы.")
        break

    parsed_url = urlparse(url)
    file_name = os.path.basename(parsed_url.path)

    file_path = output_folder / file_name

    try:
        req = Request(url, headers={'User-Agent': 'Mozilla/5.0'})

        with urlopen(req, timeout=10) as response:
            if response.status == 200:
                with open(file_path, "wb") as file:
                    file.write(response.read())
                download_history.append((url, "Успешно"))
            else:
                download_history.append((url, "Ошибка"))

    except (URLError, HTTPError, Exception):
        download_history.append((url, "Ошибка"))

if download_history:
    max_url_len = max(max(len(row[0]) for row in download_history), 50)
    max_url_len = min(max_url_len, 80)
    status_len = 20

    print("=" * (max_url_len + status_len + 5))
    print(f" {'Ссылка'.ljust(max_url_len)} | {'Статус'.ljust(status_len)} ")
    print("=" * (max_url_len + status_len + 5))

    for url, status in download_history:
        display_url = url if len(url) <= max_url_len else url[:max_url_len - 3] + "..."
        print(f" {display_url.ljust(max_url_len)} | {status.ljust(status_len)} ")

    print("=" * (max_url_len + status_len + 5))
else:
    print("Вы не ввели ни одной ссылки.")
