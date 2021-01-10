# # Tarea 2
# ## *Raúl Jorge Domínguez Vilchis* *Yesenia Sarahi García González*

# ## Derivadas superiores y series de Taylor

# Hasta ahora hemos visto que, usando las técnicas de diferenciación
# automática, podemos calcular la derivada de funciones de una variable
# esencialmente con un error del orden del epsilon de la máquina.
# La pregunta que abordaremos ahora, es cómo hacer para calcular la
# segunda derivada, y derivadas de orden superior.

# Una posibilidad, específica para el caso de la segunda derivada,
# es proceder como en el caso anterior, es decir, definir una
# *terna ordenada* donde la primer componente es el valor de la
# función evaluada en $x_0$, i.e., $f(x_0)$, el de la segunda es el
# valor de la primer derivada $f'(x_0)$, y la tercer componente
# tiene el valor de la segunda derivada, $f^{(2)}(x_0) = f''(x_0)$.

# Con esta definición, las operaciones aritméticas vienen dadas por:
#
# \begin{eqnarray}
# \vec{u} + \vec{v} & = & (u + v, \quad u'+ v', \quad u''+v''),\\
# \vec{u} - \vec{v} & = & (u - v, \quad u'- v', \quad u''-v''),\\
# \vec{u} \times \vec{v} & = & (u v, \quad u v' + u' v, \quad u v'' + 2 u' v' + u'' v),\\
# \frac{\vec{u}}{\vec{v}} & = & \Big( \frac{u}{v}, \quad \frac{u'-( u/v) v'}{v}, \quad
# \frac{u'' - 2 (u/v)' v' - (u/v)v'' }{v}\Big).\\
# \end{eqnarray}
#
# Claramente, este proceso es muy ineficiente para determinar las
# derivadas de orden aún más alto, dado que las expresiones se complican
# y es fácil cometer errores.
#

# ## Series de Taylor

# El punto importante a recordar es que las derivadas de orden superior
#de una función $f(x)$ en un punto $x_0$ están contenidas en el
# desarrollo de Taylor de la función cerca de este punto. La suposición
# importante en esto es que $f(x)$ es suficientemente suave; por
# simplicidad supondremos que $f(x)$ es ${\cal C}^\infty$ y que
# estamos suficientemente cerca del punto $x_0$, i.e., $|x-x_0|\ll 1$.

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

# Si la serie es truncada, la aproximación es un polinomio de orden
# $k$ (grado máximo es $k$) en $x$. Dado que los polinomios en una
# variable están definidos por $k+1$ coeficientes, entonces pueden
# ser mapeados a vectores en $\mathbb{R}^{k+1}$.

# Las operaciones aritméticas, en este caso, vienen dadas por:
#
# \begin{eqnarray}
# (f+g)_{[k]} & = & f_{[k]} + g_{[k]} ,\\
# (f-g)_{[k]} & = & f_{[k]} - g_{[k]} ,\\
# (f \cdot g)_{[k]} & = & \sum_{i=0}^k f_{[i]} \,g_{[k-i]} \, ,\\
# \Big(\frac{f}{g}\Big)_{[k]} & = & \frac{1}{g_{[0]}}
# \Big( f_{[k]} - \sum_{i=0}^{k-1} \big(\frac{f}{g}\big)_{[i]} \, g_{[k-i]} \Big) . \\
# \end{eqnarray}

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

#-

"""
Definición de polinomios de Taylor, donde
...
"""
struct Taylor{}
    #código:
end
#-

#-
import Base: +, -, *, /, ==
#-

#Muestren que su código funciona con tests adecuados
#-
using Base.Test
include("runtest_taylor.jl")
#-


