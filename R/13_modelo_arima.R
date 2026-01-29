
# Modulo 13: Modelagem ARIMA para Curto Prazo
# Autor: Luiz Tiago Wilcke
# Descrição: Ajusta um modelo AutoRegressive Integrated Moving Average para previsão.

library(tidyverse)
library(forecast)

data <- readRDS("data/dataset_analitico_final.rds")

# Preparar TS
dados_ts <- data %>%
  group_by(ano_epidemio, semana_epidemio) %>%
  summarise(total = sum(total_casos), .groups = 'drop')

ts_gripe <- ts(dados_ts$total, frequency = 52)

# Treino e Teste (últimas 20 semanas para teste)
treino <- subset(ts_gripe, end = length(ts_gripe) - 20)
teste <- subset(ts_gripe, start = length(ts_gripe) - 19)

# Auto ARIMA
fit_arima <- auto.arima(treino, seasonal = TRUE)
summary(fit_arima)

# Previsão
forecast_arima <- forecast(fit_arima, h = 20)

# Avaliação
accuracy(forecast_arima, teste)

# Plot
png("output/grafico_previsao_arima.png", width = 800, height = 600)
plot(forecast_arima)
lines(teste, col = "red")
legend("topleft", legend = c("Previsão", "Real"), col = c("blue", "red"), lty = 1)
dev.off()

saveRDS(fit_arima, "data/modelo_arima.rds")
print("Módulo 13 concluído.")
