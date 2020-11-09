# # Tarea 1
# 
# Fecha inicial de entrega (envío del PR): 
# Fecha aceptación del PR: 
# 
# ---

# ## 1
# 
# - Implementen una nueva estructura paramétrica (`struct`) que 
# llamaremos `Dual` y que definirá los duales. La estructura deberá 
# ser paramétrica, y el parámetro deberá ser subtipo de `Real`. La 
# parte que identifica a $f_0$ será llamada `fun`, y la correspondiente 
# a $f'_0$ será `der`.
# 
# - Definan los métodos apropiados para que el Dual de una 
# constante (`Real`), i.e., `Dual(c)` se comporte como debe, y 
# que la función `dual` represente la función identidad (o 
# variable independiente).
# 
# - Muestren que su código funciona con tests adecuados para crear 
# duales, para promoverlos, y al definir el dual de un número y 
# `dual` para la variable independiente. Para esto es útil usar la 
# infraestructura que Julia provee; ver 
# https://docs.julialang.org/en/v1/stdlib/Test/#Basic-Unit-Tests

#= Respuestas =#

#-

# ### 2
# 
# - Implementen *todas* las operaciones aritméticas definidas arriba; 
# para `^` consideren sólo potencias enteras. 
# Estas operaciones deben incluir las operaciones aritméticas que 
# involucran un número cualquiera (`a :: Real`) y un dual (`b::Dual`), 
# o dos duales. Esto se puede hacer implementando (sobrecargando)
# los métodos específicos para estos casos (¡y que sirven en cualquier 
# órden!). 
# 
# - Implementen la comparación (equivalencia) entre duales (`==`). 
# 
# - Incluyan tests que muestren que cada una de ellas está bien 
# definida, y que sus resultados dan valores consistentes.
# 
# - Evalúen la función `f(x) = (3x^2-8x+5)/(7x^3-1)` en el dual
# `x₀ = 1 + \epsilon`, que representa la variable independiente
# en el punto $x_0=1$. Rehagan este inciso usando un dual
# en el punto $x_0=1$ usando aritmética de racionales.
# - Evalúen analíticamente (usando el álgebra  de duales) la 
# función `f(x)` en la variable independiente en $x_0=1$, a fin 
# de verificar que el resultado obtenido es el correcto.

#= Respuestas =#

#-

# ### 3
# 
# - Recordando la regla de la cadena, extiendan el uso de `Dual` a 
# las funciones elementales: `sqrt`, `exp`, `log`, `sin`, `cos`,
# `tan`, `asin`, `acos`, `atan`, `sinh`, `cosh`, `tanh`, `asinh`,
# `acosh`, `atanh`.
# 
# - Muestren que su implementación da los resultados que se esperan 
# usando pruebas como hicieron en ejercicios anteriores.
# 
# - Calculen la derivada de $h(x)=\sin(x^3−2/x^6)$ en $x_0=2$. ¿Qué 
# tan preciso es el resultado? (Pueden usar cualquier otra manera 
# de obtener el resultado correcto, sólo tienen que ser claros 
# en la explicación.)
# 
# - Grafiquen, para $x_0\in[1,5]$ la función $h^\prime(x)$.

#= Respuestas =#

#-

# ### 4
# 
# Argumenten qué podrían hacer para extender la idea de los `Dual` 
# y calcular derivadas aún más altas. (Como ejemplo concreto, consideren 
# el obtener la derivada 18 de funciones como las que hemos usado arriba.)
# 

# = Respuestas (markdown) =

