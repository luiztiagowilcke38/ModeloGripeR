
library(tidyverse)
library(sf)

# Load data
data <- readRDS("data/dataset_analitico_final.rds")
mapa_sul <- readRDS("data/mapa_sul_sf.rds")

print("--- Data Summary ---")
print(unique(data$uf))
print(summary(data$total_casos))

# Aggregation
casos_uf <- data %>%
  group_by(uf) %>%
  summarise(total_casos_acumulados = sum(total_casos, na.rm=TRUE))
print("--- Aggregated Cases by UF ---")
print(casos_uf)

print("--- Map Shapefile ---")
print(head(mapa_sul))
print(unique(mapa_sul$abbrev_state))

# Join
mapa_dados <- mapa_sul %>%
  left_join(casos_uf, by = c("abbrev_state" = "uf"))

print("--- Joined Data ---")
print(mapa_dados)
