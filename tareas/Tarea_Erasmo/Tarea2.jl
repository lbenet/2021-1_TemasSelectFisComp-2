# # Tarea 2
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

"""
   Dual{T<:Real}

Estructura de los duales, donde lo campos son:
    fun - la parte f0 del dual.
    der - la parte f'0 del dual.
"""
struct Dual{T <: Real}
    fun :: T
    der :: T
end
#-

Dual(x, y) = ( aux = promote(x, y) ; Dual(aux[1], aux[2]) )
#-


# - Definan los métodos apropiados para que el Dual de una 
# constante (`Real`), i.e., `Dual(c)` se comporte como debe, y 
# que la función `dual` represente la función identidad (o 
# variable independiente).

Dual(c::Real) = Dual(c, 0)

"""
    dual(x0) -> Dual(x0, 1)

Regresa el dual de la función identidad f(x) = x evaluada en x0.
"""
function dual(x0)
    return Dual(x0, 1)
end
#-

# - Muestren que su código funciona con tests adecuados para crear 
# duales, para promoverlos, y al definir el dual de un número y 
# `dual` para la variable independiente. Para esto es útil usar la 
# infraestructura que Julia provee; ver 
# https://docs.julialang.org/en/v1/stdlib/Test/#Basic-Unit-Tests

using Test
@testset "Definición de duales" begin
    @test Dual(1, 1.0) == Dual(1.0, 1.0)
    @test Dual(1) == Dual(1, 0)
    @test dual(1//2) == Dual(1//2, 1//1)
end;
#-

#-

# ## 2
# 
# - Implementen *todas* las operaciones aritméticas definidas arriba; 
# para `^` consideren sólo potencias enteras. 
# Estas operaciones deben incluir las operaciones aritméticas que 
# involucran un número cualquiera (`a :: Real`) y un dual (`b::Dual`), 
# o dos duales. Esto se puede hacer implementando (sobrecargando)
# los métodos específicos para estos casos (¡y que sirven en cualquier 
# órden!). 

#-
# Para facilitar la escritura, se abilita el uso de índices para la estructura Dual. 
# El primer índice corresponde a la parte de la función *fun*, mientras que el segundo 
# para el de la derivada *der*.

function Base.getindex(D::Dual, i::Int)
    if i == 1
        return D.fun
    elseif i == 2
        return D.der
    else
        throw(AssertError)
    end
end
#-

import Base: +, -, *, /, ^, inv, ==, !=
#-

# ### Suma.

+(D::Dual) = D
+(D1::Dual, D2::Dual) = Dual(D1[1] + D2[1], D1[2] + D2[2])
+(c::Real, D::Dual) = Dual(c) + D
+(D::Dual, c::Real) = D + Dual(c)
#-

# ### Multiplicación.

*(D1::Dual, D2::Dual) = Dual(D1[1] * D2[1], D1[1] * D2[2] + D2[1] * D1[2])
*(c::Real, D::Dual) = Dual(c) * D
*(D::Dual, c::Real) = D * Dual(c)
#-

# ### Exponenciación.

inv(D::Dual) = Dual(D[1]^(-1),  - D[1]^(-2) * D[2])
^(D::Dual, n::Int) = Dual(D[1]^n, n * D[1]^(n - 1) * D[2])
#-

# Con base a la suma, es fácil definir la resta entre duales. Así mismo, a partir 
# del producto entre duales y la exponenciación por un entero es fácil definir la 
# división, como se muestra a continuación.

# ### Resta

-(D::Dual) = Dual(-D[1], -D[2])
-(D1::Dual, D2::Dual) = D1 + (-D2)
-(c::Real, D::Dual) = Dual(c) - D
-(D::Dual, c::Real) = D - Dual(c)
#-

# ### División.

/(D1::Dual, D2::Dual) = D1 * D2^(-1)
/(c::Real, D::Dual) = Dual(c) * D^(-1)
/(D::Dual, c::Real) = inv(c) * D
#-

# - Implementen la comparación (equivalencia) entre duales (`==`). 

==(D1::Dual, D2::Dual) = ( D1[1] == D2[1] ) && ( D1[2] == D2[2] )
==(c::Real, D::Dual) = Dual(c) == D
==(D::Dual, c::Real) = D == Dual(c)
#-

!=(D1::Dual, D2::Dual) = !(D1 == D2)
!=(c::Real, D::Dual) = !(c == D)
!=(D::Dual, c::Real) = !(D == c)
#-

# - Incluyan tests que muestren que cada una de ellas está bien 
# definida, y que sus resultados dan valores consistentes.

@testset "Operaciones para Duales" begin
    
    @testset "Suma" begin
        @test Dual(1, 2) + Dual(3.0, 4.0) == Dual(4, 6)
        @test 1.0 + Dual(5, 6) == Dual(6, 6)
        @test Dual(6.0, 8) + 2 == Dual(8, 8)
    end
    
    @testset "Producto" begin
        @test Dual(1, 2) * Dual(3.0, 4.0) == Dual(3, 10)
        @test 2.0 * Dual(5, 6) == Dual(10, 12)
        @test Dual(6.0, 8) * 3 == Dual(18, 24)
    end
    
    @testset "Potencia" begin
        @test Dual(1, 2.0)^(-1) == Dual(1, -2)
        @test Dual(3, 4)^2 == Dual(9.0, 24)
    end

    @testset "Resta" begin
        @test Dual(1, 2) - Dual(3.0, 4.0) == Dual(-2, -2)
        @test - Dual(1, 2) + Dual(3.0, 4.0) == Dual(2, 2)
        @test 1.0 - Dual(5, 6) == - Dual(4, 6)
        @test Dual(6.0, 8) - 2 == Dual(4, 8)
    end
    
    @testset "División" begin
        @test Dual(3.0, 4.0) / Dual(1, 2) == Dual(3, -2)
        @test 6.0 / Dual(2, 3) == Dual(3, -4.5)
        @test Dual(6.0, 8) / 2 == Dual(3, 4)
    end
    
    @testset "Comparación" begin
        @test Dual(1//2, 3//4) == Dual(0.5, 0.75)
        @test Dual(2, 3) != Dual(3, 2)
    end
    
end;
#-

# - Evalúen la función `f(x) = (3x^2-8x+5)/(7x^3-1)` en el dual
# `x₀ = 1 + \epsilon`, que representa la variable independiente
# en el punto $x_0=1$. Rehagan este inciso usando un dual
# en el punto $x_0=1$ usando aritmética de racionales.
# - Evalúen analíticamente (usando el álgebra  de duales) la 
# función `f(x)` en la variable independiente en $x_0=1$, a fin 
# de verificar que el resultado obtenido es el correcto.

# ## 3
# 
# - Recordando la regla de la cadena, extiendan el uso de `Dual` a 
# las funciones elementales: `sqrt`, `exp`, `log`, `sin`, `cos`,
# `tan`, `asin`, `acos`, `atan`, `sinh`, `cosh`, `tanh`, `asinh`,
# `acosh`, `atanh`.
# 
# - Muestren que su implementación da los resultados que se esperan 
# usando pruebas como hicieron en ejercicios anteriores.
# 
# - Calculen la derivada de $h(x)=\sin(x^3−2/x^6)$ en $x_0=2$. ¿Qué 
# tan preciso es el resultado? (Pueden usar cualquier otra manera 
# de obtener el resultado correcto, sólo tienen que ser claros 
# en la explicación.)
# 
# - Grafiquen, para $x_0\in[1,5]$ la función $h^\prime(x)$.

#= Respuestas =#

#-

# ## 4
# 
# Argumenten qué podrían hacer para extender la idea de los `Dual` 
# y calcular derivadas aún más altas. (Como ejemplo concreto, consideren 
# el obtener la derivada 18 de funciones como las que hemos usado arriba.)
# 

# = Respuestas (markdown) =

