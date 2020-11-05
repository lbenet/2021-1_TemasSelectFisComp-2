# # Tarea 1
# 
# Fecha inicial de entrega (envío del PR): 23 de octubre
# Fecha aceptación del PR: 30 de octubre
# 
# ---

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

using Pkg; Pkg.activate("../../")  # activa el "ambiente" de paquetes usados
Pkg.instantiate()  # descarga las dependencias de los paquetes
using Plots

# Solución a la tarea
#-

"""
newton(f, fprime, x0; iter = 10, tol = 10^(-6))

Por el método de Newton, encuentra un cero de una función partiendo de una 
aproximación inicial.

Argumentos:
    f -> función de una varibale a la cual se le buscará una raíz
    fprime -> primera derivada de f
    x0 -> aproximación inicial
    iter -> número máximo de iteraciones. Si iteraciones = Inf, sólo se toma 
en cuenta la tolerancia, en este caso se debe tener cuidado ya que es posible 
que la función nunca termine.
    tol -> tolerancia mínima. Si tolerancia = 0, sólo se toman en cuenta las 
iteraciones.

Retorno:
    x -> aproximación del cero
"""
function newton(f, fprime, x0; iter = 10, tol = 10^(-6))
    x = x0
    contador = 1
    
    while abs( f(x) ) > tol && contador < iter
        x = x0 - f(x0) / fprime(x0)
        
        if f(x) == 0
            break
        end
        
        x0 = x
        contador += 1
    end
    
    return x
end
#-

"""
convergencia_newton(f, fprime, x0; iter = 10, xscale = :log10, yscale = :identity)

Grafica |xn - x*|, donde xn es la n ésima iteración del método de Newton y x* es 
el cero de f encontrado por este método con una tolerancia de 10^(-15).

Argumentos:
    f -> función de una varibale a la cual se le buscará una raíz
    fprime -> primera derivada de f
    x0 -> aproximación inicial
    iter -> máximo número de iteraciones a probar
    xscale, yscale -> argumentos de la función plot para el tipo de escala de un eje. Para escala logarítmica
                :log, para escala normal :identity .
"""
function convergencia_newton(f, fprime, x0; iter = 10, xscale = :log10, yscale = :identity)
    x = newton(f, fprime, x0, iter = Inf, tol = 10^(-14)) # Aproximación a la raíz
    n = 1:iter
    newton_aux(n) = newton(f, fprime, x0, tol = 0, iter = n)
    xn = newton_aux.(n)
    xn = abs.( xn .- x )
    
    display( plot(n, xn, xscale = xscale, yscale = yscale, label = "|xn - x*|", title = "Convergencia", xlabel = "n") )
    
    return nothing
end
#-

# ### $f(x) = x^2 - 2$

f(x) = x^2 - 2
fprime(x) = 2x
#-

newton(f, fprime, 10.0)
#-

convergencia_newton(f, fprime, 10.0)
#-

# Nótese que la escala del eje $x$ es logarítmica. La convergencia es exponcial
# para las primeras iteraciones.

# ### $f(x) = (x - 1)(x - 2)(x - 3)$

f(x) = (x - 1) * (x - 2) * (x - 3)
fprime(x) = (x - 2) * (x - 3) + (x - 1) * (x - 3) + (x - 1) * (x - 2)
#-

newton(f, fprime, 10.0)
#-

convergencia_newton(f, fprime, 10.0)
#-

# La convergencia es exponcial para las primeras iteraciones.

# ### $f(x) = \cos x - \sin x$

f(x) = cos(x) - sin(x)
fprime(x) = - sin(x) - cos(x)
#-

newton(f, fprime, π / 2)
#-

convergencia_newton(f, fprime, π / 2)
#-

# La convergencia es exponcial para las primeras iteraciones.

# ### $f(x) = e^x - 5 x$

f(x) = ℯ^x - 5x
fprime(x) = ℯ^x - 5
#-

newton(f, fprime, 10.0)
#-

convergencia_newton(f, fprime, 10.0, xscale = :identity)
#-

# Nótese que se adopta la escala normal en el eje $x$. La convergencia es lineal
# para las primeras iteraciones.

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


"""
cond_inicial_newton(f, fprime, x0_min, x0_max, Δx0 = 0.01; iter = 10, tol = 10^(-6))

Grafica el cero de una función, encontrado por el método de Newton, en función de la
aproximación inicial.

Argumentos:
    f -> función de una varibale a la cual se le buscará una raíz
    fprime -> primera derivada de f
    x0_min -> aproximación inicial mínima
    x0_max -> aproximación inicial máxima
    Δx0 -> tamaño del paso por el cual se recorre el intervalo [x0_min, x0_max]
    iter -> argumento de la función newton para el número máximo de iteraciones.
que la función nunca termine.
    tol -> argumento de la función newton para tolerancia mínima.
"""
function cond_inicial_newton(f, fprime, x0_min, x0_max, Δx0 = 0.01; iter = 10, tol = 10^(-6))
    x0 = x0_min : Δx0 : x0_max
    newton_aux(x) = newton(f, fprime, x, iter = iter, tol = tol)
    x_raiz = newton_aux.(x0)
    
    display( scatter(x0, x_raiz, label = "x*", title = "Raíz", xlabel = "x0", ms = 1) )
end
#-

# ### $f(x) = x^2 - 2$

f(x) = x^2 - 2
fprime(x) = 2x
#-

cond_inicial_newton(f, fprime, -3.0, 3.0)
#-

# La raíz encontrada corresponde a la más cercana a la condición inicial. Nótese que
# en 0 no está definida la raíz porque la derivada de la función es cero por lo que
# la siguiente iteración está indeterminada.

# ¿Qué ocurre si se disminuye el tamaño de pasos?

cond_inicial_newton(f, fprime, -0.1, 0.1, 0.001)
#-

# El algoritmo diverge alrededor del 0 porque la sucesión
# $ x_{n+1} = x_n - f(x_n) / f'(x_n) $ diverge para $x_n = 0$. Sin embargo, esto ya
# no se observa si se basa la convergencia en la tolerancia:

cond_inicial_newton(f, fprime, -0.1, 0.1, 0.001, iter = Inf)
#-

# ### $f(x) = (x - 1)(x - 2)(x - 3)$

f(x) = (x - 1) * (x - 2) * (x - 3)
fprime(x) = (x - 2) * (x - 3) + (x - 1) * (x - 3) + (x - 1) * (x - 2)
#-

# En el ejemplo anterior, la función tenía un único punto crítico claramente 
# en cero. En este caso, hay dos puntos críticos, uno en 
# $ \frac{1}{3} (6 - \sqrt{3}) \approx 1.423 $ y el otro en
# $ \frac{1}{3} (6 + \sqrt{3}) \approx 2.577 $. Por el ejemplo anterior, se sabe
# que la tolerancia es un mejor criterio de convergencia.

cond_inicial_newton(f, fprime, 1.0, 3.0, iter = Inf)
#-

# Se observa algo inesperado ya que los resultados no son bien portados en lo que
# parecen ser cuatro puntos, en vez de sólo dos. Nótes que, apesar que 1.5 está
# justo en medio de las raíz 1 y 2, el algoritmo converge a 3, la otra raíz, para
# valores iniciales alrededor de 1.5. Ocurre lo mismo con 2.5 que está en medio de
# 2 y 3 pero que converge a 1:

newton(f, fprime, 1.5), newton(f, fprime, 2.5)
#-

# Se pueden encontrar los intervalos con una función.

"""
intervalos_newton(f, fprime, x0_min, x0_max, Δx0 = 0.01; iter = 10, tol = 10^(-6))

Encuentra los puntos donde el método de Newton cambia de convergencia. Es decir, cuando en vez de encontrar una raíz, encuentra otra. 

Argumentos:
    f -> función de una varibale a la cual se le buscará una raíz
    fprime -> primera derivada de f
    x0_min -> aproximación inicial mínima
    x0_max -> aproximación inicial máxima
    Δx0 -> tamaño del paso por el cual se recorre el intervalo [x0_min, x0_max]
    iter -> argumento de la función newton para el número máximo de iteraciones.
que la función nunca termine.
    tol -> argumento de la función newton para tolerancia mínima.

Retorno:
    raices -> arreglo de raíces en el orden en el que se fueron encontrando.
    intervalos -> arreglo de límites de los intervalos en los que se hayaron las raíces. Dos elementos seguidos componen el intervalo en el que se halló la raíz correspondiente del arreglo raices.
"""
function intervalos_newton(f, fprime, x0_min, x0_max, Δx0 = 0.01; iter = 10, tol = 10^(-6))
    x0 = x0_min : Δx0 : x0_max
    newton_aux(x) = newton(f, fprime, x, iter = iter, tol = tol)
    x_raiz = newton_aux(x0_min)
    raices = []
    intervalos = []
    
    for x in x0
        if abs(newton_aux(x) - x_raiz) > tol
            x_raiz = newton_aux(x)
            push!(raices, x_raiz)
            push!(intervalos, x)
        end
    end
    
    return raices, intervalos
end
#-

aux = intervalos_newton(f, fprime, 1.0, 3.0, 0.001, iter = Inf)
aux[1]
#-

aux[2]
#-

# Esto muestra que, para $x_0 < \frac{1}{3} (6 - \sqrt{3}) \approx$ 1.423, 
# el algoritmo converge a 1. En el intervalo de 1.423 a 1.535, converge a 3,
# despúes vuelve a converger a 1 de 1.535 a 1.550 y nuevamente converge a 3 en
# el pequeño intervalo de 1.550 a 1.553. El algoritmo converge a 2 sólo en el
# intervalo de 1.553 a 2.448. En el intervalo de 2.448 a 2.451 converge a 1,
# despúes converger a 3 en el intervalo de 2.451 a 2.466 y luego vuleve a converger
# a 1 de 2.466 a 2.578. Finalmente, el algoritmo converge a 3 para 
# $x_0 > \frac{1}{3} (6 + \sqrt{3}) \approx$ 2.578.

# Esto describe la convergencia del algoritmo sin embargo, no explica porqué la
# convergencia cambia ocho puntos. Ya se han explicado dos, que se deben a que la
# derivada de la función es cero en ese par de puntos. Intuitivamente, la convergencia
# debe cambiar cerca de 1.5, que es el punto medio de las raíces 1 y 2, pero esto ocurre
# entres puntos cercanos a 1.5, no sólo en uno. Pasa lo mismo cerca de 2.5, el punto
# medio de las raíces 2 y 3.

# ### $f(x) = \cos x - \sin x$

f(x) = cos(x) - sin(x)
fprime(x) = - sin(x) - cos(x)
#-

cond_inicial_newton(f, fprime, 0.0, π / 2.0, 0.001, iter = Inf, tol = 10^(-11))
#-

# Nótese que se converge a la misma raíz que es $\pi / 4$ pero, dependiende del intervalo,
# puede caer más cerca o más lejos y la manera en la que varía es complicada.

# ### $f(x) = e^x - 5 x$

f(x) = ℯ^x - 5x
fprime(x) = ℯ^x - 5
#-

cond_inicial_newton(f, fprime, 0.0, 3.0, iter = Inf)
#-

# Nuevamente, como en el primer ejemplo, la convergencia cambia en punto crítico de la
# función que, en este caso, corresponde a $x_0 = \ln 5 \approx 1.609$.

cond_inicial_newton(f, fprime, 1.609, 1.611, 0.000001, iter = Inf)
#-

# Resulta que el algoritmo regres NaN en todo un intervalo alrededor de $x_0 = 1.61$.

newton(f, fprime, 1.61)
#-
