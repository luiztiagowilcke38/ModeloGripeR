
# Modelo Estatístico da Propagação da Gripe no Sul do Brasil (2020-2050)

**Autor:** Luiz Tiago Wilcke
**Linguagem:** R

## Visão Geral
Este projeto implementa um sistema completo para modelagem, previsão e simulação da propagação do vírus Influenza na região Sul do Brasil. Utiliza dados reais do DATASUS combinados com variáveis climáticas e demográficas.

O sistema é composto por **32 módulos independentes** orquestrados por um "Super Módulo".

## Estrutura do Projeto
- `R/`: Código fonte (32 scripts).
- `data/`: Dados brutos, processados e shapefiles.
- `output/`: Gráficos, mapas e relatórios gerados.
- `docs/`: Dashboards e documentação técnica.

## Funcionalidades Principais
1.  **Coleta Automatizada**: Integração com `microdatasus` para baixar dados de SIH/SIM.
2.  **Análise Espaço-Temporal**: Modelos CAR, Moran's I e Scan Statistics para detecção de clusters geográficos.
3.  **Epidemiologia Avançada**: Modelos SIR, SEIR, SIR-Etário e Metapopulacional resolvidos via equações diferenciais (`deSolve`).
4.  **Inteligência Artificial**: Previsão com Facebook Prophet, Redes Neurais (NNAR) e Random Forest.
5.  **Simulação de Longo Prazo**: Projeções estocásticas até 2050, incluindo detecção de potencial risco pandêmico.

## Equações Fundamentais

### Modelo SIR
O modelo base é regido pelo sistema de EDOs:

$$
\begin{aligned}
\frac{dS}{dt} &= -\beta \frac{S I}{N} \\
\frac{dI}{dt} &= \beta \frac{S I}{N} - \gamma I \\
\frac{dR}{dt} &= \gamma I
\end{aligned}
$$

Onde:
- $\beta$: Taxa de transmissão
- $\gamma$: Taxa de recuperação
- $R_0 = \frac{\beta}{\gamma}$: Número reprodutivo básico

### Modelo GWR (Geographically Weighted Regression)
$$ y_i = \beta_0(u_i,v_i) + \sum_k \beta_k(u_i,v_i)x_{ik} + \epsilon_i $$
Onde $(u_i, v_i)$ são as coordenadas geográficas do ponto $i$.

## Como Executar

1. Abra o R ou RStudio na raiz do projeto.
2. Execute o **Super Módulo** para rodar todo o pipeline:
   ```R
   source("R/32_super_modulo.R")
   ```
3. Os resultados serão gerados na pasta `output/`.

## Requisitos de Sistema
Pacotes R necessários:
`tidyverse`, `microdatasus`, `sf`, `spdep`, `forecast`, `prophet`, `deSolve`, `caret`, `randomForest`, `plotly`, `rmarkdown`.

---
*Desenvolvido com recursos estatísticos avançados recentes.*
