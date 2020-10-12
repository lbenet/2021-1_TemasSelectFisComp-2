# # Introducción a Julia
# 
# El texto canónico de referencia para cualquier cosa (duda o discusión) 
# relacionada con Julia es la propia 
# [documentación oficial de Julia](https://docs.julialang.org/en/v1/).
#
# ## Asignación de variables
r = 1.0 # Asigna 1.0 a la variable `r`

#-
r  # regresa el valor asignado a `r`

#-
circunferencia = 2 * pi * r
circunferencia

#-
areacirculo = π * r^2 # π se obtiene al hacer \pi<TAB>

#-
areacirculo / circunferencia

#-
esta_clase = "Temas Selectos de Física Computacional 2"  # Una cadena (string)

#-
exp(π)  # funciones elementales

#-
1/2 + 1/3  # operaciones típicas

#-
1//2 # número racional

#-
1//2 + 1//3  # operaciones con números racionales

#-
1//2 + 1/3  # suma un racional y un número de punto flotante

#-
sqrt(-1.0)  # devuelve un error; vale la pena tratar de entenderlo!

#-
ii = sqrt(Complex(-1.0)) # existen número complejos

#-
cmplx = complex(1.0, 3.2) # Esto es equivalente a `1.0 + 3.2*im`

#-
ii^2 # las potencias son con `^`

#-
π # pi como "irracional"

#-
1.0 * π # pi como número de punto flotante

#-
big(1.0) # números de precisión extendida

#-
big(1) * pi # pi en precisión extendida

#-
BigFloat(π) # lo mismo que la celda anterior

# Se pueden asignar vectores a variables

un_vector = [1, 2, 3, 4] # se definene con `[...]`

#-
otro_vector = [1.0, 2, 3, 4 ] # Noten la salida; en este caso es un `Array{Float64,1}`

#-
una_tupla = (1, 2, 3, 4) # una tupla

#-
una_tupla_con_nombres = (a=1, b=3.0) # una tupla cuyas entradas tienen nombres

# La diferencia entre un vector y una tupla es que el vector es *mutable*, mientras
# que la tupla no. Eso lo que significa es que los elementos de un vector pueden ser
# cambiados o reasignados, y los de la tupla no.

#-
un_vector_de_vectores = [[1, 2], [3, 4]] # concateno verticalmente; vector de vectores

#-
una_matriz = [[1, 2] [3, 4]] # concateno horizontalmente; noten el espacio entre los vectores columna

#-
[1 3; 2 4] # Esto es equivalente a la línea anterior

# Los elementos de un arreglo o de una tupla se obtienen con `[...]`, especificando el
# índice del vector o tupla, o los índices de la matriz, o incluso un rango.

un_vector[1]

#-
una_tupla[end]

#-
una_matriz[1,1]

#-
una_matriz[2,2] = -5 # Esto *muta* el valor del elemento (2,2) a -5

#-
una_tupla[1] = -3  # da un error, porque  las tuplas son inmutables

# Todo en Julia tiene asignado un *tipo*. Reconocer esto permite explotar variables
# ventajas que Julia ofrece

typeof(r) # un número de punto flotante `Float64`

#-
typeof(pi) # un número irracional

#-
typeof(1) # un entero; para procesadores antiguos, el resultado puede ser `Int32`

#-
typeof(1//3) # Un número racional; noten que hay `Int64` en el tipo, que etiqueta al racional

#-
typeof(ii) # Un número complejo; noten otra vez que incluye "un apellido"

#-
typeof(complex(1,3))

#-
typeof(un_vector) # Un vector; aquí hay dos "parámetros" para distinguirlo, el segundo es la dimensión

#-
typeof(una_matriz) # Una matriz es un `Array` de dimensión 2

#-
typeof(una_tupla)

#-
typeof(una_tupla_con_nombres)

#-
typeof(esta_clase) # una cadena

#-
typeof(+) # Los operadores (funciones) también tienen *su propio* tipo

#-
typeof(exp) # ... y esto se aplica a todas las funciones

#-
typeof(1.0)

#-
typeof(Float64) # Incluso los "tipos" tienen un tipo asignado específico

#-
typeof(DataType)

#-
typeof(typeof(exp))

# Los tipos en Julia constituyen una estructura (en el sentido de grafos)
# que es un árbol; uno puede ver los tipos más generales, o más específicos,
# usando `supertype` y `subtypes`

supertype(Int)

#-
supertype(Signed)

#-
supertype(Integer)

#-
supertype(Real)

#-
supertype(Number)

#-
supertype(Float64)

#-
supertype(AbstractFloat)

#-
supertype(esta_clase)

#-
supertype(typeof(esta_clase))

#-
supertype(AbstractString)

# Para saber si un objeto es de cierto tipo, uno utiliza la función `isa`

1.0 isa Int # esto equivale a isa(1.0, Int)

#-
typeof(false) # `false` y `true` son de tipo `Bool`

#-
supertype(Bool) # `Bool` es de tipo `Integer` ya que es equivalente a 0 o 1, y requiere 1 bit de memoria

# Para saber si un tipo es subtipo de otro, uno utiliza el operador `<:`; en algún sentido,
# este operador verifica si `Bool` está en una subrama de `Integer`

Bool <: Integer

#-
Real <: Number

#-
Float64 <: Number

#-
BigFloat <: Real

# Los tipos pueden ser `concretos` o `abstractos`; la deferencia está en que los tipos
# concretos se pueden representar de una manera *concreta* en memoria; los tipos abstractos
# sirven para poder "generalizar ciertas funciones a varios tipos.

isconcretetype(Float64), isconcretetype(Real)

#-
isabstracttype(Number)


# ## Funciones

# En Julia, una función mapea una tupla de elementos de entrada, en una salida.

# Julia permite distintas formas de definir una función. La manera estándar es
# usando la instrucción `function`, y el bloque que define la función se termina con `end`.
# El resultado de una función se especifica con `return`, que si se trata de la última
# línea que define a la función (antes del `end`) se puede omitir. La convención
# a la hora de nombrar funciones es que éstas usen sólo minúsculas.

"""
área_círculo(r)

Calcula el área de un círculo de radio `r`
"""
function área_círculo(r)
    return π * r^2
end

# En Julia, el formato de la función (por ejemplo, la indentación) no es obligatoria; sin 
# embargo, se recomienda usarla ya que hace más sencilla la lectura del código. 
# Lo que aparece entre comillas triples `"""` se llama `docstrings`, y es simplemente
# la descripción de lo que hace la función. Si bien no es obligatorio, es altamente
# recomendable incluir docstrings en el código. (Vale la pena notar, además, que hay dos 
# caracteres UTF (no ASCII), `á` e `í`, en el nombre de la función.)

área_círculo(2)

#-
área_círculo(BigFloat(2.0))

# Es importante señalar que la `r` en la definición de `área_círculo` no es la misma
# variable que la `r` que asignamos al principio y cuyo valor *sigue* siendo `1.0`. Los
# argumentos de una función se tratan como nuevas variables, cuyo valor es idéntico
# al que se pasa con la función.

r

# Sin embargo, es posible que una función modifique variables que son *mutables*, como
# por ejemplo, las componentes de un vector. En este caso, la convención recomienda
# usar `!` al final del nombre de la función, justamente para indicar que al menos
# un argumento de entrada de la función puede ser modificado.

# Uno puede también definir funciones que no requieren ningún argumento.

mi_nombre() = "Luis"

#-
mi_nombre()

# También vale la pena decir que los operdores, como `+` o `^`, son funciones. Por lo mismo,
# uno puede usarlas incluyendo paréntesis (que es lo que se llama *infix form*) de 
# manera completamente equivalente:

1 + 2 + 3

#-
+(1, 2, 3) # forma alterna de ejecutar la instrucción anterior

# ### Broadcasting

# La siguiente instrucción arroja un error, ya que implícitamente hemos asumido que
# la función recibirá un número `r` (aunque ésto no lo hemos especificado), y estamos
# tratando de usarla con una matriz.

área_círculo([1.0 2.0; 3.1 1.0])

# Julia ofrece la posibilidad de aplicar la misma función *elemento a elemento* a las 
# componentes de un vector, tupla, matriz, u otros arreglos más generales. Para esto se usa un 
# punto `.` (típicamente) después del nombre de la función y antes del paréntesis que
# especifican los argumentos. El concepto asociado a esto se llama "broadcasting".

área_círculo.([1.0 2.0; 3.1 1.0])  # broadcasting sobre una matriz

# Una manera, totalmente equivalente, de definir `área_círculo` es:

área_círculo(r) = π * r^2

# que tiene la ventaja de ser más compacta. (Noten el mensaje de que sólo hay un método
# definido para la función `área_círculo`.)

# ### Funciones anónimas

# En ciertos casos, por ejemplo cuando una función requiere a otra para ser ejecutada, 
# puede ser conveniente definir funciones anónimas, esto es, sin nombre. Las siguientes 
# definciones equivalentes definen a la misma función anónima, que corrresponde a
# `f(x) = x^2 + 2x -1`

x -> x^2 + 2x -1

#-
function (x)
    x^2 + 2x -1
end

# Una función anónima, que depende de múltiples argumentos, se escribe `(x,y) -> x^2 + y^2`,
# mientras que una función anónima sin argumentos se escribe como `() -> π`.

# ### Tuplas como argumentos y funciones con argumentos variables (varags)

# Es posible definir funciones de tal manera que uno pase como único argumento una tupla
# al ejecutar la función. Hay diversas posibilidades; la siguiente es una que explota
# (y a la vez impone) la estructura que debe tener la tupla.

distancia((max, min)) = max - min

#-
distancia((5, 2))

# Es útil tener la opción de escribir funciones que puedan tener un número arbitrario de
# argumentos; al número variable de argumentos se le llama *varargs*. Como ejemplo (tomado
# de la [documentación oficial](https://docs.julialang.org/en/v1/manual/functions/#Varargs-Functions))
# definiremos la función

lala(a, x...) = (a, x) # `...` que aparecen en la definición se llaman "slurp"

#-
lala(1, ()) # esto es equivalente a `lala(1,)`

#-
lala(1, (2,))

#-
lala(1, 2, (3, 4, 5, 6, 7))

# La siguiente ejecución de `lala` distribuye los argumentos de la tupla; esto se
# llama `splat`

lala((1,2,3)...) # equivalente a lala(1,(2,3))

# ### Métodos, *multiple dispatch*, y estabilidad de tipo

# Julia permite utilizar *la misma función* en distintos contextos. Por ejemplo,
# con `*` podemos multiplicar dos números, o concatenar cadenas. 

2 * 3

#-
"dos por tres es igual a " * "seis"

# Esta multiplicidad en el uso de una función significa que la función tiene  
# definidos varios métodos. 

# Julia permite definir métodos especializados respecto al tipo
# del argumento de entrada a la función. Por ejemplo, la siguiente función `ff`
# muestra el valor del argumento, e imprime su valor al cuadrado.

ff(x) = (@show(x); x^2)

# Vale la pena notar que usamos paréntesis para usar la forma "infix" y 
# definir de la función `ff`, que consta de dos instrucciones, que son
# separadas por `;`. El macro `@show` lo que hace es precisamente imprimir
# (sustituyenco código a la hora de "leer" el código) la variable `x`.

# Esta función, por ejemplo, la podemos aplicar a un número de punto flotante o 
# a uno complejo:

ff(1.1)

#-
ff(1.1 + 3im)

# Supongamos que queremos que el comportamiento de esta función, para números complejos,
# devuelva el módulo al cuadrado, en lugar de su cuadrado. En este caso debemos
# entonces definir un método especializado para el caso en que `x` sea un número
# complejo. Esto lo hacemos utilizando `::` para especificar/restringir uno o varios 
# argumentos de la función a un tipo; es aquí que los "tipos abstractos" suelen
# ser útiles.

ff(x::Complex) = (@show(x); x*x')  # x' es el complejo conjugado

#-
ff(1.1 + 3im)

# Para además particularizar en el posible parámetro del tipo, uno usa la siguiente
# forma:

ff(x::Complex{T}) where {T<:BigFloat} = (@show(typeof(x)); ff(Float64(x)))

#-
ff(big(1.1) + 3im)

# El hecho de que los métodos se aplican de manera distinta
# *según* el *tipo* de los argumentos es lo que se llama *multiple dispatch*. Lograr
# código rápido en Julia no significa escribir métodos específicos según el tipo 
# --aunque a veces esto es útil--, sino que el tipo del resultado de una función 
# esté determinado *sólamente* por el tipo de los argumentos de entrada. Es esto 
# lo que se conoce como *estabilidad de tipo*.

# Como ejemplo de esto último, construyamos una función que *no* es estable según
# el tipo; para esto, utilizaremos un block `if`-`else`-`end`.

function mi_sqrt(x)
    @show(x)
    if x < 0
        return sqrt(Complex(x))  # El resultado es `Complex{...}`
    else
        return sqrt(x) # El resultado es del mismo tipo que `x` (`AbstractFloat`)
    end
end        

#-
mi_sqrt(-1//1)

#-
mi_sqrt(1//1)

# El macro `@code_warntype` ayuda a encontrar problemas respecto a la estabilidad de tipo.

@code_warntype mi_sqrt(1//1)

# ### Ambigüedades

# Consideremos las siguientes definiciones de la función `gg`:

gg(a, b::Any)              = "fallback"   # default
gg(a::Number, b::Number)   = "a and b are both `Number`s"
gg(a::Number, b)           = "a is a `Number`"
gg(a, b::Number)           = "b is a `Number`"
gg(a::Integer, b::Integer) = "a and b are both `Integer`s"

# Uno puede obtener información sobre los métodos que tiene definidos la función
# usando `methods(gg)`

methods(gg)  # Describe los distintos métodos de una función

#-
gg(1.5, 2)

#-
gg("2", 1.5)

#-
gg(1.0, "2")

#-
gg(1, 2)

#-
gg("Hello", "World!")

#-
@which f("2", 1.5) # El macro `@which` permite identificar qué método se está usando

# A veces, uno puede definir la función de tal manera que Julia no encuentre qué método 
# aplicar en el sentido de cuál es el *más concreto* respecto al tipo de los argumentos. 
# En ese caso, hay un `MethodError` dado que los métodos son *ambiguos*.

gg(x::Int, y::Any) = println("int")
gg(x::Any, y::String) = println("string")

#-
gg(3, "test")

# Vale la pena notar que  en el mensaje de error, está  una posible solución para resolver
# la ambigüedad.


# ### Ejercicios

# 1. Escriban una función que proporcione el área y el volumen de un círculo de manera 
# simultánea, es decir, que la función regrese esos dos valores.
# 
# 1. Llamando a la función que hicieron en el ejercicio anterior `mifunc`, ¿qué obtienen 
# (tipo de resultado) al hacer la asignación `res = mifunc(1.0)`?
# 
# 1. ¿Qué asignación pueden hacer para separar los resultados de `mifunc`?
# 
# 1. ¿Cuál es el tipo de `mifunc`? Hint: ¿Cuál es el tipo de `(mifunct, typeof(mifunc))`?
# 
# 1. ¿Qué tipo de resultado se obtiene al ejecutar la siguiente función?
#     ```julia
#     println("Nada")
#     ```
# 1. Analicen qué representa el resultado obtenido al ejecutar la siguiente función: 
#     ```julia
#     map(first ∘ reverse ∘ uppercase, split("you can compose functions like this"))
#     ```


# ## Control del flujo

# ### Condicionales

# Los condicionales en cualquier lenguaje de programación permiten decidir 
# si ciertas partes del código se evalúan o no. En Julia, los condicionales tienen 
# la estructura `if-else-end`, como vimos en un ejemplo arriba, y cada condición 
# debe regresar una variable booleana (`true` o `false`).

function compara_x_y(x, y)
    if x < y
        println("x es menor que y")
    elseif x > y
        println("x es mayor que y")
    else
        println("x es igual a y")
    end
end

#-
compara_x_y(1.0, 2.3)

# En ocasiones, uno requiere regresar un valor dependiendo de una condición, y si 
# ésta no se cumple, entonces se regresa otro valor. Esto se puede hacer con la 
# construcción anterior haciendo las asignaciones pertinentes, o también, de una 
# manera más corta, a través del "operador ternario".

positivo_o_negativo(x::Real) = x > zero(x) ? "positivo" : "negativo"

#-
positivo_o_negativo(-1.2)

# La función anterior se puede igualmente escribir en una línea con `ifelse`

positivo_o_negativo(x::Real) = ifelse(x > zero(x), "positivo", "negativo")

# Hay otra forma más de condicional, que es la llamada evaluación de "corto circuito". 
# En ciertos casos, uno requiere evaluar expresiones que involucran dos variables 
# booleanas. Esto se puede conseguir con los operadores `&` (*and*) y `|` (*or*), por 
# ejemplo.

false & true

# Por otro lado, en ciertas ocasiones es rendundante evaluar *ambos* lados del operador
# lógico, por ejemplo, cuando la primera resulta en `false` y evaluamos `and`,
# o si resulta un `true` y evaluamos un `or`. En este caso, basta con la primer evaluación 
# para decidir el resultado; # de ahí que se llamen de *corto circuito*. Concretamente,
# 
# - `bool_a && bool_b` significa que `b` se evaluará si `a == true`, ya que si `a == false` el resultado es `false`;
# - `bool_a || bool_b` significa que `b` se evaluará si `a == false`, ya que si `a == true` el resultado es `true`.

# Para ilustrar esto, usaremos las funciones `verdadero(x)` y `falso(x)`, que imprimen
# el valor de entrada `x`, y que regresan `true` o `false`, respectivamente.

verdadero(x) = (println(x); true)
falso(x) = (println(x); false)

#-
verdadero(1) && verdadero(2) # Dos operaciones

#-
verdadero(1) && falso(2) # Dos operaciones

#-
falso(1) && verdadero(2) # Una operación

#-
falso(1) && falso(2) # Una operación

#-
verdadero(1) || verdadero(2)  # Una operación

#-
verdadero(1) || falso(2)  # Una operación

#-
falso(1) || verdadero(2) # Dos operaciones

#-
falso(1) || falso(2) # Dos operaciones

# ### Ciclos

# Hay dos tipos de ciclos: el ciclo `while` y el ciclo `for`. Si bien éstos son en algún 
# sentido equivalentes, a veces conviene usar uno en lugar del otro. *Ambas formas*, igual
# que el *bloque* `if`, requiere terminar con `end`, que marca donde acaba el código que 
# se repite.

glob_i = 1  # Esta variable debe definirse *antes* del `while`
while glob_i <= 5
    println(glob_i)
    glob_i += 1
    v_out = glob_i
end
glob_i

#-
v_out  # Regresa un `UndefVarError` ya que `v_out` sólo existe dentro del `while`

#-
for loc_i in 1:5
    println(loc_i)
    v_out = loc_i
end

#-
v_out  # Regresa un `UndefVarError` por la misma razón que antes

#-
loc_i  # Regresa el mismo error, ya que el contador `loc_i` sólo existe dentro del `for`

# Los errores que aparecen tienen que ver con el hecho de que los bloques `for` o `while`
# definen cierto ámbito para el contenido; en inglés, un *scope*. Por default ese 
# ámbito es local. Entonces, las variables `v_out` no existen fuera de ese ámbito,
# que es la razón del error. Para poderlas usar fuera, entonces, debemos definirlas antes.

# En cuanto a `1:5`, éste define un `UnitRange{Int64}` que es una manera muy conveniente 
# (memoria) de definir un iterador. Si uno quiere que el iterador no tenga pasos de
# tamaño 1, uno utiliza `1:2:5`, lo que daría saltos de 2 en 2, empezando en 1 y terminando
# en 5.

# Los ciclos `for` permiten *iterar* sobre objetos iterables.

for i in [1,2,3]
    println(i)
end

#-
animales = ["perro", "gato", "conejo"]
for i ∈ animales   # ∈ se obtiene con `\in<TAB>`
    println(i)
end

# A veces es necesario interrumpir un ciclo, o quizás sólo no ejecutar parte del ciclo.
# Esto se logra con `break` y `continue`.

jj = 0
for j = 1:1000
    println(j)
    j >= 5 && break
    jj = j
end
jj

#-
jj = 0
for i = 1:10
    i % 3 != 0 && continue   ## i % 3 es equivalente a mod(i, 3)
    println(i)
    jj = i
end
jj

# Es posible encadenar ejecuciones de varios ciclos `for` en una línea, formando el 
# producto cartesiano de los iterados.

for i = 1:2, j = 1:5
    println((i, j))
end

# Es posible construir vectores usando ciclos `for` directamente en una línea; a esto
# se le llama `comprehensions`. Por ejemplo:

v_tupla = [ (i,j) for i = 1:2, j = 1:5]

# En el caso en que el vector corresponda a un rango, es mejor usar rangos, justamente
# para evitar el uso de memoria. Esto lo podemos ver usando `sizeof`.

sizeof( [i for i=1:1_000_000] )

#-

sizeof( 1:1_000_000 )

# ## Ejercicios

# 1. Construyan una función qué, a partir de un tipo de estructura (e.g., `Int64`), muestre 
# el árbol de estructuras que están por arriba de él, es decir, que son más generales. hasta 
# llegar a `Any`. Ilustren su función con varios ejemplos.
# 
# 1. Usando la siguiente función (tomada de 
# [aquí](https://github.com/crstnbr/JuliaWorkshop19/blob/master/1_One/1_types_and_dispatch.ipynb))
# ```julia
# function show_subtypetree(T, level=1, indent=4)
#     level == 1 && println(T)
#     for s in subtypes(T)
#         println(join(fill(" ", level * indent)) * string(s))
#         show_subtypetree(s, level+1, indent)
#     end
# end
# ```
# - ¿Qué pueden decir de los tipos que son concretos en cuanto a su posición en el árbol de tipos?
# 
# 1. Escriban una función que aproxime la raíz cuadrada de `a` usando el método iterativo Babilonio:  
# - (1) Empiecen con un número arbitrario *positivo* `x`.
# - (2) Reemplacen `x` por  `(x+a/x)/2` .
# - (3) Repitan el paso anterior usando el nuevo valor de `x`.
# (Recuerden definir algún criterio de parada de la función.)
# 


# ## Manejo de Paquetes (Pkg)

# Julia tiene un potente manejador de paquetes, [`Pkg`](https://docs.julialang.org/en/v1/stdlib/Pkg/), 
# que está concebido para permitir
# la reproducibilidad del código, entre otras propiedades. Hay varias paqueterías que
# están incluidas en Julia, pero separadas del lenguaje que se carga por default, y éstas
# constituyen lo que se llama la librería estándard (*standard library*). Esto es, son 
# paqueterías que *no* debemos instalar, pero sí se deben cargar si hacen falta.

# Empezaremos cargando `Pkg`, para lo que usaremos la instrucción `using`.

using Pkg

# Lo que haré a continuación es *definir* un proyecto, el del curso, que incluirá todas
# las paqueterías que (por ahora) nos serán necesarias para empezar, y que poco a poco
# iremos ampliando. Para hacer esto, "activaremos" el directorio local y "instanciaremos"
# (*instantiate*) el repositorio, lo que creará los archivos "Project.toml" y "Manifest.toml",
# que son la base de la reproducibilidad en Julia. Subiéndolos a GitHub, en principio tendremos
# todos compartiremos los archivos necesarios, para hacer que todo funcione para todos.

Pkg.activate("..")  # Activa el directorio ".." respecto al lugar donde estamos (clases/)

# En la instrucción anterior, estamos ejecutando la función `activate`, del módulo `Pkg`,
# que vive dentro de él y que no se exporta.

# Ahora, instanciaremos el repositorio; lo que esto hace es actualizar los archivos
# "Project.toml" y "Manifest.toml".

Pkg.instantiate() # crea o actualiza "Project.toml" y "Manifest.toml"

# Ahora *instalaremos* una paquetería que usaremos para *generar* los notebooks del curso:
# [Literate.jl](https://github.com/fredrikekre/Literate.jl):

Pkg.add("Literate")

# La instrucción anterior instala la paquetería `Literate.jl` en el proyecto del curso;
# además, actualiza "Project.toml" con la información de la paquetería que se instaló,
# y "Manifest.toml" con todas las dependencias que puede tener `Literate`.
# Otras paqueterías se instalan de la misma manera.

# Para saber qué paquetes tenemos instalados, usamos `Pkg.status()`.

Pkg.status()

# Cuando iniciemos cualquier actividad del curso, será importante activar nuevamente 
# el projecto, lo que esencialmente permitirá *cargar* (con `using`) las librerías
# que usaremos.



