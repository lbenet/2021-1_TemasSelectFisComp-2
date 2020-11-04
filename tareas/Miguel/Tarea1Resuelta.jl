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
function newton(f,df, x)
    x0 = x               
    c = 0       
    x1 = 0.0    
    while abs(f(x0)) > 0.00001
        x1 = x0 - f(x0)/df(x0)
        x0 = x1
        c = c+1
    end
    return x1, c
end

#-
# $f$:: Función descrita en términos de una variable "x".

# $df$:: Función que describe la primera derivada respectiva de f, en términos de la misma variable "x", y "x" llamaremos arbitratriamente la condición inicial.

# Asignamos a x0 la condición inicial dada, c es el número de iteraciones que realiza el loop "while" para llegar a la raiz de la función y x1 es una varible de tipo
# flotante en donde almacenaremos el resultado de la ecuación que describe el método, declaramos que la condición implique que el valor absoluto de f
# evaluada en el punto iterado sea pequeño y menor a 10^{-5}, así al final sólo pedimos que nos devuelva el valor de la raiz x1 y del número de pasos necesarios.
# Cabe aclarar que ésto solo aplica para funciones "bien comportadas con éste método".

#-
# Definimos la f y df de prueba:

#- 
f(x) = x^2 -2
#-
df(x) = 2x

#-
# Probamos la funcion newton con una condición inicial arbitraria x0 = 4.

#-
newton(f,df,4.0)

#-
# Corroboramos que en efecto, nos devuelve la raiz de 2, con 5 iteraciones.

#-
sqrt(2)

#-
#Con esto en mano, analicemos el número de pasos realizados, con respecto a $|x_{n-1}-x_n|$. Para ello, realizamos una nueva
# función llamada *newton2*, donde almacenaremos en 3 arrays declarados globalmente, la raices obtenidas, el número de pasos
# hechos y la diferencia entre cada valor iterado previo y consecutivo.

#-
raicesf = Float64[]
Delta = Float64[]
npasos = Float64[]

#-
function newton2(f,df, x, raiz, delta, pasos)
    x0 = x
    c = 0
    x1 = 0.0
    while abs(f(x0)) > 0.00005
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

# Nótese que ahora la función pide 3 argumentos más, los arrays van en orden respectivo:
# - raiz es cualquier arreglo de tipo flotante para almacenar las iteraciones.
# - delta es cualquier arreglo de tipo flotante para almacenar la diferencia entre iteraciones consecutivas.
# - pasos es cualquier arreglo de tipo int o flotante para almecenar el número de pasos, nada que no pueda generarse por cuenta propia.

#-
newton(f,df,8.0,raicesf,Delta,npasos)

#-
# Procedemos a graficar el número de pasos vs. las delta de los valores iterados.

#-
using Plots

#-
x = npasos
y = Delta
scatter(x, y, title = "No. pasos vs Delta", xlabel = "Pasos", ylabel = "Delta" , label = "Delta", lw = 3)

#-
# Por lo tanto, garantizamos la convergencia del método para la funcion *f*, puesto que la diferencia se va haciendo cada vez más
# pequeña, hasta llegar a cero.

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
# Haremos una nueva función llamada *newton3*, donde ahora variaremos la condición inicial utilizada para el método, y pediremos
# que nos almacene en otro nuevo arrays las raíces generadas para cada condición inicial respectivamente.

#-
cond1 = [i for i in -3:0.125:3] 

#-
# El arreglo anterior varía $x$ de $[-3,3]$ en pasos de 0.125

function newton3(f,df,cond,raicesf)
    for x in 1:length(cond) 
    x0 = cond[x]
    x1 = 0.0
    while abs(f(x0)) > 0.00005
        x1 = x0 - f(x0)/df(x0)
        x0 = x1
    end
    push!(raicesf,x0)
    end
    return cond, raicesf
end

#-
# Creamos un nuevo array vacío, de lo contrario, al usar uno ya hecho, concatenaríamos los valores almacenados.

#-
raices2f = Float64[]

#-
newton3(f,df,cond1,raices2f)

#-
x = cond1
y = abs.(raices2f)
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3)

#-
# Graficamos el valor absoluto para ver con mejor detalle la precisión de las raíces obtenidas, aunque recordemos, las raices
# cuadradas poseen dos valores posibles, sin embargo, con fines prácticos consideraremos lo anterior. En la gráfica podemos
# apreciar, como, dependiendo de la condición inicial, la raíz adquiere un valor determinado, podríamos decir que los valores con
# mayor población o cercanía entre ellos tengan o no reelevancia, pues, en $-2$ y $2$ , los valores parecen distinguirse de los
# demás, asi como en valores muy cercanos, tal es el caso del $2.125$ y $-2.125$, que son los que más se alejan de la población.

#-
# Generamos 2 nuevas funciones, $g$ y $dg$, en términos de la misma variable.

#-
g(x) = (x-1)*(x-2)*(x-3)

#-
dg(x) = 3x^2 - 12x + 11

#-
# Declaramos los arrays respectivos para éstas funciones, es decir, aquel que contiene las condiciones iniciales y otro que
# almacena las raices encontradas para *g*

#-
cond2 = [i for i in 1:0.125:3] 

#-
raicesg = Float64[]

#-
# Finalmente, aplicamos la misma fución *newton3* a $g$ y $dg$.

#-
newton3(g,dg,cond2,raicesg)

#-
# Graficamos de igual forma.

#-
x = cond2
y = abs.(raicesg)
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3)

#-
# Comparemos con diferentes pasos de la condición inicial

#-
cond3 = [i for i in 1:0.25:3] 

#-
raices2g = Float64[]

#-
newton3(g,dg,cond3,raices2g)

#-
x = cond3
y = abs.(raices2g)
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3)

#-
cond4 = [i for i in 1:0.105:3] 

#-
raices3g = Float64[]

#-
newton3(g,dg,cond4,raices3g)

#-
x = cond4
y = abs.(raices3g)
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3)

#-
x = 0.5:0.125:3.5
y = (x.-1).*(x.-2).*(x.-3)
scatter(x,y)

#-
# Si vemos, la función, al ser de 3er grado, tiene 3 raices, en  $1,2$ y $3$, por lo que en los valores respectivos anteriores,
# la función se anulará, dando como resultado la raíz misma generada por la evaluación de la condición inicial, por lo que esos
# valores, no tiene ningún problema la función, pero al dar pasos más refinados, vemos que la función toma ciertos valores
# curiosos, tal es el caso de los pasos en $0.125$, pues en $1.5$ y $2.5$ pareciera ser que el método no sabe que raiz tomar,
# esperariamos que conforme se aproxime a un valor de raiz, la tendencia de los valores obtenidos se vea explícita, pero parece
# ser que no es el caso, computacionalmente, las iteraciones darán un valor que cumpla la condición respectiva dada, pero esto se
# apega entonces a que condicion le demos para que evalue, puesto que, en ciertos intervalos se llega un valor similar, pero
# conforme estos se alejan, los valores de la raiz toman otra tendencia, por eso vemos "escalones" en la misma gráfica, una
# depencia que debe analizarse con mucho más detalle.

