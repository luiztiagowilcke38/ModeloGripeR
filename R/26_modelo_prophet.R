
# Modulo 26: Previsão com Facebook Prophet
# Autor: Luiz Tiago Wilcke
# Descrição: Modelo aditivo com componentes de tendência e sazonalidade robusto a outliers.

library(prophet)
library(tidyverse)
library(lubridate)

# Carregar dados e preparar formato do Prophet (ds, y)
data <- readRDS("data/dataset_analitico_final.rds")

df_prophet <- data %>%
  group_by(ano_epidemio, semana_epidemio) %>%
  summarise(y = sum(total_casos), .groups = 'drop') %>%
  mutate(ds = as.Date(paste(ano_epidemio, semana_epidemio, 1, sep="-"), format="%Y-%U-%u")) %>%
  select(ds, y) %>%
  filter(!is.na(ds))

# Ajustar modelo
# Adiciona feriados brasileiros se quiser (country_name = 'BR') - opcional
m <- prophet(daily.seasonality = FALSE, weekly.seasonality = TRUE)
m <- add_country_holidays(m, country_name = 'BR')
m <- fit.prophet(m, df_prophet)

# Previsão Futura (1 ano = 52 semanas)
future <- make_future_dataframe(m, periods = 52, freq = "week")
forecast <- predict(m, future)

# Plot
png("output/grafico_prophet_previsao.png", width=800, height=600)
plot(m, forecast) + 
  ggtitle("Previsão de Influenza usando Prophet")
dev.off()

png("output/grafico_prophet_componentes.png", width=800, height=600)
prophet_plot_components(m, forecast)
dev.off()

saveRDS(forecast, "data/modelo_prophet_resultado.rds")
print("Módulo 26 concluído.")
