# # Derivadas superiores y series de Taylor

#-

# Los ejercicios que aparecen en este notebook se iniciarán en
# clase y constituyen la Tarea3.

#-

# Hasta ahora hemos visto que, usando las técnicas de diferenciación 
# automática, podemos calcular la derivada de funciones de una variable 
# esencialmente con un error del orden del epsilon de la máquina.
# La pregunta que abordaremos ahora, es cómo hacer para calcular la 
# segunda derivada, y derivadas de orden superior.

#-

# Una posibilidad, específica para el caso de la segunda derivada, 
# es proceder como en el caso anterior, es decir, definir una 
# *terna ordenada* donde la primer componente es el valor de la 
# función evaluada en $x_0$, i.e., $f(x_0)$, el de la segunda es el 
# valor de la primer derivada $f'(x_0)$, y la tercer componente 
# tiene el valor de la segunda derivada, $f^{(2)}(x_0) = f''(x_0)$. 

#-

# Con esta definición, las operaciones aritméticas vienen dadas por:
# 
# \begin{eqnarray}
# \vec{u} + \vec{v} & = & (u + v, \quad u'+ v', \quad u''+v''),\\
# \vec{u} - \vec{v} & = & (u - v, \quad u'- v', \quad u''-v''),\\
# \vec{u} \times \vec{v} & = & (u v, \quad u v' + u' v, \quad u v'' + 2 u' v' + u'' v),\\
# \frac{\vec{u}}{\vec{v}} & = & \Big( \frac{u}{v}, \quad \frac{u'-( u/v) v'}{v}, \quad 
# \frac{u'' - 2 (u/v)' v' - (u/v)v'' }{v}\Big).\\
# \end{eqnarray}

#-

# Claramente, este proceso es muy ineficiente para determinar las 
# derivadas de orden aún más alto, dado que las expresiones se complican 
# y es fácil cometer errores.

#-

# ## Series de Taylor

#-

# El punto importante a recordar es que las derivadas de orden superior 
# de una función $f(x)$ en un punto $x_0$ están contenidas en el 
# desarrollo de Taylor de la función cerca de este punto. La suposición 
# importante en esto es que $f(x)$ es suficientemente suave; por 
# simplicidad supondremos que $f(x)$ es ${\cal C}^\infty$ y que 
# estamos suficientemente cerca del punto $x_0$, i.e., $|x-x_0|\ll 1$. 

#-

# La serie de Taylor de $f(x)$ viene dada por
# 
# \begin{eqnarray}
# f(x) & = & f(x_0) + f^{(1)}(x_0) (x-x_0) + \frac{f^{(2)}(x_0)}{2!} (x-x_0)^2 + 
# \dots + \frac{f^{(k)}(x_0)}{k!} (x-x_0)^k + \dots,\\
# & = & f_{[0]} + f_{[1]} (x-x_0) + f_{[2]} (x-x_0)^2 + \dots + 
# f_{[k]} (x-x_0)^k + \dots,\\
# \end{eqnarray}
# 
# donde los coeficientes *normalizados* de Taylor $f_{[k]}$ que 
# aparecen en la segunda línea de la ecuación anterior se definen como
# 
# \begin{equation}
# f_{[k]} = \frac{f^{(k)}(x_0)}{k!} = 
# \frac{1}{k!}\frac{{\rm d}^k f}{{\rm d}x^k}(x_0).
# \end{equation}

#-

# Vale la pena **enfatizar** que la expresión anterior es exacta en 
# tanto que la serie **no** sea truncada. En el caso de que la serie 
# truncada a orden k, el 
# [teorema de Taylor](https://en.wikipedia.org/wiki/Taylor%27s_theorem) 
# asegura que el residuo (error del truncamiento) se puede escribir como:
# 
# \begin{equation}
# {\cal R_{k}} = \frac{f^{(k+1)}\,(\xi)}{(k+1)!} (x-x_0)^{k+1},
# \end{equation}
# 
# donde $\xi$ es un punto que pertenece al intervalo $[x_0,x]$.

#-

# Si la serie es truncada, la aproximación es un polinomio de orden 
# $k$ (grado máximo es $k$) en $x$. Dado que los polinomios en una 
# variable están definidos por $k+1$ coeficientes, entonces pueden 
# ser mapeados a vectores en $\mathbb{R}^{k+1}$. 

#-

# Las operaciones aritméticas, en este caso, vienen dadas por:
# 
# \begin{eqnarray}
# (f+g)_{[k]} & = & f_{[k]} + g_{[k]} ,\\
# (f-g)_{[k]} & = & f_{[k]} - g_{[k]} ,\\
# (f \cdot g)_{[k]} & = & \sum_{i=0}^k f_{[i]} \,g_{[k-i]} \, ,\\
# \Big(\frac{f}{g}\Big)_{[k]} & = & \frac{1}{g_{[0]}}
# \Big( f_{[k]} - \sum_{i=0}^{k-1} \big(\frac{f}{g}\big)_{[i]} \, g_{[k-i]} \Big) . \\
# \end{eqnarray}
# 

#-

# ### Ejercicio 1
# 
# - Implementen una nueva estructura paramétrica (`struct`) que defina 
# el tipo `Taylor`, donde el parámetro debe ser un subtipo de `Number`,
# es decir, lo podremos también usar con complejos y otras cosas más.
# - Definan métodos que implementen las operaciones aritméticas básicas 
# (`+`, `-`, `*`, `/`) y la igualdad (`==`). 
# - Implementen esto en un archivo a parte (`taylor.jl`) como un  
# modulo; revisen el manual en  caso de urgencia.
# - Incluyan pruebas (en un archivo "runtests_taylor.jl") para cada 
# uno de los métodos que implementen.

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

# ## Funciones de polinomios

# El siguiente punto, es cómo definir y calcular funciones (elementales) 
# de polinomios, e.g., $\exp(p(x))$. Como veremos a continuación 
# (*spoiler alert*), esto se basará en plantear una ecuación diferencial 
# apropiada, cuya solución es, precisamente, la expresión que estamos 
# buscando. Este punto es de hecho *muy importante*, y muestra que hay 
# una conexión importante con la solución de ecuaciones diferenciales.

#-

# Como ejemplo consideraremos la función
# 
# \begin{equation}
# E(x) = \exp\big(g(x)\big),
# \end{equation}
# 
# donde 
# 
# \begin{equation}
# g(x) = \sum_{k=0}^\infty g_{[k]} (x-x_0)^k
# \end{equation}
# 
# está escrita como una serie de Taylor (¡exacta!) alrededor de $x_0$. 

#-

# Empezaremos por escribir a $E(x)$ como una serie de Taylor alrededor 
# de $x_0$, es decir,
# 
# \begin{equation}
# E(x) = \sum_{k=0}^\infty E_{[k]} (x-x_0)^k.
# \end{equation}
# 
# El objetivo es determinar los coeficientes  $E_{[k]}$ para *toda* $k$,
# que finalmente representan las derivadas de $E(x)$.

#-

# Dado que $E(x)$ es un polinomio en $x$, su derivada la podemos escribir
# como
# 
# \begin{equation}
# \frac{{\rm d} E(x)}{{\rm d}x} = \sum_{k=1}^\infty k E_{[k]}\, (x-x_0)^{k-1} .
# \end{equation}
# 

#-

# Ahora escribiremos una ecuación diferencial para $E(x)$. En este caso 
# basta y sobra con escribir la derivada de $E(x)$ en términos de $g(x)$, 
# y que viene dada por
# 
# \begin{equation}
# \frac{{\rm d} E(x)}{{\rm d}x} = \exp\big(g(x)\big) \frac{{\rm d} g(x)}{{\rm d}x} = E(x) \frac{{\rm d} g(x)}{{\rm d}x},
# \end{equation}
# 
# donde del lado derecho aparece la derivada de $g(x)$. 

#-

# Ya que $g(x)$ *también* está escrita en forma polinomial, su derivada es
# 
# \begin{equation}
# \frac{{\rm d} g(x)}{{\rm d}x} = \sum_{k=1}^\infty k g_{[k]}\, (x-x_0)^{k-1} .
# \end{equation}
# 

#-

# Con estas ecuaciones tenemos, entonces, todo lo que requerimos para 
# escribir el lado derecho de la ecuación diferencial y explotar la 
# aritmética de polinomios:
# 
# \begin{eqnarray}
# E(x) \frac{{\rm d} g(x)}{{\rm d}x} & = & 
# \Big[ \sum_{k=0}^\infty E_{[k]} (x-x_0)^k \Big]
# \Big[ \sum_{j=1}^\infty j g_{[j]} (x-x_0)^{j-1}\Big] \\
#  & = & \sum_{k=1}^\infty \Big[ \sum_{j=0}^k j 
# g_{[j]} E_{[k-j]} \; \Big] (x-x_0)^{k-1} .\\
# \end{eqnarray}
# 
# La segunda línea (igualdad) se obtiene reordenando los términos al fijar 
# la potencia de $(x-x_0)$, esto es, $k+j$ se toma como un nuevo 
# índice ($k$), y el nuevo índice $j$ describe el índice del 
# producto de los polinomios. (La potencia se deja de la forma $k-1$ 
# ya que el lado izquierdo de la ecuación aparece así.)
# 

#-

# Igualando con el lado izquierdo de la ecuación diferencial, que 
# sólo involucra a la derivada de $E(x)$, tenemos que se debe cumplir
# 
# \begin{equation}
# E_{[k]} = \frac{1}{k} \sum_{j=0}^k j g_{[j]} \, E_{[k-j]} = 
# \frac{1}{k} \sum_{j=0}^{k} (k-j) g_{[k-j]} \, E_{[j]}, \qquad k=1,2,\dots,
# \end{equation}
# 
# con *la condición inicial*
# 
# \begin{equation}
# E_{[0]} = \exp\big(g(x_0)\big).
# \end{equation}
# 
# Estas relaciones *de recurrencia* permiten calcular 
# $\exp\big(g(x)\big)$, para *cualquier* polinomio $g(x)$.
# 

#-

# Como ejemplo sencillo, consideremos el caso concreto $g(x) = x$ 
# alrededor de $x_0=0$. En este caso tenemos $g_{[j]} = \delta_{j,1}$.
# Usando la expresión para la recurrencia obtenida arriba obtenemos
# 
# \begin{eqnarray}
# E_{[0]} & = & 1,\\
# E_{[k]} & = & \frac{1}{k} E_{[k-1]} = \frac{1}{k(k-1)} E_{[k-2]} = 
# \dots = \frac{1}{k!} E_{[0]} = \frac{1}{k!}\ .
# \end{eqnarray}
# 
# Éste es el resultado bien conocido.

#-

# ### Ejercicio 2
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

#-

# ### Ejercicio 3
# 
# Para  las funciones anteriores, incluyendo la exponencial, implementen métodos 
# adecuados para estas funciones en el módulo del ejercicio 1, que deben actuar sobre 
# estructuras `Taylor`, e incluyan pruebas necesarias en `runtest_taylor.jl`.
# 

#-
