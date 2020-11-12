# # Tarea 1
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

# ## Solución:

#-
# Comenzamos definiendo una función llamada *newton* en la cual, definiremos el método descrito por el mismo nombre:

#-
"""
    Función que calcula la raíz de una función usando el método de 
    Newton, a 30 iteraciones como máximo.
    
    (f:: Función de "x", df:: derivada de f(x), x:: Condición inicial ; Tolerancia de la iteración)
"""
function newton(f,df, x; tolerancia)
    x0 = x               
    c = 0       
    x1 = 0.0    
    while abs(f(x0)) > tolerancia || c == 30
        x1 = x0 - f(x0)/df(x0)
        x0 = x1
        c = c+1
    end
    return x1#, c
end


#-
# Definimos la f y df de prueba:

#- 
f(x) = x^2 -2
#-
df(x) = 2x

#-
# Probamos la funcion *newton* con una condición inicial arbitraria $x_{0}$ = 4 y una tolerancia pequeña.

#-
newton(f,df,4.0, tolerancia = 1e-10)

#-
# Corroboramos que en efecto, nos devuelve un valor muy aproximado de la raíz de 2, con 5 iteraciones.
# Verificamos la diferencia entre el valor obtenido con *newton* y la función *sqrt* incluida en Julia.

#-
abs(newton(f,df,4.0, tolerancia = 1e-8) - sqrt(2))

#-
# Con esto en mano, analicemos el número de pasos realizados, con respecto a $|x_{n-1}-x_n|$. Para ello,
# realizamos una nueva función llamada *newton2*, donde almacenaremos en 3 arrays declarados globalmente,
# la raíces obtenidas, el número de pasos hechos y la diferencia entre cada valor iterado previo y consecutivo.

#-
raicesf = Float64[]
Delta = Float64[]
npasos = Float64[]

#-
"""
    Función que calcula la raíz de una función usando el método de 
    Newton, a 30 iteraciones como máximo, almacenando en 3 vectores la raíz por iteración,
    la diferencia entre cada raíz iterada y el número de iteraciones realizada.
    
    (f:: Función de "x", df:: derivada de f(x), x:: Condición inicial ; Tolerancia , raiz, delta, pasos)
    
    raiz:: raiz es cualquier arreglo de tipo flotante para almacenar las iteraciones
    
    delta:: delta es cualquier arreglo de tipo flotante para almacenar la diferencia
    entre iteraciones consecutivas.
    
    pasos:: pasos es cualquier arreglo de tipo int o flotante para almecenar el número
    de pasos, nada que no pueda generarse por cuenta propia. 

"""
function newton_2(f,df, x, raiz, delta, pasos ; tolerancia)
    x0 = x               
    c = 0       
    x1 = 0.0    
    while abs(f(x0)) > tolerancia || c == 30
        x1 = x0 - f(x0)/df(x0)
        push!(raiz, x1)
        push!(delta, abs(x1 - x0))
        x0 = x1
        c = c+1
        push!(pasos,c)
    end
    return pasos, x1, c
end


#-
# Probamos nuestra nueva función, con f y df, y los arrays respectivos.

#-
newton_2(f,df,10.0, raicesf, Delta, npasos; tolerancia = 1e-9)

#-
# Procedemos a graficar el número de pasos vs. las delta de los valores iterados.

#-
using Plots

#-
x = npasos
y = Delta
scatter(x, y, yscale = :log10, title = "No. pasos vs Delta", xlabel = "Pasos", ylabel = "Delta" , label = "Delta", lw = 3)

#-
# Por lo tanto, garantizamos la convergencia del método para la funcion *f* de forma cuadrática,
# puesto que la diferencia se va haciendo cada vez más pequeña, hasta llegar a cero. La gráfica
# anterior muestra este decaimiento.

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

#- 
# ## Solución:
#- 
# Ahora variaremos la condición inicial utilizada para el método, y pediremos que nos almacene
# en otro nuevo array las raíces generadas para cada condición inicial respectivamente.

#-
raices2 = Float64[]

#-
for i in -3.0:0.125:3.0 #Este bucle varía $x$ de $[-3,3]$ en pasos de 0.125
    push!(raices2,newton(f,df,i, tolerancia = 1e-15 ))
end

#-
# Graficamos entonces las raíces vs. las condiciones iniciales.

#-
x = -3.0:0.125:3.0
y = abs.(raices2)
scatter(x, y, yscale = :log10, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3)

#-
# Graficamos el valor absoluto para ver con mejor detalle la precisión de las raíces obtenidas,
# aunque recordemos, las raíces cuadradas poseen dos valores posibles, sin embargo, con fines prácticos
# consideraremos lo anterior. En la gráfica podemos apreciar los valores de cada raíz con su respectiva
# condición inicial, veáse que sólo 2 de los valores parecen distinguirse de los demás, pues ésto mismo 
# depende de como elijamos la tolerancia del método, en este caso, 1e-15.

#-
# Generamos 2 nuevas funciones, $g$ y $dg$, en términos de la misma variable.

#-
g(x) = (x-1)*(x-2)*(x-3)

#-
dg(x) = 3x^2 - 12x + 11

#-
# Declaramos un nuevo array para $g(x)$ donde almacenaremos las raices encontradas.

#-
# Correremos de igual forma las condiciones iniciales usadas en el caso anterior mediante un *for*.

#-
raicesg = Float64[]

#-
# Finalmente, aplicamos la misma fución *newton3* a $g$ y $dg$.

#-
for i in 1.0:0.0125:3.0 #Este bucle varía $x$ de $[-3,3]$ en pasos de 0.125
    push!(raicesg,newton(g,dg,i, tolerancia = 1e-15 ))
end

#-
# Graficamos de igual forma.

#-
x = 1.0:0.0125:3.0
y = abs.(raicesg)
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3)

#-
# Comparemos con diferentes pasos de la condición inicial

#-
raices2g = Float64[]

#-
for i in 1.0:0.1:3.0 #Este bucle varía $x$ de $[-3,3]$ en pasos de 0.1
    push!(raices2g,newton(g,dg,i, tolerancia = 1e-15 ))
end

#-
x = 1:0.1:3.0
y = abs.(raices2g)
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3)

#-
raices3g = Float64[]

#-
for i in 1.0:0.25:3.0 #Este bucle varía $x$ de $[-3,3]$ en pasos de 0.25
    push!(raices3g,newton(g,dg,i, tolerancia = 1e-15 ))
end

#-
x = 1.0:0.25:3.0
y = abs.(raices3g)
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3)

#-
x = 0.5:0.125:3.5
y = (x.-1).*(x.-2).*(x.-3)
scatter(x,y)

#-
# Si vemos, la función, al ser de 3er grado, tiene 3 raices, en  $1,2$ y $3$, por lo que en los valores respectivos anteriores,
# la función se anulará, dando como resultado la raíz misma generada por la evaluación de la condición inicial, por lo que esos
# valores, no tienen ningún problema la función, pero al dar pasos más refinados, las iteraciones suelen tomar una tendencia hacia
# una raíz que se encuentre más cerca de la condición inicial. Vemos que en el caso de los pasos de $0.0125$, los cúmulos de las 
# raíces se encuentran entre las raíces mismas, y dependiendo de donde se tomen, éstas mismas toman "preferencia", concecuencia del
# método mismo, pues de $1.5-2.5$ la raíz tendencia es $2$, salvo en pequeños casos y el valor $2$ que claro, es una raíz.
