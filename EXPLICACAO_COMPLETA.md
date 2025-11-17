# Explicação Completa do Sistema de Otimização
## Para quem não conhece Pesquisa Operacional

---

## 🎯 O QUE É PESQUISA OPERACIONAL?

**Pesquisa Operacional** é uma área da matemática que ajuda a tomar **decisões melhores** quando você tem:
- **Objetivos** (o que você quer alcançar)
- **Limitações** (o que você não pode ultrapassar)
- **Opções** (diferentes escolhas possíveis)

É como ter um assistente matemático que testa todas as possibilidades e te diz qual é a **melhor solução**.

---

## 📋 O PROBLEMA DA FARMÁCIA

### Situação Real:

Imagine que você é dono de uma farmácia que **produz medicamentos**. Você precisa decidir:

> **"Quantos lotes de cada medicamento devo produzir para gastar o MENOR dinheiro possível, mas ainda assim atender todas as demandas e não ultrapassar a capacidade das máquinas?"**

### Os Personagens do Problema:

#### 🏭 **Os Produtos (O que você produz)**
- **P1 - Paracetamol**: Precisa de pelo menos 150 lotes
- **P2 - Ibuprofeno**: Precisa de pelo menos 100 lotes  
- **P3 - Vitamina C**: Precisa de pelo menos 150 lotes

#### ⚙️ **As Máquinas (Recursos limitados)**
- **Misturador**: Tem 1200 horas disponíveis
- **Reator**: Tem 1000 horas disponíveis

#### 💰 **Os Custos (Quanto cada produto custa)**
- Paracetamol: R$ 35,00 por lote
- Ibuprofeno: R$ 45,00 por lote
- Vitamina C: R$ 20,00 por lote

#### ⏱️ **Os Tempos (Quanto cada produto demora em cada máquina)**
- **Paracetamol**: 2h no Misturador + 2,5h no Reator = 4,5h total por lote
- **Ibuprofeno**: 3h no Misturador + 3h no Reator = 6h total por lote
- **Vitamina C**: 1,5h no Misturador + 2h no Reator = 3,5h total por lote

---

## 🎯 O QUE PRECISAMOS RESOLVER?

### Objetivo:
**Minimizar o custo total** (gastar o menos possível)

### Mas temos REGRAS que DEVEM ser respeitadas:

#### ✅ Regra 1: Atender a Demanda Mínima
- Paracetamol: **Pelo menos** 150 lotes
- Ibuprofeno: **Pelo menos** 100 lotes
- Vitamina C: **Pelo menos** 150 lotes

#### ✅ Regra 2: Respeitar a Capacidade das Máquinas
- Misturador: **No máximo** 1200 horas
- Reator: **No máximo** 1000 horas

### Exemplo de Cálculo:

Se produzirmos 150 lotes de Paracetamol:
- **Custo**: 150 × R$ 35 = R$ 5.250
- **Tempo no Misturador**: 150 × 2h = 300 horas
- **Tempo no Reator**: 150 × 2,5h = 375 horas

---

## 🧮 COMO O SISTEMA RESOLVE?

### O que o sistema faz:

1. **Testa milhões de combinações** matematicamente
2. **Verifica** se cada combinação respeita as regras
3. **Calcula** o custo de cada combinação válida
4. **Escolhe** a combinação com menor custo

### A Solução Encontrada:

```
✅ Paracetamol (P1): 150 lotes
✅ Ibuprofeno (P2): 100 lotes
✅ Vitamina C (P3): 150 lotes

💰 Custo Total: R$ 12.750,00
```

### Verificando se está correto:

#### ✅ Atende as demandas?
- Paracetamol: 150 ≥ 150 ✅
- Ibuprofeno: 100 ≥ 100 ✅
- Vitamina C: 150 ≥ 150 ✅

#### ✅ Respeita as capacidades?

**Misturador:**
- Paracetamol: 150 × 2h = 300h
- Ibuprofeno: 100 × 3h = 300h
- Vitamina C: 150 × 1,5h = 225h
- **Total**: 825 horas (dentro do limite de 1200h) ✅

**Reator:**
- Paracetamol: 150 × 2,5h = 375h
- Ibuprofeno: 100 × 3h = 300h
- Vitamina C: 150 × 2h = 300h
- **Total**: 975 horas (dentro do limite de 1000h) ✅

---

## 📁 O QUE É CADA ARQUIVO?

### 1. `farmarcia.mod` - O MODELO (A Receita)

Este arquivo é como uma **receita de bolo**. Ele define:
- **O que** queremos (minimizar custo)
- **Quais são as regras** (demandas e capacidades)
- **Como calcular** a solução

**Não precisa mexer neste arquivo** a menos que você queira mudar a estrutura do problema.

**Principais partes:**

```ampl
# Conjuntos (listas)
set PROD;            # Lista de produtos (P1, P2, P3)
set MAQ;             # Lista de máquinas (Misturador, Reator)

# Parâmetros (dados que você fornece)
param demanda{PROD};         # Quantos lotes MÍNIMOS de cada produto
param custo{PROD};           # Quanto custa cada lote
param capacidade{MAQ};       # Quantas horas cada máquina tem
param tempo{MAQ, PROD};      # Quanto tempo cada produto leva em cada máquina

# Variável (o que queremos descobrir)
var x{PROD} >= 0, integer;   # Quantos lotes produzir de cada produto

# Objetivo (o que queremos)
minimize Custo_Total:
    sum{p in PROD} custo[p] * x[p];
    # Soma: (custo P1 × lotes P1) + (custo P2 × lotes P2) + (custo P3 × lotes P3)

# Regras (o que DEVE ser respeitado)
subject to Atende_Demanda{p in PROD}:
    x[p] >= demanda[p];
    # Os lotes produzidos devem ser MAIORES OU IGUAIS à demanda mínima

subject to Capacidade{m in MAQ}:
    sum{p in PROD} tempo[m,p] * x[p] <= capacidade[m];
    # O tempo total usado em cada máquina deve ser MENOR OU IGUAL à capacidade
```

### 2. `farmarcia.dat` - OS DADOS (Os Ingredientes)

Este arquivo contém **os números específicos** do seu problema:
- Quantos lotes você precisa de cada produto
- Quanto cada produto custa
- Quantas horas cada máquina tem disponível
- Quanto tempo cada produto leva em cada máquina

**Este é o arquivo que você MODIFICA** quando quer mudar os valores.

**Exemplo do arquivo:**

```ampl
# Produtos
set PROD := P1 P2 P3;

# Máquinas
set MAQ := Misturador Reator;

# Demandas mínimas
param demanda :=
P1 150     # Precisa de pelo menos 150 lotes de Paracetamol
P2 100     # Precisa de pelo menos 100 lotes de Ibuprofeno
P3 150 ;   # Precisa de pelo menos 150 lotes de Vitamina C

# Custos por lote
param custo :=
P1 35      # Cada lote de Paracetamol custa R$ 35
P2 45      # Cada lote de Ibuprofeno custa R$ 45
P3 20 ;    # Cada lote de Vitamina C custa R$ 20

# Capacidades das máquinas (em horas)
param capacidade :=
Misturador 1200    # Misturador tem 1200 horas disponíveis
Reator     1000 ;  # Reator tem 1000 horas disponíveis

# Tempos de processamento (horas por lote)
param tempo :
                 P1    P2    P3 :=
Misturador       2     3     1.5    # Paracetamol leva 2h, Ibuprofeno 3h, Vitamina C 1,5h
Reator           2.5   3     2 ;    # Paracetamol leva 2,5h, Ibuprofeno 3h, Vitamina C 2h
```

### 3. `run.bat` - O EXECUTOR (O Cozinheiro)

Este arquivo **automatiza tudo**:
1. Executa o GLPK (o "solver" que resolve o problema)
2. Gera os arquivos de resultado
3. Mostra os resultados no terminal
4. Abre o dashboard no navegador

**Você só precisa dar duplo clique nele!**

### 4. `resultado.sol` - A SOLUÇÃO DETALHADA

Este arquivo mostra **tudo** sobre a solução encontrada:
- Status: Se encontrou solução ótima
- Custo total mínimo
- Quantos lotes produzir de cada produto
- Quanto cada máquina será usada

**Exemplo:**
```
Status: INTEGER OPTIMAL          # Encontrou a melhor solução possível!
Objective: Custo_Total = 12750   # Custo mínimo: R$ 12.750

x[P1] = 150    # Produzir 150 lotes de Paracetamol
x[P2] = 100    # Produzir 100 lotes de Ibuprofeno
x[P3] = 150    # Produzir 150 lotes de Vitamina C
```

### 5. `resultado.txt` - RESULTADO SIMPLES

Versão simplificada dos resultados, fácil de ler:
```
Resultados da Producao:
P1: 150 lotes
P2: 100 lotes
P3: 150 lotes
```

### 6. `resultado.html` / `index.html` - O DASHBOARD

Interface visual interativa que mostra:
- Todos os dados do problema
- A solução encontrada
- Gráficos de utilização das máquinas
- Campos editáveis para testar diferentes cenários

---

## 🔄 COMO TUDO FUNCIONA JUNTO?

### Fluxo Completo:

```
1. Você edita farmarcia.dat
   ↓
   (Muda demandas, custos, capacidades, tempos)
   
2. Você executa run.bat
   ↓
   (O script roda o GLPK)
   
3. GLPK lê farmarcia.mod + farmarcia.dat
   ↓
   (Entende o problema e os dados)
   
4. GLPK resolve o problema matematicamente
   ↓
   (Testa milhões de combinações)
   
5. GLPK gera resultado.sol e resultado.txt
   ↓
   (Salva a solução encontrada)
   
6. Dashboard (resultado.html) mostra tudo visualmente
   ↓
   (Você vê os resultados de forma clara)
```

---

## 💡 EXEMPLOS PRÁTICOS

### Exemplo 1: "E se a demanda aumentar?"

**Situação**: A demanda de Paracetamol aumentou de 150 para 200 lotes.

**O que fazer:**
1. Edite `farmarcia.dat`
2. Mude `P1 150` para `P1 200`
3. Execute `run.bat`
4. Veja o novo custo total e quantidades

**Resultado esperado**: O custo total vai aumentar, e as máquinas serão mais utilizadas.

### Exemplo 2: "E se uma máquina quebrar?"

**Situação**: O Reator agora só tem 800 horas (em vez de 1000).

**O que fazer:**
1. Edite `farmarcia.dat`
2. Mude `Reator 1000` para `Reator 800`
3. Execute `run.bat`
4. Veja se ainda é possível atender todas as demandas

**Resultado esperado**: Pode ser que não seja possível atender todas as demandas. O sistema vai indicar se o problema é "inviável".

### Exemplo 3: "E se o custo de um produto mudar?"

**Situação**: O custo do Ibuprofeno aumentou de R$ 45 para R$ 50.

**O que fazer:**
1. Edite `farmarcia.dat`
2. Mude `P2 45` para `P2 50`
3. Execute `run.bat`
4. Veja o novo custo total

**Resultado esperado**: O custo total vai aumentar, mas as quantidades podem ou não mudar (depende de outros fatores).

---

## 🎓 CONCEITOS IMPORTANTES

### Programação Linear Inteira

É o tipo de problema que estamos resolvendo:
- **Linear**: As relações são lineares (multiplicação e soma)
- **Inteira**: As soluções devem ser números inteiros (não podemos produzir 150,5 lotes!)

### Solução Ótima

É a **melhor solução possível** que:
- ✅ Respeita todas as regras
- ✅ Tem o menor custo possível

### Inviável

Quando o problema **não tem solução** porque as regras são incompatíveis.

**Exemplo**: Se você precisar de 2000 horas no Reator, mas ele só tem 1000 horas disponíveis, é impossível!

---

## ❓ PERGUNTAS FREQUENTES

### Por que não posso simplesmente produzir o mínimo de cada produto?

Porque você precisa **otimizar o uso das máquinas**. Às vezes, produzir um pouco mais de um produto mais barato pode ser melhor do que produzir exatamente o mínimo de todos.

### Por que o sistema não produz mais do que o necessário?

Porque o objetivo é **minimizar custos**. Produzir mais do que o necessário só aumenta os gastos sem necessidade.

### O que acontece se eu mudar os dados e o problema ficar inviável?

O GLPK vai retornar um erro dizendo que o problema é "INFEASIBLE" (inviável). Isso significa que é **matematicamente impossível** atender todas as demandas com as capacidades disponíveis.

### Posso adicionar mais produtos ou máquinas?

Sim! Mas você precisará:
1. Adicionar no `farmarcia.dat` (fácil)
2. Possivelmente ajustar o `farmarcia.mod` (mais complexo)

---

## 📊 RESUMO VISUAL

```
┌─────────────────────────────────────────────────┐
│           O PROBLEMA DA FARMÁCIA                │
├─────────────────────────────────────────────────┤
│                                                 │
│  OBJETIVO:                                      │
│  💰 Minimizar o custo total de produção         │
│                                                 │
│  REGRAS:                                        │
│  ✅ Atender demanda mínima de cada produto      │
│  ✅ Respeitar capacidade das máquinas           │
│                                                 │
│  DADOS:                                         │
│  📦 3 produtos (Paracetamol, Ibuprofeno, C)    │
│  ⚙️ 2 máquinas (Misturador, Reator)            │
│  💵 Custos por lote                             │
│  ⏱️ Tempos de processamento                      │
│                                                 │
│  SOLUÇÃO:                                       │
│  🎯 Quantos lotes produzir de cada produto?     │
│                                                 │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│         O SISTEMA RESOLVE E RETORNA             │
├─────────────────────────────────────────────────┤
│                                                 │
│  P1: 150 lotes  →  Custo: R$ 5.250             │
│  P2: 100 lotes  →  Custo: R$ 4.500             │
│  P3: 150 lotes  →  Custo: R$ 3.000             │
│                                                 │
│  💰 CUSTO TOTAL: R$ 12.750                      │
│                                                 │
│  ✅ Todas as demandas atendidas                 │
│  ✅ Capacidades respeitadas                      │
│  ✅ Solução ótima encontrada!                    │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## 🎯 CONCLUSÃO

Este sistema ajuda a farmácia a:
1. **Tomar decisões melhores** sobre produção
2. **Economizar dinheiro** encontrando a solução mais barata
3. **Garantir** que todas as demandas sejam atendidas
4. **Respeitar** as limitações das máquinas

É como ter um **consultor matemático** que testa todas as possibilidades e te diz exatamente o que fazer para gastar menos e produzir o necessário!

---

**Última atualização**: 2024

