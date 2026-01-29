
# Modulo 22: Teste de Autocorrelação Espacial (Moran's I)
# Autor: Luiz Tiago Wilcke
# Descrição: Verifica se a distribuição dos casos é aleatória ou agrupada no espaço.

library(spdep)
library(sf)
library(tidyverse)

# Carregar dados
mapa <- readRDS("data/mapa_sul_sf.rds")
lw <- readRDS("data/matriz_pesos_espaciais.rds")
data <- readRDS("data/dataset_analitico_final.rds")

# Agregar casos totais para cada estado
casos_uf <- data %>%
  group_by(uf) %>%
  summarise(taxa = sum(total_casos) / n()) # Normalizado (aprox)

# Unir com mapa
mapa_dados <- mapa %>%
  left_join(casos_uf, by = c("abbrev_state" = "uf")) %>%
  mutate(taxa = replace_na(taxa, 0))

# Teste de Moran Global
moran_global <- moran.test(mapa_dados$taxa, lw, zero.policy = TRUE)
print(moran_global)

# Moran Local (LISA)
local_moran <- localmoran(mapa_dados$taxa, lw, zero.policy = TRUE)
mapa_dados$lisa <- local_moran[,1] # Ii

# Mapa de Cluster (simplificado apenas o índice I local)
p_lisa <- ggplot(mapa_dados) +
  geom_sf(aes(fill = lisa)) +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red") +
  labs(title = "Autocorrelação Espacial Local (LISA)",
       subtitle = "Áreas vermelhas indicam clusters de alta incidência") +
  theme_void()

ggsave("output/mapa_lisa_moran.png", plot = p_lisa)
print("Módulo 22 concluído.")
