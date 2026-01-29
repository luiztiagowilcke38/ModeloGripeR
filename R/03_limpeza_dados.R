
# Modulo 3: Pré-processamento e Limpeza (Data Cleaning)
# Autor: Luiz Tiago Wilcke
# Descrição: Padronização e limpeza dos dados brutos coletados.

library(tidyverse)
library(janitor)
library(lubridate)

print("Iniciando limpeza de dados...")

# Carregar dados
if(file.exists("data/dados_brutos_sih_sul.csv")) {
  df_saude <- read.csv("data/dados_brutos_sih_sul.csv") %>%
    clean_names() # Padroniza nomes de colunas (snake_case)
} else {
  stop("Arquivo de dados brutos SIH não encontrado.")
}

if(file.exists("data/dados_clima_sul.csv")) {
  df_clima <- read.csv("data/dados_clima_sul.csv") %>%
    clean_names()
} else {
  stop("Arquivo de dados climáticos não encontrado.")
}

# Limpeza e Transformação - Saúde
df_saude_limpo <- df_saude %>%
  mutate(
    data_internacao = as.Date(data_internacao),
    ano_mes = floor_date(data_internacao, "month"),
    # Tratar Missing Values
    idade = replace_na(idade, mean(idade, na.rm=TRUE)),
    sexo = ifelse(is.na(sexo), "Desconhecido", sexo)
  ) %>%
  filter(idade >= 0 & idade <= 120) # Remove idades impossíveis

# Agregação por Semana Epidemiológica (padrão em saúde)
df_saude_semanal <- df_saude_limpo %>%
  mutate(semana_epidemio = epiweek(data_internacao),
         ano_epidemio = epiyear(data_internacao)) %>%
  group_by(ano_epidemio, semana_epidemio, uf, tipo_gripe) %>%
  summarise(
    total_casos = n(),
    idade_media = mean(idade, na.rm=TRUE),
    .groups = "drop"
  )

# Salvar dados limpos
write.csv(df_saude_limpo, "data/dados_saude_limpos.csv", row.names = FALSE)
write.csv(df_saude_semanal, "data/dados_saude_semanal.csv", row.names = FALSE)
write.csv(df_clima, "data/dados_clima_limpos.csv", row.names = FALSE)

print("Limpeza concluída. Arquivos salvos em 'data/'.")
