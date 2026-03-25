#!/bin/bash
set -e
echo "▶️Старт Docker-сборки внутри WSL..."

cd /mnt/c/Users/igorpooh/Desktop/Projects/Uz.EnterCo/BaGetterUz

rm -rf ./publish
find . -type d \( -name bin -o -name obj \) -not -path "./publish/*" -exec rm -rf {} + 2>/dev/null || true
dotnet clean  -c Release
echo "▶️ Публикация проектов с оптимизациями ..."

dotnet publish  -c Release -r linux-x64 -o ./publish

exit

rm -rf ./publish/ResDiary/wwwroot/html

docker compose build --no-cache
echo "▶️Сборка контейнера DbUpdater..."
docker save -o dbupdater.tar dbupdater:latest
echo "✅  Сборка контейнера DbUpdater завершена."

echo "▶️Сборка контейнера ResDiary..."
docker save -o resdiary.tar resdiary:latest
echo "✅  Сборка контейнера ResDiary завершена."

echo "▶️Сборка контейнера ApiGateway..."
docker save -o apigateway.tar apigateway:latest
echo "✅  Сборка контейнера ApiGateway завершена."

echo "▶️Сборка контейнера ServiceUser..."
docker save -o serviceuser.tar serviceuser:latest
echo "✅  Сборка контейнера User завершена."

echo "▶️Сборка контейнера ServiceResDiary..."
docker save -o serviceresdiary.tar serviceresdiary:latest
echo "✅  Сборка контейнера ServiceResDiary завершена."

echo "▶️Сборка контейнера ServiceSyrvePlugin..."
docker save -o servicesyrveplugin.tar servicesyrveplugin:latest
echo "✅  Сборка контейнера ServiceSyrvePlugin завершена."


rm -rf ./publish

echo "▶️ Архивация контейнера DbUpdater..."
gzip -f dbupdater.tar
echo "✅  Архивация контейнера DbUpdater завершена."

echo "▶️ Архивация контейнера ResDiary..."
gzip -f resdiary.tar
echo "✅  Архивация контейнера ResDiary завершена."
echo "▶️ Архивация контейнера ApiGateway..."
gzip -f apigateway.tar
echo "✅  Архивация контейнера ApiGateway завершена."
echo "▶️ Архивация контейнера ServiceUser..."
gzip -f serviceuser.tar
echo "✅  Архивация контейнера ServiceUser завершена."
echo "▶️ Архивация контейнера ServiceResDiary..."
gzip -f serviceresdiary.tar
echo "✅  Архивация контейнера ServiceResDiary завершена."
echo "▶️ Архивация контейнера ServiceSyrvePlugin..."
gzip -f servicesyrveplugin.tar
echo "✅  Архивация контейнера ServiceSyrvePlugin завершена."

mv /mnt/c/Users/igorpooh/Desktop/Projects/Ru.Dolgov/ResDiary/*.tar.gz /mnt/c/Users/igorpooh/Desktop/Projects/Ru.Dolgov/ResDiary/DockerBuild

exit
echo "▶️Отправка контейнеров..."
sshpass -p 'Gjytltkmybr1978' rsync -avP --inplace /mnt/c/Users/igorpooh/Desktop/Projects/Ru.Dolgov/MyHoreca/DockerData/*.tar.gz igorpooh@45.87.246.66:/usr/local/myhoreca/
#sshpass -p 'Gjytltkmybr1978' rsync -avP --inplace /mnt/c/Users/igorpooh/Desktop/Projects/Ru.Dolgov/MyHoreca/DockerData/*.yml igorpooh@45.87.246.66:/usr/local/myhoreca/

#rm -f *.tar.gz
echo "✅  Отправка контейнеров завершена."

date +"%Y-%m-%d %H:%M:%S"

echo "✅  Готово."