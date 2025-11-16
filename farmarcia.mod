# -----------------------------------------------------------
# Modelo de Planejamento de Produção por Lotes – Farmácia
# -----------------------------------------------------------

set PROD;            # Conjunto de produtos
set MAQ;             # Conjunto de máquinas

param demanda{PROD};         # Demanda mínima em lotes
param custo{PROD};           # Custo por lote
param capacidade{MAQ};       # Horas disponíveis da máquina
param tempo{MAQ, PROD};      # Tempo necessário em cada máquina por lote

var x{PROD} >= 0, integer;   # Lotes a produzir de cada produto

# --------------------------
# Função Objetivo
# --------------------------
minimize Custo_Total:
    sum{p in PROD} custo[p] * x[p];

# --------------------------
# Restrição – Atender demanda
# --------------------------
subject to Atende_Demanda{p in PROD}:
    x[p] >= demanda[p];

# --------------------------
# Restrição – Capacidade de máquina
# --------------------------
subject to Capacidade{m in MAQ}:
    sum{p in PROD} tempo[m,p] * x[p] <= capacidade[m];

solve;

# --------------------------
# Impressão dos resultados
# --------------------------
printf "Resultados da Producao:\n" > "resultado.txt";
for {p in PROD}
    printf "%s: %d lotes\n", p, x[p] >> "resultado.txt";

end;