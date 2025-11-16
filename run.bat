@echo off
cls
color 0A

REM Caminho da pasta do projeto (pasta atual onde o script está)
set "BASE=%~dp0"
cd /d "%BASE%"

echo ========================================
echo   SISTEMA DE OTIMIZACAO DE PRODUCAO
echo   Farmacia - Pesquisa Operacional
echo ========================================
echo.

REM Verifica se o GLPK existe
set "GLPK=C:\glpk\winglpk-4.65\glpk-4.65\w64\glpsol.exe"
if not exist "%GLPK%" (
    echo [ERRO] GLPK nao encontrado em: %GLPK%
    echo.
    echo Por favor, verifique se o GLPK esta instalado ou ajuste o caminho
    echo no arquivo run.bat na variavel GLPK.
    echo.
    pause
    exit /b
)

REM Verifica se os arquivos necessarios existem
if not exist "%BASE%farmarcia.mod" (
    echo [ERRO] Arquivo farmarcia.mod nao encontrado em: %BASE%
    pause
    exit /b
)

if not exist "%BASE%farmarcia.dat" (
    echo [ERRO] Arquivo farmarcia.dat nao encontrado em: %BASE%
    pause
    exit /b
)

echo [1/4] Executando otimizacao com GLPK...
echo Caminho: %BASE%
echo.

REM Executa o GLPK na pasta atual
"%GLPK%" --model "%BASE%farmarcia.mod" --data "%BASE%farmarcia.dat" -o "%BASE%resultado.sol"

echo.
echo [2/4] Verificando resultados...

REM Aguarda um momento para garantir que o arquivo foi criado
ping 127.0.0.1 -n 2 >nul

REM Verifica se resultado.txt existe (GLPK cria na pasta atual de trabalho)
REM Verifica tanto na pasta BASE quanto na pasta atual
set "RESULTADO_TXT="

REM Primeiro tenta na pasta atual (onde o GLPK executa)
if exist "resultado.txt" (
    set "RESULTADO_TXT=resultado.txt"
    echo [INFO] Encontrado resultado.txt na pasta atual
) else if exist "%BASE%resultado.txt" (
    set "RESULTADO_TXT=%BASE%resultado.txt"
    echo [INFO] Encontrado resultado.txt na pasta BASE
) else (
    REM Tenta criar extraindo do resultado.sol se existir
    if exist "%BASE%resultado.sol" (
        echo [INFO] Tentando extrair resultados do resultado.sol...
        findstr /C:"x[P1]" /C:"x[P2]" /C:"x[P3]" "%BASE%resultado.sol" > "%BASE%resultado_temp.txt" 2>nul
        if exist "%BASE%resultado_temp.txt" (
            echo Resultados da Producao: > "%BASE%resultado.txt"
            for /f "tokens=1,4" %%a in ('findstr /C:"x[P" "%BASE%resultado.sol"') do (
                if "%%a"=="1" echo P1: %%b lotes >> "%BASE%resultado.txt"
                if "%%a"=="2" echo P2: %%b lotes >> "%BASE%resultado.txt"
                if "%%a"=="3" echo P3: %%b lotes >> "%BASE%resultado.txt"
            )
            del "%BASE%resultado_temp.txt" >nul 2>&1
            if exist "%BASE%resultado.txt" (
                set "RESULTADO_TXT=%BASE%resultado.txt"
                echo [INFO] Resultado extraido do resultado.sol
            )
        )
    )
)

if "%RESULTADO_TXT%"=="" (
    echo.
    echo [ERRO] resultado.txt nao foi criado.
    echo.
    echo Possiveis causas:
    echo   1. GLPK nao esta instalado corretamente
    echo   2. Erro na execucao do GLPK (verifique acima)
    echo   3. Problema com os arquivos .mod ou .dat
    echo.
    echo Verificando se resultado.sol foi criado...
    if exist "%BASE%resultado.sol" (
        echo [INFO] resultado.sol existe. Verificando conteudo...
        type "%BASE%resultado.sol" | findstr /C:"Status:" /C:"ERROR" /C:"Error"
    ) else (
        echo [INFO] resultado.sol tambem nao foi criado.
        echo O GLPK pode nao ter executado corretamente.
    )
    echo.
    pause
    exit /b
)

echo [OK] Arquivo resultado.txt criado com sucesso!
echo.

echo [3/4] Exibindo resultados no terminal:
echo ========================================
echo.
type "%RESULTADO_TXT%"
echo.
echo ========================================
echo.

REM Cria HTML simples com o resultado
echo [4/4] Gerando arquivo HTML...
(
    echo ^<!DOCTYPE html^>
    echo ^<html lang="pt-br"^>
    echo ^<head^>^<meta charset="UTF-8"^>^<title^>Resultado GLPK^</title^>^</head^>
    echo ^<body^>
    echo ^<h2^>Resultado da Otimizacao</h2^>
    echo ^<pre^>
) > "%BASE%resultado.html"

type "%RESULTADO_TXT%" >> "%BASE%resultado.html"

echo ^</pre^> >> "%BASE%resultado.html"
echo ^</body^> >> "%BASE%resultado.html"
echo ^</html^> >> "%BASE%resultado.html"

echo [OK] Arquivo resultado.html criado!
echo.

REM Mostra informações adicionais do arquivo .sol se existir
if exist "%BASE%resultado.sol" (
    echo ========================================
    echo   INFORMACOES DETALHADAS (resultado.sol)
    echo ========================================
    echo.
    findstr /C:"Status:" /C:"Objective:" /C:"Custo_Total" "%BASE%resultado.sol" 2>nul
    echo.
)

echo ========================================
echo   PROCESSO CONCLUIDO!
echo ========================================
echo.
echo Arquivos gerados:
echo   - resultado.txt (resultados formatados)
echo   - resultado.sol (solucao detalhada)
echo   - resultado.html (visualizacao web)
echo.
echo Abrindo resultado.html no navegador...
echo.

REM Abre no navegador
start "" "%BASE%resultado.html"

echo Pressione qualquer tecla para fechar...
pause >nul
