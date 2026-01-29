
# Modulo 17: Modelo SIR Básico
# Autor: Luiz Tiago Wilcke
# Descrição: Implementa e resolve as equações diferenciais do modelo Suscetível-Infectado-Recuperado.

library(deSolve)
library(tidyverse)

# Função SIR
sir_model <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    dS <- -beta * S * I
    dI <- beta * S * I - gamma * I
    dR <- gamma * I
    
    return(list(c(dS, dI, dR)))
  })
}

# Parâmetros Iniciais (Simulação)
# População normalizada (S+I+R = 1)
init <- c(S = 0.999, I = 0.001, R = 0.0)

# Parâmetros epidemiológicos (Gripe)
# Beta: Taxa de transmissão
# Gamma: Taxa de recuperação (1/duração da infecção ~ 5 dias -> 1/5 = 0.2)
# R0 = Beta/Gamma. Se R0 de gripe é ~1.3, então Beta ~ 0.26
parameters <- c(beta = 0.26, gamma = 0.2)

# Tempo (dias)
times <- seq(0, 150, by = 1)

# Resolver EDO
out <- ode(y = init, times = times, func = sir_model, parms = parameters)
out_df <- as.data.frame(out)

# Plot
p_sir <- ggplot(out_df, aes(x = time)) +
  geom_line(aes(y = S, color = "Suscetíveis")) +
  geom_line(aes(y = I, color = "Infectados")) +
  geom_line(aes(y = R, color = "Recuperados")) +
  labs(title = "Modelo SIR Básico - Simulação Teórica",
       x = "Tempo (dias)", y = "Proporção da População") +
  theme_minimal() +
  scale_color_manual(values = c("blue", "red", "green"), name = "Compartimento")

ggsave("output/grafico_sir_basico.png", plot = p_sir)
saveRDS(out_df, "data/simulacao_sir.rds")

print("Módulo 17 concluído.")
