
# Modulo 14: Modelagem ETS (Exponential Smoothing)
# Autor: Luiz Tiago Wilcke
# Descrição: Ajusta um modelo de Suavização Exponencial (Error, Trend, Seasonal).

library(tidyverse)
library(forecast)

data <- readRDS("data/dataset_analitico_final.rds")

dados_ts <- data %>%
  group_by(ano_epidemio, semana_epidemio) %>%
  summarise(total = sum(total_casos), .groups = 'drop')

ts_gripe <- ts(dados_ts$total, frequency = 52)
treino <- subset(ts_gripe, end = length(ts_gripe) - 20)
teste <- subset(ts_gripe, start = length(ts_gripe) - 19)

# Modelo ETS
fit_ets <- ets(treino)
summary(fit_ets)

# Previsão
forecast_ets <- forecast(fit_ets, h = 20)

# Plot Comparativo
png("output/grafico_previsao_ets.png", width = 800, height = 600)
plot(forecast_ets)
lines(teste, col = "red")
legend("topleft", legend = c("Previsão ETS", "Real"), col = c("blue", "red"), lty = 1)
dev.off()

saveRDS(fit_ets, "data/modelo_ets.rds")
print("Módulo 14 concluído.")
