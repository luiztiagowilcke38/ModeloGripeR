
# Modulo 19: Modelo SIR Estruturado por Idade
# Autor: Luiz Tiago Wilcke
# Descrição: Simula diferentes taxas de contato entre faixas etárias (Crianças, Adultos, Idosos).

library(deSolve)
library(tidyverse)

# Modelo simplificado com 2 grupos: Jovens (1) e Idosos (2)
age_sir_model <- function(time, state, parameters) {
  # Extrair estados
  S1 <- state[1]; I1 <- state[2]; R1 <- state[3]
  S2 <- state[4]; I2 <- state[5]; R2 <- state[6]
  
  with(as.list(parameters), {
    # Força de infecção para cada grupo (baseada na matriz de contato C)
    lambda1 <- beta * (c11 * I1 + c12 * I2)
    lambda2 <- beta * (c21 * I1 + c22 * I2)
    
    dS1 <- -lambda1 * S1
    dI1 <- lambda1 * S1 - gamma * I1
    dR1 <- gamma * I1
    
    dS2 <- -lambda2 * S2
    dI2 <- lambda2 * S2 - gamma * I2
    dR2 <- gamma * I2
    
    return(list(c(dS1, dI1, dR1, dS2, dI2, dR2)))
  })
}

# Matriz de Contato (Simplificada): Jovens contatam mais todos. Idosos isolados.
# c11 (J-J), c12 (J-I), c21 (I-J), c22 (I-I)
parameters <- c(beta = 0.05, gamma = 0.1, 
                c11 = 10, c12 = 2, 
                c21 = 2, c22 = 4)

# 80% Jovens, 20% Idosos
init <- c(S1 = 0.8, I1 = 0.001, R1 = 0,
          S2 = 0.2, I2 = 0.000, R2 = 0)

times <- seq(0, 100, by = 1)
out <- ode(y = init, times = times, func = age_sir_model, parms = parameters)
out_df <- as.data.frame(out)

p_age <- ggplot(out_df, aes(x = time)) +
  geom_line(aes(y = I1, color = "Jovens (Infectados)")) +
  geom_line(aes(y = I2, color = "Idosos (Infectados)")) +
  labs(title = "Modelo SIR Estruturado por Idade",
       subtitle = "Dinâmica de infecção distinta entre grupos",
       x = "Dias", y = "Proporção Infectada") +
  theme_minimal()

ggsave("output/grafico_sir_etario.png", plot = p_age)

print("Módulo 19 concluído.")
