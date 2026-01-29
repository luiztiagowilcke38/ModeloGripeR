
# Modulo 27: Redes Neurais para Séries Temporais (NNET/LSTM)
# Autor: Luiz Tiago Wilcke
# Descrição: Modelo não-linear (Rede Neural) para captura de padrões complexos.

library(tidyverse)
library(caret)
library(forecast)

data <- readRDS("data/dataset_analitico_final.rds")

dados_ts <- data %>%
  group_by(ano_epidemio, semana_epidemio) %>%
  summarise(total = sum(total_casos), .groups = 'drop')

ts_gripe <- ts(dados_ts$total, frequency = 52)
treino <- subset(ts_gripe, end = length(ts_gripe) - 20)
teste <- subset(ts_gripe, start = length(ts_gripe) - 19)

# Rede Neural AutoRegressiva (NNAR) do pacote forecast (Wrapper para nnet)
# P = lags, k = neurônios na camada oculta
fit_nnet <- nnetar(treino)
summary(fit_nnet)

# Previsão
forecast_nnet <- forecast(fit_nnet, h = 20)

# Avaliação no Teste
acc <- accuracy(forecast_nnet, teste)
print(acc)

# Plot
png("output/grafico_previsao_redes_neurais.png", width=800, height=600)
plot(forecast_nnet)
lines(teste, col="red")
legend("topleft", legend=c("NNAR", "Real"), col=c("blue", "red"), lty=1)
dev.off()

saveRDS(fit_nnet, "data/modelo_nnet.rds")
print("Módulo 27 concluído.")
