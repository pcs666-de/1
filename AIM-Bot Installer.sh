#!/bin/bash

echo -ne "\033]0;AIM-Bot Installer\007"
echo -e "\033[32m"
clear

echo
echo "    -- AIM-Bot Installer --"
echo
echo "    Made by Philip :D"
echo
echo

read -p "To install - press Enter" _

SCRIPT_PATH="$(realpath "$0")"
TARGET_DIR="$HOME/Desktop/AIM-Bot"

echo "Creating folder..."
sleep 0.1
mkdir -p "$TARGET_DIR"

# Copy installer itself
cp "$SCRIPT_PATH" "$TARGET_DIR"

cd "$TARGET_DIR" || exit

echo "Downloading files..."
sleep 0.1

# Starter
wget -q https://raw.githubusercontent.com/pcs666-de/1/main/starter.sh -O starter.sh
echo "starter.sh Done!"

sleep 0.2

# Aimbot
wget -q https://raw.githubusercontent.com/pcs666-de/1/main/aimbot.sh -O aimbot.sh
echo "aimbot.sh Done!"

sleep 0.1

# Key file
wget -q https://raw.githubusercontent.com/pcs666-de/1/main/key-secret.wav -O key-secret.wav
echo "key-secret Done!"

wget -q https://raw.githubusercontent.com/pcs666-de/1/main/key-creator.sh -O key-creator.sh
echo "key-creator.sh Done!"

chmod +x starter.sh
chmod +x aimbot.sh
chmod +x key-creator.sh

./key-creator.sh
read -p "Do you wanna start the AIM-Bot? - If yes: press Enter" _

./starter.sh
