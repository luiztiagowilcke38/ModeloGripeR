
# Modulo 15: Análise de Intervenção (Impacto Vacinação/Lockdown)
# Autor: Luiz Tiago Wilcke
# Descrição: Analisa mudança estrutural na série temporal após eventos conhecidos.

library(tidyverse)
library(forecast)

data <- readRDS("data/dataset_analitico_final.rds")

dados_ts <- data %>%
  group_by(ano_epidemio, semana_epidemio) %>%
  summarise(total = sum(total_casos), .groups = 'drop')

# Criação de dummy de intervenção
# Exemplo: Início da Vacinação em Massa ou Lockdown (simbolico na semana 50 da série)
# Ajustar semana_intervencao conforme dados reais
semana_intervencao <- round(nrow(dados_ts) * 0.5) 

dados_ts <- dados_ts %>%
  mutate(intervencao = ifelse(row_number() >= semana_intervencao, 1, 0))

ts_gripe <- ts(dados_ts$total, frequency = 52)
xreg_intervencao <- dados_ts$intervencao

# ARIMAX com variavel exogena de intervenção
fit_intervencao <- auto.arima(ts_gripe, xreg = xreg_intervencao)
summary(fit_intervencao)

coeficiente_intervencao <- fit_intervencao$coef["xreg"]

print(paste("Coeficiente de Intervenção:", coeficiente_intervencao))
if(coeficiente_intervencao < 0) {
  print("A intervenção teve impacto negativo (redutor) no número de casos.")
} else {
  print("Não houve redução significativa associada à intervenção no modelo.")
}

print("Módulo 15 concluído.")
