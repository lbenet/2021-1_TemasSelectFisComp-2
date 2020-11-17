# # Tarea 1
# 
# Fecha inicial de entrega (envío del PR): 
# Fecha aceptación del PR: 
# 
# ---

# ## 1
# 
# - Implementen una nueva estructura paramétrica (`struct`) que 
# llamaremos `Dual` y que definirá los duales. La estructura deberá 
# ser paramétrica, y el parámetro deberá ser subtipo de `Real`. La 
# parte que identifica a $f_0$ será llamada `fun`, y la correspondiente 
# a $f'_0$ será `der`.
# 
# - Definan los métodos apropiados para que el Dual de una 
# constante (`Real`), i.e., `Dual(c)` se comporte como debe, y 
# que la función `dual` represente la función identidad (o 
# variable independiente).
# 
# - Muestren que su código funciona con tests adecuados para crear 
# duales, para promoverlos, y al definir el dual de un número y 
# `dual` para la variable independiente. Para esto es útil usar la 
# infraestructura que Julia provee; ver 
# https://docs.julialang.org/en/v1/stdlib/Test/#Basic-Unit-Tests

#-
# # Solución

#-
# Creamos una estructura llamada Dual

#-
"""
   Dual{T<:Real}

Definición de los duales, donde lo campos son:
...
"""
struct Dual{T<:Real}
    fun :: T
    der :: T
end

#-
# Probamos primero que la estructura tienen un error del método.

#-
Dual(1.0 , 1//1)

#-
# Revisamos los subtipos de *Real*, con ello podemos darnos una idea de como imprimir las entradas cuando
# no son iguales, es decir, si ingresamos a *Dual* un flotante y un entero, un racional y un abs.rational.

#-
subtypes(Real)

#-
"""
    funcion Dual(f:: Cualquier subtipo de Real, df :: Cualquier subtipo de Real)
    Al ejecutarse, evalua si ambas entradas son del mismo tipo, de serlo las devuelve sin cambios.
    Al encontrar coincidencia, las devuelve como Float64.

"""
function Dual(f,df)
    if typeof(f) == typeof(df)
        return (f,df)
    else
        return (Float64(f),Float64(df))
    end  
end

#-

# Quizas esto soluciona por el momento ese error del método, y no se esta 100% seguro de que 
# sea lo más eficiente, pero al menos, las entradas no son *Any* o *Real*, que son tipos de elementos
# muy generales.

#-
Dual(1.0, ℯ)

#-
"""

    Dual(c::Variable de tipo real)
    
    Devuelve la misma variable y la segunda entrada 0, ese decir, la derivada de una constante.

"""
Dual(c::Real) = return(c,0)

#-

"""
    dual(x0) -> Dual(x0, 1)
    Devuelve la misma variable y devuelve el parámetro 1, simulando a $f(x)$ = x y su derivada.

...
"""
function dual(x0)
    return(x0, 1)
end

#-
# Vemos un par de test.

#-
using Test
@testset "Dual tests" begin
           @test Dual(1//2)   == (0.5,0)
           @test dual(1)  == (1,1)
           @test Dual(3, 2.0) == (3.0,2.0)
           @test Dual(2//2 , 1) == (1.0,1.0)
       end;