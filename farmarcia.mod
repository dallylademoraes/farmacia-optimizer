# modelo de planejamento de produção por lotes – farmácia

set PROD;            # Conjunto de produtos
set MAQ;             # Conjunto de máquinas

param demanda{PROD};         # Demanda em lotes
param custo{PROD};           # Custo por lote
param capacidade{MAQ};       # Horas disponíveis da máquina
param tempo{MAQ, PROD};      # Tempo necessário em cada máquina por lote

var x{PROD} >= 0, integer;   # Lotes a produzir de cada produto
var d{PROD} >= 0, integer;   # Demanda não atendida

# função objetivo - custo de produção + penalidade por demanda não atendida
minimize Custo_Total:
    sum{p in PROD} (custo[p] * x[p] + 1000 * d[p]);  # Penalidade alta!

# restrição – balanço entre produção e demanda
subject to Balanco_Demanda{p in PROD}:
    x[p] + d[p] = demanda[p];

# restrição – capacidade de máquina
subject to Capacidade{m in MAQ}:
    sum{p in PROD} tempo[m,p] * x[p] <= capacidade[m];

solve;

# impressão dos resultados
printf "=== RESULTADOS DA PRODUÇÃO ===\n" > "resultado.txt";
for {p in PROD}
    printf "%s: Produzir %d lotes (demanda não atendida: %d)\n", p, x[p], d[p] >> "resultado.txt";

printf "\n=== UTILIZAÇÃO DAS MÁQUINAS ===\n" >> "resultado.txt";
for {m in MAQ} {
    printf "%s: %g horas (capacidade = %g) - Utilização: %.1f%%\n",
           m, sum{p in PROD} tempo[m,p] * x[p], capacidade[m],
           (sum{p in PROD} tempo[m,p] * x[p]) / capacidade[m] * 100 >> "resultado.txt";
}

printf "\nCusto Total: %.2f\n", Custo_Total >> "resultado.txt";
printf "  - Custo Produção: %.2f\n", sum{p in PROD} custo[p] * x[p] >> "resultado.txt";
printf "  - Penalidade Demanda: %.2f\n", sum{p in PROD} 1000 * d[p] >> "resultado.txt";

end;