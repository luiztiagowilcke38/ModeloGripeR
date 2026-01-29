
# Modulo 6: Análise Descritiva Temporal
# Autor: Luiz Tiago Wilcke
# Descrição: Gera gráficos de séries temporais para visualizar a evolução dos casos ao longo do tempo.

library(tidyverse)
library(ggplot2)
library(scales)

# Carregar dados
data <- readRDS("data/dataset_analitico_final.rds")

# Preparar dados: agregar casos por semana para toda a região Sul
ts_sul <- data %>%
  group_by(ano_epidemio, semana_epidemio) %>%
  summarise(total_casos = sum(total_casos, na.rm=TRUE),
            temp_media = mean(temp_media_semana, na.rm=TRUE)) %>%
  ungroup() %>%
  mutate(data_ref = as.Date(paste(ano_epidemio, semana_epidemio, 1, sep="-"), format="%Y-%U-%u")) # Aproximação data

# Gráfico 1: Curva Epidêmica
p1 <- ggplot(ts_sul, aes(x = data_ref, y = total_casos)) +
  geom_line(color = "steelblue", size = 1.2) +
  geom_area(fill = "steelblue", alpha = 0.3) +
  labs(title = "Evolução Temporal dos Casos de Gripe no Sul do Brasil",
       subtitle = "Série Histórica Agregada",
       x = "Data", y = "Total de Casos",
       caption = "Fonte: Dados DATASUS processados") +
  theme_minimal() +
  scale_x_date(date_breaks = "6 months", date_labels = "%b/%Y")

ggsave("output/grafico_curva_epidemica.png", plot = p1, width = 10, height = 6)

# Gráfico 2: Sazonalidade (Boxplot por Mês) - precisa da data original ou recriar mes
ts_sul_mensal <- ts_sul %>%
  mutate(mes = format(data_ref, "%B")) %>%
  mutate(mes = factor(mes, levels = c("janeiro","fevereiro","março","abril","maio","junho",
                                      "julho","agosto","setembro","outubro","novembro","dezembro")))

# Como usamos epiweek, a conversão para mês é aproximada, mas suficiente para visualização
p2 <- ggplot(ts_sul, aes(x = factor(month(data_ref), labels=month.abb), y = total_casos)) +
  geom_boxplot(fill = "orange", alpha = 0.5) +
  labs(title = "Sazonalidade da Gripe",
       x = "Mês", y = "Casos") +
  theme_minimal()

ggsave("output/grafico_sazonalidade.png", plot = p2, width = 8, height = 6)

print("Módulo 6 concluído. Gráficos salvos em output/")
