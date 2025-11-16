@echo off

REM Caminho da pasta do projeto
set "BASE=C:\Users\dallyla\Desktop\modelo"

REM Executa o GLPK
"C:\glpk\winglpk-4.65\glpk-4.65\w64\glpsol.exe" --model "%BASE%\farmarcia.mod" --data "%BASE%\farmarcia.dat" -o "%BASE%\resultado.sol"

REM Verifica se resultado.txt existe
if not exist "%BASE%\resultado.txt" (
    echo ERRO: resultado.txt nao foi criado.
    pause
    exit /b
)

REM Cria HTML simples com o resultado
(
    echo ^<!DOCTYPE html^>
    echo ^<html lang="pt-br"^>
    echo ^<head^>^<meta charset="UTF-8"^>^<title^>Resultado GLPK^</title^>^</head^>
    echo ^<body^>
    echo ^<h2^>Resultado da Otimizacao</h2^>
    echo ^<pre^>
) > "%BASE%\resultado.html"

type "%BASE%\resultado.txt" >> "%BASE%\resultado.html"

echo ^</pre^> >> "%BASE%\resultado.html"
echo ^</body^> >> "%BASE%\resultado.html"
echo ^</html^> >> "%BASE%\resultado.html"

REM Abre no navegador
start "" "%BASE%\resultado.html"
