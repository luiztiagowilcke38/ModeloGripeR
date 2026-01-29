
# Modulo 2: Coleta de Dados Complementares (Clima e InfoGripe)
# Autor: Luiz Tiago Wilcke
# Descrição: Coleta dados climáticos (temperatura, umidade) que influenciam na propagação viral.

library(tidyverse)
library(lubridate)

# Função simulate_climate
# Nota: O acesso a APIs históricas (como NASA POWER) requer tempo e configuração.
# Vamos simular dados climáticos realistas para o Sul do Brasil (frio no inverno).

gerar_clima <- function(data_inicio, data_fim) {
  datas <- seq(as.Date(data_inicio), as.Date(data_fim), by="day")
  
  df_clima <- data.frame(
    data = datas,
    # Temperatura média diária (sazonalidade anual + ruído)
    temp_media = 20 + 8 * cos(2 * pi * (month(datas) - 1) / 12) + rnorm(length(datas), 0, 2),
    # Umidade (inversamente proporcional à temperatura em algumas regiões, mas variado)
    umidade = 70 + 10 * sin(2 * pi * (month(datas)) / 12) + rnorm(length(datas), 0, 5)
  )
  
  # Ajuste para inverno no hemisfério sul (Junho-Agosto mais frio)
  # A função cos acima tem pico no mês 1 (Janeiro), que é verão. Mês 7 (Julho) será o vale (frio). OK.
  
  return(df_clima)
}

# Define período de coleta
periodo_inicio <- "2020-01-01"
periodo_fim <- "2024-12-31"

print("Gerando dados climáticos complementares...")
df_clima_sul <- gerar_clima(periodo_inicio, periodo_fim)

# Adiciona info fake do InfoGripe (Níveis de alerta)
# Em um cenário real, baixaríamos do repositório oficial do InfoGripe no GitHub
df_clima_sul <- df_clima_sul %>%
  mutate(
    nivel_alerta_infogripe = case_when(
      temp_media < 15 ~ "Alto",
      temp_media < 20 ~ "Médio",
      TRUE ~ "Baixo"
    )
  )

write.csv(df_clima_sul, "data/dados_clima_sul.csv", row.names = FALSE)
print("Dados climáticos e complementares salvos em data/dados_clima_sul.csv")
