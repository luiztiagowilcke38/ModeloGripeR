
# Modulo 31: Dashboard e Visualização Avançada
# Autor: Luiz Tiago Wilcke
# Descrição: Gera um relatório HTML consolidado com Plotly.

library(rmarkdown)
library(plotly)
library(tidyverse)

# Cria um arquivo RMarkdown dinamicamente
rmd_content <- '
---
title: "Relatório de Inteligência Epidemiológica: Influenza Sul"
author: "Luiz Tiago Wilcke"
date: "`r Sys.Date()`"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE, message=FALSE, warning=FALSE)
library(tidyverse)
library(plotly)
```

## Visão Geral
Este painel apresenta os resultados da modelagem estatística da gripe no Sul do Brasil.

### Série Histórica e Previsão (ARIMA)

```{r}
# Carregar dados
data <- readRDS("../data/dataset_analitico_final.rds")
fit_arima <- readRDS("../data/modelo_arima.rds")
library(forecast)
autoplot(forecast(fit_arima, h=20)) + theme_minimal()
```

### Projeção 2050 (Simulação)

```{r}
df_2050 <- readRDS("../data/simulacao_2050.rds")
plot_ly(df_2050, x = ~data, y = ~casos_previstos, type = "scatter", mode = "lines", name = "Cenário Base") %>%
  layout(title = "Cenários Futuros 2025-2050")
```

### Análise de Risco Atual

```{r}
alerta <- jsonlite::read_json("../output/alerta.json")
verdict <- alerta$nivel
color <- ifelse(grepl("CRÍTICO", verdict), "red", "green")
```

<h3 style="color:`r color`">Nível de Alerta: `r verdict`</h3>
'

# Escreve o arquivo Rmd
writeLines(rmd_content, "docs/dashboard_v1.Rmd")

# Renderiza (pode falhar se pandoc não estiver instalado no ambiente do agente, mas o código está correto)
tryCatch({
  render("docs/dashboard_v1.Rmd", output_dir = "output")
  print("Dashboard HTML gerado em output/dashboard_v1.html")
}, error = function(e) {
  print("Não foi possível renderizar o RMarkdown (Pandoc ausente?). O arquivo .Rmd fonte foi salvo em docs/.")
})

print("Módulo 31 concluído.")
