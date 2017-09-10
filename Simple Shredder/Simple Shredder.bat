@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET Parent=%~dp0
SET Self=%~n0
SET Sprompt=%Self% ^$
SET Sprompt1=%Self% $
SET SDsource=https://live.sysinternals.com/Files/SDelete.zip
SET Ver=v1.70
REM Add title and set size ;)
TITLE %Self%
MODE CON: COLS=95 LINES=30

CD /D "%Parent%"

:TESTBIT
SET "SDelete="
SET "OS_ARCH="
FOR /F "tokens=2 delims==" %%a IN ('WMIC OS GET OSARCHITECTURE /VALUE ^| FIND "="') DO SET "OS_ARCH=%%a"
IF "%OS_ARCH%"=="32-bit" (
	SET SDelete=sdelete.exe
	GOTO :SDELEXIST
) ELSE (
	IF "%OS_ARCH%"=="64-bit" (
		SET SDelete=sdelete64.exe
		GOTO :SDELEXIST
) ELSE (
	GOTO :UNSUP
	)
)

:SDELEXIST
IF NOT EXIST %SDelete% (
	COLOR 4E
	CALL :HEADER
	ECHO.
	ECHO %Sprompt%: The %SDelete% binary was NOT found in parent directory.
	ECHO %Sprompt%: Download SDelete from %SDsource%
	ECHO %Sprompt%: Extract the SDelete.zip in %Parent%
	ECHO %Sprompt%: PRESS ANY KEY TO CONTINUE.
	PAUSE >NUL
	GOTO :HASFILE
) ELSE (
	IF EXIST %SDelete% (
		COLOR A
		CALL :HEADER
		ECHO.
		ECHO %Sprompt%: The %SDelete% binary WAS found in %Parent%
		::PING 1.0.0.0 -n 1 -w 300 >NUL
		GOTO :HASFILE
	)
)
:HASFILE
REM Check if user clicked on icon or dropped a file.
IF EXIST "%~1" ( 2>NUL PUSHD "%~1" POPD & GOTO :MENU ) ELSE ( GOTO :MSG )

:HEADER
ECHO.
ECHO  +-------------------------------------------------------------------------------------------+
ECHO  :                        * * *  S I M P L E   S H R E D D E R  * * *                        :
ECHO  +-------------------------------------------------------------------------------+ %Ver% +---+
GOTO :EOF

:MSG
COLOR E
CALL :HEADER
ECHO  :                                                                                           :
ECHO  :          Simple Shredder is a batch script that uses SDelete v2.0 either 32-bit or        :
ECHO  :          64-bit depending on your system. SDelete is (C) Mark Russinovich.                :
ECHO  :                                                                                           :
ECHO  :          Copyright (c) 2017 the-j0k3r <th3-j0ker at protonmail dot com>                   :
ECHO  :                                                                                           :
ECHO  :          This program is FREE software. You can redistribute it and/or                    :
ECHO  :          modify it under the terms of the GNU General Public License                      :
ECHO  :          as published by the Free Software Foundation; either version 2                   :
ECHO  :          of the License, or (at your option) any later version.                           :
ECHO  :                                                                                           :
ECHO  :          This program is distributed in the HOPE that it will be USEFUL,                  :
ECHO  :          but WITHOUT ANY WARRANTY; without even the implied warranty of                   :
ECHO  :          MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                             :
ECHO  :          See the GNU General Public License for more details.                             :
ECHO  :                                                                                           :
ECHO  :          You should have received a copy of the GNU General Public License                :
ECHO  :          along with this program. If not, write to the Free Software Foundation,          :
ECHO  :          Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.               :
ECHO  :                                                                                           :
ECHO  +-------------------------------------------------------------------------------------------+
ECHO.
ECHO %Sprompt%: INFO: Drop Files / Folders to be deleted onto the %Self% Icon.
ECHO %Sprompt%: PRESS ANY KEY TO EXIT.
PAUSE >NUL.
GOTO :EXIT

:HELP
CLS
COLOR 1F
CALL :HEADER
ECHO.
ECHO  +--------------------------------------+ HELP AND FAQ +-------------------------------------+
ECHO  :                                                                                           :
ECHO  :  1) When dropping a mix* of folders or folders + files at same time only only the main**  :
ECHO  :     file or folder contents will be listed in detail. If you want to review the listing   :
ECHO  :     for a large directory containing other folders and files that you drop them alone.    :
ECHO  :                                                                                           :
ECHO  :  *  All mixed items will be deleted irrespectively if they are listed in detail or not.   :
ECHO  :  ** The main file or folder in the group is the one you select and drop into the Icon.    :
ECHO  :                                                                                           :
ECHO  :  2) Listing of items dropped only happens after selection the number of passes and in     :
ECHO  :     accordance to limitation #1.                                                          :
ECHO  :                                                                                           :
ECHO  :  3) You must drag and drop files or folders onto Shredder Icon to be processed, if not    :
ECHO  :     there is no way to determine if items were dropped after you clicked the Shredder     :
ECHO  :     Icon, so only the licence is shown.                                                   :
ECHO  :                                                                                           :
ECHO  :  4) Single drop empty Directories are not listed, but are deleted none-the-less.          :
ECHO  :                                                                                           :
ECHO  +-------------------------------------------------------------------------------------------+
ECHO.

:RTMMQ
ECHO %Sprompt%: PRESS "N" KEY TO EXIT.
SET /P RtMM="%Sprompt1%: Return to Main Menu [Y/N]? "
IF /I "%RtMM%" EQU "Y" GOTO :MENU
IF /I "%RtMM%" EQU "N" GOTO :EXIT
::IF /I "%RtMM%"=="%RtMM%" GOTO :ERROR
::ERROR
ECHO %Sprompt1%: ERROR: Not a valid option. Valid options are [Y/N], try again^^!
GOTO :RTMMQ

:MENU
CLS
VER > NUL
CALL :HEADER
ECHO.
ECHO                           Press CTRL+C to Abort and Terminate Batch Job
ECHO.
COLOR 4F
SET "Passes="
ECHO  +-----------------------------------------+ MAIN MENU +-------------------------------------+
ECHO  :                                                                                           :
ECHO  :                                   [1] 2 Secure DoD Passes                                 :
ECHO  :                                   [2] 3 Secure DoD Passes                                 :
ECHO  :                                   [3] 4 Secure DoD Passes                                 :
ECHO  :                                   [4] 5 Secure DoD Passes                                 :
ECHO  :                                   [5] 6 Secure DoD Passes                                 :
ECHO  :                                                                                           :
ECHO  :                                   [6] Help and FAQ                                        :
ECHO  :                                   [7] EXIT                                                :
ECHO  :                                                                                           :
ECHO  +-------------------------------------------------------------------------------------------+
ECHO.
CHOICE /C 1234567 /M "%Sprompt1%: Select the number of secure passes to use: "
IF %ERRORLEVEL%==1 SET Passes=2
IF %ERRORLEVEL%==2 SET Passes=3
IF %ERRORLEVEL%==3 SET Passes=4
IF %ERRORLEVEL%==4 SET Passes=5
IF %ERRORLEVEL%==5 SET Passes=6
IF %ERRORLEVEL%==6 GOTO :HELP
IF %ERRORLEVEL%==7 GOTO :EXIT
ECHO %Sprompt%: INFO: %Passes% passes are set to securely delete the items queued.
ECHO %Sprompt%: INFO: %Self% has loaded SDelete %OS_ARCH%.
ECHO.

SET "arg=%*"
SET "arg=%arg:)=^)%"
SET "arg=%arg:(=^(%"

:LIST
REM We cant reliably list in detail e.g multiple directories via drag and drop.
REM Because of this batch limitation only the selected and first dropped item is listed in detail.
REM Look into loading items dynamically by browsing for them and queuing them instead.
ECHO  +-----------------------+ BEGIN LISTING ITEMS QUEUED FOR DELETION +-------------------------+
ECHO.
FOR /F "tokens=1,2 delims=d" %%b IN ("-%~a1") DO (
	IF "%%c" NEQ "" (
		FOR /R "%~f1" %%d IN (*) DO (
			ECHO %Sprompt%: %%d
		)
) ELSE (
	IF "%%c" NEQ "-" (
		FOR %%d IN (%arg%) DO (
			ECHO %Sprompt%: %%~fd
		)
	)
)
ECHO.
ECHO  +------------------------+ END LISTING ITEMS QUEUED FOR DELETION +--------------------------+
ECHO.
GOTO :WDELQ

:SDELETE
REM Because we cant reliably detect SDelete error level, its advised to review SDelete output.
IF "%OS_ARCH%" == "64-bit" (
	FOR %%c IN (%arg%) DO (
		%SDelete% -p %Passes% -s "%%~fc"
	)
) ELSE (
	IF "%OS_ARCH%" == "32-bit" (
		FOR %%c IN (%arg%) DO (
			%SDelete% -p %Passes% -s "%%~fc"
		)
	)
)
::ECHO.
ECHO %Sprompt%: TIP: Scroll up to review process output log.
PING 1.1.1.1 -n 1 -w 80 >NUL
ECHO %Sprompt%: PRESS ANY KEY TO EXIT.
PAUSE >NUL
GOTO :EXIT

:WDELQ
VER > NUL
CHOICE /C YN /M "%Sprompt1%: Would you like to proceed and permanently delete all items listed: "
IF %ERRORLEVEL%==1 GOTO :SDELETE
IF %ERRORLEVEL%==2 GOTO :MENU
GOTO :WDELQ

:EXIT
COLOR 0E
CALL :EXITH
ECHO %KthX%
ECHO %ExiT% . . .
PING 1.0.0.0 -n 1 -w 100 >NUL
CALL :EXITH
ECHO %KthX%
ECHO %ExiT% .
PING 1.0.0.0 -n 1 -w 100 >NUL
CALL :EXITH
ECHO %KthX%
ECHO %ExiT% . .
PING 1.0.0.0 -n 1 -w 100 >NUL
CALL :EXITH
ECHO %KthX%
ECHO %ExiT% . . .
PING 1.0.0.0 -n 1 -w 100 >NUL
EXIT

:UNSUP
COLOR 0B
CALL :HEADER
ECHO.
ECHO %Sprompt%: ERROR: OS architecture %OS_ARCH% is NOT supported!
ECHO %Sprompt%: PRESS ANY KEY TO EXIT.
PAUSE >NUL
CALL :EXIT

:EXITH
SET KthX=%Sprompt%: Thank you for using %Self% :)
SET ExiT=%Sprompt%: Will now exit
CLS
CALL :HEADER
ECHO.
ENDLOCAL
:END
