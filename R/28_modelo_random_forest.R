
# Modulo 28: Random Forest para Importância de Variáveis
# Autor: Luiz Tiago Wilcke
# Descrição: Identifica quais variáveis (Clima, Semana, Estado) mais impactam nos casos.

library(tidyverse)
library(randomForest)
library(caret)

data <- readRDS("data/dataset_analitico_final.rds")

# Preparar dataset para ML (remover NAs)
df_ml <- data %>%
  select(total_casos, temp_media_semana, umidade_media_semana, ano_epidemio, semana_epidemio, uf) %>%
  na.omit() %>%
  mutate(uf = as.factor(uf))

# Treino RF
set.seed(123)
fit_rf <- randomForest(total_casos ~ ., data = df_ml, ntree = 500, importance = TRUE)

# Importância das Variáveis
imp <- importance(fit_rf)
print(imp)

# Plot Importância
png("output/grafico_importancia_variaveis_rf.png", width=800, height=600)
varImpPlot(fit_rf, main = "Importância das Variáveis - Random Forest")
dev.off()

saveRDS(fit_rf, "data/modelo_random_forest.rds")
print("Módulo 28 concluído.")
