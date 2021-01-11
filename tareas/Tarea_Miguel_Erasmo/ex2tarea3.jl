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

#-

# Proponemos similar al caso anterior una serie de potencias para cada función.

#-

# ## L(x) = log(g(x))

#-

# Sea 
# \begin{equation}
# L(x) = \sum_{k=0}^\infty L_{[k]} (x-x_0)^k.
# \end{equation}


#-

# Al derivar la expresión anterior tenemos
# \begin{equation}
# \frac{{\rm d} L(x)}{{\rm d}x} = \sum_{k=1}^\infty k L_{[k]}\, (x-x_0)^{k-1} .
# \end{equation}

#- 

# Y sabemos de antemano la forma de $g(x)$
# \begin{equation}
# g(x) = \sum_{k=0}^\infty g_{[k]} (x-x_0)^k
# \end{equation}

#-

# Si planteamos una ec. dif. similar a la de $Exp(g(x))$
# \begin{equation}
# \frac{{\rm d} L(x)}{{\rm d}x} = \frac{g'(x)}{g(x)} = \sum_{k=1}^\infty k L_{[k]}\, (x-x_0)^{k-1} .
# \end{equation}

#-

# Sustituyendo las expresiones de $g(x)$ y $g'(x)$
# \begin{equation}
# \frac{\sum_{k=1}^\infty k g_{[k]}\, (x-x_0)^{k-1}}{ \sum_{k=0}^\infty g_{[k]} (x-x_0)^k}
# = \sum_{k=1}^\infty k L_{[k]}\, (x-x_0)^{k-1} .
# \end{equation}

#-

# Despejando el lado izquierdo tenemos
# \begin{equation}
# \sum_{k=1}^\infty k g_{[k]}\, (x-x_0)^{k-1} = \left( \sum_{k=0}^\infty g_{[k]} (x-x_0)^k \right) \left( \sum_{k=1}^\infty k L_{[k]}\, (x-x_0)^{k-1} \right)
# \end{equation}

#-

# \begin{equation}
# \sum_{k=1}^\infty k g_{[k]}\, (x-x_0)^{k-1} = \left( g_{0} + \sum_{k=1}^\infty g_{[k]} (x-x_0)^k \right) \left( \sum_{k=1}^\infty k L_{[k]}\, (x-x_0)^{k-1} \right)
# \end{equation}

#-

# \begin{equation}
# \sum_{k=1}^\infty k g_{[k]}\, (x-x_0)^{k-1} = \left( \sum_{k=1}^\infty g_{[k]} (x-x_0)^k \right) \left( \sum_{k=1}^\infty k L_{[k]}\, (x-x_0)^{k-1} \right) + g_{0} \left( \sum_{k=1}^\infty k L_{[k]}\, (x-x_0)^{k-1} \right)
# \end{equation}

#- 

# \begin{equation}
# \sum_{k=1}^\infty k g_{[k]}\, (x-x_0)^{k-1} = g_{0} \left( \sum_{k=1}^\infty k L_{[k]}\, (x-x_0)^{k-1} \right) +
# \left( \sum_{k=1}^\infty \left[ \sum_{j=1}^\infty j L_{[j]}\ g_{k-j} \right] (x-x_0)^{k-1} \right) 
# \end{equation}

#-

# ## $P_\alpha(x) = (g(x))^{\alpha}$

#-

# Sea 
# \begin{equation}
# P_{\alpha}(x) = \sum_{k=0}^\infty P_{\alpha[k]} (x-x_0)^k.
# \end{equation}

#-

# Derivando
# \begin{equation}
# \frac{{\rm d} P_{\alpha}(x)}{{\rm d}x} = \sum_{k=1}^\infty k P_{\alpha[k]} (x-x_0)^k.
# \end{equation}

#-

# Planteando la ec. dif. similar al caso anterior tenemos
# \begin{equation}
# \frac{{\rm d} P_{\alpha}(x)}{{\rm d}x} = \alpha (g(x))^{\alpha -1} g'(x) 
# \end{equation}

#- 

# \begin{equation}
# \sum_{k=1}^\infty k P_{\alpha[k]} (x-x_0)^k = \alpha \left( \sum_{k=0}^\infty g_{[k]} (x-x_0)^k \right)^{\alpha -1} \left( \sum_{k=1}^\infty k g_{[k]}\, (x-x_0)^{k-1} \right)
# \end{equation}



