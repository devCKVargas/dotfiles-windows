: TODO: fix admin permission

@echo off
:: Request administrative privileges
powershell -Command "Start-Process -Verb RunAs -FilePath '%comspec%' -ArgumentList '/c \"%~0 %*\"'"

:: Check for administrative privileges
NET SESSION >NUL 2>NUL
if %ERRORLEVEL% EQU 0 (
    echo ============================================================================
    echo = Setup Scheduled task for elevated auto-starts without UAC prompt =
    echo = If you do not want to continue, close the window or hit Ctrl+C   =
    echo ============================================================================
    echo Going to run command:

    for %%f in (.\elevated_*.xml) do (
        echo Creating task from XML: %%f
        schtasks.exe /CREATE /TN "%%~nf" /XML "%%f"
    )

    pause
) else (
    echo =================================
    echo = Requesting admin access failed =
    echo =================================
    pause
    exit /b 1
)
