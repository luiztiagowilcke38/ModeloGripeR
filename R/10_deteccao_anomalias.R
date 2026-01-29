
# Modulo 10: Detecção de Outliers e Anomalias
# Autor: Luiz Tiago Wilcke
# Descrição: Identifica picos anômalos de casos que podem indicar surtos.

library(tidyverse)
library(ggplot2)

data <- readRDS("data/dataset_analitico_final.rds")

ts_sul <- data %>%
  group_by(ano_epidemio, semana_epidemio) %>%
  summarise(total_casos = sum(total_casos, na.rm=TRUE)) %>%
  ungroup() %>%
  mutate(idx = row_number())

# Método simples: Média + 3 Desvios Padrão (Regra 3-Sigma)
media_movel_window <- 4 # Janela de 4 semanas
ts_sul <- ts_sul %>%
  mutate(
    media_movel = zoo::rollmean(total_casos, k = media_movel_window, fill = NA, align = "right"),
    desvio = zoo::rollapply(total_casos, width = media_movel_window, FUN = sd, fill = NA, align = "right"),
    limite_superior = media_movel + 3 * desvio,
    outlier = total_casos > limite_superior
  )

num_outliers <- sum(ts_sul$outlier, na.rm=TRUE)

p_outliers <- ggplot(ts_sul, aes(x = idx, y = total_casos)) +
  geom_line(color = "grey") +
  geom_point(data = subset(ts_sul, outlier == TRUE), color = "red", size = 3) +
  geom_ribbon(aes(ymin = 0, ymax = limite_superior), alpha = 0.1, fill = "blue") +
  labs(title = "Detecção de Anomalias (Surto)",
       subtitle = paste("Pontos vermelhos indicam desvios > 3 sigma. Total:", num_outliers),
       x = "Semana Sequencial", y = "Casos") +
  theme_minimal()

ggsave("output/grafico_outliers.png", plot = p_outliers, width = 10, height = 5)

write.csv(ts_sul %>% filter(outlier == TRUE), "output/tabela_anomalias.csv", row.names = FALSE)

print("Módulo 10 concluído.")
