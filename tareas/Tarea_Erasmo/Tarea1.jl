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

using Pkg; Pkg.activate("../")  # activa el "ambiente" de paquetes usados
Pkg.instantiate()  # descarga las dependencias de los paquetes
using Plots

# Solución a la tarea

"""
newton(f, fprime, x0; error = 10^(-6))

Por el método de Newton, encuentra un cero de una función partiendo de una aproximación inicial.

Argumentos:
    f -> función de una varibale a la cual se le buscará una raíz
    fprime -> primera derivada de f
    x0 -> aproximación inicial
    error -> es mayor que |f(x*)|, donde x* es la aproximación final del cero hallado por esta función
"""
function newton(f, fprime, x0; error = 10^(-6))
    x = x0
    
    while abs( f(x) ) > error 
        x = x0 - f(x0) / fprime(x0)
        
        if f(x) == 0
            break
        end
        
        x0 = x
    end
    
    return x
end

"""
convergencia_newton(f, fprime, x0; error = 10^(-6))

Grafica |xn - x*|, donde xn es la n ésima iteración del método de Newton y x* es el cero de f encontrado por este método.

Argumentos:
    f -> función de una varibale a la cual se le buscará una raíz
    fprime -> primera derivada de f
    x0 -> aproximación inicial
    error -> es mayor que |f(x*)|, donde x* es la aproximación final del cero hallado por esta función
"""
function convergencia_newton(f, fprime, x0; error = 10^(-6))
    n = 0
    xn = [x0]
    x = x0
    
    while abs( f(x) ) > error 
        n += 1
        x = x0 - f(x0) / fprime(x0)
        
        if f(x) == 0
            break
        end
        
        x0 = x
        push!(xn, x)
    end
    
    xn = abs.( xn .- x )
    
    display( plot(0:n, xn, label = "|xn - x*|", title = "Convergencia", xlabel = "n") )
    
    return nothing
    
end

f(x) = x^2 - 2
fprime(x) = 2x

newton(f, fprime, 10.0)

convergencia_newton(f, fprime, 10.0)

f(x) = (x - 1) * (x - 2) * (x - 3)
fprime(x) = (x - 2) * (x - 3) + (x - 1) * (x - 3) + (x - 1) * (x - 2)

newton(f, fprime, 10.0)

convergencia_newton(f, fprime, 10.0)

f(x) = cos(x) - sin(x)
fprime(x) = - sin(x) - cos(x)

newton(f, fprime, π / 2)

convergencia_newton(f, fprime, π / 2)

f(x) = ℯ^x - 5x
fprime(x) = ℯ^x - 5

newton(f, fprime, 10.0)

convergencia_newton(f, fprime, 10.0)

#-

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
cond_inicial_newton(f, fprime, x0_min, x0_max; Δx0 = 0.01)

Grafica el cero de una función, encontrado por el método de Newton, en función de la aproximación inicial.

Argumentos:
    f -> función de una varibale a la cual se le buscará una raíz
    fprime -> primera derivada de f
    x0_min -> aproximación inicial mínima
    x0_max -> aproximación inicial máxima
    Δx0 -> tamaño del paso por el cual se recorre el intervalo [x0_min, x0_max]
"""
function cond_inicial_newton(f, fprime, x0_min, x0_max; Δx0 = 0.01)
    x0 = x0_min : Δx0 : x0_max
    newton_aux(x) = newton(f, fprime, x)
    x_raiz = newton_aux.(x0)
    
    display( plot(x0, x_raiz, label = "x*", title = "Raíz", xlabel = "x0") )
end

f(x) = x^2 - 2
fprime(x) = 2x

cond_inicial_newton(f, fprime, -3, 3)

f(x) = (x - 1) * (x - 2) * (x - 3)
fprime(x) = (x - 2) * (x - 3) + (x - 1) * (x - 3) + (x - 1) * (x - 2)

cond_inicial_newton(f, fprime, 1, 3)

newton(f, fprime, 1.5), newton(f, fprime, 2.5)

f(x) = ℯ^x - 5x
fprime(x) = ℯ^x - 5

cond_inicial_newton(f, fprime, 0.0, 3.0)
