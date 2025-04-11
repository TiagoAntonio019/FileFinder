# 📁FileFinder
FileFinder is a PowerShell script designed to search and optionally delete files in a specified directory and its subdirectories.

It uses a regular expression to identify files with names that match a specific pattern (e.g., files containing numbers inside parentheses like file (1).txt).

## 🧪How to use
```
.\fileFinder.ps1 -directory "B:\" -outputFile "B:\"
```
- -directory: Path to the folder you want to scan.
- -outputFile: Path to the folder where the .csv report will be saved.
