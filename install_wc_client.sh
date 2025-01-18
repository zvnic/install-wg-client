#!/bin/bash

# Проверка наличия аргумента
if [ -z "$1" ]; then
    echo "Ошибка: Не указан файл конфигурации."
    echo "Использование: $0 {file_name.conf}"
    exit 1
fi

CONFIG_FILE="$1"
DESTINATION="/etc/wireguard/wg0.conf"

# Обновление системы
echo "Обновление системы..."
sudo apt update && sudo apt upgrade -y

# Установка WireGuard и resolvconf
echo "Установка WireGuard и resolvconf..."
sudo apt install wireguard resolvconf -y

# Загрузка модуля WireGuard
echo "Загрузка модуля WireGuard..."
sudo modprobe wireguard

# Включение и запуск resolvconf
echo "Включение и запуск resolvconf..."
sudo systemctl enable resolvconf --now

# Проверка существования файла конфигурации
if [ -f "$CONFIG_FILE" ]; then
    echo "Копирование файла конфигурации $CONFIG_FILE в $DESTINATION..."
    sudo cp "$CONFIG_FILE" "$DESTINATION"
else
    echo "Ошибка: Файл $CONFIG_FILE не найден!"
    exit 1
fi

# Установка прав на файл конфигурации
echo "Установка прав на файл конфигурации..."
sudo chmod 600 "$DESTINATION"

# Включение сервиса WireGuard
echo "Включение сервиса wg-quick@wg0.service..."
sudo systemctl enable wg-quick@wg0.service

# Запуск WireGuard
echo "Запуск WireGuard..."
sudo wg-quick up wg0

# Проверка состояния WireGuard
echo "Состояние WireGuard:"
sudo wg show

echo "Установка и настройка WireGuard завершена."
