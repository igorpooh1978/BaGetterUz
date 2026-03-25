@echo off
git add .
git commit -a -m "build to nuget" 
git push

wsl -d Ubuntu bash /mnt/c/Users/igorpooh/Desktop/Projects/Uz.EnterCo/BaGetterUz/docker_build.sh
pause
