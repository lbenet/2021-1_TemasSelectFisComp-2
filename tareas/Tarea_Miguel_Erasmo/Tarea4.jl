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
# 
#-

include("taylor.jl")
#-

function coeficientes(f, x0, p)
    polim = [x0]
    
    for i in 1:p
        push!(polim, f(Taylor(polim)).polim[i] / i)
    end
    
    return Taylor(polim)
end
#-

function paso(T::Taylor, ϵ = 10^(-16))
    p = T.orden
    aux = T.polim[p:p+1]
    aux = ϵ * (abs ∘ inv).(aux)
    aux = [aux[i]^(1 / (p-2+i)) for i in 1:2]
    return min(aux...)
end
#-

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

function integrador(f, x0, p, t)
    t1 = 0
    t2 = 0
    T = Taylor(p, [x0])
    
    while t2 < t
        T = coeficientes(f, x0, p)
        h = paso(T)
        x0 = Horner(T, h)
        t1 = t2
        t2 += h
    end
    
    return Horner(T, t - t1)
end
#-

cuadrado(x) = x^2
integrador(cuadrado, 3, 29, 0.5)
#-

using Plots

x(t) = 3 / (1 - 3*t)
error_relativo(t) = abs(1 - integrador(cuadrado, big(3), 29, t) / x(big(t)))

t = 0.001:10^(-3):0.3333
y = error_relativo.(t)

plot(t, y, scale = :log10)
#-

# ## 2
# 
# Repitan el ejercicio anterior, integración de $\dot{x} = x^2$ con la condición 
# inicial $x(0)=3$, usando el 
# método de Runge-Kutta de 4o orden con paso de integración fijo y comparen los 
# resultados del error relativo con los obtenidos con el método de Taylor. 
# 

#-