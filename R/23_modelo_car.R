
# Modulo 23: Modelo CAR (Conditional Autoregressive)
# Autor: Luiz Tiago Wilcke
# Descrição: Regressão espacial para modelar dependência entre áreas vizinhas.

library(spdep)
library(spatialreg)
library(sf)
library(tidyverse)

# Carregar dados preparados no Modulo 22 (reprocessaremos aqui por garantia)
mapa <- readRDS("data/mapa_sul_sf.rds")
lw <- readRDS("data/matriz_pesos_espaciais.rds")
data <- readRDS("data/dataset_analitico_final.rds")

# Agregar dados por estado
# Variável dependente: Casos
# Variável independente: Temperatura média
dados_uf <- data %>%
  group_by(uf) %>%
  summarise(casos = sum(total_casos),
            temp = mean(temp_media_semana, na.rm=TRUE))

mapa_dados <- mapa %>%
  left_join(dados_uf, by = c("abbrev_state" = "uf"))

# Ajuste do Modelo Spatial Error (similar ao CAR para fins práticos em spdep)
# errorsarlm ou spautolm
model_car <- spautolm(casos ~ temp, data = mapa_dados, listw = lw, family = "CAR", zero.policy = TRUE)

summary(model_car)

# Salvar resultados
sink("output/resultado_modelo_car.txt")
print(summary(model_car))
sink()

print("Módulo 23 concluído.")
