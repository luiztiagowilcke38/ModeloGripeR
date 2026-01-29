
# Modulo 29: Detector de Potencial Pandêmico (Alerta Precoce)
# Autor: Luiz Tiago Wilcke
# Descrição: Sistema de alerta que monitora múltiplos indicadores (Rt, Taxa de Crescimento, Ocupação de Leitos).

library(tidyverse)
library(jsonlite)

# Carrega indicadores gerados anteriormente
# rt_df (M16), anomalias (M10)

# Simulação de leitura de indicadores recentes
rt_atual <- 1.2 # Exemplo: vindo de um arquivo salvo
anomalias_recentes <- 5 # Exemplo
crescimento_casos <- 0.15 # 15% aumento semanal

# Lógica de Alerta
calcular_risco <- function(rt, anomalias, crescimento) {
  pontos <- 0
  if(rt > 1) pontos <- pontos + 2
  if(rt > 1.5) pontos <- pontos + 3
  if(anomalias > 0) pontos <- pontos + 1
  if(crescimento > 0.1) pontos <- pontos + 2
  
  nivel <- case_when(
    pontos >= 5 ~ "CRÍTICO - Potencial Pandêmico Elevado",
    pontos >= 3 ~ "ALERTA - Risco de Surto",
    TRUE ~ "MONITORAMENTO - Situação Controlada"
  )
  return(list(score = pontos, nivel = nivel))
}

alerta <- calcular_risco(rt_atual, anomalias_recentes, crescimento_casos)

# Salvar Relatório de Alerta
alerta_final <- data.frame(
  data = Sys.Date(),
  rt_atual = rt_atual,
  anomalias = anomalias_recentes,
  crescimento = crescimento_casos,
  score_risco = alerta$score,
  nivel_alerta = alerta$nivel
)

write.csv(alerta_final, "output/relatorio_alerta_pandemico.csv", row.names = FALSE)
write_json(alerta_final, "output/alerta.json")

print(paste("Nível de Alerta Atual:", alerta$nivel))
print("Módulo 29 concluído.")
