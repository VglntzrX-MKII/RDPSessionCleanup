@echo off
setlocal enabledelayedexpansion

:: ===========================================================================
:: CONFIGURATION
:: Set the directory where logs will be created. Use quotes for paths with spaces.
set "LOG_PATH=C:\RDPLogs"
:: ===========================================================================

if not exist "%LOG_PATH%" mkdir "%LOG_PATH%" >nul 2>&1
call :Main >> "%LOG_PATH%\run.log" 2>&1
exit /b 0

:Main
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: This script requires administrator privileges.
    exit /b 1
)

echo Vglntzr's RDP Session Cleanup v0.2a - Logging out disconnected sessions 
echo ==========================================================================
echo Script executed on: %date% %time%
echo.

set /a TOTAL_SESSIONS=0
set /a LOGGED_OUT=0

:: Process disconnected sessions
for /f "skip=1 tokens=1,2,3" %%a in ('query session 2^>nul ^| findstr /i "Disc"') do (
    set /a TOTAL_SESSIONS+=1
    
    if "%%c"=="Disc" (
        set SESSION_ID=%%b
        set SESSION_USER=%%a
        
        echo Found disconnected session:
        echo   Session ID: !SESSION_ID!
        echo   User: !SESSION_USER!
        
        :: Skip services session (session 0) as it can't be logged out normally
        if "!SESSION_ID!"=="0" (
            echo   [INFO] Services session cannot be logged out - skipping
            echo.
        ) else (
            echo   [ACTION] Logging out session...
            
            logoff !SESSION_ID! >nul 2>&1
            if !errorlevel! equ 0 (
                echo   [SUCCESS] Session !SESSION_ID! has been logged out.
                echo [!date! !time!] SessionID: !SESSION_ID! User: !SESSION_USER! >> "C:\RDPLogs\disconnect.log"
                set /a LOGGED_OUT+=1
            ) else (
                echo   [ERROR] Failed to log out session !SESSION_ID!
                echo   [DEBUG] Trying rwinsta...
                rwinsta !SESSION_ID! >nul 2>&1
                if !errorlevel! equ 0 (
                    echo   [SUCCESS] Session reset using rwinsta.
                    echo [!date! !time!] SessionID: !SESSION_ID! User: !SESSION_USER! >> "C:\RDPLogs\disconnect.log"
                    set /a LOGGED_OUT+=1
                ) else (
                    echo   [ERROR] All methods failed for session !SESSION_ID!
                )
            )
            echo.
        )
    )
)

:: Summary
echo ===========================================================================
echo SUMMARY:
echo Total disconnected sessions found: !TOTAL_SESSIONS!
echo Sessions logged out: !LOGGED_OUT!
echo Script completed on: %date% %time%
echo ===========================================================================
echo:

if !TOTAL_SESSIONS! equ 0 (
    echo No disconnected RDP sessions found.
    echo:
)
exit /b
