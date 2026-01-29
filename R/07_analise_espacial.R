
# Modulo 7: Análise Descritiva Espacial
# Autor: Luiz Tiago Wilcke
# Descrição: Mapas de calor e distribuição geográfica dos casos por estado.

library(tidyverse)
library(sf)
library(ggplot2)

# Carregar dados
data <- readRDS("data/dataset_analitico_final.rds")
mapa_sul <- readRDS("data/mapa_sul_sf.rds")

# Agregar dados por Estado (UF)
casos_uf <- data %>%
  group_by(uf) %>%
  summarise(total_casos_acumulados = sum(total_casos, na.rm=TRUE))

# Join com dados espaciais
# Ajuste nomes se necessário: no sf original é 'abbrev_state' ou 'postal'
mapa_dados <- mapa_sul %>%
  left_join(casos_uf, by = c("abbrev_state" = "uf"))

# Mapa Cloropleth
p_mapa <- ggplot(mapa_dados) +
  geom_sf(aes(fill = total_casos_acumulados), color = "white") +
  scale_fill_viridis_c(option = "magma", direction = -1, name = "Casos") +
  labs(title = "Distribuição Espacial Acumulada da Gripe",
       subtitle = "Região Sul do Brasil") +
  theme_void()

ggsave("output/mapa_casos_acumulados.png", plot = p_mapa, width = 8, height = 8)

print("Módulo 7 concluído. Mapa salvo em output/")
