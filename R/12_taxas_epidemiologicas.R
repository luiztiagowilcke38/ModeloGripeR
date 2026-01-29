
# Modulo 12: Estimativa de Taxas de Mortalidade e Morbidade
# Autor: Luiz Tiago Wilcke
# Descrição: Calcula taxas de letalidade e incidência baseada na população estimada.

library(tidyverse)

# Carrega dados
data <- readRDS("data/dataset_analitico_final.rds")

# Estimativa populacional dos estados do Sul (IBGE 2021 aprox)
# PR: 11.5M, SC: 7.3M, RS: 11.4M -> Total ~30.2 Milhões
populacao_sul <- 30200000

# Cálculo semanal
df_taxas <- data %>%
  group_by(ano_epidemio, semana_epidemio) %>%
  summarise(casos = sum(total_casos), .groups = 'drop') %>%
  mutate(
    incidencia_100k = (casos / populacao_sul) * 100000,
    # Assumindo uma taxa de letalidade fixa de 0.1% a 0.5% para gripe comum/influenza variada
    # Em dados reais usaríamos a coluna de óbitos do SIM
    obitos_estimados = round(casos * 0.002), 
    mortalidade_100k = (obitos_estimados / populacao_sul) * 100000
  )

write.csv(df_taxas, "output/tabela_taxas_epidemiologicas.csv", row.names = FALSE)

# Gráfico
p <- ggplot(df_taxas, aes(x = as.numeric(row.names(df_taxas)))) +
  geom_line(aes(y = incidencia_100k, color = "Incidência")) +
  geom_line(aes(y = mortalidade_100k * 100, color = "Mortalidade (x100)")) + # Escala ajustada
  labs(title = "Taxas Epidemiológicas (por 100k hab)", y = "Taxa", x = "Tempo (Semanas)") +
  theme_minimal()

ggsave("output/grafico_taxas.png", plot = p)

print("Módulo 12 concluído.")
