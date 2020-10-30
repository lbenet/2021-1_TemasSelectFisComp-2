# # Derivación numérica

#-

using Pkg
Pkg.activate("../")

#-
# ## Motivación: el método de Newton
# 
# Un problema común es el de encontrar los ceros de una función. Una situación
# concreta donde esto ocurre es cuando buscamos los máximos o mínimos de una 
# función $f(x)$. Aplicaciones de esto se encuentran en redes neuronales, en
# las que uno *entrena* la red buscando el mínimo de una función de costo.
# 
# Un método común para obtener los ceros de una función es el método de Newton, 
# que requiere evaluar sucesivamente tanto la función $f(x)$ como su derivada 
# $f^\prime(x)$. Si bien uno puede escribir la función $f^\prime(x)$ en un
# programa, uno quisiera tener formas de evaluar la derivada a partir de la 
# propia función $f(x)$, lo que ocurre a menudo en redes neuronales si uno quiere
# introducir nuevas funciones para el entrenamiento de la red. 

# En este notebook estudiaremos algunos algoritmos para obtener *aproximaciones* 
# de las derivadas de una función $f(x)$ numéricamente.

#-

# ## Derivadas numéricas
# 
# ### Derivada *derecha*
# 
# Como bien sabemos del curso de cálculo, la derivada se define como:
# 
# $$
# f^\prime(x0) = \frac{{\rm d}f}{{\rm d}x}(x_0) \equiv \lim_{h\to 0} 
# \frac{f(x_0+h)-f(x_0)}{h}.
# $$
# 
# Numéricamente, es difícil implementar el límite. Olvidándolo por el momento,
# el lado derecho de la definición es relativamente sencillo de implementar 
# numéricamente. Esencialmente requerimos evaluar $f(x)$ en $x_0$ y en $x_0+h$, 
# donde $h$ es un número (de punto flotante) pequeño. La sutileza está entonces 
# en implementar por el límite $h\to 0$.
# 

#-

# #### Ejercicio 1
# 
# - Definan una función `derivada_derecha` que calcule *numéricamente* la 
# derivada de la función $f(x)$, de una variable (a priori arbitaria), en 
# un punto $x_0$. Para esto, utilizaremos la aproximación de la derivada
# que se basa en su definición, *omitiendo* el límite. Esta función entonces
# dependerá de `f`, la función que queremos derivar, `x0` el punto donde queremos
# derivar la función, y `h`, que es el incremento *finito* respecto a $x_0$.
# Es decir, calcularemos la derivada usando la aproximación
# $$ 
# f'(x_0) \approx \frac{\Delta f_+}{\Delta x} \equiv \frac{f(x_0+h)-f(x_0)}{h},
# $$
# Este método se conoce por el nombre de *diferencias finitas*.
# 
# - A fin de simular el $\lim_{h\to 0}$, consideren distintos valores de $h$ 
# cada vez más próximos a cero. Para cada valor de $h$ calculen el error 
# absoluto del cálculo numérico, es decir, la diferencia del valor calculado 
# respecto al valor *exacto*. Ilustren esto con una gráfica del error, 
# para $f(x) = 3x^3-2$, en $x_0=1$. ¿Cuál es el valor de `h` (aproximadamente) 
# donde obtienen el menor error del cálculo?
# 

#-

# ### Derivada *simétrica*
# 
# Una definición alternativa a la dada anteriormente consiste en *simetrizar*
# la ocurrencia de $h$ en la definición. Podemos entonces definir a la derivada
# usando la definición
# 
# $$
# f^\prime(x_0) \equiv \lim_{h\to 0} \frac{f(x_0+h)-f(x_0-h)}{2h}.
# $$
# 

#-

# #### Ejercicio 2
# 
# - Repitan el ejercicio anterior usando como base la definición simétrica de 
# la derivada. Esto es, escriban una función `derivada_simetrica` y estudien
# gráficamente las propiedades de convergencia de este método.
# 
# - ¿Por qué es correcto afirmar que la derivada simétrica resulta en una 
# mejor aproximación que la derivada derecha? Argumenten usando
# consideraciones analíticas.
# 

#-

# ### Derivada de *paso complejo*
# 
# Consideremos la siguiente definición de la derivada, que podemos llamar  *derivada de 
# paso complejo*
# 
# $$
# f^\prime(x_0) \equiv \lim_{h\to 0} \textrm{Im}\left(\frac{f(x_0+i h)}{h}\right),
# $$
# 
# donde $i^2 = -1$, e $\textrm{Im}(x)$ es la parte imaginaria de $x$.

#-

# #### Ejercicio 3
#
# - Argumenten, si es posible de manera analítica, qué motiva definir la derivada así.
# 
# - Escriban una función que implemente la definición anterior, y estudien gráficamente 
# sus propiedades de convergencia.
# 
# - ¿Qué ventajas y desventajas puede tener usar esta definición para calcular
# derivadas? 

#-

# #### Ejercicio 4
# 
# - ¿Cómo afecta usar las distintas definiciones de la derivada al método
# de Newton, esto es, si en lugar de calcular $f^\prime(x)$ a partir de las reglas
# de cálculo, usamos los valores *numéricos* que las funciones anteriores devuelven? 
# Consideren en particular la dependencia de $h$ para las distintas definiciones.
# 

#-