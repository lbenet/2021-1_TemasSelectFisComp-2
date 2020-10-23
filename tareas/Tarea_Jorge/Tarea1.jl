# # Tarea 1
# 
# Fecha inicial de entrega (envío del PR): 23 de octubre
# Fecha aceptación del PR: 30 de octubre
# 
# ---

using Pkg; Pkg.activate("../")  # activa el "ambiente" de paquetes usados
##Pkg.instantiate()  # descarga las dependencias de los paquetes


# ## 1
# 
# El método de Newton es un método iterativo para encontrar los ceros, o raíces, 
# de la ecuación $f(x)=0$. Partiendo de una aproximación $x_0$, que debe ser 
# lo suficientemente cercana, y denotando la derivada de $f(x)$ como $f'(x)$, 
# el método de Newton consiste en iterar un número suficiente de veces la ecuación:
# 
# $$
# x_{n+1} = x_n - \frac{f(x_n)}{f'(x_n)} .
# $$
# 
# - Escriban una función (tan genérica como sea posible), que llamaremos `newton` que, 
# a partir de dos funciones de una variable `f` y `fprime`, y de un valor `x0`, obtenga 
# una de las raíces de la ecuación # $f(x)=0$. Comprueben que la función `newton` da 
# resultados correctos para algunos ejemplos concretos, como por ejemplo $f(x)=x^2-2$. 
# (Tengan suficiente cuidado para que no haya ningún tipo de inestabilidad de tipo 
# en su función).
# 
# - Documenten la función de manera adecuada usando 
# [*docstrings*](https://docs.julialang.org/en/v1/manual/documentation/).
# 
# - ¿Cómo se comporta, en términos del número de iterados, la convergencia del 
# método de Newton? Esto es, estudien el comportamiento de $|x_n-x^*|$ en términos
# de $n$, donde $x^*$ es una raíz de $f(x)=0$. Para cuestiones de cómo graficar,
# utilicen la paquetería [Plots.jl](https://github.com/JuliaPlots/Plots.jl).
# 

## Solución a la tarea

#-

# ## 2
# 
# - Usando la función que implementaron en el ejercicio anterior y variando la condición 
# inicial `x0` de -3 a 3 con pasos *suficientemente* pequeños, por ejemplo `0.125`, 
# grafiquen la dependencia de la raíz encontrada en términos de la condición inicial para 
# la función $f(x)=x^2-2$. Para hacer esto, vale la pena que guarden en un vector la raíz 
# obtenida y en otro la condición inicial.
# 
# - Repitan el inciso anterior para $g(x) = (x-1)(x-2)(x-3)$, considerando el intervalo 
# $x_0\in[1,3]$ y varias condiciones iniciales distintas. ¿Qué pueden decir de la dependencia
# del resultado que obtienen de la condición inicial.
# 