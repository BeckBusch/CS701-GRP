@echo off
setlocal enabledelayedexpansion

:: Check if the correct number of arguments is provided
if "%~4"=="" (
    echo Usage: %0 [search_directory] [file_extension] [entity] [time]
    echo Example: %0 "C:\Your\Path\Here" ".txt" "Entity" "Time in ns"
    exit /b 1
)

:: Set the directory and file extension from command line arguments
set "search_directory=%~1"
set "file_extension=%~2"
set "entity=%~3"
set "time=%~4"

echo Searching for files with the extension %file_extension% in %search_directory% and its subdirectories.
echo.

pushd "%search_directory%"
for /r %%f in (*%file_extension%) do (
    set "relative_path=%%f"
    set "relative_path=!relative_path:%search_directory%\=!"
    echo Found: !relative_path!
    
    ghdl -a .\!relative_path!
)
popd

ghdl -e %entity%
ghdl -r %entity% --vcd=WaveformOutput.vcd --stop-time=%time%ns

echo.
echo Search completed.

endlocal