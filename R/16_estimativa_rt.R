
# Modulo 16: Estimativa do Número Reprodutivo Efetivo (Rt)
# Autor: Luiz Tiago Wilcke
# Descrição: Calcula o Rt (taxa de contágio) ao longo do tempo usando EpiEstim.

library(tidyverse)

# Tenta carregar EpiEstim
if (!require(EpiEstim)) {
  install.packages("EpiEstim")
  library(EpiEstim)
}

data <- readRDS("data/dataset_analitico_final.rds")

# Preparar dados diários ou semanais para EpiEstim
# O EpiEstim espera um vetor de incidência
dados_incidencia <- data %>%
  group_by(data = as.Date(paste(ano_epidemio, semana_epidemio, 1, sep="-"), format="%Y-%U-%u")) %>%
  summarise(I = sum(total_casos)) %>%
  arrange(data) %>%
  filter(!is.na(data))

# Configuração Intervalo Serial (SI) para Influenza (Aprox. Média 3.6, DP 1.6)
# Fonte: Literatura Epidemiológica
res_rt <- estimate_R(dados_incidencia$I, 
                     method = "parametric_si",
                     config = make_config(list(
                       mean_si = 3.6, 
                       std_si = 1.6)))

# Extrair resultados
rt_df <- res_rt$R
rt_df$data_ref <- dados_incidencia$data[rt_df$t_end]

# Plot
p_rt <- ggplot(rt_df, aes(x = data_ref, y = `Mean(R)`)) +
  geom_line(color = "darkgreen") +
  geom_ribbon(aes(ymin = `Quantile.0.025(R)`, ymax = `Quantile.0.975(R)`), alpha = 0.2, fill = "green") +
  geom_hline(yintercept = 1, linetype = "dashed", color = "red") +
  labs(title = "Número Reprodutivo Efetivo (Rt) - Influenza Sul",
       subtitle = "Rt > 1 indica expansão da epidemia",
       x = "Data", y = "Rt") +
  theme_minimal()

ggsave("output/grafico_rt.png", plot = p_rt, width = 8, height = 5)
saveRDS(res_rt, "data/modelo_rt.rds")

print("Módulo 16 concluído.")
