#!/bin/bash

validate_params() {
    # Проверка абсолютного пути
    if [[ ! "$ABSOLUTE_PATH" = /* ]]; then
        echo "Ошибка: путь должен быть абсолютным"
        exit 1
    fi

    # Проверка существования директории
    if [ ! -d "$ABSOLUTE_PATH" ]; then
        echo "Ошибка: директория $ABSOLUTE_PATH не существует"
        exit 1
    fi

    # Проверка чисел
    if ! [[ "$NUM_FOLDERS" =~ ^[0-9]+$ ]] || [ "$NUM_FOLDERS" -le 0 ]; then
        echo "Ошибка: количество папок должно быть положительным числом"
        exit 1
    fi

    if ! [[ "$NUM_FILES" =~ ^[0-9]+$ ]] || [ "$NUM_FILES" -le 0 ]; then
        echo "Ошибка: количество файлов должно быть положительным числом"
        exit 1
    fi

    # Проверка длины
    if [ ${#FOLDER_LETTERS} -gt 7 ]; then
        echo "Ошибка: для названия папок не более 7 символов"
        exit 1
    fi

    if [ ${#FILE_NAME} -gt 7 ]; then
        echo "Ошибка: для имени файла не более 7 символов"
        exit 1
    fi

    if [ ${#FILE_EXT} -gt 3 ]; then
        echo "Ошибка: для расширения не более 3 символов"
        exit 1
    fi

    # Проверка, что буквы только английские
    if [[ ! "$FOLDER_LETTERS" =~ ^[a-zA-Z]+$ ]]; then
        echo "Ошибка: буквы для папок должны быть английскими"
        exit 1
    fi

    if [[ ! "$FILE_NAME" =~ ^[a-zA-Z]+$ ]]; then
        echo "Ошибка: буквы для имени файла должны быть английскими"
        exit 1
    fi

    if [[ ! "$FILE_EXT" =~ ^[a-zA-Z]+$ ]]; then
        echo "Ошибка: расширение должно содержать только английские буквы"
        exit 1
    fi

    # Проверка размера файла
    if ! [[ "$FILE_SIZE_KB" =~ ^[0-9]+$ ]] || [ "$FILE_SIZE_KB" -le 0 ] || [ "$FILE_SIZE_KB" -gt 100 ]; then
        echo "Ошибка: размер файла должен быть числом от 1 до 100 KB"
        exit 1
    fi

    # Проверка имя.расширение
    if [[ ! "$FILE_NAME_EXT" =~ ^[a-zA-Z]+\.[a-zA-Z]+$ ]]; then
        echo "Ошибка: параметр 5 должен быть в формате имя.расширение"
        exit 1
    fi
}
