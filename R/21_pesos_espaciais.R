
# Modulo 21: Matrizes de Vizinhança e Pesos Espaciais
# Autor: Luiz Tiago Wilcke
# Descrição: Define quem é vizinho de quem (matriz W) para os estados do Sul.

library(spdep)
library(sf)
library(tidyverse)

# Carregar mapa
mapa <- readRDS("data/mapa_sul_sf.rds")

# Criar lista de vizinhança (Queen contiguity)
nb <- poly2nb(mapa)

# Converter para matriz de pesos espaciais (W) - Padronização por linha (W)
# Se houver regiões sem vizinhos, zero.policy=TRUE evita erro
lw <- nb2listw(nb, style = "W", zero.policy = TRUE)

# Visualização das conexões (Protegido com tryCatch)
tryCatch({
  png("output/grafico_matriz_vizinhanca.png", width=600, height=600)
  plot(st_geometry(mapa), border = "grey")
  coords <- st_coordinates(st_centroid(mapa))
  plot(nb, coords, add = TRUE, col = "red")
  title("Matriz de Vizinhança (Região Sul)")
  dev.off()
}, error = function(e) {
  print(paste("Aviso: Não foi possível gerar o gráfico de vizinhança:", e$message))
  if (dev.cur() > 1) dev.off()
})

saveRDS(lw, "data/matriz_pesos_espaciais.rds")
print("Módulo 21 concluído.")
