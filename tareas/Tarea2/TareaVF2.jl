# ## $$\textbf{Tarea 2}$$
# #$$\textit{Raúl Jorge Domínguez Vilchis && Yesenia Sarahi García González}$$


# ### Ejercicio 1
#
# - Implementen una nueva estructura paramétrica (`struct`) que
# llamaremos `Dual` y que definirá los duales. La estructura deberá
# ser paramétrica, y el parámetro deberá ser subtipo de `Real`. La
# parte que identifica a $f_0$ será llamada `fun`, y la correspondiente
# a $f'_0$ será `der`.

# La definición deberá incluir métodos que sean compatibles con las
# dos propiedades arriba mencionadas, es decir, que el dual de una
# constante sea $(c,0)$, y que el de la variable independiente sea
# $(x_0,1)$. Para lo segundo definiremos una función `dual` con la
# propiedad mencionada.

#-
"""
   Dual{T<:Real}

Definición de los duales, donde lo campos son: 
fun - una función arbitraria evaluada en x0
der - la derivada de la función en x0
...
"""

struct Dual{T <: Real}
    fun :: T
    der :: T
end
#Dual(x,y) = ( j = p(x,y))
Dual(x,y) = ( i = promote(x,y); Dual(i[1], i[2] ))
#-

#-
#Creamos un método para crear el dual de una constante
Dual(r::Real) = Dual(r, zero(r))
#-

#-
#Creamos un método para el dual de la función identidad
"""
    dual(x0) -> Dual(x0, 1)
      Función identidad para duales evaluada en x0
...
"""
function dual(x0)
    return Dual(x0, one(x0))
end
#-

#-
#Usamos la siguiente función para trabajar con índices
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

#-

dual(5.0)

#-

#-

Dual(1.5)

#-

#-
using Test
@testset "Definicion de las estructuras duales" begin 
    @test Dual(1, 1.0) == Dual(1.0, 1.0) #igualdad 
    @test Dual(7) == Dual(7,0) #Dual de una constante 
    @test dual(3.0) == Dual(3.0, 1.0) #Dual de la identidad
end
#-

# ### Ejercicio 2
#
# - Implementen *todas* las operaciones aritméticas definidas arriba;
# para `^` consideren sólo potencias enteras.
# Estas operaciones deben incluir las operaciones aritméticas que
# involucran un número cualquiera (`a :: Real`) y un dual (`b::Dual`),
# o dos duales. Esto se puede hacer implementando (sobrecargando)
# los métodos específicos para estos casos (¡y que sirven en cualquier
# órden!).

#-
#Implementamos la suma.
import Base: +
+(D::Dual) = D
+(D1::Dual, D2::Dual) = Dual(D1[1] + D2[1], D1[2] + D2[2])
+(r::Real, D3::Dual) = Dual(r + D3[1], D3[2])
+(D::Dual, c::Real) = Dual(c + D[1], D[2] )
#-

#-
Dual(1.0, 3) + Dual(3, 4.5)
#-

#-
2 + Dual(20,50) 
#-

#-
Dual(2.0, 3.0) + 5
#-

#-
#Evaluamos nuestras definiciones de suma usando @testset
 @testset "Suma de las estructuras duales" begin
        @test Dual(1, 2) + Dual(3, 4) == Dual(4, 6)
        @test 1.0 + Dual(5, 6) == Dual(6.0, 6.0)
        @test Dual(6.0, 8) + 2 == Dual(8.0, 8.0)
end;
#-

#-
#Implementamos la resta
import Base: -
-(D::Dual) = Dual(-D[1], -D[2])
-(D1::Dual, D2::Dual) = Dual(D1[1] - D2[1], D1[2] - D2[2])
-(D2::Dual, D1::Dual) = Dual(D2[1] - D1[1], D2[2] - D1[2])
-(r::Real, D3::Dual) = Dual(r - D3[1],  -D3[2])
-(D::Dual, c::Real) = Dual(D[1] - c, D[2] )
#-

#-
Dual(1.0, 3) - Dual(3, 4.5)
#-

#-
- Dual(3, 4.5) + Dual(1.0, 3)
#-

#-
11.5 - Dual(2, 3)
#-

#-
Dual(2.0, 3) - 5
#-

#-
#Evaluamos nuestras definiciones de la resta
@testset "Resta de las estructuras duales" begin
        @test Dual(1, 2) - Dual(3.0, 4) == Dual(-2.0, -2.0)
        @test - Dual(3, 4.5) + Dual(1.0, 3) == Dual(-2, -1.5)
        @test 1 - Dual(2.0, 3) == Dual(-1, 3.0)
        @test Dual(2, 3.0) - 5 == Dual(-3.0, 3.0)
end;
#-


#-
#Implementamos la multiplicación
import Base: *
*(D1::Dual, D2::Dual) = Dual(D1[1] * D2[1], D1[1] * D2[2] + D2[1] * D1[2])
*(r::Real, D3::Dual) = Dual(r * D3[1], r * D3[2])
*(D::Dual, c::Real) = Dual(D[1] * c, D[2] * c)
#-

#-
Dual(3, 2) * Dual(1.0, 3)
#-

#-
3 * Dual(3, 4.5) 
#-

#-
Dual(1.0, 3) * 3
#-

#-
#Evaluamos nuestras definiciones de multiplicación
@testset "Multiplicación de las estructuras duales" begin
        @test Dual(3, 2) * Dual(1.0, 3) == Dual(3.0, 11)
        @test 3 * Dual(3, 4.5) == Dual(9, 13.5) 
        @test Dual(1, 3) * 3 == Dual(3, 9)
end;
#-

#-
#Implementamos la división 
import Base: /
/(D1::Dual, D2::Dual) = Dual( (D1[1] / D2[1]) , ( D1[2] -(D1[1]/D2[1])*(D2[2]) ) / D2[1] )
/(D2::Dual, D1::Dual) = Dual( (D2[1] / D1[1]) , ( D2[2] -(D2[1]/D1[1])*(D1[2]) ) / D1[1] )
/(r::Real, D3::Dual) = Dual( (r / D3[1]) , ( -(r/D3[1])*(D3[2]) ) / D3[1] )
/(D::Dual, c::Real) = Dual( (D[1]/c) , (D[2]/c) )
#-


#-
Dual(3, 2) / Dual(1.0, 3)
#-

#-
Dual(1//1,3//1) / Dual(3//1, 2//1)
#-

#-
3 / Dual(3, 4.5) 
#-

#-
Dual(7, 14.0) / 7
#-

#-
#Evaluamos nuestras definiciones de divisón
@testset "División de las estructuras duales" begin
        @test Dual(3, 2) / Dual(1.0, 3) == Dual(3.0, -7)
        @test Dual(1//1,3//1) / Dual(3//1, 2//1) == Dual(1//3, 7//9 )
        @test 3 / Dual(3, 4.5) == Dual(1, -1.5) 
        @test Dual(7, 14.0) / 7 == Dual(1, 2.0)
end;
#-

#-
#Implementamos la operación exponente
import Base: ^
^(D::Dual,r::Real) = Dual( D[1]^(r), r*D[1]^(r - 1)*D[2] )
#-

#-
Dual(3, 2)^(3)
#-

#-
Dual(1/4, 2.0)^(1/2)
#-

#-
(1 / Dual(4, 2)^(3)) * Dual(4, 2)^(3)
#-

#-
#Evaluamos nuestras definiciones de la exponente
@testset "Exponenciación de las estructuras duales" begin
        @test Dual(3, 2)^(3) == Dual(27, 54)
        @test Dual(1/4, 2.0)^(1/2) == Dual(0.5, 2)
end;
#- 

#= código =#

#= código con los tests =#

#= código con los tests =#

#= código =#

#= código =#

#= código =#

#= código =#
