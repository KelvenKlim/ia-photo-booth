@echo off
echo Iniciando emulador Android (Pixel_9a)...
start "" "%LOCALAPPDATA%\Android\Sdk\emulator\emulator.exe" -avd Pixel_9a -gpu swiftshader_indirect
echo Aguarde o Android inicializar (~1-2 min) e depois rode: flutter run
pause
