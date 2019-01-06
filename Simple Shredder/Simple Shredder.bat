@ECHO OFF
REM UNCOMMENT BELOW FOR DEBUG
::IF NOT DEFINED in_subprocess (CMD /K SET in_subprocess=y ^& %0 %*) & EXIT )
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET Parent=%~dp0
SET Self=%~n0
SET Sprompt=%Self% ^$
SET Sprompt1=%Self% $
SET SDsource=https://live.sysinternals.com/Files/SDelete.zip
SET Ver=v1.89
REM Add title and set size ;)
TITLE %Self%
MODE CON: COLS=97 LINES=35

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
	ECHO %Sprompt%: ERROR: The %SDelete% binary was NOT found in parent directory.
	ECHO.
	ECHO %Sprompt%: INFO: Download SDelete from %SDsource%
	ECHO %Sprompt%: INFO: Extract the SDelete.zip in %Parent%
	ECHO %Sprompt%: INFO: Drop Files / Folders to be deleted onto the %Self% Icon.
	ECHO %Sprompt%: PRESS ANY KEY TO EXIT.
	PAUSE >NUL
	GOTO :EXIT
) ELSE (
	IF EXIST %SDelete% (
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
MODE CON: COLS=95 LINES=31
COLOR E
CALL :HEADER
ECHO  :                                                                                           :
ECHO  :          Simple Shredder is a batch script that uses SDelete v2.0 either 32-bit or        :
ECHO  :          64-bit depending on your system. SDelete is (C) Mark Russinovich.                :
ECHO  :                                                                                           :
ECHO  :          Copyright (C) 2017 the-j0k3r ^<th3-j0ker at protonmail dot com^>                   :
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
ECHO %Sprompt%: INFO: Drop Files / Folders to be shredded onto the %Self% Icon.
ECHO.
ECHO %Sprompt%: PRESS "N" KEY TO EXIT.
CHOICE /M "%Sprompt1%: Display HELP AND FAQ"
IF %ERRORLEVEL%==1 CALL :HELPB
IF %ERRORLEVEL%==2 GOTO :EXIT

:HELP
CLS
MODE CON: COLS=95 LINES=40
COLOR 1F
CALL :HEADER
TYPE HELP_AND_FAQ

:RTMMQ
ECHO %Sprompt%: PRESS "N" KEY TO EXIT.
CHOICE /M "%Sprompt1%: Return to Main Menu"
IF %ERRORLEVEL%==1 GOTO :MENU
IF %ERRORLEVEL%==2 GOTO :EXIT
GOTO :RTMMQ

:MENU
MODE CON: COLS=97 LINES=35
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
ECHO  :                                   [2] 4 Secure DoD Passes                                 :
ECHO  :                                   [3] 6 Secure DoD Passes                                 :
ECHO  :                                   [4] 8 Secure DoD Passes                                 :
ECHO  :                                   [5] x Custom DoD Passes                                 :
ECHO  :                                                                                           :
ECHO  :                                   [6] Drop to CMD Line                                    :
ECHO  :                                   [7] Help and FAQ                                        :
ECHO  :                                   [8] EXIT                                                :
ECHO  :                                                                                           :
ECHO  +-------------------------------------------------------------------------------------------+
ECHO.
CHOICE /C 12345678 /M "%Sprompt1%: Select your desired option above: "
IF %ERRORLEVEL%==1 SET Passes=2
IF %ERRORLEVEL%==2 SET Passes=4
IF %ERRORLEVEL%==3 SET Passes=6
IF %ERRORLEVEL%==4 SET Passes=8
IF %ERRORLEVEL%==5 GOTO :CUSTOM
IF %ERRORLEVEL%==6 GOTO :CMDL
IF %ERRORLEVEL%==7 GOTO :HELP
IF %ERRORLEVEL%==8 GOTO :EXIT
:CONTINUE
ECHO %Sprompt%: INFO: %Passes% passes are set to securely delete the items queued.
ECHO %Sprompt%: INFO: %Self% has loaded SDelete %OS_ARCH%.
ECHO.

:LIST
REM Set buffer size to 9999 this enables scrolling
REM We use powershell here sadly batch is limited this way.
powershell.exe -command "& {$pshost = Get-Host;$pswindow = $pshost.UI.RawUI;$newsize = $pswindow.BufferSize;$newsize.height = 9999;$pswindow.buffersize = $newsize;}"
SET "arg=%*"
SET "arg=%arg:)=^)%"
SET "arg=%arg:(=^(%"
ECHO  +-----------------------+ BEGIN LISTING ITEMS QUEUED FOR DELETION +-------------------------+
ECHO.

REM We cant reliably list in detail e.g. multiple directories via a single drag and drop operation.
REM Because of this batch limitation only the selected and first dropped item is listed in detail.
REM Look into loading items dynamically by browsing for them and queuing them instead.
REM List empty directories too
REM Unfortunately doesn't list empty directories, if they are dropped over
REM any existing Simple Shredder shortcut, despite this these are shredded anyway.

FOR /D /R %%d IN (*) DO (
	DIR /B /S /A-D "%%d" >NUL 2>&1|| ECHO %Sprompt%: %%d
	COMPACT /U %%~fd 1>NUL 2>NUL
)

REM COMPACT: SDelete does not support NTFS compressed items and fails to shred them.
REM Decompress them and hide unrelated output (COMPACT /U *) to allow shred operation.

REM Support recursive directory listing of contents.
REM Without this recursive directory and content listing doesn't work as desired.
FOR /F "tokens=1,2 delims=d" %%b IN ("-%~a1") DO IF "%%c" NEQ "" (
	FOR /R "%~f1" %%d IN (*) DO (
		ECHO %Sprompt%: %%d
		COMPACT /U %%d 1>NUL 2>NUL
	)
) ELSE (
	IF "%%c" NEQ "-" (
		FOR %%d IN (%arg%) DO (
			ECHO %Sprompt%: %%~fd
			COMPACT /U %%d 1>NUL 2>NUL
		)
	)
)
ECHO.
ECHO  +------------------------+ END LISTING ITEMS QUEUED FOR DELETION +--------------------------+
ECHO.
GOTO :WDELQ

:SDELETE
REM Because we cant reliably detect SDelete's error level, its advised to review SDelete output.
REM The HELP and FAQ section holds the current issues unable to be resolved at this time.
ECHO.
FOR %%c IN (%arg%) DO (
	%SDelete% -nobanner -p %Passes% -r -s "%%~fc"
)

ECHO.
ECHO %Sprompt%: TIP: Scroll up to review process output log.
PING 1.1.1.1 -n 1 -w 80 >NUL
ECHO %Sprompt%: PRESS "N" KEY TO EXIT.
CHOICE /M "%Sprompt1%: Return to Main Menu"
IF %ERRORLEVEL%==1 GOTO :MENU
IF %ERRORLEVEL%==2 GOTO :EXIT

:WDELQ
VER > NUL
CHOICE /M "%Sprompt1%: Would you like to permanently delete all items listed:"
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

:CUSTOM
SET "CustomLenQ="
SET MinLen=9
SET MaxLen=99
SET /P CustomLenQ="%Sprompt%: Enter a custom DoD pass length: "
SET /A EvalCLen=CustomLenQ
IF %EvalCLen% EQU %CustomLenQ% (
	IF %CustomLenQ% GTR %MaxLen% ( GOTO :INVALID )
	IF %CustomLenQ% GTR %MinLen% ( SET "Passes=%CustomLenQ%" & GOTO :CONTINUE )
) ELSE ( GOTO :INVALID )

:INVALID
ECHO %Sprompt%: ERROR: Input is invalid.
ECHO %Sprompt%:  INFO: Enter a number greater than %MinLen% and smaller than 100.
GOTO :CUSTOM

:UNSUP
COLOR 0B
CALL :HEADER
ECHO.
ECHO %Sprompt%: ERROR: OS architecture %OS_ARCH% is NOT supported!
ECHO %Sprompt%: PRESS ANY KEY TO EXIT.
PAUSE >NUL
CALL :EXIT

:CMDL
CLS
CALL :HEADER
%COMSPEC% /C %SDelete%
%COMSPEC% /K PROMPT !Self! $g

:HELPB
CLS
MODE CON: COLS=95 LINES=40
COLOR 1F
CALL :HEADER
TYPE HELP_AND_FAQ
ECHO %Sprompt%: INFO: Drop Files / Folders to be deleted onto the %Self% Icon.
ECHO %Sprompt%: PRESS ANY KEY TO EXIT.
PAUSE >NUL
GOTO :EXIT

:EXITH
MODE CON: COLS=95 LINES=31
SET KthX=%Sprompt%: Thank you for using %Self% :)
SET ExiT=%Sprompt%: Bye!
CLS
CALL :HEADER
ECHO.
ENDLOCAL
:END
