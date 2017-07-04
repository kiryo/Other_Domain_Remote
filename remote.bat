@echo off
REM Oppilasverkon koneiden IP-numeron tiedustelu/ etäyhdistys
REM Santeri Suomalainen Joulu- ja Tammikuu 2017
chcp 1252
color f1
rem set arg=%1
rem shift
echo Tämä ohjelma vaatii PSEXEC työkalun sekä DameWaren jotta se toimii.
echo Muokkaa skriptiä vikatilanteissa esim: ohjelmien polut tai muuten toimivuus.
echo:
echo Syötä/liitä dnshostname
SET /P kirnumero=">"
echo Syötä edu admin käyttäjätunnus ilman @edu.kirkkonummi.fi
set /p "tunnus= tunnus: "
echo Syötä tunnuksen salasana
powershell -Command $pword = read-host "Syötä salasana" -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword) ; ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR) > .tmp.txt 
set /p salasana=<.tmp.txt & del .tmp.txt
REM lisää tähän domainin osoite ja parametrit
psexec \\10.2.14.5 -u %tunnus%@edu -p %salasana% ping %kirnumero% -4 -n 1 > ping.txt
if %errorlevel% == 0 (
echo:
echo Kone on päällä
echo.
) else (
echo:
echo kone ei ole päällä tai yhteyttä ei saada
echo:
echo:
goto loppu
)
for /f "tokens=2 delims=[]" %%a in ('type ping.txt') do set "ip=%%a"
echo IP-numero on %ip%
echo:
echo etäyhdistetäänkö koneeseen (k/e)?
SET /P "valinta=K/E : "
if %valinta% == e (
goto loppu
)
del result.txt
"C:\Program Files\DameWare\DameWare Mini Remote Control 7.5\DWRCC.exe"  -h: -m:%ip% -u:rannanjärvi  -a:2
:loppu
del ping.txt
echo paina mitä tahansa nappia poistuaksesi...
pause
exit
