# # Tarea 3
# 
# Fecha inicial de entrega (envío del PR): 30/11/2020
# Fecha aceptación del PR: 11/12/2020
# 
# ---

# ## 1
# 
# - Implementen una nueva estructura paramétrica (`struct`) que defina 
# el tipo `Taylor`, donde el parámetro debe ser un subtipo de `Number`,
# es decir, lo podremos también usar con complejos y otras cosas más.
# 
# - Definan métodos que implementen las operaciones aritméticas básicas 
# (`+`, `-`, `*`, `/`) y la igualdad (`==`). 
# 
# - Implementen esto en un archivo a parte (`taylor.jl`) como un  
# modulo; revisen el manual en  caso de urgencia.
# 
# - Incluyan pruebas (en un archivo "runtests_taylor.jl") para cada 
# uno de los métodos que implementen.
# 
# (Lo que aparece abajo les puede servir como guía; se espera que este ejercicio
# incluya dos archivos extras, además de su resulución de los demás ejercicios.)

include("taylor.jl")
include("runtest_taylor.jl")
#-