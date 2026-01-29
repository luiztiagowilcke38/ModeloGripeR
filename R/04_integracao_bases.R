
# Modulo 4: Integração de Bases (Merge)
# Autor: Luiz Tiago Wilcke
# Descrição: Unifica as bases de saúde e clima em um único dataset analítico.

library(tidyverse)
library(lubridate)

print("Iniciando integração de bases...")

# Carregar dados limpos
df_saude <- read.csv("data/dados_saude_semanal.csv")
df_clima <- read.csv("data/dados_clima_limpos.csv")

# Preparar Clima para Merge Semanal
df_clima_semanal <- df_clima %>%
  mutate(data = as.Date(data),
         semana_epidemio = epiweek(data),
         ano_epidemio = epiyear(data)) %>%
  group_by(ano_epidemio, semana_epidemio) %>%
  summarise(
    temp_media_semana = mean(temp_media, na.rm=TRUE),
    umidade_media_semana = mean(umidade, na.rm=TRUE),
    .groups = "drop"
  )

# Join (Merge) das bases
# Unimos pela chave temporal (Ano e Semana)
df_integrado <- df_saude %>%
  left_join(df_clima_semanal, by = c("ano_epidemio", "semana_epidemio"))

# Verificação de integridade
colunas_na <- colSums(is.na(df_integrado))
if(any(colunas_na > 0)) {
  print("Aviso: Existem valores ausentes após o merge.")
  print(colunas_na[colunas_na > 0])
  # Imputação simples pela média se necessário
  df_integrado <- df_integrado %>%
    mutate(
      temp_media_semana = ifelse(is.na(temp_media_semana), mean(temp_media_semana, na.rm=TRUE), temp_media_semana),
      umidade_media_semana = ifelse(is.na(umidade_media_semana), mean(umidade_media_semana, na.rm=TRUE), umidade_media_semana)
    )
}

# Salvar dataset final para modelagem
write.csv(df_integrado, "data/dataset_analitico_final.csv", row.names = FALSE)
saveRDS(df_integrado, "data/dataset_analitico_final.rds") # Formato nativo R é mais eficiente

print("Integração concluída. Dataset analítico salvo.")
