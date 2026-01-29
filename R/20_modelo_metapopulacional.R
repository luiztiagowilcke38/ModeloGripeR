
# Modulo 20: Modelo Metapopulacional (Conexão entre Cidades/Regiões)
# Autor: Luiz Tiago Wilcke
# Descrição: Simula a propagação entre patches (cidades) conectados por fluxo de pessoas.

library(deSolve)
library(tidyverse)

# Modelo Metapopulacional para 2 Cidades (A e B)
meta_model <- function(time, state, parameters) {
  # Cidades A e B
  SA <- state[1]; IA <- state[2]; RA <- state[3]
  SB <- state[4]; IB <- state[5]; RB <- state[6]
  
  with(as.list(parameters), {
    # Acoplamento (migração de infectados curto prazo)
    # infection flow from neighbors
    forceA <- beta * IA + alpha * IB # Alpha representa importação de casos de B para A
    forceB <- beta * IB + alpha * IA
    
    dSA <- -forceA * SA
    dIA <- forceA * SA - gamma * IA
    dRA <- gamma * IA
    
    dSB <- -forceB * SB
    dIB <- forceB * SB - gamma * IB
    dRB <- gamma * IB
    
    return(list(c(dSA, dIA, dRA, dSB, dIB, dRB)))
  })
}

# Parâmetros: Alpha indica fluxo entre cidades
parameters <- c(beta = 0.3, gamma = 0.1, alpha = 0.01)

# Cidade A começa com infecção, Cidade B está limpa
init <- c(SA = 0.499, IA = 0.001, RA = 0,
          SB = 0.5, IB = 0, RB = 0)

times <- seq(0, 200, by = 1)
out <- ode(y = init, times = times, func = meta_model, parms = parameters)
out_df <- as.data.frame(out)

p_meta <- ggplot(out_df, aes(x = time)) +
  geom_line(aes(y = IA, color = "Cidade A")) +
  geom_line(aes(y = IB, color = "Cidade B")) +
  labs(title = "Modelo Metapopulacional",
       subtitle = "Propagação da Cidade A para Cidade B devido à mobilidade",
       x = "Dias", y = "Infectados") +
  theme_minimal()

ggsave("output/grafico_metapopulacional.png", plot = p_meta)

print("Módulo 20 concluído.")
