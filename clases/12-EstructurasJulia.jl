# # Tipos/Estructuras en Julia
# 
# Vimos que **todo** en Julia tiene asociado un tipo. Aquí veremos algunas 
# formas de crear *estructuras* que se acomoden a lo que necesitamos, lo que define 
# tipos *ad-hoc*, y algunos trucos para que 
# la ejecución del código sea rápida. La importancia de las estructuras radica en que
# uno puede diseñar estructuras adaptadas sin sacrificar rendimiento.
# 
# La convención para definir las estructuras es que se escriban en estilos "camello", 
# es decir, en que la primer letra de cada palabra empiece en mayúscula. Ejemplos de esto 
# son `Float64`, `AbstractFloat` o `BigInt`.
# 
# Antes de empezar vale la pena decir que las estructuras **no** pueden ser redefinidas o 
# sobreescritass en una (la misma) sesión de Julia, sea en el REPL o en el Jupyter notebook; 
# para poder hacerlo, se tiene que iniciar una nueva sesión, o reiniciar el kernel del Jupyter 
# notebook. Es por esto que en este notebook, definiremos varias estructuras con campos 
# esencialmente similares o incluso idénticos.

#-

# ## Tipos inmutables y constructores internos

# La siguiente construcción muestra la definición más sencilla de una estructura, en este
# caso llamada `MiTipo`.

struct MiTipo end

# Al igual que en otras partes en Julia, se requiere finalizar `struct` con `end`.

# Para crear un objeto del tipo `MiTipo` se requiere un *constructor*, que 
# simplemente es una función que devuelve un objeto del tipo especificado.
# Podemos usar `methods` para vere qué constructores hay definidos para `MiTipo`.

methods(MiTipo)

# La estructura `MiTipo` consta de un método, lo que nos permite usarlo para construir
# objetos del tipo `MiTipo`. Claramente de la definición vemos que `MiTipo` no contiene
# ningún tipo de objeto (o campo); a este tipo de estructura se le llaman "singleton". 
# Este tipo de estructuras es útil cuando queremos especializar ciertas funciones, 
# es decir, explotar *dispatch*.

mt = MiTipo()

#-
typeof(mt)

#-
mt isa MiTipo

# En general, cuando definimos un tipo nuevo es para que contenga cierto tipo de 
# información. Esto se puede hacer de varias maneras.

struct Particula1d
    x :: Float64
    v :: Float64
end

# Es importante enfatizar que por cuestiones de eficiencia conviene que los tipos de
# los campos internos de la estructura sean concretos; como veremos más adelante, Julia 
# permite definir estructuras paramétricas que dan más flexibilidad preservando el hecho 
# de que los tipos sean concretos. Incluso, Julia permite insertar los tipos definidos
# en la jerarquía del árbol de tipos.
# 
# A pesar de que el ejemplo de `Particula1d` incluye los campos `x` y `y`, y que ambos son 
# del tipo `Float64`, los distintos campos de una estructura pueden tener tipos 
# distintos asociados.
# 
# El método que por default crea a un objeto `Particula1d` requiere que especifiquemos 
# *en el mismo orden* en que fueron definidos *todos* los campos que lo componen.

methods(Particula1d)

#-
p1 = Particula1d(1.0, -2.4)

#-
fieldnames(Particula1d)

#-
p1.x  # muestra los que el campo `x` de `p1` contiene

# El tipo de estructura que acabamos de crear es *inmutable*, lo que significa que los 
# campos individuales (cuando son *concretos*), no se pueden cambiar.

isimmutable(p1)

#- 
p1.x = 2.0  # arroja un error dado que `p1` es inmutable

# La propiedad de inmutabilidad no es recursiva; así, si un objeto consiste de algún 
# campo que es mutable (por ejemplo, `Array{T,N}`), entonces ese campo puede cambiar.

struct Particula2d
    x :: Array{Float64,1}
    v :: Array{Float64,1}
    function Particula2d(x :: Array{Float64,1}, v :: Array{Float64,1})
        @assert length(x) == length(v) == 2
        return new(x, v)
    end
end

#-
p2 = Particula2d([1.0, 2.5], [1.0, 3.0])

# La función que aparece en el interior de la definición de la estructura *redefine* el 
# constructor de default; a ésta se llama *constructor interno*. Hay que notar que 
# el comando `new` *sólo* se utiliza en constructores internos (ya que `Particula2d` no
# existe aún).

# Dado que p2 es inmutable, sus campos internos no se pueden modificar de manera individual,
# pero sí sus componentes.

p2.x = [2.0, 1.0]   # esto arroja un  error

#-
p2.x[1] = 6.0   # aquí  cambiamos la primer componente
p2

#-
p2.x .= [2, 1]  # explotando broadcasting podemos cambiar *todo* el vector `x`
p2

# Vale la pena enfatizar que esta manera de cambiar el contenido de un campo
# evita el constructor interno, y por lo mismo, puede llevar a *inconsistencias*.
# Por ejemplo, el constructor interno de `Particula2d` verifica que cada campo sea 
# un vector de tamaño 2. Sin embargo, esto se puede cambiar, lo que puede "romper"
# el código.

push!(p2.v, 3.0)

p2    # Ahora, p2.v es un vector de tamaño 3 !?


# ## Tipos mutables

# Todo lo dicho anteriormente se puede extender para definir tipos mutables. La única 
# diferencia es la instrucción que usamos a la hora de definirlos: `mutable struct`.

mutable struct ParticulaMutable2d
    x :: Array{Float64,1}
    v :: Array{Float64,1}
    function ParticulaMutable2d(x :: Array{Float64,1}, v :: Array{Float64,1})
        @assert length(x) == length(v) == 2
        return new(x, v)
    end
end

#-
mp2 = ParticulaMutable2d([1.0, 2.5], [1.0, 3.0])

#-
mp2.x = [2, 1]   # no arroja ningún error!

#-
mp2


# ## Constructores paramétricos

# Como mencionamos arriba, en ocasiones uno quiere definir estructuras que contengan
# distintos tipos de los campos internos. Un ejemplo son los vectores, es decir, podemos
# definir un vector con números `Int`, `Array{Int,1}` , o con números de punto flotante
# `Array{Float64,1}`, o incluso matrices, `Array{Float64 2}`. Otro ejemplo podría ser
# tener la posibilidad de que los campos de `Particula1d` sean `Float64` o quizás `BigFloat`,
# o la posibilidad de que `Particula2d` pueda funcionar con vectores cuyas componentes son 
# de varios tipos según la aplicación.
# 
# En el ejemplo con `Particula2d`, dado que definimos los campos enteros como 
# vectores de `Float64`, si tratamos de usar otro tipo de vectores, esto dará errores.

Particula2d([1, 2], [1, 3])  # Esto da un error de método

# En principio uno *podría* usar en la definición de los campos que componen a la estructura
# algún tipo abstracto, como `Real`. Sin embargo, dado que el compilador *no* conoce la 
# estructura específica, el código será ineficiente. Lo siguiente muestra un ejemplo del 
# código que hay que evitar:
# 
#    ```julia
#    struct EstructuraConCamposAbstracto
#        x :: Real
#        v :: Real
#    end
#    ```
# 
# La alternativa es definir estructuras *paramétricas*, donde precisamente el parámetro 
# de la estructura será especializado en algún tipo concreto, que se especifica al construir 
# explícitamente el objeto, y que es subtipo de algún tipo abstracto.

struct Particula1dParam{T <: Real}
    x :: T
    v :: T
end
#-
Particula1dParam(big(1.1), BigFloat("1.1"))

#-
Particula1dParam(2^64, 0)

#-
Particula1dParam(Int128(2)^64, Int128(0))

# Noten que en los distintos ejemplos, en el tipo `Particula1dParam{T}` el parámetro `T`
# adquiere un tipo concreto que se utiliza a la hora de definirlo.
# 
# Por defecto, los tipos definidos se acomodan abajo de `Any`. Sin embargo, uno puede 
# lograr *insertar* la estructura que uno define en el árbol de tipos
# que existe en Julia. Esto permite que el tipo que uno define adquiera o *herede* cierto 
# tipo de comportamiento y, por lo mismo, la posibilidad de usar ciertas funciones con la 
# estructura definida.

struct MiVector2d{T <: Real} <: AbstractArray{T,1}
    x :: T
    y :: T
end

#-
x = MiVector2d(1, 2)

# El error indica que no existe un método definido para `size(::MiVector2d)`, y suena 
# *aparentemente* "no relacionado" con lo que hemos hecho. El error, de hecho, está relacionado
# con la visualización del objeto `x`, dado que podemos imprimir el valor que tiene cada
# uno de sus campos, y de hecho, `x` ha sido *definido*.

x.x, x.y
#-
isdefined(Main, :x)  # verifica si el símbolo `x` existe

# Para evitar  este error y poder visualizar visualizar objetos del tipo `MiVector2d`, 
# sobrecargaremos las funciones `size` y `getindex`, es decir, las extenderemos para
# poderlas usar con `MiVector2d`, siguiendo la recomendación que se encuentra en 
# [la documentación](https://docs.julialang.org/en/v1.5/manual/interfaces/#man-interface-array-1).

import Base: size  # la función `size` está definida en el módulo `Base`

size(::MiVector2d{T}) where {T} = (2,)

#-
## Esto ilustra otra manera de sobrecargar funciones, especificando el módulo
## donde está definida la función. 
function Base.getindex(v::MiVector2d, i::Int)
    if i == 1
        return v.x
    elseif i == 2
        return v.y
    else
        throw(AssertError)
    end
end

#-
x

#-
y = MiVector2d(1.2, 2.1)

# Vale la pena ahora enfatizar lo siguiente: a pesar de que **no** hemos sobrecargado 
# la suma (`:+`) entre dos (o más) objetos del tipo `MiVector2d`, la suma (y otras funciones)
# funcionan gracias a que hemos impuesto `MiVector2d{T} <: AbstractArray{T,1}`. Más aún, 
# los parámetros de `x` y de `y` son distintos.

x + y

#-
x .+ y  # broadcasting también funciona

#-
typeof(ans)

# Vale la pena también notar que el resultado es un `Array{Float64,1}` y no un 
# `MiVector2d{Float64}`. Para logar que el resultado sea del tipo que queremos, debemos 
# sobrecargar la función `:+`. El siguiente comando se encarga de hacer eso; vale la 
# pena notar que no estamos especificando el parámetro de `MiVector2d`, cosa que también
# se puede hacer.

Base.:+(x::MiVector2d, y::MiVector2d) = MiVector2d((x .+ y)...)

#-
x + y

# Los ejemplos que hemos visto *no* son particularmente interesantes, aún, pero muestran 
# que Julia permite adecuar las cosas a lo que requerimos, de manera más o menos sencilla.
