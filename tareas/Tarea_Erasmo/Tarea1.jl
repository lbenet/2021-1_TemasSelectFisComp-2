
# # Tarea 1
#
# Fecha inicial de entrega (envío del PR): 23 de octubre
# Fecha aceptación del PR: 30 de octubre
#
# ---
#
# ## 1
#
# El método de Newton es un método iterativo para encontrar los ceros, o raíces,
# de la ecuación $f(x)=0$. Partiendo de una aproximación $x_0$, que debe ser
# lo suficientemente cercana, y denotando la derivada de $f(x)$ como $f'(x)$,
# el método de Newton consiste en iterar un número suficiente de veces la ecuación:

# $$
# x_{n+1} = x_n - \frac{f(x_n)}{f'(x_n)} .
# $$

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

using Pkg; Pkg.activate("../../")  # activa el "ambiente" de paquetes usados
Pkg.instantiate()  # descarga las dependencias de los paquetes
using Plots
#-

# ## Solución a la tarea

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

Grafica |xn - x*|, donde xn es la n ésima iteración del método de Newton,
partiendo de la aproximación inicial x0. x* es
el cero de f encontrado por este método con una tolerancia de 10^(-15).

Argumentos:
    f -> función de una varibale a la cual se le buscará una raíz
    fprime -> primera derivada de f
    x0 -> aproximación inicial
    x -> solución exacta
    iter -> máximo número de iteraciones a probar
    xscale, yscale -> argumentos de la función plot para el tipo de escala de un eje. Para escala logarítmica
                :log, para escala normal :identity .
"""
function convergencia_newton(f, fprime, x0, x; iter = 10, xscale = :identity, yscale = :identity)
    n = 1:iter
    newton_aux(n) = newton(f, fprime, x0, tol = 0, iter = n)
    xn = newton_aux.(n)
    xn = abs.( xn .- x )

    display( plot(n, xn, xscale = xscale, yscale = yscale, ylabel = "|xn - x*|", key = false, title = "Convergencia", xlabel = "n") )

    return nothing
end
#-

# ### $f(x) = x^2 - 2$

f(x) = x^2 - 2
fprime(x) = 2x
#-

newton(f, fprime, 10.0)
#-

convergencia_newton(f, fprime, 10.0, sqrt(big(2)), iter = 10, yscale = :log10)
#-

# Nótese que la escala del eje $x$ es logarítmica. La convergencia es exponcial
# para las primeras iteraciones.

# ### $f(x) = (x - 1)(x - 2)(x - 3)$

f(x) = (x - 1) * (x - 2) * (x - 3)
fprime(x) = (x - 2) * (x - 3) + (x - 1) * (x - 3) + (x - 1) * (x - 2)
#-

newton(f, fprime, 10.0)
#-

convergencia_newton(f, fprime, 10.0, big(3), iter = 10, yscale = :log10)
#-

# ### $f(x) = \cos x - \sin x$

f(x) = cos(x) - sin(x)
fprime(x) = - sin(x) - cos(x)
#-

newton(f, fprime, π / 2)
#-

convergencia_newton(f, fprime, π / 2, π / big(4), iter = 10, yscale = :log10)
#-

# ## 2

# - Usando la función que implementaron en el ejercicio anterior y variando la condición
# inicial `x0` de -3 a 3 con pasos *suficientemente* pequeños, por ejemplo `0.125`,
# grafiquen la dependencia de la raíz encontrada en términos de la condición inicial para
# la función $f(x)=x^2-2$. Para hacer esto, vale la pena que guarden en un vector la raíz
# obtenida y en otro la condición inicial.
#
# - Repitan el inciso anterior para $g(x) = (x-1)(x-2)(x-3)$, considerando el intervalo
# $x_0\in[1,3]$ y varias condiciones iniciales distintas. ¿Qué pueden decir de la dependencia
# del resultado que obtienen de la condición inicial.

"""
cond_inicial_newton(f, fprime, x0_min, x0_max, Δx0 = 0.01; iter = 10, tol = 10^(-6))

Grafica el cero de una función, encontrado por el método de Newton, en función
de la aproximación inicial.

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
function cond_inicial_newton(f, fprime, x0_min, x0_max, Δx0 = 0.01; iter = 10, tol = 10^(-14))
    x0 = x0_min : Δx0 : x0_max
    newton_aux(x) = newton(f, fprime, x, iter = iter, tol = tol)
    x_raiz = newton_aux.(x0)

    display( scatter(x0, x_raiz, ylabel = "x*", title = "Raíz", xlabel = "x0", ms = 1, key = false) )
end
#-

# ### $f(x) = x^2 - 2$

f(x) = x^2 - 2
fprime(x) = 2x
#-

cond_inicial_newton(f, fprime, -3.0, 3.0)
#-

# La raíz encontrada corresponde a la más cercana a la condición inicial.
# Nótese que en 0 no está definida la raíz porque la derivada de la función es
# cero por lo que la siguiente iteración está indeterminada.
#
# ¿Qué ocurre si se disminuye el tamaño de pasos?

cond_inicial_newton(f, fprime, -0.1, 0.1, 0.001)
#-

# El algoritmo diverge alrededor del 0 porque la sucesión
# $ x_{n+1} = x_n - f(x_n) / f'(x_n) $ diverge para $x_n = 0$. Sin embargo,
# esto ya no se observa si se basa la convergencia en la tolerancia:

cond_inicial_newton(f, fprime, -0.1, 0.1, 0.001, iter = Inf)
#-

# ### $f(x) = (x - 1)(x - 2)(x - 3)$

f(x) = (x - 1) * (x - 2) * (x - 3)
fprime(x) = (x - 2) * (x - 3) + (x - 1) * (x - 3) + (x - 1) * (x - 2)
#-

# En el ejemplo anterior, la derivada de la función se hacía cero en un único
# punto. En esta nueva función, esto ocurre dos veces, uno en el punto
# $ \frac{1}{3} (6 - \sqrt{3}) \approx 1.423 $ y el otro en
# $ \frac{1}{3} (6 + \sqrt{3}) \approx 2.577 $. Por el ejemplo anterior, se sabe
# que la tolerancia es un mejor criterio de convergencia.

cond_inicial_newton(f, fprime, 1.0, 3.0, iter = Inf)
#-

# Se observa algo inesperado ya que, parece ser que hay cuatro puntos de
# discontinuidad, en vez de sólo dos. Nótese que, apesar que 1.5 está
# justo en medio de las raíz 1 y 2, el algoritmo converge a 3, la otra raíz,
# para valores iniciales alrededor de 1.5. Ocurre lo mismo con 2.5 que está en
# medio de 2 y 3 pero que converge a 1:

newton(f, fprime, 1.5), newton(f, fprime, 2.5)
#-

# Se pueden encontrar los puntos de discontinuidad con una función.

"""
discontinuidad_newton(f, fprime, x0_min, x0_max, Δx0 = 0.01; iter = 10,
tol = 10^(-6))

Encuentra los puntos donde el método de Newton cambia de convergencia, que se
observan como puntos de discontinuidad.

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
    intervalos -> arreglo de límites de los intervalos en los que se hayaron las
    raíces. Dos elementos seguidos componen el intervalo en el que se halló la
    raíz correspondiente del arreglo raices.
"""
function discontinuidad_newton(f, fprime, x0_min, x0_max, Δx0 = 0.01; iter = 10, tol = 10^(-16))
    x0 = x0_min : Δx0 : x0_max
    newton_aux(x) = newton(f, fprime, x, iter = iter, tol = tol)
    x_raiz = newton_aux(x0_min)
    raices = Float64[]
    discontinuidades = Float64[]

    for x in x0
        if abs(newton_aux(x) - x_raiz) > tol # Si se cambia de raíz
            x_raiz = newton_aux(x)
            push!(raices, x_raiz) # Se añade la nueva raíz al arreglo
            push!(discontinuidades, x) # Así como la condición inicial para la cual ocurrió el cambio
        end
    end

    return raices, discontinuidades
end
#-

# Los puntos de discontinuidad dependen del paso $\Delta x_0$.
#
# $$\Delta x_0 = 10^{-1}$$

aux = discontinuidad_newton(f, fprime, 1.0, 3.0, 0.1, iter = Inf)
aux[1]
#-

# Para $\Delta x_0 = 0.1$, sólo se encuentran cuatro discontinuidades. Éstas se
# localizan en los siguientes puntos:

aux[2]
#-

# Esto es, para $x_0 < 1.5$, el algoritmo converge a 1:

cond_inicial_newton(f, fprime, -1, 1.5, 0.1 , iter = Inf)
#-

# En este caso, en $x_0 = 1.5$ converge a $3$ y luego converge a $2$:

cond_inicial_newton(f, fprime, 1.2, 1.8, 0.1 , iter = Inf)
#-

# Para $1.6 \leq x_0 < 2.5$, la convergencia es a $2$:

cond_inicial_newton(f, fprime, 1.5, 2.5, 0.1 , iter = Inf)
#-

# En $x_0 = 2.5$ converge a $1$:

cond_inicial_newton(f, fprime, 2.2, 2.8, 0.1 , iter = Inf)
#-

# Finalmente, converge a $3$ para todo $x_0 \geq 2.5$:

cond_inicial_newton(f, fprime, 2.5, 4, 0.1 , iter = Inf)
#-

# $$\Delta x_0 = 10^{-3}$$
#
# Para $\Delta x_0 = 0.001$, se encuentran ocho discontinuidades. Éstas se
# localizan en los siguientes puntos:

discontinuidad_newton(f, fprime, 1.0, 3.0, 0.001, iter = Inf)[2]
#-

cond_inicial_newton(f, fprime, 1, 3, 0.001 , iter = Inf)
#-

# $$\Delta x_0 = 10^{-5}$$
#
# Para $\Delta x_0 = 10^{-5}$, se encuentran catorce discontinuidades. Éstas se
# localizan en los siguientes puntos:

discontinuidad_newton(f, fprime, 1.0, 3.0, 10^(-5), iter = Inf)[2]
#-

cond_inicial_newton(f, fprime, 1, 3, 10^(-5) , iter = Inf)
#-

# Nótese que en la gráfica no se distinguen los catorce puntos de discontinuidad
# por lo próximos que están unos de otros.
# Nótese también que en el primer punto de discontinuidad es
# $ \frac{1}{3} (6 - \sqrt{3}) \approx 1.423 $, mientras que
# el último coincide con $ \frac{1}{3} (6 + \sqrt{3}) \approx 2.577 $,que son
# los dos puntos donde la derivada se anula.
#
# Lo describe la convergencia del algoritmo sin embargo, no explica la
# dependencia del número de discontinuidades con el tamaño de paso. Mucho menos
# se explica cuáles deben de ser lo puntos de discontinuidad y porqué.

# ### $f(x) = \cos x - \sin x$

f(x) = cos(x) - sin(x)
fprime(x) = - sin(x) - cos(x)
#-

cond_inicial_newton(f, fprime, 0.0, 10, 0.01, iter = 1000)
#-

# Para este caso, la convergencia cambia de una manera muy complicada. Se tienen
# puntos de diveregencia, alrededor de los cuales, conforme se itera, el algoritmo
# calcula valores cada vez más alejados a las raíces exactas.

# ### $f(x) = e^x - 5 x$

f(x) = exp(x) - 5x
fprime(x) = exp(x) - 5
#-

cond_inicial_newton(f, fprime, 0.0, 3.0, iter = Inf)
#-

# Nuevamente, como en el primer ejemplo, la convergencia cambia en el punto donde
# la derivada se anula que, en este caso, corresponde a $x_0 = \ln 5 \approx 1.609$.

cond_inicial_newton(f, fprime, 1.609, 1.611, 0.000001, iter = Inf)
#-

# Resulta que el algoritmo regres NaN en todo un intervalo alrededor de $x_0 = 1.61$.

newton(f, fprime, 1.61)
#-
