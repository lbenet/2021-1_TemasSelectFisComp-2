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

# ## Solución:
# 
# Proponemos similar al caso anterior una serie de potencias para cada función.
# 
# ## $L(x) = \log(g(x))$
# 
# Sea
# \begin{equation}
# L(x) = \sum_{k=0}^\infty L_{[k]} (x-x_0)^k.
# \end{equation}
# 
# Al derivar la expresión anterior tenemos
# \begin{equation}
# \frac{{\rm d} L(x)}{{\rm d}x} = \sum_{k=1}^\infty k L_{[k]}\, (x-x_0)^{k-1} .
# \end{equation}
# 
# Y sabemos de antemano la forma de $g(x)$
# \begin{equation}
# g(x) = \sum_{k=0}^\infty g_{[k]} (x-x_0)^k
# \end{equation}
# 
# Si planteamos una ec. dif. similar a la de $Exp(g(x))$
# \begin{equation}
# \sum_{k=0}^\infty (k+1) L_{[k+1]}\, (x-x_0)^k = \frac{{\rm d} L(x)}{{\rm d}x} = \frac{g'(x)}{g(x)} = \sum_{k=0}^\infty \left( \frac{g'}{g} \right)_{[k]} (x-x_0)^k ,
# \end{equation}
# 
# así que
# 
# \begin{equation}
#     L_{[k+1]} = \frac{1}{k+1} \left( \frac{g'}{g} \right)_{[k]} .
# \end{equation}
# 
# Usando la división de polinomios, se tiene que
# 
# \begin{align}
#     \left( \frac{g'}{g} \right)_{[k]} &= \frac{1}{g_{[0]}} \left( g'_{[k]} - \sum_{i=0}^{k-1} \left( \frac{g'}{g} \right)_{[i]} g_{[k-i]} \right) \\
#          &= \frac{1}{g_{[0]}} \left( (k+1)g_{[k+1]} - \sum_{i=0}^{k-1} (i+1) L_{[i+1]} g_{[k-i]} \right) ,
# \end{align}
# 
# donde se usó que $g'_{[k]} = (k+1) g_{[k+1]}$.
# 
# Se tiene entonces que
# 
# \begin{align}
#     L_{[k]} &= \frac{1}{kg_{[0]}} \left( k g_{[k]} - \sum_{i=0}^{k-2} (i+1)L_{[i+1]} g_{[k-1-i]} \right) \\
#     L_{[k]} &= \frac{1}{kg_{[0]}} \left( k g_{[k]} - \sum_{i=1}^{k-1} i L_{[i]} g_{[k-i]} \right) \\
#     \therefore \quad L_{[k]} &= \frac{1}{kg_{[0]}} \left( k g_{[k]} - \sum_{i=0}^{k-1} i L_{[i]} g_{[k-i]} \right) \\
# \end{align}
# 
# donde se hizo un cambio de variable en la suma y se le añadió un término que 
# siempre es cero. Además, la condición inicial es
# 
# \begin{equation}
#     L_{[0]} = \log(g(x_0)) .
# \end{equation}
# 
# A modo de ejemplo, si se tiene $g(x) = 1 + x$, es bien sabido que
# 
# $$ \ln(1+x) = \sum_{n=1}^{\infty} (-1)^{n+1} \frac{1}{n} x^n ,$$
# 
# así que se va a probar que $L_{[k]} = (-1)^{k+1} / k$.
# 
# En este caso, se tiene que $g_{[k]} = \delta_{0k} + \delta_{1k}$. Primero 
# nótese que $L_{[0]} = \ln(g_{[0]}) = 0$. También se tiene que $L_{[1]} = g_{[1]}/g_{[0]} = 1$.
# Mientras que, para $k>1$, $L_{[k]}$ está dada por
# 
# $$ L_{[k]} = - \frac{k-1}{k} L_{[k-1]} ,$$
# 
# de esta forma $L_{[2]} = -1/2$, $L_{[2]} = 1/3$, $L_{[2]} = -1/4$, $L_{[2]} = 1/5$,
# $L_{[k]} = (-1)^{k+1} / k$, que era lo que se quería probar.

# ## $P_\alpha(x) = (g(x))^{\alpha}$
# 
# Sea
# \begin{equation}
# P_{\alpha}(x) = \sum_{k=0}^\infty P_{\alpha[k]} (x-x_0)^k.
# \end{equation}
# 
# Derivando
# \begin{equation}
# \frac{{\rm d} P_{\alpha}(x)}{{\rm d}x} = \sum_{k=1}^\infty k P_{\alpha[k]} (x-x_0)^k.
# \end{equation}
# 
# Planteando la ec. dif. similar al caso anterior tenemos
# \begin{equation}
# \frac{{\rm d} P_{\alpha}(x)}{{\rm d}x} = \alpha (g(x))^{\alpha -1} g'(x)
# \end{equation}
# 
# y siguiendo la recomendación de Luis, al multiplicar ambos miembros de la
# ecuación anterior por $g(x)$ se tiene que
# 
# \begin{equation}
# \sum_{k=0}^\infty (g P'_{\alpha})_{[k]} (x-x_0)^k = g(x) P'_{\alpha}(x) = \alpha g'(x) P_{\alpha}(x) = \alpha \sum_{k=0}^\infty (g' P_{\alpha})_{[k]} (x-x_0)^k ,
# \end{equation}
# 
# por lo que
# \begin{align}
# (g P'_{\alpha})_{[k]} & = \alpha (g' P_{\alpha})_{[k]} \\
# \sum_{i=0}^k P'_{\alpha [i]}g_{[k-i]} & = \alpha \sum_{i=0}^k P_{\alpha [i]}g'_{[k-i]} \\
# \sum_{i=0}^k (i+1)P_{\alpha [i+1]}g_{[k-i]} & = \alpha \sum_{i=0}^k (k-i+1)P_{\alpha [i]}g_{[k-i+1]} \\
# (k+1)g_{|0|}P_{\alpha[k+1]} + \sum_{i=0}^{k-1} (i+1)P_{\alpha [i+1]}g_{[k-i]} & = \alpha(k+1)g_{|k+1|}P_{\alpha[0]} + \alpha \sum_{i=0}^{k-1} (k-i)P_{\alpha [i+1]}g_{[k-i]} ,\\
# \end{align}
# 
# con lo que se obtiene la relación de recurrencia
# 
# \begin{align}
# P_{\alpha [k]} &= \frac{1}{kg_{[0]}} \left( \alpha k P_{\alpha[0]}g_{[k]} + \sum_{i=0}^{k-2} \big[ \alpha(k-i-1) - (i+1) \big] P_{\alpha[i+1]}g_{[k-i-1]} \right) \\
# P_{\alpha [k]} &= \frac{1}{kg_{[0]}} \left( \alpha k P_{\alpha[0]}g_{[k]} + \sum_{i=1}^{k-1} \big[ \alpha (k-i) - i \big] P_{\alpha[i]}g_{[k-i]} \right) \\
# \therefore \quad P_{\alpha [k]} &= \frac{1}{kg_{[0]}} \sum_{i=0}^{k-1} \big[ \alpha (k-i) - i \big] P_{\alpha[i]}g_{[k-i]} , \\
# \end{align}
# 
# con la condición inicial $P_{\alpha[0]} = \big(g(x_0)\big)^{\alpha}$.
# 
# Ahora, la siguiente serie de Taylor es conocida
# 
# $$ \frac{1}{1+x} = \sum_{n=0}^{\infty} (-1)^n x^n. $$
# 
# Si $g(x) = 1+x$, entoces $g_{[k]} = \delta_{0k} + \delta_{1k}$. 
# Tomando además $\alpha = -1$, se tiene que $P_{-1[0]} = 1$.
# Así, para $k>0$ se tiene que
# 
# $$ P_{-1[k]} = \frac{g_1}{g_0} \frac{1+\alpha-k}{k} P_{\alpha [k-1]} = - P_{-1 [k-1]},$$
# 
# por lo tanto $P_{-1[k]} = (-1)^k$, como se quería probar.
 
# ## $S(x) = \sin(g(x)),\, C(x) = \cos(g(x))$
# 
# Ahora, al derivar, se obtiene el siguiente sistema de ecuaciones
# 
# $$ S'(x) = g'(x) C(x), \quad C'(x) = - g'(x) S(x), $$
# 
# que, análogamente a los procedimientos de los incisos anteriores,
# se obtiene que
# 
# $$ S_{[k]} = \frac{1}{k} \sum_{i=0}^{k-1} (k-i) C_{[i]} g_{[k-i]}, \quad C_{[k]} = - \frac{1}{k} \sum_{i=0}^{k-1} (k-i) S_{[i]} g_{[k-i]}, $$
# 
# con las condiciones iniciales $S_{[0]} = \sin(g(x_0))$ y $C_{[0]} = \cos(g(x_0))$.
# 
# Nótese que estas ecuaciones tienen complejidad $\mathcal{O}(k),$
# de forma que resolverlas simultáneamente desde $k=1$ a alguna
# $k$ arbitraria tiene una complejidad $\mathcal{O}(k^2)$.
# 
# Ahora, el sistema de ecuaciones es separable y la solución puede
# escribirse de la siguiente manera:
# 
# $$S_{[k]} = -\frac{1}{k} \sum_{i=0}^{k-1} \left(\frac{k}{i}-1\right) g_{[k-i]} \sum_{j=0}^{i-1} (i-j) S_{[j]} g_{[i-j]},$$
# $$C_{[k]} = -\frac{1}{k} \sum_{i=0}^{k-1} \left(\frac{k}{i}-1\right) g_{[k-i]} \sum_{j=0}^{i-1} (i-j) C_{[j]} g_{[i-j]},$$
# 
# y ahora las condiciones iniciales serían 
# $S_{[0]} = \sin(g(x_0))$ y $S_{[1]} = g'(x_0) \cos(g(x_0))$
# para la primera ecuación y $C_{[0]} = \cos(g(x_0))$ y
# $C_{[1]} = - g'(x_0) \sin(g(x_0))$ para la segunda.
# 
# Este par de ecuaciones son de utilidad teórica, como se
# muestra más adelante, pero no de utilidad práctica ya que
# calcular un coeficiente empleando dichas ecuaciones
# representa una complejidad $\mathcal{O}(k^2)$, por lo que
# calcularlos desde $k=1$ hasta $k$ implica una complejidad
# $\mathcal{O}(k^3)$, lo que lo hace bastantemente más costoso
# que resolver el sistema de forma simultánea.
# 
# Se sabe que
# 
# $$ \sin(x) = \sum_{n=0}^{\infty} \frac{(-1)^{n+1}}{(2n+1)!} x^{2n+1},\quad \cos(x) = \sum_{n=0}^{\infty} \frac{(-1)^{n}}{(2n)!} x^{2n}. $$
# 
# Ahora, si $g(x) = x$, entonce $g_{[k]} = \delta_{1k}$. Sea
# $Y_{[k]}$ tal que
# 
# $$Y_{[k]} = -\frac{1}{k} \sum_{i=0}^{k-1} \left(\frac{k}{i}-1\right) g_{[k-i]} \sum_{j=0}^{i-1} (i-j) Y_{[j]} g_Y{[i-j]},$$
# 
# entonces se tiene que
# 
# \begin{align}
# Y_{[k]} & = -\frac{1}{k} \sum_{i=0}^{k-1} \left(\frac{k}{i}-1\right) Y_{[i-1]} g_{[k-i]} \\
# \therefore \quad Y_{[k]} & = -\frac{1}{k(k-1)} Y_{[k-2]}.
# \end{align}
# 
# Finalmente, $Y = S$ si $Y_{[0]} = 0$ y $Y_{[1]} = 1$.
# De esta forma, de $S_{[0]} = 0$ se sigue trivialmente
# que $S_{[2k]} = 0$. Mientras que de $Y_{[1]} = 1$ se
# sigue que $Y_{[3]} = -1/3!$, $Y_{[5]} = 1/5!$, 
# $Y_{[2k+1]} = (-1)^k/(2k+1)!$.
# 
# Análogamente, $Y = C$ si $C_{[0]} = 1$ y $C_{[1]} = 0$,
# con lo que se obtiene que $C_{[2k]} = (-1)^k/(2k)!$ y
# $C_{[2k+1]} = 0$, que es lo que se quería comprobar.