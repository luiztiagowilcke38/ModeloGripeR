
# Modulo 24: Detecção de Clusters Espaço-Temporais (Scan Stat)
# Autor: Luiz Tiago Wilcke
# Descrição: Simula a funcionalidade do SaTScan para detectar clusters de alto risco.

library(tidyverse)
# O pacote rsatscan requer software externo instalado. Faremos uma simulação algorítmica simplificada em R
# Identificar região com maior taxa em janela de tempo deslizante.

data <- readRDS("data/dataset_analitico_final.rds")

# Algoritmo simplificado de varredura:
# Para cada Estado e Mês, calcular se Incidência > Média Global + 2 Desvios

media_global <- mean(data$total_casos, na.rm=TRUE)
sd_global <- sd(data$total_casos, na.rm=TRUE)
limiar <- media_global + 2 * sd_global

clusters <- data %>%
  filter(total_casos > limiar) %>%
  select(uf, ano_epidemio, semana_epidemio, total_casos) %>%
  mutate(risco = "Alto Risco (Cluster Detectado)")

write.csv(clusters, "output/tabela_clusters_scan.csv", row.names = FALSE)

# Plot dos clusters no tempo
p_scan <- ggplot(clusters, aes(x = semana_epidemio, y = total_casos, color = uf)) +
  geom_point(size = 3) +
  facet_wrap(~ano_epidemio) +
  labs(title = "Clusters Espaço-Temporais Detectados",
       subtitle = "Semanas com casos significativamente acima da média",
       x = "Semana", y = "Casos") +
  theme_gray()

ggsave("output/grafico_scan_clusters.png", plot = p_scan)
print("Módulo 24 concluído.")
