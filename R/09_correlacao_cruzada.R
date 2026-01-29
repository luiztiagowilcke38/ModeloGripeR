
# Modulo 9: Análise de Correlação Cruzada
# Autor: Luiz Tiago Wilcke
# Descrição: Analisa a defasagem (lag) entre temperatura/clima e aumento de casos.

library(tidyverse)
library(ggplot2)

data <- readRDS("data/dataset_analitico_final.rds")

# Agrega dados gerais
ts_analysis <- data %>%
  group_by(ano_epidemio, semana_epidemio) %>%
  summarise(casos = sum(total_casos),
            temp = mean(temp_media_semana, na.rm=TRUE)) %>%
  ungroup()

# Correlação Cruzada (CCF)
ccf_res <- ccf(ts_analysis$temp, ts_analysis$casos, lag.max = 20, plot = FALSE)

# Transformar em DF para ggplot
ccf_df <- data.frame(lag = ccf_res$lag, acf = ccf_res$acf)

p_ccf <- ggplot(ccf_df, aes(x = lag, y = acf)) +
  geom_bar(stat = "identity", fill = "purple", width = 0.5) +
  geom_hline(yintercept = 0) +
  geom_hline(yintercept = c(1.96/sqrt(nrow(ts_analysis)), -1.96/sqrt(nrow(ts_analysis))), 
             linetype = "dashed", color = "blue") +
  labs(title = "Correlação Cruzada: Temperatura vs Casos",
       subtitle = "Lags negativos indicam que Temperatura antecede Casos",
       x = "Lag (Semanas)", y = "Correlação") +
  theme_minimal()

ggsave("output/grafico_ccf.png", plot = p_ccf, width = 8, height = 5)

print("Módulo 9 concluído.")
