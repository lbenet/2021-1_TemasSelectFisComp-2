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
    Newton, dado un número de iteraciones límite.
    
    (f:: Función de "x", df:: derivada de f(x), x:: Condición inicial ; Tolerancia de la iteración, No. Iteraciones)
"""
function newton(f,df, x; tolerancia, max_iteraciones)
    x0 = x               
    c = 0       
    x1 = 0.0    
    while abs(f(x0)) > tolerancia || c == max_iteraciones
         if df(x0) == 0.0
            break
        else
        x1 = x0 - f(x0)/df(x0)
        x0 = x1
        c = c+1
        end
    end
    @show c
    #println("Se realizarón ", c," interaciones")
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
newton(f,df,4.0, tolerancia = 1e-14, max_iteraciones = 30)

#-
# Corroboramos que en efecto, nos devuelve un valor muy aproximado de la raíz de 2, con 5 iteraciones.
# Verificamos la diferencia entre el valor obtenido con *newton* y la función *sqrt* incluida en Julia.
# La diferencia depende del tamaño del error a considerar.

#-
abs(newton(f,df,4.0, tolerancia = 1e-9, max_iteraciones = 30) - sqrt(2.0))

#-
# Con esto en mano, analicemos el número de pasos realizados, con respecto a $|x_{n}-x^*|$. Para ello,
# realizamos una nueva función llamada *newton!*, donde almacenaremos en 2 arrays declarados globalmente,
# la raíces obtenidas, y la diferencia entre cada valor iterado y la raíz final.

#-
raicesf = Float64[]
Delta = Float64[]


#-
"""
    Función que calcula la raíz de una función usando el método de Newton, con
    un número deiteraciones máximo, almacenando en 2 vectores la raíz por 
    iteración, la diferencia entre la raíz obtenida y la raíz calculada en 
    cada iteración.
    
    (f:: Función de "x", df:: derivada de f(x), x:: Condición inicial, raiz, delta; Tolerancia, Max_iteraciones)
    
    raiz:: raiz es cualquier arreglo de tipo flotante para almacenar las iteraciones
    
    delta:: delta es cualquier arreglo de tipo flotante para almacenar la diferencia
    entre iteraciones consecutivas.
    
"""
function newton!(f,df, x, raiz, delta; tolerancia, max_iteraciones)
    x0 = x               
    c = 0       
    x1 = 0.0    
    while abs(f(x0)) > tolerancia || c == max_iteraciones
        if df(x0) == 0.0
            break
        else
        x1 = x0 - f(x0)/df(x0)
        push!(raiz, x1)
        x0 = x1
        c = c+1
        end
    end
    
    for i in 1:length(raiz) 
    push!(delta, abs(raiz[i] - x1))
    end
    
    @show c
    return x1
end


#-
# Probamos nuestra nueva función, con f y df, y los arrays respectivos.

#-
newton!(f,df,10.0, raicesf, Delta; tolerancia = 1e-9, max_iteraciones = 30)

#-
# Procedemos a graficar el número de pasos vs. las delta de los valores iterados.

#-
using Plots

#-
x = 1.0:7:0
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
rango1 = range(-3.0, step= 0.125, stop = 3)

#-
for i in rango1 #Este bucle varía $x$ de $[-3,3]$ en pasos de 0.125
    push!(raices2,newton(f,df,i, tolerancia = 1e-15, max_iteraciones = 30 ))
end

#-
# Graficamos el rango de condiciones iniciales contra las raíces.

#-
x = rango1
y = raices2
scatter(x, y, yscale = :log10, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3)

#-
# Graficamos ambas raíces para ver con mejor detalle las valores posibles. En la
# gráfica podemos apreciar los valores de cada raíz con su respectiva condición
# inicial, es decir, desde $-3$, pasando por $0$, donde la condición del bucle *while*
# se rompe y no es posible obtener la raíz con esa condición inicial. Veáse que los
# valores con condición negativa nos dan la raíz negativa, y no parecen distinguirse
# entre ellas, también depende como elijamos la tolerancia del método, en este caso,
# 1e-15. Las raíces positivas se corresponden con condiciones inciales positivas
# respectivamente y de igual forma no parecen distintas de sí mismas. Si graficamos
# el valor absoluto de éstas, podrían notarse diferencias casi insignificantes entre
# ellos, aunque son realmente pequeñas que la misma escala de *Plots* no lo permite
# mostrar de forma correcta.

#-
raices2[25] = sqrt(2)

#-
# Insertamos la raíz de 2 en el arreglo de raíces para ver con mejor detalle donde
# está la falla, nótese que al graficar nos arroja un error.

#-
x = rango1
y = abs.(raices2)
scatter(x, y,title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz",fmt = :png )

#-
# Generamos 2 nuevas funciones, $g$ y $dg$, en términos de la misma variable.

#-
g(x) = (x-1)*(x-2)*(x-3)

#-
dg(x) = 3x^2 - 12x + 11

#-
# Declaramos un nuevo array para $g(x)$ donde almacenaremos las raices encontradas.

#-
# Haremos un nuevo rango para correr las condiciones iniciales.

#-
raicesg = Float64[]

#-
# Finalmente, aplicamos la misma fución *newton* a $g$ y $dg$.

#-
rango2 = range(1.0, step= 0.125, stop = 3)

#-
for i in rango2 #Este bucle varía $x$ de $[1,3]$ en pasos de 0.125
    push!(raicesg,newton(g,dg,i, tolerancia = 1e-15, max_iteraciones = 30 ))
end

#-
# Graficamos de igual forma.

#-
x = rango2
y = raicesg
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3, fmt = :png)

#-
# Comparemos con diferentes pasos de la condición inicial

#-
raices2g = Float64[]

#-
rango3 = range(1.0, step= 0.02, stop = 3)

#-
for i in rango3 #Este bucle varía $x$ de $[1,3]$ en pasos de 0.02
    push!(raices2g,newton(g,dg,i, tolerancia = 1e-15, max_iteraciones = 30 ))
end

#-
x = rango3
y = raices2g
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3, fmt = :png)

#-
raices3g = Float64[]

#-
rango4 = range(1.0, step= 0.01, stop = 3)

#-
for i in rango4 #Este bucle varía $x$ de $[1,3]$ en pasos de 0.01
    push!(raices3g,newton(g,dg,i, tolerancia = 1e-15, max_iteraciones = 30 ))
end

#-
x = rango4
y = raices3g
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3, fmt = :png)

#-
# Vemos ahora el comportamiento de las raices alrededor de las singularidades exteriores.

#-
rango5 = range(0, step= 0.01, stop = 2)

#-
raices4g  = Float64[]

#-
for i in rango5 #Este bucle varía $x$ de $[0,2]$ en pasos de 0.01
    push!(raices4g,newton(g,dg,i, tolerancia = 1e-15, max_iteraciones = 30 ))
end

#-
x = rango5
y = raices4g
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3, fmt = :png)

#-
raices5g  = Float64[]

#-
rango6 = range(2, step= 0.01, stop = 4)

#-
for i in rango6 #Este bucle varía $x$ de $[2,4]$ en pasos de 0.01
    push!(raices5g,newton(g,dg,i, tolerancia = 1e-15, max_iteraciones = 30 ))
end

#-
x = rango6
y = raices5g
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3, fmt = :png)

#-
# Por último, veamos que sucede en esos brincos que dan las raíces al ser calculadas en condiciones iniciales dentro del rango de 1.25 a 1.75.

#-
raices6g = Float64[]

#-
for i in 1.25:0.001:1.75 
    push!(raices6g,newton(g,dg,i, tolerancia = 1e-15, max_iteraciones = 30 ))
end

#-
x = 1.25:0.001:1.75 
y = raices6g
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3, fmt = :png)

#-
x = 0.5:0.125:3.5
y = (x.-1).*(x.-2).*(x.-3)
scatter(x,y)

#-
# Podemos analizar primero en la gráfica donde realizamos condicones inciales en
# pasos de $x$ = 0.01, que hay cúmulos de raíces($y$) por ejemplo, cerca de $x$ = 1,
# exceptuando el mismo, y hasta $x$ = 1.42 aproximadamente las raíces caen en 1,
# salvo por pequeños intervalos donde estas toman los valores de las demás, pues,
# apartir de aprox. $x$ = 1.42 la raíz que se obtiene es 3, luego baja a 1 entre
# $x$ = 1.54 y 1.55, para subir la raíz a 2 a partir de estas últimas condiciones.
# Una conclusión no inmediata es que este comportamiento  se debe a que la función
# toma valores particulares en cada valor de $x$ donde nos movemos, como en el caso
# de $f(x)$. Vimos que en el caso de $f(x)$, la raíz dependía de la condición inicial
# tomada, si ésta era negativa, obteniamos la raíz negativa, con $g(x)$ vemos que en
# la gráfica de la misma(la de arriba justamente) los valores que mencionamos que dan
# ese salto, primero se encuentran donde la función alcanza un máximo local, justamente
# antes de $x$ = 1.5 y empiezan a descender a 2, entonces, la raíz obtenida al tomar
# condiciones inciales se acercan a la raíz *mas cercana*, que en ese caso es 2, para
# luego descender a 1, en donde $x$ = 2.5 aproximadamente. Claro, uno esperaría un
# comportamiento mas *suave* en cuanto a la convergencia de las raíces, pero el método
# no lo permite por tener condiciones fijas que nosotros le imponemos, pero podría darse
# un caso donde al variar la tolerancia y el número de iteraciones, podemos lograr un
# comportamiento similar a cuando vimos $f(x)$ , una curva suave que muestre la convergencia
# hacia cada raíz de $g$.