@echo off

REM Set the paths to ImageJ and Rscript executable
set IMAGEJ_PATH="C:\path\to\ImageJ\ImageJ-win64.exe"
set RSCRIPT_PATH="C:\path\to\R\bin\Rscript.exe"

REM Get the input and output folder paths from command-line arguments
set INPUT_FOLDER=%1
set OUTPUT_FOLDER=%2

REM Check if input and output folders are provided
if "%INPUT_FOLDER%"=="" (
    echo Input folder path is missing.
    exit /b 1
)

if "%OUTPUT_FOLDER%"=="" (
    echo Output folder path is missing.
    exit /b 1
)

REM Execute the ImageJ script with input and output folder arguments
%IMAGEJ_PATH% -batch -macro ImageJ_Script.js "inputFolder='%INPUT_FOLDER%'" "outputFolder='%OUTPUT_FOLDER%'"

REM Set the directory where your CSV files are located in R
set csv_directory=%OUTPUT_FOLDER%

REM Execute the R script to process CSV files
%RSCRIPT_PATH% Data_Cleanup.R

%RSCRIPT_PATH% EDA_Vis.R