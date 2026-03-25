#!/bin/bash
set -e
echo "▶️Старт Docker-сборки внутри WSL..."

cd /mnt/c/Users/igorpooh/Desktop/Projects/Uz.EnterCo/BaGetterUz

rm -rf ./publish
find . -type d \( -name bin -o -name obj \) -not -path "./publish/*" -exec rm -rf {} + 2>/dev/null || true



# Установка .NET SDK 10.0.201 для WSL

# 1. Скачиваем установочный скрипт
#echo "Скачиваем dotnet-install.sh..."
#wget -q https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
#chmod +x dotnet-install.sh

# 2. Устанавливаем SDK 10.0.201 в домашнюю папку
#echo "Устанавливаем .NET SDK 10.0.201..."
#./dotnet-install.sh --version 10.0.201 --install-dir $HOME/.dotnet

# 3. Настраиваем переменные для текущей сессии
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$DOTNET_ROOT:$PATH

# 4. Добавляем в ~/.bashrc, чтобы было навсегда
#if ! grep -q 'DOTNET_ROOT=$HOME/.dotnet' ~/.bashrc; then
#    echo "" >> ~/.bashrc
#    echo "# .NET 10.0.201 SDK" >> ~/.bashrc
#    echo "export DOTNET_ROOT=\$HOME/.dotnet" >> ~/.bashrc
#    echo "export PATH=\$DOTNET_ROOT:\$PATH" >> ~/.bashrc
#fi

# 5. Проверяем установку
#echo "Проверяем установку..."
#dotnet --list-sdks
#dotnet --version

#echo "Готово! SDK 10.0.201 должен работать с global.json и сборкой Docker."




dotnet clean  -c Release
echo "▶️ Публикация проектов с оптимизациями ..."

dotnet publish -c Release -f net10.0 -r linux-x64 -o ./publish

docker compose build --no-cache

echo "▶️Сборка контейнера BagetterUz..."
docker save -o bagetter.tar bagetter:latest
echo "✅  Сборка контейнера BagetterUz завершена."

exit
rm -rf ./publish

echo "▶️ Архивация контейнера BagetterUz..."
gzip -f bagetter.tar
echo "✅  Архивация контейнера BagetterUz завершена."

mv /mnt/c/Users/igorpooh/Desktop/Projects/Ru.Dolgov/ResDiary/*.tar.gz /mnt/c/Users/igorpooh/Desktop/Projects/Ru.Dolgov/ResDiary/DockerBuild

exit
echo "▶️Отправка контейнеров..."
sshpass -p 'Gjytltkmybr1978' rsync -avP --inplace /mnt/c/Users/igorpooh/Desktop/Projects/Ru.Dolgov/MyHoreca/DockerData/*.tar.gz igorpooh@45.87.246.66:/usr/local/myhoreca/
#sshpass -p 'Gjytltkmybr1978' rsync -avP --inplace /mnt/c/Users/igorpooh/Desktop/Projects/Ru.Dolgov/MyHoreca/DockerData/*.yml igorpooh@45.87.246.66:/usr/local/myhoreca/

#rm -f *.tar.gz
echo "✅  Отправка контейнеров завершена."

date +"%Y-%m-%d %H:%M:%S"

echo "✅  Готово."