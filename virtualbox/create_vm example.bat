@echo off

:: Параметры виртуалки
set VM_NAME=Win11VM
set RAM_SIZE=8192
set CPU_COUNT=4
set DISK_SIZE=81920

:: Пути до файлов
:: set WIN_ISO="C:\Users\changeme\Desktop\Win11_24H2_Russian_x64.iso"
:: set UNATTEND_ISO="C:\Users\changeme\Desktop\unattend.iso"
:: set DISK_PATH="C:\Users\changeme\Desktop\Win11VM.vdi"
set WIN_ISO=
set UNATTEND_ISO=
set DISK_PATH=

set GUEST_ADDITIONS_ISO="C:\Program Files\Oracle\VirtualBox\VBoxGuestAdditions.iso"

:: Проверка существования файла unattend.iso
if not exist %UNATTEND_ISO% (
    echo Ошибка: Файл unattend.iso не найден!
    pause
    exit /b
)

:: Удаление старой виртуальной машины, если она существует
VBoxManage unregistervm "%VM_NAME%" --delete

:: Создание виртуальной машины
VBoxManage createvm --name "%VM_NAME%" --ostype "Windows11_64" --register

:: Настройка параметров машины
VBoxManage modifyvm "%VM_NAME%" --memory %RAM_SIZE% --cpus %CPU_COUNT% --graphicscontroller vboxsvga --vram 128

:: Создание виртуального жесткого диска
VBoxManage createhd --filename %DISK_PATH% --size %DISK_SIZE% --format VDI

:: Добавление контроллера SATA и подключение дисков
VBoxManage storagectl "%VM_NAME%" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "%VM_NAME%" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium %DISK_PATH%
VBoxManage storageattach "%VM_NAME%" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium %WIN_ISO%
VBoxManage storageattach "%VM_NAME%" --storagectl "SATA Controller" --port 2 --device 0 --type dvddrive --medium %GUEST_ADDITIONS_ISO%
VBoxManage storageattach "%VM_NAME%" --storagectl "SATA Controller" --port 3 --device 0 --type dvddrive --medium %UNATTEND_ISO%

:: Запуск виртуальной машины
:: VBoxManage startvm "%VM_NAME%" --type gui
pause
