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
    Al encontrar coincidencia, las devuelve promoviendo el subtipo considerado por la función promote.
"""
function Dual(f,df)
       return Dual(promote(f,df)...)
end

#-

# Probando un ejemplo vemos que funciona de mejor manera.

#-
Dual(1.0, ℯ)

#-
"""

    Dual(c::Variable de tipo real)
    
    Devuelve la misma variable y la segunda entrada 0, ese decir, la derivada de una constante.

"""
Dual(c::Real) = return(c,zero(c))

#-

"""
    dual(x0) -> Dual(x0, 1)
    Devuelve la misma variable y devuelve el parámetro 1, simulando a $f(x)$ = x y su derivada.

...
"""
function dual(x0)
    return(x0, one(x0))
end

#-
# Vemos un par de test.

#-
using Test
@testset "Dual tests" begin
           @test Dual(1)   == Dual(1,0)
           @test dual(1)  == Dual(1,1)
           @test Dual(1 , 1.0) == Dual(1.0 ,1.0)
           @test Dual(2//2 , 1) == Dual(1//1,1//1)
       end;

#-

# ### 2
# 
# - Implementen *todas* las operaciones aritméticas definidas arriba; 
# para `^` consideren sólo potencias enteras. 
# Estas operaciones deben incluir las operaciones aritméticas que 
# involucran un número cualquiera (`a :: Real`) y un dual (`b::Dual`), 
# o dos duales. Esto se puede hacer implementando (sobrecargando)
# los métodos específicos para estos casos (¡y que sirven en cualquier 
# órden!). 
# 
# - Implementen la comparación (equivalencia) entre duales (`==`). 
# 
# - Incluyan tests que muestren que cada una de ellas está bien 
# definida, y que sus resultados dan valores consistentes.
# 
# - Evalúen la función `f(x) = (3x^2-8x+5)/(7x^3-1)` en el dual
# `x₀ = 1 + \epsilon`, que representa la variable independiente
# en el punto $x_0=1$. Rehagan este inciso usando un dual
# en el punto $x_0=1$ usando aritmética de racionales.
# - Evalúen analíticamente (usando el álgebra  de duales) la 
# función `f(x)` en la variable independiente en $x_0=1$, a fin 
# de verificar que el resultado obtenido es el correcto.


#- ### Solución:

#-

# Sobrecargamos la función getindex que nos permite seleccionar la entrada del Dual de 
# igual manera que un Array

#-

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

# Ahora importamos las operaciones que vamos a sobrecargar con los duales

#-

import Base: +, -, *, /, ^, ==

#-

# ### Suma

#- 

function +(f::Dual, df::Dual)
    return Dual(f[1] + df[1], f[2] + df[2])
end

#-

function +(a::Real, f::Dual)
    return Dual(a + f[1] , f[2])
end

#-

function +(f::Dual, a::Real)
    return Dual(a + f[1], f[2])
end

#-

function +(f::Dual)
    return Dual(f[1],f[2])
end

#-

# ### Resta

#- 

function -(f::Dual, df::Dual)
    return Dual(f[1] - df[1], f[2] - df[2])
    
end

#-

function -(a::Real, f::Dual)
    return Dual(a - f[1] , f[2])
end

#-

function -(f::Dual, a::Real)
    return Dual(f[1] - a, f[2])
end

#-

function -(f::Dual)
    return Dual(-f[1], -f[2])
end

#- 

# ### Producto

#-

function *(f::Dual, df::Dual)
    return Dual(f[1]*df[1], f[1]*df[2] + f[2]*df[1] )

end

#-

function *(a::Real, f::Dual)
    return Dual(a*f[1] , a*f[2])
end

#-

function *(f::Dual , a::Real)
    return Dual(f[1]*a , f[2]*a)
end

#-

# ### División

#-

function /(f::Dual, df::Dual)
    return Dual(f[1]/df[1], (f[2]*df[1] - f[1]*df[2])/(df[1]^2) )

end

#-

function /(a::Real, f::Dual)
    return Dual(a/f[1] , -a*f[2]/f[1]^2)
end

#-

function /(f::Dual, a::Real)
    return Dual(f[1]/a , f[2]/a)
end

#-

# ### Potenciación

#-

function ^(f::Dual , n::Int)
    return Dual(f[1]^n, (n*f[1]^(n-1))*f[2] )

end

#-

# ### equivalencia

#-

function ==(f::Dual, df::Dual)
    if f[1]==df[1] && f[2]==df[2]
        return true
    else
        return false
    end
end

#-

function ==(a::Real, f::Dual)
    if f[1]==a && f[2]==0
        return true
    else
        return false
    end
end

#-

function ==(f::Dual, a::Real)
    ==(a::Real, f::Dual)
end

#-

# ### Test de las operaciones entre duales

#-

using Test
@testset "Suma de duales" begin
           @test 1 + Dual(1.0,2//2) == Dual(2.0,2//2)
           @test Dual(1,2.0) + Dual(1//1, 0) == Dual(2//1,2.0)
           @test Dual(1.0,2//2) + 2 == Dual(3.0, 2//2) 
       end;

#-

using Test
@testset "Resta de duales" begin
        @test Dual(2,2.0) - Dual(1//1, 1) == Dual(1//1,1.0)   
        @test 2 - Dual(1.0,2//2) == Dual(1.0,2//2)
        @test Dual(1.0,2//2) - 2 == Dual(-1.0, 2//2)
        @test -Dual(1,2) == Dual(-1,-2)
       end;

#-

using Test
@testset "Producto de duales" begin
        @test Dual(2,2.0) * Dual(2//1, 3) == Dual(4//1,10.0)   
        @test 2 * Dual(1.0,2//2) == Dual(2.0,4//2)
        @test Dual(1.0,2//2) * 2 == Dual(2.0, 4//2)
        
       end;

#-

using Test
@testset "División de duales" begin
        @test Dual(2,2.0) / Dual(2//1, 3) == Dual(1//1, -1//2)   
        @test 2 / Dual(1.0,2//2) == Dual(2.0,-4//2)
        @test Dual(1.0,2//2) / 2 == Dual(0.5, 2//4)
        
       end;

#-

using Test
@testset "Potenciación de duales" begin
        @test Dual(2,2.0) ^ 3 == Dual(8,24.0)   
        @test Dual(1.0,2//2) ^-1 == Dual(-1.0,-2//2)
     
        
       end;

#-

# Aqui hay un error de método, tal parece no funcionar potencias negativas. Será
# cuestión de implementar otro método donde se especifique que sucede con estas potencias dentro
# de la misma función que intentamos implementar.

#-

# ### Dual de f(x)

#-

# Definimos f(x) y f'(x) 

#-

f(x) = (3*x^2 -8*x + 5)/(7*x^3 - 1)

#-

df(x) = (-21*x^4 + 112*x^3 -105*x^2 -6x + 8) / (7*x^3 -1)^2

#-

# Creamos un dual para llamarlas

#-

function DualFx(x)
    return Dual(f(x),df(x))
end

#-

DualFx(1.0)

#-

DualFx(1//1)

#- 

# Vemos que los resultados son iguales y no, al evaluar el dual de forma racional no da como
# resultado la fracción exacta, a diferencia de usar un número entero(Julia al final lo trabaja como flotante)

#-

# Haciendo el álgebra de los duales:
# Recordemos que por definición de duales
# \begin{equation}
# \mathbb{D}f(x_0) = \big( f_0, f'_0\big) = \big( f(x_0), f'(x_0)\big)
# \end{equation}

#-

#Entonces

# \begin{equation}
# \mathbb{D}f(x_0) = (f(1), f'(1))  
# \end{equation}

#-

# Con la derivada obtenida anteriormente tenemos:

# \begin{equation}
# \mathbb{D}f(x_0) = \left( \frac{3(1)^{2} -8(1) + 5}{7(1)^{3} - 1}, \frac{-21(1)^{4} + 112(1)^{3} -105(1)^{2} -6(1) + 8} {(7(1)^{3} -1)^{2}} \right)
# \end{equation}

#-

# \begin{equation}
# \mathbb{D}f(x_0) = \left( \frac{0}{6}, \frac{-12}{36} \right)
# \end{equation}

#- 

# \begin{equation}
# \mathbb{D}f(x_0) = \left( 0, \frac{-1}{3} \right)
# \end{equation}