#!/bin/bash
set -e  # Останавливать выполнение при любой ошибке

REPO_DIR=~/"${GITHUB_REPOSITORY}"
BRANCH="${GITHUB_REF_NAME}"
DESTINATION="/var/www/vilkova.ru"

if [ -z "$REPO_DIR" ] || [ -z "$BRANCH" ]; then
  echo "Ошибка: Не установлены необходимые переменные окружения."
  exit 1
fi

echo '-> export NVM_DIR' && export NVM_DIR=/home/vilkova/.nvm && \
echo '-> run \$NVM_DIR/nvm.s' && [ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh" && \

echo "-> Переходим в папку репозитория ${REPO_DIR}"
cd "$REPO_DIR" || { echo "Ошибка: Директория $REPO_DIR не найдена"; exit 1; }

echo "-> Переключение на ветку $BRANCH"
git checkout "$BRANCH" || { echo "Ошибка: Не удалось переключиться на ветку $BRANCH"; exit 1; }

echo "-> Обновление репозитория"
git pull || { echo "Ошибка: Не удалось выполнить git pull"; exit 1; }

echo "-> Установка node"
nvm install || { echo "Ошибка: Не удалось установить node"; exit 1; }

echo "-> Выбор node"
nvm use || { echo "Ошибка: Не удалось установить node"; exit 1; }

echo "-> Установка зависимостей"
npm i || { echo "Ошибка: Не удалось установить зависимости"; exit 1; }

echo "-> Сборка проекта"
npm run build || { echo "Ошибка: Не удалось собрать проект"; exit 1; }

echo "-> Копируем проект в папку назначения"
cp -r dist/* ${DESTINATION} || { echo "Ошибка: Не удалось скопировать файлы"; exit 1; }

echo "Деплой успешно завершён!"
