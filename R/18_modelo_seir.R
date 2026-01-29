
# Modulo 18: Modelo SEIR com Latência
# Autor: Luiz Tiago Wilcke
# Descrição: Modelo Suscetível-Exposto-Infectado-Recuperado.

library(deSolve)
library(tidyverse)

seir_model <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    dS <- -beta * S * I
    dE <- beta * S * I - sigma * E
    dI <- sigma * E - gamma * I
    dR <- gamma * I
    
    return(list(c(dS, dE, dI, dR)))
  })
}

# Parâmetros
# Sigma: Taxa de latência (1/período de incubação ~ 2 dias -> 1/2 = 0.5)
parameters <- c(beta = 0.4, sigma = 0.5, gamma = 0.2)
init <- c(S = 0.999, E = 0.0, I = 0.001, R = 0.0)
times <- seq(0, 150, by = 1)

out <- ode(y = init, times = times, func = seir_model, parms = parameters)
out_df <- as.data.frame(out)

# Transformar para formato longo para plot
out_long <- out_df %>%
  pivot_longer(cols = -time, names_to = "Compartimento", values_to = "Proporcao")

p_seir <- ggplot(out_long, aes(x = time, y = Proporcao, color = Compartimento)) +
  geom_line(size = 1) +
  labs(title = "Modelo SEIR (com Latência)",
       subtitle = "Inclusão do compartimento Exposto (E)",
       x = "Tempo (dias)", y = "Proporção") +
  theme_minimal()

ggsave("output/grafico_seir.png", plot = p_seir)
saveRDS(out_df, "data/simulacao_seir.rds")

print("Módulo 18 concluído.")
