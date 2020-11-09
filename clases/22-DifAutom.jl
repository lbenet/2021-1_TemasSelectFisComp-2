# # Diferenciación automática (o algorítmica)

#-

# Los ejercicios que aparecen en este notebook se iniciarán en
# clase y constituyen la Tarea2.

#-

# ## Motivación
# 
# En la clase anterior, vimos que hay diferentes formas de implementar 
# numéricamente la derivada de una función $f(x)$ en un punto $x_0$ y 
# que éstas dependen de un parámetro $h$, que es la separación entre 
# puntos cercanos.
# Ahí obtuvieron que el error absoluto en términos de $h$, cuando 
# $h\to 0$, tiene un comportamiento distinto según la definición 
# que uno utiliza, y que de hecho puede ser "contaminado" por errores 
# de numéricos.

#-

# Concretamente, obtuvimos que:
# - La "derivada derecha" converge linealmente con $h\to 0$ al valor 
# correcto de la derivada, es decir, el error es proporcional a 
# $\mathcal{O}(h)$. Sin embargo, para valores suficientemente pequeños 
# de $h$, el valor obtenido de la derivada deja de tener sentido ya 
# que se pierde exactitud.
# - La "derivada simétrica" converge cuadráticamente, es decir, el 
# error escala como $\mathcal{O}(h^2)$. Al igual que la derivada derecha, 
# para $h$ suficientemente pequeña los 
# [*errores de cancelación*](https://en.wikipedia.org/wiki/Loss_of_significance)
# debidos a la diferencia y hacen que el resultado pierda sentido.
# - La definición de la "derivada compleja" también converge 
# cuadráticamente. A diferencia de las dos definiciones anteriores no 
# exhibe problemas al considerar valores de $h$ muy pequeños. Esto se 
# debe a que no involucra restas de números muy cercanos, y que dan 
# lugar a errores de cancelación.

#-

# Los puntos anteriores muestran que al implementar un algoritmo 
# numéricamente (usando números de punto flotante u otros con 
# *precisión finita*) es importante la manera en que se hace, 
# respecto a cuestiones de la convergencia y del manejo de errores 
# numéricos. En este sentido, la "derivada compleja" da el resultado 
# que más se acerca al exacto, incluso para valores de $h \sim 10^{-16}$.

#-

# La pregunta es si podemos ir más allá y obtener el valor exacto 
# en un sentido numérico, es decir, usando números de punto flotante,
# y en la medida de lo posible, hacer que esto sea independiente de $h$.
# Esto es, obtener como resultado el valor que más se acerca al valor 
# que se obtendría usando números reales, excepto quizás por cuestiones 
# inevitables de redondeo. Las técnicas que introduciremos se conocen como 
# *diferenciación automática* o *algorítmica*.

# Citando a [wikipedia](https://en.wikipedia.org/wiki/Automatic_differentiation): 
# > ``Automatic differentiation (AD), also called algorithmic 
# > differentiation or computational differentiation, is a set of 
# > techniques to numerically evaluate the derivative of a function 
# > specified by a computer program.''
# 
# Diferenciación automática **no es** diferenciación numérica. Está 
# basada en cálculos numéricos (evaluación de funciones en la computadora), 
# pero **no** usa ninguna de las definiciones basadas een diferencias 
# finitas, como las que vimos la clase anterior.

#-

# ## Analogía con los números complejos

# Para ilustrar cómo funcionan los *números duales*, empezaremos usando 
# el ejemplo de los números complejos: $z = a + \mathrm{i} b$, donde $a$ 
# representa la parte real y $b$ la parte imaginaria del *número* $z$.
# 
# Uno puede definir todas las operaciones aritméticas de la manera 
# natural (a partir de los números reales), manteniendo las expresiones 
# con $\mathrm{i}$ factorizada. En el caso de la multiplicación (y la 
# división) debemos explotar el hecho que $\mathrm{i}^2=-1$.
# 
# De esta manera, para $z = a + \mathrm{i} b$ y $w = c + \mathrm{i} d$, 
# tenemos que, 
# 
# \begin{eqnarray*}
# z + w & = & (a + \mathrm{i} b) + (c + \mathrm{i} d) = (a + c) + \mathrm{i}(b + d),\\
# z \cdot w & = & (a + \mathrm{i} b)\cdot (c + \mathrm{i} d)
#   = ac + \mathrm{i} (ad+bc) + \mathrm{i}^2 b d\\
#  & = & (ac - b d) + \mathrm{i} (ad+bc).
# \end{eqnarray*}
# 
# Por último, vale también la pena recordar que, $\mathbb{C}$ es 
# *isomorfo* a $\mathbb{R}^2$, esto es, uno puede asociar un punto 
# en $\mathbb{C}$ con uno en $\mathbb{R}^2$ de manera unívoca, y 
# visceversa.

#-

# ## Números duales

# De manera análoga a los números complejos, introduciremos un par 
# ordenado que llamaremos *números duales*, donde la primer componente 
# es el valor de una función $f(x)$ evaluada en $x_0$, y la segunda es 
# el valor de su derivada evaluada en el mismo punto. Esto es, definimos 
# a los *duales* como:
# 
# \begin{equation}
# \mathbb{D}f(x_0) = \big( f_0, f'_0\big) = \big( f(x_0), f'(x_0)\big) = 
# f_0 + \epsilon\, f'_0,
# \end{equation}
#
# donde $f_0 = f(x_0)$ y $f'_0=\frac{d f}{d x}(x_0)$ y, en la segunda 
# igualdad, $\epsilon$ sirve para indicar la segunda componente del 
# par ordenado. (En un sentido que se precisará más adelante, $\epsilon$ 
# se comporta de una manera semejante a $\mathrm{i}$ para los números 
# complejos, con diferencias respecto al producto.)
# 
#-
# En particular, para la función constante $f(x)=c$ se debe cumplir 
# que el dual asociado sea $\mathbb{D}{c}(x_0)=(c,0)$, y para la función 
# identidad $f(x)=x$ tendremos $\mathbb{D}{x}(x_0)=(x_0,1)$. Vale la pena 
# enfatizar que la función identidad es precisamente la variable 
# independiente respecto a la que estamos derivando.

#-

# ### Ejercicio 1
# 
# - Implementen una nueva estructura paramétrica (`struct`) que 
# llamaremos `Dual` y que definirá los duales. La estructura deberá 
# ser paramétrica, y el parámetro deberá ser subtipo de `Real`. La 
# parte que identifica a $f_0$ será llamada `fun`, y la correspondiente 
# a $f'_0$ será `der`.
# 
# La definición deberá incluir métodos que sean compatibles con las 
# dos propiedades arriba mencionadas, es decir, que el dual de una 
# constante sea $(c,0)$, y que el de la variable independiente sea 
# $(x_0,1)$. Para lo segundo definiremos una función `dual` con la 
# propiedad mencionada.

#-
# La siguiente celda ayuda en la definición de la estructura `Dual`,
# y la deberán completar de manera apropiada.

"""
   Dual{T<:Real}

Definición de los duales, donde lo campos son:
...
"""
struct Dual{#= código =#}
    #= código =#
end

# - Definan un método que permita la promoción automática cuando 
# las entradas para definir el dual no son del mismo tipo.

# - Definan los métodos apropiados para que el Dual de una 
# constante (`Real`), i.e., `Dual(c)` se comporte como debe, y 
# que la función `dual` represente la función identidad (o 
# variable independiente).

Dual(c::Real) = #= código =#

"""
    dual(x0) -> Dual(x0, 1)

...
"""
function dual(x0)
    #= código =#
end

# - Muestren que su código funciona con tests adecuados para crear 
# duales, para promoverlos, y al definir el dual de un número y 
# `dual` para la variable independiente. Para esto es útil usar la 
# infraestructura que Julia provee; ver 
# https://docs.julialang.org/en/v1/stdlib/Test/#Basic-Unit-Tests

using Test
#= código con los tests =#

#-

# ## Aritmética de duales
# 
# De la definición, y recordando el significado de cada una de las 
# componentes del par doble, tenemos que las operaciones aritméticas 
# quedan definidas por:
# 
# \begin{eqnarray}
#     \mathbb{D}{u} \pm \mathbb{D}{w} &=& \big( u_0 \pm w_0, \, u'_0\pm w'_0 \big),\\
#     \mathbb{D}{u} \times \mathbb{D}{w} &=& \big( u_0 \cdot w_0,\, u_0 w'_0 +  w_0 u'_0 \big),\\
#     \frac{\mathbb{D}{u}}{\mathbb{D}{w}} &=& \big( \frac{u_0}{w_0},\, \frac{ u'_0 - (u_0/w_0)w'_0}{w_0}\big),\\
#     {\mathbb{D}{u}}^\alpha &=& \big( u_0^\alpha,\, \alpha u_0^{\alpha-1} u'_0 \big).\\
# \end{eqnarray}    
# 
# Noten que las dos últimas operaciones son consistentes con $\epsilon^2=0$.
# 
# Además, están los operadores unitarios, que satisfacen:
# 
# \begin{equation}
#    \pm \mathbb{D}{u} = \big(\pm u_0, \pm u'_0 \big).
# \end{equation}

#-

# ### Ejercicio 2
# 
# - Implementen *todas* las operaciones aritméticas definidas arriba; 
# para `^` consideren sólo potencias enteras. 
# Estas operaciones deben incluir las operaciones aritméticas que 
# involucran un número cualquiera (`a :: Real`) y un dual (`b::Dual`), 
# o dos duales. Esto se puede hacer implementando (sobrecargando)
# los métodos específicos para estos casos (¡y que sirven en cualquier 
# órden!). 

import Base: +, -, *, /, ^, ==

#= código =#

#-

# - Implementen la comparación (equivalencia) entre duales (`==`). 

#= código =#

#-

# - Incluyan tests que muestren que cada una de ellas está bien 
# definida, y que sus resultados dan valores consistentes.

#= código con los tests =#

# - Evalúen la función `f(x) = (3x^2-8x+5)/(7x^3-1)` en el dual
# `x₀ = 1 + \epsilon`, que representa la variable independiente
# en el punto $x_0=1$. Rehagan este inciso usando un dual
# en el punto $x_0=1$ usando aritmética de racionales.

#= código con los tests =#

# - Evalúen analíticamente (usando el álgebra  de duales) la 
# función `f(x)` en la variable independiente en $x_0=1$, a fin 
# de verificar que el resultado obtenido es el correcto.

#-

# ### Ejercicio 3
# 
# - Recordando la regla de la cadena, extiendan el uso de `Dual` a 
# las funciones elementales: `sqrt`, `exp`, `log`, `sin`, `cos`,
# `tan`, `asin`, `acos`, `atan`, `sinh`, `cosh`, `tanh`, `asinh`,
# `acosh`, `atanh`.

#= código =#

# - Muestren que su implementación da los resultados que se esperan 
# usando pruebas como hicieron en ejercicios anteriores.

#= código =#

# - Calculen la derivada de $h(x)=\sin(x^3−2/x^6)$ en $x_0=2$. ¿Qué 
# tan preciso es el resultado? (Pueden usar cualquier otra manera 
# de obtener el resultado correcto, sólo tienen que ser claros 
# en la explicación.)

#= código =#

# - Grafiquen, para $x_0\in[1,5]$ la función $h^\prime(x)$.

#= código =#
