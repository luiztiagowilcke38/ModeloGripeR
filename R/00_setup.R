
# Modulo 0: Instalação de Pacotes e Configuração Inicial
# Autor: Luiz Tiago Wilcke

# Lista de pacotes necessários
options(repos = c(CRAN = "https://cloud.r-project.org")) # Define espelho CRAN para execução não interativa

pacotes <- c(
  "tidyverse",      # Manipulação de dados e visualização
  "microdatasus",   # Coleta de dados do SUS (se disponível no CRAN ou GitHub)
  "lubridate",      # Manipulação de datas
  "janitor",        # Limpeza de nomes de variáveis
  "sf",             # Dados espaciais
  "spdep",          # Dependência espacial
  "forecast",       # Modelagem de séries temporais
  "prophet",        # Previsão (Facebook Prophet)
  "deSolve",        # Solução de equações diferenciais (SIR/SEIR)
  "caret",          # Machine Learning
  "randomForest",   # Random Forest
  "plotly",         # Gráficos interativos
  "zoo",            # Médias móveis
  "scales",         # Formatação de escalas
  "rnaturalearth"   # Mapas
)

# Função para instalar e carregar pacotes
instalar_e_carregar <- function(pkg){
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# Tenta instalar microdatasus do GitHub se não estiver no CRAN
if (!require("microdatasus")) {
  if (!require("remotes")) install.packages("remotes")
  remotes::install_github("rfsaldanha/microdatasus")
  library(microdatasus)
}

# Aplica a função para os demais pacotes
lapply(pacotes, instalar_e_carregar)

# Configurações globais
options(scipen = 999) # Evita notação científica
dir.create("data", showWarnings = FALSE)
dir.create("output", showWarnings = FALSE)
dir.create("docs", showWarnings = FALSE)

print("Ambiente configurado com sucesso!")
