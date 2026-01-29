
# Modulo 5: Definição de Variáveis e Estrutura Espacial (Shapefiles)
# Autor: Luiz Tiago Wilcke
# Descrição: Prepara os objetos espaciais (mapas) para análise geográfica.

library(tidyverse)
library(sf)
library(rnaturalearth)
# library(rnaturalearthbr) # Removido por descontinuidade no CRAN

print("Carregando estrutura espacial...")

# Tenta carregar shapefile dos estados do Brasil
tryCatch({
  # Opção 1: Usando pacote geobr se instalado (melhor resolução)
  if (requireNamespace("geobr", quietly = TRUE)) {
    mapa_sul <- geobr::read_state(code_state = "all", year = 2020, showProgress = FALSE) %>%
      filter(abbrev_state %in% c("PR", "SC", "RS"))
  } else {
    # Opção 2: Usando rnaturalearth
    br <- ne_states(country = "brazil", returnclass = "sf")
    mapa_sul <- br %>%
      filter(postal %in% c("PR", "SC", "RS")) %>%
      select(abbrev_state = postal, nome_estado = name, geometry)
  }
  
  # Salvar o objeto espacial processado para uso nos scripts de visualização
  # Salvar como .rds preserva a estrutura sf
  saveRDS(mapa_sul, "data/mapa_sul_sf.rds")
  print("Shapefile dos estados do Sul salvo em 'data/mapa_sul_sf.rds'.")
  
  # Mapa de municípios (opcional, pesado para baixar na hora, vamos focar nos estados para este exemplo)
  # Se precisar de municípios, usar geobr::read_municipality(code_muni = "all", year=2020)
  
}, error = function(e) {
  print(paste("Erro ao carregar shapefiles:", e$message))
  # Cria um objeto vazio sf para não quebrar scripts futuros
  mapa_vazio <- st_sf(id = 1, geometry = st_sfc(st_point(c(0,0))))
  saveRDS(mapa_vazio, "data/mapa_sul_sf.rds")
})
