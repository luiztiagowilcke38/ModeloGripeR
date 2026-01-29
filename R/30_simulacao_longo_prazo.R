
# Modulo 30: Simulação de Cenários 2020-2050
# Autor: Luiz Tiago Wilcke
# Descrição: Projeção de longo prazo considerando sazonalidade e tendências estocásticas.

library(forecast)
library(tidyverse)
library(ggplot2)

data <- readRDS("data/dataset_analitico_final.rds")

# Criar série temporal
dados_ts <- data %>%
  group_by(ano_epidemio, semana_epidemio) %>%
  summarise(total = sum(total_casos), .groups = 'drop')

ts_gripe <- ts(dados_ts$total, frequency = 52, start = c(2020, 1))

# Horizonte de previsão: 2025 (fim dos dados reais/simulados) até 2050 = 25 anos
# 25 anos * 52 semanas = 1300 semanas
horizonte <- 1300

# Usando um modelo ARIMA com drift para capturar tendências de longo prazo ou estabilidade
# Limitação: prever 30 anos de gripe é altamente incerto devido a mutações virais (shifts).
# Adicionamos "ruído" extra para simular incerteza biológica.

fit <- auto.arima(ts_gripe)
fc <- forecast(fit, h = horizonte)

# Adicionar componentes de possíveis novas pandemias (choques aleatórios)
# Simulação de Monte Carlo simplificada
set.seed(2050)
ruido <- arima.sim(model = list(ar=0.9), n = horizonte) * sd(fc$residuals) * 2
ruido <- ts(ruido, start=start(fc$mean), frequency=frequency(fc$mean))
simulacao <- fc$mean + ruido

# Criar dataframe para plot
datas_futuras <- seq(as.Date("2025-01-01"), by = "week", length.out = horizonte)
df_futuro <- data.frame(
  data = datas_futuras,
  casos_previstos = as.numeric(simulacao)
)

# Garantir não negativo
df_futuro$casos_previstos <- pmax(df_futuro$casos_previstos, 0)

# Introduzir "Picos Pandêmicos" aleatórios (ex: a cada ~10 anos)
picos <- sample(1:horizonte, 3)
df_futuro$casos_previstos[picos] <- df_futuro$casos_previstos[picos] * 5
df_futuro$casos_previstos[picos+1] <- df_futuro$casos_previstos[picos+1] * 3

p_longo <- ggplot(df_futuro, aes(x = data, y = casos_previstos)) +
  geom_line(color = "purple", alpha = 0.7) +
  labs(title = "Projeção de Longo Prazo: Gripe no Sul (2025-2050)",
       subtitle = "Simulação com componentes estocásticas e possíveis surtos pandêmicos",
       x = "Ano", y = "Casos Estimados") +
  theme_minimal() +
  scale_x_date(date_breaks = "5 years", date_labels = "%Y")

ggsave("output/grafico_projecao_2050.png", plot = p_longo, width = 12, height = 6)
saveRDS(df_futuro, "data/simulacao_2050.rds")

print("Módulo 30 concluído.")
