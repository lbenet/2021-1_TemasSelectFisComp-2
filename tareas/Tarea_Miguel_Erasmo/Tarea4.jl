# # Tarea 4
# 
# Fecha inicial de entrega (envío del PR): 4.01.2021
# Fecha aceptación del PR: 8.01.2021
# 
# ---

# ## 1
# 
# Usando su implementación de polinomios de Taylor, escriban un integrador para la
# ecuación diferencial $\dot{x} = x^2$ con la condición inicial $x(0) = 3$.
# 
# El integrador debe hacer las operaciones necesarias para obtener automáticamente
# los coeficientes $x_{[k]}$, *en cada paso de integración*, a partir de la condición
# inicial "local" (al tiempo de interés). Un requisito básico para que esto
# pueda funcionar es que tengan una implementación de la función
# $P_\alpha(x) = [g(x)]^\alpha$ donde $g(x)$ un polinomio de Taylor, que hicieron
# en la tarea anterior.
# 
# La implementación debe consistir de varias funciones intermedias:
# 
# - Una función donde se calculen los coeficientes $x_{[k]}$ de la expansión. Esta
# función deberá llamar a otra donde se implementan las recurrencias que imponen las
# ecuaciones de movimiento.
# 
# - Una función donde se obtenga el paso de integración $h$ como se describió en las
# notas de la clase, a partir de los dos últimos coeficientes $x_{[k]}$ del desarrollo de
# Taylor.
# 
# - Otra función donde se haga la suma usando el método de Horner.
# 
# - Finalmente, una función que combine las funciones anteriores para hacer la
# integración desde un tiempo inicial (`t0`) a uno final. En este punto,
# *fingiremos ignorancia*, en el sentido de  que el tiempo inicial para el problema es
# 0, y el tiempo final será $0.5$ que está más allá de donde la solución está definida.
# 
# Dado que conocemos la solución analítica de este problema, grafiquen como función
# de $t$ el error relativo de su integrador (respecto al valor del resultado analítico).

include("taylor.jl")
using Plots, LaTeXStrings, .SeriesTaylor
pgfplotsx()
Plots.scalefontsizes(1.3)
#-

"""
Calcula los coeficientes x_k de la serie de Taylor de la solución x.

Argumentos:
    f -> función a la que es igual la derivada de x con respecto del tiempo.
    x0 -> la condición inicial.
    p -> orden de la serie de Taylor.
"""
function coeficientes(f, x0, p)
    polim = [x0]

    for i in 1:p
        push!(polim, f(Taylor(polim)).polim[i] / i)
    end

    return Taylor(polim)
end
#-

"""
Calcula el paso de integración para el método de Taylor tomando en
cuenta el radio de convergencia y los dos últimos coeficientes de
la serie de Taylor de la solución.

Argumentos:
    T -> serie de Taylor.
    ϵ -> cota para el residuo.
"""
function paso(T::Taylor, ϵ)
    p = T.orden
    aux = T.polim[p:p+1]
    aux = ϵ * (abs ∘ inv).(aux)
    aux = [aux[i]^(1 / (p-2+i)) for i in 1:2]
    return min(aux...)
end
#-

"""
Suma un polinomio mediante el método de Horner.

Argumentos:
    T -> serie de Taylor.
    h -> punto en el que se evalúa el polinomio.
"""
function Horner(T::Taylor, h)
    p = T.orden
    polim = T.polim
    suma = polim[p] + h*polim[p+1]

    for i in p-1:-1:1
        suma = polim[i] + h*suma
    end

    return suma
end
#-

"""
Integra una ecuación diferencial ordinaria de primer grado
por el método de Taylor.

Argumentos:
    f -> función a la que es igual la derivada de x con respecto del tiempo.
    x0 -> la condición inicial.tiempo en el que se desea conocer la solución.
    p -> orden de la serie de Taylor.
    t -> tiempo en el que se desea conocer la solución.
    ϵ -> cota para el residuo de una serie de Taylor.
"""
function integrador(f, x0, p, t, ϵ = 10^(-16))
    t1 = zero( typejoin(typeof(x0), typeof(ϵ)) )
    t2 = t1
    T = Taylor(p, [x0])

    while t2 < t
        T = coeficientes(f, x0, p)
        h = paso(T, ϵ)
        x0 = Horner(T, h)
        t1 = t2
        t2 += h
    end

    return Horner(T, t - t1)
end
#-

cuadrado(x) = x^2
integrador(cuadrado, 3, 29, 0.5, )
#-

# Después de hacer la integración de 0 a 0.5, se obtiene que la solución es un
# ``Nan``. Esto se debe a que la solución no está definida para tiempos mayores
# que 1/3. De hecho, la solución numérica se indefine muy cerca del tiempo 1/3:

integrador(cuadrado, 3, 29, 1/3 - 10^(-10)), integrador(cuadrado, 3, 29, 1/3 + 10^(-10))
#-

# Sea $x_{\rm A}$ la solución analítica de una ecuación diferencia y 
# $x_{\rm N}$ la solución numérica hallada por algún método de
# integración, en este caso, el de Taylor. El error relativo $e$ se
# define entonces como 
# 
# $$ e(t) = \left| 1 - \frac{x_{\rm N}(t)}{x_{\rm A}(t)} \right|$$

x(t) = 3 / (1 - 3*t)
error_relativo(x0, t) = abs(1 - x0 / x(t))

Δt = 10^(-5)
t = 0.0:Δt:0.333
y = Float64[]

t0 = 0.0
x0 = 3.0

for τ in t
    x0 = integrador(cuadrado, x0, 29, Δt, 10^(-10))
    push!(y, error_relativo(x0, τ))
end

plot(t, y, yscale = :log10, key = false, title = "Serie de Taylor: error relativo", ylabel = L"e(t)", xlabel = L"t")
#-

# ## 2
# 
# Repitan el ejercicio anterior, integración de $\dot{x} = x^2$ con la condición
# inicial $x(0)=3$, usando el
# método de Runge-Kutta de 4o orden con paso de integración fijo y comparen los
# resultados del error relativo con los obtenidos con el método de Taylor.

# Se tiene una ecuación diferencial de la forma
# 
# $$ \frac{{\rm d} x}{{\rm d} t} = f(x) ,$$
# 
# se tiene entonces que la solución numérica por el método de Runge Kutta está dada por
# 
# $$ x(t_{n+1}) = x(t_{n}) + h K(x_n,\, h), $$
# 
# donde $t_n = t_0 + n h$, $h$ es el paso de integración, $t_0$ es el tiempo inicial
# y $K(x,\, h)$ está dada por
# 
# $$ K(x,\, h) = \frac{1}{6} (k_1 + 2 k_2 + 2 k_3 + k_4) ,$$
# 
# y las $k_i$ están dadas a su vez por
# 
# \begin{align}
#     & k_1(x,\, h) = f(x), & k_2(x, h) = f(x + hk_1/2) \\
#     & k_3(x, h) = f(x + hk_2/2), &k_4(x, h) = f(x + hk_3) .
# \end{align}
# -

"""
Calcula la K(x, h) del método de Runge Kutta.

Argumentos:
    f -> función a la que es igual la derivada de x con respecto del tiempo.
    x -> valor de la solución a la ecuación diferencial.
    h -> paso de integración.
"""
function K(f, x, h)
    k1 = f(x)
    k2 = f(x + h*k1/2)
    k3 = f(x + h*k2/2)
    k4 = f(x + h*k3)
    return (k1 + 2*k2 + 2*k3 + k4)/6
end

"""
Integra una ecuación diferencial ordinaria de primer grado
por el método de Runge Kutta.

Argumentos:
    f -> función a la que es igual la derivada de x con respecto del tiempo.
    x0 -> condición inicial.
    t -> tiempo en el que se desea conocer la solución.
    h -> paso de integración.
"""
function RK4(f, x0, t, h = 10^(-7))
    tiempo = zero(h)
    
    h = t / (ceil(t/h))
    
    for τ in 0:h:t
        x0 += h * K(f, x0, h)
        tiempo += h
    end
    
    return x0
end
#-

RK4(cuadrado, 3, 0.5)
#-

# El método de Runge Kutta arroja ``Inf`` para tiempos que están fuera del intervalo
# de validez de las soluciones, que en este caso es para tiempos mayores que 1/3.
# Esto contrasta con el método de Taylor que arroja ``Nan``. Otra diferencia es que
# Esto se debe a Runge Kutta continúa integrando la solución a pasos constantes, por
# lo que ésta crece indefinidamente, en cuanto el método de Taylor decrece su paso
# para no salirse del intervalo en el que están definidas las soluciones. Cabe mencionar
# que Runge Kutta no arroja ``Inf`` a partir de 1/3 sino que para algún tiempo posterior:

RK4(cuadrado, 3, 1/3 - 10^(-7)), RK4(cuadrado, 3, 1/3 + 10^(-7))
#-

y = Float64[]

t0 = 0.0
x0 = 3.0

for τ in t
    x0 = RK4(cuadrado, x0, Δt)
    push!(y, error_relativo(x0, τ))
end

plot(t, y, yscale = :log10, key = false, title = "Runge Kutta: error relativo", ylabel = L"e(t)", xlabel = L"t")
#-

# En la gráfica anterior se observa una recta entre 0.1 y 0.3. Como la escala es
# semi logarítmica, esto quiere decir que el erro relativo crece exponencialmente
# en dicho intervaol. Por otro lado, la gráfica de error relativo para Taylor
# muestra un crecimiento más rápido que exponencial. Eston no quiere decir que el
# método de Runge Kutta sea más exacto, de hecho el error realtivo de dicho
# método es hasta medio orde de magnitud en este intervalo en cuestión.
# 
# Finalmente, la característica más notable del error relativo para el método de
# Runge Kutta es que toma valores mayores a la unidad en un intervalo a la
# derecha de 0.3 y, de echo, el error relativo tiene un pendiente casi vertical.
# Esto quiere decir la solución numérica de Runge Kutta crece mucho más rápido
# que la solución analítica. Esto no ocurre con el método de Taylor, con lo que
# se concluye que Runge Kutta falla cerca de 1/3.
# -