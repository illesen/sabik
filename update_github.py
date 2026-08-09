import base64
import os
import requests

# === НАСТРОЙКИ ===
GITHUB_TOKEN = "ВАШ_ТОКЕН_GHP_СЮДА"
REPO_OWNER = "illesen"  # Ваше имя пользователя на GitHub
REPO_NAME = "sabik"  # Название вашего репозитория
FILE_PATH = "FinkaVozForFamily.lua"  # Путь к файлу в репозитории
COMMIT_MESSAGE = "Автоматическое обновление скрипта через API"


def update_github_file():
    # 1. Проверяем, существует ли локальный файл
    if not os.path.exists(FILE_PATH):
        print(f"Ошибка: Локальный файл {FILE_PATH} не найден!")
        return

    # Читаем локальный обновленный код
    with open(FILE_PATH, "r", encoding="utf-8") as f:
        local_content = f.read()

    url = f"https://github.com{REPO_OWNER}/{REPO_NAME}/contents/{FILE_PATH}"
    headers = {
        "Authorization": f"token {GITHUB_TOKEN}",
        "Accept": "application/vnd.github.v3+json",
    }

    # 2. Получаем текущую версию (SHA) файла из GitHub, это обязательно для обновления
    response = requests.get(url, headers=headers)

    sha = None
    if response.status_code == 200:
        sha = response.json().get("sha")
    elif response.status_code != 404:
        print(f"Ошибка при получении данных репозитория: {response.text}")
        return

    # 3. Кодируем новый контент в Base64 (требование API GitHub)
    base64_content = base64.b64encode(local_content.encode("utf-8")).decode(
        "utf-8"
    )

    # Формируем тело запроса
    data = {"message": COMMIT_MESSAGE, "content": base64_content}
    if sha:
        data["sha"] = sha  # Передаем SHA, если файл уже существует

    # 4. Отправляем изменения
    put_response = requests.put(url, headers=headers, json=data)

    if put_response.status_code in:
        print(" Успешно! Файл обновлен в репозитории GitHub.")
    else:
        print(f"Ошибка при обновлении файла: {put_response.text}")


if __name__ == "__main__":
    update_github_file()
