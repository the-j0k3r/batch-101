@ECHO OFF
TITLE Simple Password Generator
MODE CON: COLS=95 LINES=30
SET SPGprompt=SPG ^$
SET Ver=v1.99

:MAIN
COLOR 1F
CALL:HEADER
ECHO.
ECHO.                          Press CTRL+C to Abort and Terminate Batch Job
ECHO.
SET RNDLength=0
ECHO  +----------------------------------------+ MAIN MENU +--------------------------------------+
ECHO  :                                                                                           :
ECHO  :                                [1] 10 Random Characters Long                              :
ECHO  :                                [2] 15 Random Characters Long                              :
ECHO  :                                [3] 20 Random Characters Long                              :
ECHO  :                                [4] 25 Random Characters Long                              :
ECHO  :                                [5] 30 Random Characters Long                              :
ECHO  :                                [6] Custom Random Lenght                                   :
ECHO  :                                                                                           :
ECHO  :                                [7] ABOUT                                                  :
ECHO  :                                [8] EXIT                                                   :
ECHO  :                                                                                           :
ECHO  +-------------------------------------------------------------------------------------------+
ECHO.
CHOICE /C 12345678 /M "SPG $: Choose a password lenght: "
IF %ERRORLEVEL%==1 SET RNDLength=10
IF %ERRORLEVEL%==2 SET RNDLength=15
IF %ERRORLEVEL%==3 SET RNDLength=20
IF %ERRORLEVEL%==4 SET RNDLength=25
IF %ERRORLEVEL%==5 SET RNDLength=30
IF %ERRORLEVEL%==6 GOTO :CUSTOM
IF %ERRORLEVEL%==7 GOTO :ABOUT
IF %ERRORLEVEL%==8 GOTO :EXIT

:PGEN
:: The random character engine was provided by TheOucaste.
:: Some modifications were made to suit the Simple Password Generator.
:: A thank you to TheOutcaste for the code snippet.
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET Alphanumeric=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%&)(-_=+][}{\|'";:/?.,
SET Str=%Alphanumeric%9876543210
:LENGHTLOOP
IF NOT "%Str:~18%"=="" SET Str=%Str:~9%& SET /A Len+=9& GOTO :LENGHTLOOP
SET tmp=%Str:~9,1%
SET /A Len=Len+tmp
SET count=0
SET "RNDAlphaNum="
:LOOP
SET /A count+=1
SET RND=%Random%
SET /A RND=RND%%%Len%
SET RNDAlphaNum=!RNDAlphaNum!!Alphanumeric:~%RND%,1!
IF !count! lss %RNDLength% GOTO :LOOP
SET "PassWord="
ECHO !RNDAlphaNum!| CLIP
ECHO %SPGprompt%: INFO: Copied !RNDAlphaNum! to the clipboard^^!
ECHO  +-------------------------------------------------------------------------------------------+
ECHO  :          WARNING: THE CLIPBOARD WILL BE CLEARED ON PASSWORD REGENERATION OR EXIT.         :
ECHO  +-------------------------------------------------------------------------------------------+
SET PassWord=!RNDAlphaNum!
ENDLOCAL && SET PassWord=%PassWord%

:QUERYSAVEPASS
SET "SavePassQ="
SET /P SavePassQ="SPG $: Would you like to save the password to file [Y/N]? "
IF /I "%SavePassQ%" EQU "Y" GOTO :SAVEPASSNAME
IF /I "%SavePassQ%" EQU "N" GOTO :REGEN
IF /I "%SavePassQ%"=="%SavePassQ%" GOTO :HANDLEQUERYSAVEPASS

:HANDLEQUERYSAVEPASS
ECHO %SPGprompt%: ERROR: Not a valid option. Valid options are [Y/N], try again^!
GOTO :QUERYSAVEPASS

:REGEN
SET "GenNewQ="
SET /P GenNewQ="SPG $: Would you like to generate a new password [Y/N]? "
IF /I "%GenNewQ%" EQU "Y" ECHO OFF | CLIP && CLS && GOTO :MAIN
IF /I "%GenNewQ%" EQU "N" GOTO :EXIT
IF /I "%GenNewQ%"=="%GenNewQ%" GOTO :INFO1

:INFO1
ECHO %SPGprompt%: ERROR: Not a valid option. Valid options are [Y/N], try again^!
GOTO :REGEN

:ABOUT
COLOR E
CLS
CALL:HEADER
ECHO  :                                                                                           :
ECHO  :            The original random char generator (:PGEN) was provided by TheOutcaste.        :
ECHO  :            The Simple Password Generator is a batch script that builds upon that          :
ECHO  :            to generate user selectable lenghts passwords and save them to file.           :
ECHO  :                                                                                           :
ECHO  :            Copyright (C) 2017 the-j0k3r <th3-j0ker at protonmail dot com>                 :
ECHO  :            Copyright :PGEN (C) 2009 <http://tinyurl.com/TheOutcaste>                      :
ECHO  :                                                                                           :
ECHO  :            This program is FREE software. You can redistribute it and/or                  :
ECHO  :            modify it under the terms of the GNU General Public License                    :
ECHO  :            as published by the Free Software Foundation; either version 2                 :
ECHO  :            of the License, or (at your option) any later version.                         :
ECHO  :                                                                                           :
ECHO  :            This program is distributed in the HOPE that it will be USEFUL,                :
ECHO  :            but WITHOUT ANY WARRANTY; without even the implied warranty of                 :
ECHO  :            MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                           :
ECHO  :            See the GNU General Public License for more details.                           :
ECHO  :                                                                                           :
ECHO  :            You should have received a copy of the GNU General Public License              :
ECHO  :            along with this program. If not, write to the Free Software Foundation,        :
ECHO  :            Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.             :
ECHO  :                                                                                           :
ECHO  +-------------------------------------------------------------------------------------------+
ECHO.

:QUERY
SET Return2MMQ=
SET /P Return2MMQ="SPG $: Return to Main Menu [Y/N]? "
IF /I "%Return2MMQ%" EQU "Y" CLS && GOTO :MAIN
IF /I "%Return2MMQ%" EQU "N" GOTO :EXIT
IF /I "%Return2MMQ%"=="%Return2MMQ%" GOTO :INFO2
GOtO :ABOUT

:INFO2
ECHO %SPGprompt%: ERROR: Not a valid option. Valid options are [Y/N], try again^!
GOTO :QUERY

:EXIT
ECHO OFF | CLIP
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
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET "CustomLenQ="""
SET /P CustomLenQ="SPG $: Enter your custom password length: "
SET /A EvalCLen=CustomLenQ
IF %EvalCLen% EQU %CustomLenQ% (
	IF %CustomLenQ% GTR 999 ( GOTO :INVALID )
	IF %CustomLenQ% GTR 9 ( SET RNDLength=%CustomLenQ% & CALL:PGEN )
	IF %CustomLenQ% LSS 9 ( GOTO :INVALID )
	IF %CustomLenQ% EQU 9 ( GOTO :INVALID )
) ELSE ( GOTO :INVALID )
ENDLOCAL

:INVALID
ECHO SPG $: ERROR: Input is invalid.
ECHO SPG $: INFO : Enter a number greater than 9 and smaller than 999.
GOTO :CUSTOM

:SAVEPASSNAME
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET "SavePassName="
SET /P SavePassName="SPG $: Enter your a reference for this password: "
IF "%SavePassName%"=="" (
	GOTO :SAVEPASSNAMEINVALID
) ELSE (
	ECHO SPG $: INFO: You reference for this password is [ %SavePassName% ].
	SET Reference=%SavePassName% && GOTO :PROCESSTOFILE
)
ENDLOCAL

:SAVEPASSNAMEINVALID
ECHO SPG $: ERROR: Enter a valid reference name or title for your password.
ECHO SPG $: INFO : This will help you remember where this password belongs.
GOTO :SAVEPASSNAME

:PROCESSTOFILE
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
SET fileName=Simple-Password-Generator-List.txt
IF EXIST %FileName% (
	ECHO SPG $: INFO: %FileName% exists, appending data to file.
	ECHO. >>%FileName%
	ECHO Reference: %Reference% >>%FileName%
	ECHO. >>%FileName%
	ECHO Password: %PassWord% >>%FileName%
	ECHO. >>%FileName%
	CALL :TIMESTAMP
	ECHO. >>%FileName%
	ECHO  +-------+ SAVED SECURE PASSWORD LIST +--------------------------------------+ SPG %Ver% +---+ >>%FileName%
) ELSE (
	ECHO SPG $: INFO: %FileName% Not found, generating new file.
	ECHO. >>%FileName%
	CALL :HEADER >>%FileName%
	ECHO. >>%FileName%
	ECHO Reference: %Reference% >>%FileName%
	ECHO. >>%FileName%
	ECHO Password: %PassWord% >>%FileName%
	ECHO. >>%FileName%
	CALL :TIMESTAMP
	ECHO. >>%FileName%
	ECHO  +-------+ SAVED SECURE PASSWORD LIST +--------------------------------------+ SPG %Ver% +---+ >>%FileName%
)
ECHO SPG $: INFO: Your password and reference have been saved to %FileName%.
ECHO SPG $:  TIP: Keep this file safe in a secure external drive.
GOTO :REGEN

:TIMESTAMP
SET Date=Date: %date:~-10,2%^/%date:~-7,2%^/%date:~-4,4%
SET Time=Time 24-h: %time:~-11,2%:%time:~-8,2%:%time:~-5,2%:%time:~-2,2%
SET TimeStamp=%Date% - %Time%
ECHO Date and Time Generated: %TimeStamp% >>%FileName%
GOTO :EOF

:HEADER
ECHO.
ECHO  +-------------------------------------------------------------------------------------------+
ECHO  :                           * * *  SIMPLE PASSWORD GENERATOR  * * *                         :
ECHO  +-------------------------------------------------------------------------------+ %Ver% +---+
GOTO :EOF

:EXITH
SET KthX=%SPGprompt%: Thank you for using Simple Password Generator :)
SET ExiT=%SPGprompt%: Will now exit
CLS
CALL :HEADER
ECHO.

ENDLOCAL
