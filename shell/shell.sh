#!/bin/bash

# Проверяем, что скрипт запущен с правами суперпользователя
if [ $(id -u) -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

# Проверяем, что переданы аргументы
if [ $# -eq 0 ]; then
  echo "Specify files to delete."
  exit 1
fi

# Создаем директорию для хранения удаленных файлов
TRASH_DIR="$HOME/.trash"
mkdir -p $TRASH_DIR

# Перемещаем файлы в директорию для удаленных файлов
for file in "$@"; do
  if [ -f "$file" ]; then
    mv "$file" "$TRASH_DIR"
    echo "file \"$file\" moved to trash"
  else
    echo "file \"$file\" not found."
  fi
done

# Выводим список удаленных файлов и спрашиваем, нужно ли их восстановить
echo "Do you want to restore some file? (y/n)"
read answer

while [ "$answer" = "y" ]; do
  echo "Enter the name of the file you want to recover:"
  read filename

  if [ -f "$TRASH_DIR/$filename" ]; then
    mv "$TRASH_DIR/$filename" .
    echo "file \"$filename\" restored"
  else
    echo "file \"$filename\" not found in cart."
  fi

  echo "Do you want to restore another file? (y/n)"
  read answer
done

exit 0
