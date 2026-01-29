
# Modulo 11: Decomposição de Séries Temporais
# Autor: Luiz Tiago Wilcke
# Descrição: Decompõe a série de casos em Tendência, Sazonalidade e Ruído.

library(tidyverse)
library(forecast)

data <- readRDS("data/dataset_analitico_final.rds")

# Agregar dados semanalmente
dados_ts <- data %>%
  group_by(ano_epidemio, semana_epidemio) %>%
  summarise(total = sum(total_casos), .groups = 'drop') %>%
  arrange(ano_epidemio, semana_epidemio)

# Criar objeto Time Series (frequência 52 semanas)
ts_gripe <- ts(dados_ts$total, frequency = 52, start = c(min(dados_ts$ano_epidemio), 1))

# Decomposição STL (Seasonal and Trend decomposition using Loess)
fit_stl <- stl(ts_gripe, s.window = "periodic")

# Plotar
png("output/grafico_decomposicao_stl.png", width = 800, height = 600)
plot(fit_stl, main = "Decomposição STL da Gripe no Sul")
dev.off()

print("Módulo 11 concluído.")
