
# Modulo 8: Análise Demográfica (Faixa Etária/Sexo)
# Autor: Luiz Tiago Wilcke
# Descrição: Pirâmide etária e distribuição por sexo dos casos.

library(tidyverse)
library(ggplot2)

# Precisamos dos dados originais limpos (por indivíduo) para demografia detalhada
# Se não disponível na memória, carregamos o arquivo csv limpo
df_pacientes <- read.csv("data/dados_saude_limpos.csv")

# Criar faixas etárias
df_pacientes <- df_pacientes %>%
  mutate(faixa_etaria = cut(idade, 
                            breaks = c(0, 10, 20, 30, 40, 50, 60, 70, 80, 120),
                            labels = c("0-9", "10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70-79", "80+"),
                            include.lowest = TRUE))

# Pirâmide Etária
dados_piramide <- df_pacientes %>%
  group_by(faixa_etaria, sexo) %>%
  count() %>%
  ungroup() %>%
  mutate(n = ifelse(sexo == "M", -n, n)) # Inverte lado masculino

p_piramide <- ggplot(dados_piramide, aes(x = faixa_etaria, y = n, fill = sexo)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  scale_y_continuous(labels = abs) + # Mostra valores absolutos
  labs(title = "Perfil Demográfico dos Casos de Gripe",
       x = "Faixa Etária", y = "Número de Casos", fill = "Sexo") +
  theme_minimal() +
  scale_fill_manual(values = c("F"="#E41A1C", "M"="#377EB8"))

ggsave("output/grafico_demografico_piramide.png", plot = p_piramide, width = 8, height = 6)

print("Módulo 8 concluído.")
