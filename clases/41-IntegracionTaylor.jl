# # Integración con el método de Taylor

#-

# Aquí veremos un ejemplo sencillo de cómo integrar usando el método de Tayor 
# un problema de valor inicial, o sea, para una ecuación diferencial ordinaria con 
# una condición inicial.

#-

# El punto de partida, y *absolutamente importante* en todo lo que sigue, es el 
# [Teorema Fundamental de las Ecuaciones Diferenciales 
# Ordinarias](https://en.wikipedia.org/wiki/Picard%E2%80%93Lindel%C3%B6f_theorem), (o 
# teorema de existencia y unicidad de las EDOs):

# #### Teorema
# 
# Consideren el problema de valores iniciales 
# 
# \begin{equation}
# y'(t)=f(t,y(t)),\ y(t_0)=y_0.
# \end{equation}
# 
# Suponemos que $f(t,y)$ es Lipschitz uniformemente continua respecto a $y$ (lo que 
# significa que hay una constante, independiente de $t$, que acota $f$ para todo intervalo 
# de su dominio) y continua en $t$. Entonces, para algún valor $\varepsilon > 0$ *existe* 
# una solución *única* $y(t)$ al problema de valor inicial en el intervalo 
# $[t_0-\varepsilon, t_0+\varepsilon]$.
# 
# **Importante:** El teorema establece la existencia y unicidad de la solución en un 
# intervalo de $t$ en torno al valor $t_0$ que especifica la condición inicial. Esto, 
# sin embargo, **no** implica que la solución exista para todo tiempo $t>t_0$.
# 

#-

# ## Un ejemplo sencillo

# El método de Taylor lo describiremos a través de un ejemplo. Concretamente, ilustraremos 
# cómo integrar la ecuación diferencial
# 
# \begin{equation}
# \dot{x} = f(x) = x^2,
# \end{equation}
# 
# con la condición inicial $x(0) = 3$.

#-

# Antes de describir el método de Taylor, vale la pena notar que esta ecuación la podemos 
# resolver analíticamente. La solución, como se puede comprobar rápidamente, es
# 
# \begin{equation}
# x(t) = \frac{3}{1-3t}.
# \end{equation}
# 
# Esta solución muestra que $x(t)$ diverge cuando $t\to 1/3$; esto es un ejemplo de que la 
# solución $x(t)$ **no existe** para $t>1/3$, a partir de la condición inicial $x(0)=3$. 

#-

# El punto importante del comentario anterior es que, sin importar el método de integración, 
# si hiciéramos una integración "larga" usando un *paso de integración constante* (o sea, 
# a partir de $x(t_k)$ obtenemos $x(t_{k+1})$, con 
# $t_{k+1} = t_0 + (k+1)\delta t = t_k + \delta t$, siendo $\delta t$ un valor constante), 
# el método continuará la integración más allá de $t=1/3$, que es hasta donde tiene sentido 
# la solución, a menos de que tengamos la buena fortuna de caer exactamente en $t_n=1/3$. 
# Sin embargo, vale la pena aquí enfatizar que $1/3$ es un número que no se puede 
# representar exactamente como número de punto flotante. 
# 
# Esto es una *advertencia* de que uno debe ser extremandamente cuidadoso si considera 
# pasos de integración constantes. Sin embargo, si tenemos un método de integración con 
# paso adaptativo, hay esperanza de que este problema no ocurra.

#-

# La idea del método de Taylor es construir una solución (*local* en $t$) que aproxime muy 
# bien la solución de la ecuación diferencial en alguna vecindad del punto inicial $t_0$. 
# En particular, escribimos la solución como un polinomio (en torno a $t_0$) de la 
# siguiente manera:
# 
# \begin{equation}
# x(t) = \sum_{k=0}^\infty x_{[k]} (t-t_0)^k,
# \end{equation}
# 
# donde $x_{[k]} = x_{[k]}(t_0)$ es el coeficiente de Taylor normalizado de orden $k$ 
# evaluado en $t_0$, que está relacionado con la $k$-ésima derivada de $x(t)$. Esta 
# solución claramente cumple la condición inicial al imponer que $x_{[0]}(t_0) = x_0$. 
# Excepto por $x_{[0]}(t_0)$, el resto de los coeficientes del desarrollo están 
# aún por determinar, cosa que haremos iterativamente. 
# 
# Empezaremos considerando que $x(t)$ es un polinomio infinito, o sea, construiremos la 
# solución analítica; después entraremos en las sutilezas de tener aproximaciones de 
# orden finito.

#-

# ### Solución a primer orden

#-

# Empezamos escribiendo, como aproximación de primer orden a la solución en la forma 
# 
# \begin{equation}
# x(t) = x_0 + x_{[1]} (t-t_0) + \mathcal{O}((t-t_0)^2),
# \end{equation}
# 
# y buscamos obtener el valor de $x_{[1]}(t_0)$ de tal manera que se satisfaga la ecuación
# diferencial. Derivando ambos lados tenemos que $\dot{x} = x_{[1]}+ \mathcal{O}((t-t_0))$ y, 
# sustituyendo en la ecuación diferencial original obtenemos
# 
# \begin{eqnarray}
# x_{[1]} + \mathcal{O}((t-t_0)) & = & \big[x_0 + x_{[1]} (t-t_0) + \mathcal{O}((t-t_0)^2)\big]^2 \\
# & = & x_0^2 + \mathcal{O}((t-t_0)).
# \end{eqnarray}

# De aquí concluimos que $x_{[1]}=x_0^2$.

#-

# Es importante notar que **no** necesitamos hacer el cálculo explícito del cuadrado 
# de todo el polinomio; en este caso, *únicamente* calculamos (y usamos) el término de 
# orden cero en el lado derecho de la ecuación.

#-

# ### Solución a segundo orden y órdenes mayores

#-

# Siguiendo como antes, para la aproximación a segundo orden escribimos
# 
# \begin{equation}
# x(t) = x_0 + x_0^2 (t-t_0) + x_{[2]}(t-t_0)^2+\mathcal{O}((t-t_0)^3),
# \end{equation}
# 
# donde hemos substituido que $x_{[1]}=x_0^2$, y queremos obtener $x_{[2]}(t_0)$. 
# Nuevamente derivamos; en este caso, la derivada es 
# 
# $$\dot{x} = x_0^2 + 2 x_{[2]}(t-t_0) + \mathcal{O}((t-t_0)^2),$$ 
# 
# y sustituyendo nuevamente en la ecuación diferencial obtenemos
# 
# \begin{eqnarray}
# x_0^2 + 2 x_{[2]}(t-t_0) + \mathcal{O}((t-t_0)^2) & = & 
# \big[x_0 + x_0^2 (t-t_0) + x_{[2]}(t-t_0)^2+\mathcal{O}((t-t_0)^3)\big]^2 \\
# & = & x_0^2 + 2 x_0^3 (t-t_0) + \mathcal{O}((t-t_0)^2).
# \end{eqnarray}
# 
# De aquí obtenemos $x_{[2]}(t_0) = x_0^3$. Nuevamente, vale la pena notar que para el 
# lado derecho de la ecuación sólo hemos calculado hasta primer orden.

#-

# Para órdenes más altos, uno continua el mismo procedimiento:
# 
# $$x(t) = x_0 + x_0^2 (t-t_0) + x_0^3 (t-t_0)^2+ x_{[3]}(t-t_0)^3+\mathcal{O}((t-t_0)^4),$$ 
# 
# y al derivar y substituir en $x^2$, se obtiene $x_{[3]}=x_0^4$. Y así se continua sucesivamente.

#-

# Finalmente, recordando qué es una serie geométrica, se obtiene que
# 
# \begin{eqnarray}
# x(t) & = & x_0 + x_0^2 (t-t_0) + x_0^3 (t-t_0)^2 + x_0^4 (t-t_0)^3 + \dots \\
#      & = & x_0 \big(1 + x_0 (t-t_0) + x_0^2 (t-t_0)^2 + \dots\big) = \frac{x_0}{1-x_0(t-t_0)},\\
# \end{eqnarray}
# 
# que precisamente corresponde al resultado analítico. De la última igualdad podemos ver 
# que $t$ está limitado por $t - t_0 \le 1/x_0 = 1/3$, como se espera.

#-

# Es importante notar que para que la serie converja absolutamente se requiere que los 
# términos sucesivos satisfagan, para $t>t_0$,
# 
# \begin{equation}
# \Big | \frac{ x_{[n]} (t-t_0)^n }{x_{[n+1]} (t-t_0)^{n+1}}\Big| = \frac{1}{|x_0|(t-t_0)} < 1,
# \end{equation}
# 
# lo que define el radio de convergencia en $t$ de la serie.

#-

# ## El método de Taylor

#-

# ### Relaciones de recurrencia de los coeficientes de Taylor

# En general, para una ecuación diferencial $\dot{x} = f(x(t))$ con $x_0=x(t_0)$, 
# uno puede demostrar que los coeficientes $x_{[k]}$ de la solución están dados por
# 
# \begin{equation}
# x_{[k]} = \frac{f_{[k-1]}}{k},
# \end{equation}
# 
# donde los coeficientes $f_{[k]}$ son los coeficientes del desarrollo en serie de 
# Taylor en $t-t_0$ de $f(x(t))$. La demostración consiste simplemente en escribir los 
# polinomios para $x(t)$ y para $f(x(t))$, ambos en términos de la variable independiente 
# $t$, e igualar términos afines según el grado en $t$, dados por la ecuación diferencial 
# en las potencias de $t$.
# 
# La ecuación anterior es una relación de recurrencia para $x_{[k]}$. Es claro que, 
# dado que el lado derecho de la ecuación anterior involucra los coeficientes $f_{[k]}$, 
# uno debe implementar funciones que permitan calcular dichos coeficientes. Eso se
# obtiene desarrollando como lo hicimos el álgebra de polinomios.

#-

# ### Paso de integración

#-

# La implementación de un método como el método de Taylor en la computadora impone 
# truncar el polinomio de Taylor en un grado $p$ finito. Formalmente, escribimos
# 
# \begin{equation}
# x(t) = \sum_{k=0}^p x_{[k]} (t-t_0)^k + \mathcal{R}_{p} ,
# \end{equation}
# 
# donde el *residuo* $\mathcal{R}_{p}$ está dado por
# 
# \begin{equation}
# \mathcal{R}_{p} = x_{[p+1]}(\xi) (t-t_0)^{p+1},
# \end{equation}
# 
# donde $\xi$ es un valor en el intervalo $[t_0, t] $.

#-

# Queremos, entonces, truncar la serie en un $p$ finito *suficientemente grande* de tal 
# manera que el residuo sea pequeño.

#-

# ¿Dónde truncamos? En general esto sólo lo podemos contestar si podemos conocer el 
# residuo (en términos de $p$), cosa que no es sencilla. 
# 
# Es por esto que uno *usa* las propiedades de convergencia de la serie de Taylor para 
# $x(t)$, para $p$ *suficientemente* grande. Si $p$ es suficientemente grande, entonces 
# las correcciones sucesivas serán cada vez menores, ya que la serie converge (gracias 
# al teorema de existencia y unicidad de las ecuaciones diferenciales).

#-

# En particular, para $p$ suficientemente grande tendremos
# 
# \begin{equation}
# \big | x_{[p]} (t-t_0)^p \big | \leq \epsilon,
# \end{equation}
# 
# donde $\epsilon$ es una cota, *suficientemente pequeña*, para *todos* los términos sucesivos.
# 
# De aquí obtenemos una cota para el paso de integración $h=t-t_0$,
# 
# \begin{equation}
# h = t-t_0 \leq \Big(\frac{\epsilon}{\big| x_{[p]}(t_0)\big|}\Big)^{1/p}.
# \end{equation}
# 
# La idea es, entonces, elegir $\epsilon$ para que sea mucho menor que el epsilon 
# de la máquina. 
# 
# El paso de integración obtenido depende de $t_0$; por lo tanto, al hacer la evolución 
# temporal, distintos pasos de integración se irán calculando, por lo que el paso de 
# integración en general no será constante.

#-

# En la práctica, y dado que normalmente uno lidia con ecuaciones de segundo orden, uno 
# considera el menor de los pasos de integración obtenidos considerando usando los dos 
# últimos términos de la serie de Taylor.
# 
# Es *importante* enfatizar que este procedimiento sólo funciona cuando el orden $p$ 
# es suficientemente grande, de tal manera que estamos dentro de la "cola convergente" 
# de la serie.

#-

# ### Sumando la serie

# Una vez que tenemos el paso de integración $h$ queremos sumar la serie para obtener 
# la nueva condición inicial $x(t_1)$ con $t_1 = t_0+h$. Para esto, simplemente 
# debemos sumar la serie
# 
# \begin{equation}
# x(t_1) = x(t_0+h) = \sum_{k=0}^p x_{[k]}(t_0)\, h^k.
# \end{equation}
# 
# Numéricamente, la mejor manera de hacer esto es usando [el método de 
# Horner](https://en.wikipedia.org/wiki/Horner%27s_method). El método de Horner 
# consiste en factorizar de manera apropiada el polinomio, el cual sólo se evalúa a 
# través de productos y sumas (¡sin potencias!). Esto permite, por un lado, minimizar 
# el número de operaciones, y en el caso de series de Taylor de orden suficientemente 
# grande (a fin de estar en la cola convergente), considerar correctamente los términos 
# pequeños.

#-

# Reescribiendo la serie tenemos
# 
# \begin{eqnarray}
# x(t_1) & = & x_0 + x_{[1]} \, h + \dots + x_{[p-1]} \,h^{p-1} + x_{[p]} \, h^p\\
# & = & x_0 + x_{[1]} \, h + \dots + h^{p-1} ( x_{[p-1]} + h x_{[p]} )\\
# & = & x_0 + x_{[1]} \, h + \dots + h^{p-2} ( x_{[p-2]} + h ( x_{[p-1]} + h x_{[p]} ) )\\
# & = & x_0 + h\big( x_{[1]} + h(... + h ( x_{[p-1]} + h x_{[p]} )...\big).
# \end{eqnarray}
# 
# Entonces, consideramos primero (para la suma) el término $x_{[p]}$ y $x_{[p]}$, a partir 
# de los cuales construimos $\tilde{x}_{p-1} = x_{[p-1]} + h x_{[p]}$, 
# y usando $\tilde{x}_{p-1}$ obtenemos $\tilde{x}_{p-2} = x_{[p-2]} + h \tilde{x}_{p-1}$, y así 
# sucesivamente hasta tener $\tilde{x}_0=x(t_1)$, que es el resultado buscado.
# 
# Una vez que hemos obtenido $x(t_1)$, uno utiliza este valor como la nueva condición inicial, 
# y simplemente se iteran los pasos anteriores hasta obtener $x(t_2)$.
# 

#-
