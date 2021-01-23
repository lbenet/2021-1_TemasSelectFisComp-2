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
# Usando la división de polinomios, se tiene que, para $k=0$
#
# \begin{equation}
#     \left( \frac{g'}{g} \right)_{[0]} = \frac{ g'_{[0]} }{ g_{[0]} } = \frac{ g_{[1]} }{ g_{[0]} } ,
# \end{equation}
#
# mientras que para $k>0$ se tiene la regla de recurrencia
#
# \begin{align}
#     \left( \frac{g'}{g} \right)_{[k]} &= \frac{1}{g_{[0]}} \left( g'_{[k]} - \sum_{i=0}^{k-1} \left( \frac{g'}{g} \right)_{[i]} g_{[k-i]} \right) \\
#          &= \frac{1}{g_{[0]}} \left( (k+1)g_{[k+1]} - \sum_{i=0}^{k-1} (i+1) L_{[i+1]} g_{[k-i]} \right) ,
# \end{align}
#
# donde se usó que $g'_{[k]} = (k+1) g_{[k+1]}$.
#
# Mientras que
#
# Por lo tanto
#
# \begin{align}
#     L_{[1]} &= \frac{ g_{[1]} }{ g_{[0]} }
#     L_{[k]} &= \frac{1}{kg_{[0]}} \left( k g_{[k]} - \sum_{i=0}^{k-2} (i+1)L_{[i+1]} g_{[k-1-i]} \right) ,
# \end{align}
#
# con $k>1$ y con la condición inicial
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

# Sea
# \begin{equation}
# P_{\alpha}(x) = \sum_{k=0}^\infty P_{\alpha[k]} (x-x_0)^k.
# \end{equation}

# Derivando
# \begin{equation}
# \frac{{\rm d} P_{\alpha}(x)}{{\rm d}x} = \sum_{k=1}^\infty k P_{\alpha[k]} (x-x_0)^k.
# \end{equation}

# Planteando la ec. dif. similar al caso anterior tenemos
# \begin{equation}
# \frac{{\rm d} P_{\alpha}(x)}{{\rm d}x} = \alpha (g(x))^{\alpha -1} g'(x)
# \end{equation}

# \begin{equation}
# \sum_{k=1}^\infty k P_{\alpha[k]} (x-x_0)^k = \alpha \left( \sum_{k=0}^\infty g_{[k]} (x-x_0)^k \right)^{\alpha -1} \left( \sum_{k=1}^\infty k g_{[k]}\, (x-x_0)^{k-1} \right)
# \end{equation}
