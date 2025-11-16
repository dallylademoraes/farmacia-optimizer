# Guia de Uso - Sistema de Otimização de Produção
## Farmácia - Pesquisa Operacional

---

## 📋 Índice

1. [O que é este sistema?](#o-que-é-este-sistema)
2. [Como funciona?](#como-funciona)
3. [Estrutura dos arquivos](#estrutura-dos-arquivos)
4. [Como usar o sistema](#como-usar-o-sistema)
5. [Modificando os dados](#modificando-os-dados)
6. [Interpretando os resultados](#interpretando-os-resultados)
7. [Exemplos práticos](#exemplos-práticos)
8. [Solução de problemas](#solução-de-problemas)

---

## 🎯 O que é este sistema?

Este sistema utiliza **Pesquisa Operacional** para ajudar a farmácia a encontrar a melhor forma de produzir medicamentos, minimizando os custos enquanto atende todas as demandas e respeita as limitações das máquinas.

### Problema que resolve:

- ✅ Quantos lotes de cada medicamento produzir?
- ✅ Como minimizar o custo total de produção?
- ✅ Como garantir que todas as demandas sejam atendidas?
- ✅ Como respeitar a capacidade disponível das máquinas?

---

## 🔧 Como funciona?

O sistema usa um modelo matemático chamado **Programação Linear Inteira** que:

1. **Recebe os dados** do problema (demandas, custos, capacidades)
2. **Calcula a solução ótima** usando algoritmos de otimização
3. **Retorna os resultados** mostrando quantos lotes produzir de cada produto

### Ferramenta utilizada:
- **GLPK (GNU Linear Programming Kit)** - Software gratuito e open-source para resolver problemas de otimização

---

## 📁 Estrutura dos arquivos

### 1. `farmarcia.mod` - Modelo Matemático
Este arquivo define a **estrutura do problema**:

- **Conjuntos**: Produtos (P1, P2, P3) e Máquinas (Misturador, Reator)
- **Parâmetros**: Demandas, custos, capacidades, tempos
- **Variáveis**: Quantidade de lotes a produzir (x[P1], x[P2], x[P3])
- **Função Objetivo**: Minimizar o custo total
- **Restrições**: 
  - Atender demanda mínima de cada produto
  - Respeitar capacidade das máquinas

**⚠️ IMPORTANTE**: Este arquivo geralmente **NÃO precisa ser modificado**, a menos que você queira alterar a estrutura do problema.

### 2. `farmarcia.dat` - Dados do Problema
Este arquivo contém os **valores específicos** do seu problema:

```ampl
set PROD := P1 P2 P3;              # Produtos
set MAQ := Misturador Reator;       # Máquinas

param demanda :=                   # Demanda mínima (lotes)
P1 150     # Paracetamol
P2 100     # Ibuprofeno
P3 150 ;   # Vitamina C

param custo :=                     # Custo por lote (R$)
P1 35
P2 45
P3 20 ;

param capacidade :=                 # Capacidade das máquinas (horas)
Misturador 1200
Reator     1000 ;

param tempo :                      # Tempo de processamento (horas/lote)
                 P1    P2    P3 :=
Misturador       2     3     1.5
Reator           2.5   3     2 ;
```

**✅ Este é o arquivo que você vai modificar** para alterar os valores do problema.

### 3. `run.bat` - Script de Execução
Este arquivo automatiza a execução do sistema:
- Executa o GLPK com os arquivos .mod e .dat
- Gera os arquivos de resultado
- Abre o resultado no navegador

---

## 🚀 Como usar o sistema

### Passo 1: Preparar os dados
1. Abra o arquivo `farmarcia.dat` em um editor de texto
2. Atualize os valores conforme sua situação:
   - Demandas dos produtos
   - Custos por lote
   - Capacidades das máquinas
   - Tempos de processamento

### Passo 2: Executar o sistema
1. **Opção A - Duplo clique**: Clique duas vezes no arquivo `run.bat`
2. **Opção B - Linha de comando**: Abra o PowerShell/CMD na pasta e execute:
   ```bash
   .\run.bat
   ```

### Passo 3: Ver os resultados
O sistema irá:
- Gerar o arquivo `resultado.sol` (solução detalhada)
- Gerar o arquivo `resultado.txt` (resultados formatados)
- Abrir automaticamente o `resultado.html` no navegador

---

## ✏️ Modificando os dados

### Exemplo 1: Alterar a demanda de um produto

**Situação**: A demanda de Paracetamol aumentou para 200 lotes.

**Modificação no `farmarcia.dat`**:
```ampl
param demanda :=
P1 200     # Paracetamol (alterado de 150 para 200)
P2 100     # Ibuprofeno
P3 150 ;   # Vitamina C
```

### Exemplo 2: Alterar o custo de um produto

**Situação**: O custo do Ibuprofeno aumentou para R$ 50,00 por lote.

**Modificação no `farmarcia.dat`**:
```ampl
param custo :=
P1 35
P2 50      # Alterado de 45 para 50
P3 20 ;
```

### Exemplo 3: Alterar a capacidade de uma máquina

**Situação**: O Misturador agora tem 1500 horas disponíveis.

**Modificação no `farmarcia.dat`**:
```ampl
param capacidade :=
Misturador 1500    # Alterado de 1200 para 1500
Reator     1000 ;
```

### Exemplo 4: Adicionar um novo produto

**Situação**: Queremos adicionar um quarto produto (P4 - Aspirina).

**1. Modificar `farmarcia.dat`**:
```ampl
set PROD := P1 P2 P3 P4;    # Adicionar P4

param demanda :=
P1 150
P2 100
P3 150
P4 80 ;    # Nova demanda

param custo :=
P1 35
P2 45
P3 20
P4 30 ;    # Novo custo

param tempo :
                 P1    P2    P3    P4 :=
Misturador       2     3     1.5   2.5
Reator           2.5   3     2     2.2 ;
```

**⚠️ ATENÇÃO**: Adicionar produtos ou máquinas requer modificar também o arquivo `.mod` em alguns casos.

---

## 📊 Interpretando os resultados

### Arquivo `resultado.sol`

Este arquivo contém informações técnicas detalhadas:

```
Problem:    farmarcia
Status:     INTEGER OPTIMAL
Objective:  Custo_Total = 12750 (MINimum)
```

**O que significa:**
- **Status: INTEGER OPTIMAL** → Solução ótima encontrada
- **Objective: Custo_Total = 12750** → Custo mínimo é R$ 12.750,00

### Arquivo `resultado.txt`

```
Resultados da Producao:
P1: 150 lotes
P2: 100 lotes
P3: 150 lotes
```

**Interpretação:**
- Produzir **150 lotes** de Paracetamol (P1)
- Produzir **100 lotes** de Ibuprofeno (P2)
- Produzir **150 lotes** de Vitamina C (P3)

### Dashboard HTML (`resultado.html`)

O dashboard mostra:
- ✅ Custo total da solução
- ✅ Quantidade de lotes por produto
- ✅ Utilização das máquinas
- ✅ Status de atendimento da demanda
- ✅ Gráficos visuais

---

## 💡 Exemplos práticos

### Cenário 1: Aumento de demanda

**Situação**: A demanda de Vitamina C aumentou de 150 para 200 lotes.

**Ação**: 
1. Edite `farmarcia.dat` e altere `P3 150` para `P3 200`
2. Execute `run.bat`
3. Veja o novo custo total e quantidades

**Resultado esperado**: O custo total aumentará, e a utilização das máquinas também.

### Cenário 2: Redução de capacidade

**Situação**: O Reator está com manutenção e só tem 800 horas disponíveis.

**Ação**:
1. Edite `farmarcia.dat` e altere `Reator 1000` para `Reator 800`
2. Execute `run.bat`
3. Verifique se a solução ainda é viável

**Resultado esperado**: Pode ser que não seja possível atender todas as demandas. O sistema indicará se o problema é inviável.

### Cenário 3: Mudança de custos

**Situação**: O custo do Paracetamol diminuiu para R$ 30,00.

**Ação**:
1. Edite `farmarcia.dat` e altere `P1 35` para `P1 30`
2. Execute `run.bat`
3. Compare o novo custo total

**Resultado esperado**: O custo total diminuirá.

---

## 🔍 Solução de problemas

### Problema: "Solução não encontrada" ou "INFEASIBLE"

**Causa**: As restrições são incompatíveis (ex: demanda muito alta para a capacidade disponível).

**Solução**:
1. Verifique se a capacidade das máquinas é suficiente
2. Calcule manualmente: `(tempo P1 × demanda P1) + (tempo P2 × demanda P2) + ...` deve ser ≤ capacidade
3. Reduza as demandas ou aumente as capacidades

### Problema: "GLPK não encontrado"

**Causa**: O caminho do GLPK no `run.bat` está incorreto.

**Solução**:
1. Verifique onde o GLPK está instalado
2. Edite `run.bat` e atualize o caminho na linha:
   ```batch
   "C:\glpk\winglpk-4.65\glpk-4.65\w64\glpsol.exe"
   ```
3. Substitua pelo caminho correto da sua instalação

### Problema: Resultados não fazem sentido

**Causa**: Dados incorretos no arquivo `.dat`.

**Solução**:
1. Verifique se todos os valores estão corretos
2. Confirme que os tempos estão em horas
3. Verifique se as capacidades estão em horas
4. Certifique-se de que não há valores negativos

---

## 📝 Dicas importantes

1. **Sempre faça backup** do arquivo `farmarcia.dat` antes de fazer alterações grandes
2. **Valide os dados** antes de executar (verifique se fazem sentido)
3. **Compare resultados** quando alterar valores para entender o impacto
4. **Use o dashboard** para visualizar melhor os resultados
5. **Documente mudanças** importantes para referência futura

---

## 🎓 Entendendo melhor o modelo

### Função Objetivo
```
Minimizar: Custo_Total = (35 × P1) + (45 × P2) + (20 × P3)
```
Queremos o menor custo possível.

### Restrições

**1. Atender demanda:**
```
P1 ≥ 150 lotes
P2 ≥ 100 lotes
P3 ≥ 150 lotes
```

**2. Respeitar capacidade:**
```
Misturador: (2×P1) + (3×P2) + (1.5×P3) ≤ 1200 horas
Reator: (2.5×P1) + (3×P2) + (2×P3) ≤ 1000 horas
```

---

## 📞 Suporte

Se tiver dúvidas sobre:
- **Como modificar os dados**: Consulte a seção "Modificando os dados"
- **Interpretar resultados**: Consulte a seção "Interpretando os resultados"
- **Problemas técnicos**: Consulte a seção "Solução de problemas"

---

**Última atualização**: 2025

**Versão do sistema**: 1.0

