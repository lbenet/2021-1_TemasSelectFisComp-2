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

"""
Definición de polinomios de Taylor, donde
...
"""
struct Taylor{}
    #código: 
end

#-

import Base: +, -, *, /, ==

#Aqui se implementan los métodos necesarios para cada función

#-

#Muestren que su código funciona con tests adecuados
using Base.Test
include("runtest_taylor.jl")

#-

# ### 2
# 
# Obtengan las relaciones de recurrencia para las funciones 
# -  $L(x) = \log\big(g(x)\big)$,
# - $P_\alpha(x) = \big(g(x)\big)^\alpha$,
# - $S(x) = \sin\big(g(x)\big)$, $C(x) = \cos\big(g(x)\big)$ 
# usando el mismo procedimiento que arriba. 
# Hint: Para el último ejercicio, piensen en las soluciones (independientes)
# de una ecuación diferencial de segundo orden, que deben plantear y resolver.
# 
# (Escriban esto en celdas markdown y usen LaTeX.)
# 

#= Respuestas =#

#-

# ### 3
# 
# Para  las funciones anteriores, incluyendo la exponencial, implementen métodos 
# adecuados para estas funciones en el módulo del ejercicio 1, que deben actuar sobre 
# estructuras `Taylor`, e incluyan pruebas necesarias en `runtest_taylor.jl`.
# 

#= Respuestas =#

#-

