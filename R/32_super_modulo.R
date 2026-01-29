
# Modulo 32: Super Módulo (Orquestrador Geral)
# Autor: Luiz Tiago Wilcke
# Descrição: Executa todo o pipeline do projeto sequencialmente.

print("========================================================")
print(" INICIANDO SUPER MÓDULO - MODELO VÍRUS DA GRIPE (SUL) ")
print(" Autor: Luiz Tiago Wilcke ")
print("========================================================")

# Definir caminho base
setwd("/home/luiztiagow1987/Área de trabalho/ModeloVirusDaGripe")

# Passo 0: Setup
source("R/00_setup.R")

# Lista ordenada de scripts
scripts <- list.files("R", pattern = "\\.R$", full.names = TRUE)
scripts <- scripts[!str_detect(scripts, "00_setup.R")] # Remove setup (já rodou)
scripts <- scripts[!str_detect(scripts, "32_super_modulo.R")] # Remove a si mesmo

# Ordenar númericamente
scripts <- scripts[order(as.numeric(str_extract(basename(scripts), "\\d+")))]

# Execução Sequencial
for (script in scripts) {
  print(paste(">> Executando:", basename(script)))
  tryCatch({
    source(script)
    print(paste(">> Sucesso:", basename(script)))
  }, error = function(e) {
    print(paste(">> FALHA CRÍTICA em", basename(script), ":", e$message))
    # Dependendo da robustez desejada, pode parar ou continuar
    # stop("Execução interrompida.") 
  })
  print("--------------------------------------------------------")
}

print("========================================================")
print(" PROJETO CONCLUÍDO COM SUCESSO ")
print(" Verifique os resultados na pasta 'output/' ")
print("========================================================")
