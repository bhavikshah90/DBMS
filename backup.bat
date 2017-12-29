@ECHO OFF

set TIMESTAMP=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%

REM Export all databases into file C:\path\backup\databases.[year][month][day].sql
"C:\Program Files (x86)\MySQL\MySQL Server 5.7\bin\mysqldump.exe" --databases finalproject --result-file="C:\Users\akash\Desktop\db\databases.%TIMESTAMP%.sql" --user=root --password=Bh@vik231090

REM Change working directory to the location of the DB dump file.
C:
CD C:\Users\akash\Desktop\db\

REM Compress DB dump file into CAB file (use "EXPAND file.cab" to decompress).
MAKECAB "databases.%TIMESTAMP%.sql" "databases.%TIMESTAMP%.sql.cab"

REM Delete uncompressed DB dump file.
DEL /q /f "databases.%TIMESTAMP%.sql"