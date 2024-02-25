@echo off
:: Check for administrative privileges
>nul 2>&1 net session || (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/c \"%~0 %*\"'"
    exit /b
)

echo ============================================================================
echo = This batch will remove all "elevated_" Scheduled tasks!                      =
echo = If you do not want to continue, close the window or hit Ctrl+C            =
echo ============================================================================
echo Checking for "elevated_" tasks...

set "taskExist=false"

for /f "delims=" %%a in ('powershell -Command "Get-ScheduledTask | Where-Object { $_.TaskName -like 'elevated_*' } | Select-Object -ExpandProperty TaskName"') do (
    set "taskExist=true"
    echo Deleting task: %%a
    schtasks.exe /delete /tn "%%a" /f
)

if "%taskExist%"=="false" (
    echo No "elevated_" tasks found.
)

pause
