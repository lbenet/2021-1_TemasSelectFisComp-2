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

Dual(x, y) = Dual( promote(x, y)... )
#-


# - Definan los métodos apropiados para que el Dual de una 
# constante (`Real`), i.e., `Dual(c)` se comporte como debe, y 
# que la función `dual` represente la función identidad (o 
# variable independiente).

Dual(c::Real) = Dual(c, zero(c))

"""
    dual(x0) -> Dual(x0, 1)

Regresa el dual de la función identidad f(x) = x evaluada en x0.
"""
function dual(x0)
    return Dual(x0, one(x0))
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
+(c::Real, D::Dual) = Dual( c + D[1], D[2])
+(D::Dual, c::Real) = c + D
#-

# ### Multiplicación.

*(D1::Dual, D2::Dual) = Dual(D1[1] * D2[1], D1[1] * D2[2] + D2[1] * D1[2])
*(c::Real, D::Dual) = Dual(c * D[1], c * D[2])
*(D::Dual, c::Real) = c * D
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
-(D1::Dual, D2::Dual) = Dual(D1[1] - D2[1], D1[2] - D2[2])
-(c::Real, D::Dual) = Dual(c - D[1], - D[2])
-(D::Dual, c::Real) = Dual(D[1] - c, D[2])
#-

# ### División.

/(D1::Dual, D2::Dual) = Dual(D1[1] / D2[1], (D1[2] * D2[1] - D1[1] * D2[2]) / D2[1]^2)
/(c::Real, D::Dual) = Dual(c / D[1], - c * D[2] / D[1]^2)
/(D::Dual, c::Real) = inv(c) * D
#-

# - Implementen la comparación (equivalencia) entre duales (`==`). 

==(D1::Dual, D2::Dual) = (D1[1] == D2[1]) && (D1[2] == D2[2])
==(c::Real, D::Dual) = (c == D[1]) && (0 == D[2])
==(D::Dual, c::Real) = ==(c::Real, D::Dual)
#-

!=(D1::Dual, D2::Dual) = (D1[1] != D2[1]) || (D1[2] != D2[2])
!=(c::Real, D::Dual) = (c != D[1]) || (0 != D[2])
!=(D::Dual, c::Real) = !=(c::Real, D::Dual)
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

f(x) = (3x^2-8x+5)/(7x^3-1)
f(1)
#-

# Sean $f_1(x) = 3x^2-8x+5$ y $f_2(x) = 7x^3-1$ de tal forma 
# que $f(x) = f_1(x) / f_2(x)$.

f1(x) = 3 * x^2 - 8 * x + 5
f1_prime(x) = 6 * x - 8
Df1(x) = Dual(f1(x), f1_prime(x))
#-

f2(x) = 7 * x^3 - 1
f2_prime(x) = 21 * x^2
Df2(x) = Dual(f2(x), f2_prime(x))
#-

Df1(1) / Df2(1)
#-

# - Evalúen analíticamente (usando el álgebra  de duales) la 
# función `f(x)` en la variable independiente en $x_0=1$, a fin 
# de verificar que el resultado obtenido es el correcto.

Df(x) = (3 * dual(x)^2 - 8 * dual(x) + 5) / (7 * dual(x)^3 - 1)
Df(1)
#-

# Se obtuvo, por lo tres métodos, que $f(1) = 0$. En ambos 
# métodos en los que usaron duales también se obtuvo que 
# $f'(1) = - 1 / 3$. Sin embargo, de los dos métodos con duales, 
# el segundo fue más práctico ya que en el primero fue necesario 
# escribir explícitamente un par de derivadas.

# ## 3
# 
# - Recordando la regla de la cadena, extiendan el uso de `Dual` a 
# las funciones elementales: `sqrt`, `exp`, `log`, `sin`, `cos`,
# `tan`, `asin`, `acos`, `atan`, `sinh`, `cosh`, `tanh`, `asinh`,
# `acosh`, `atanh`.

import Base: sqrt, exp, log, sin, cos, tan, asin, acos, atan, sinh, cosh, tanh, asinh, acosh, atanh
#-

### Raíz

sqrt(D::Dual) = (aux = sqrt(D[1]) ; Dual(aux, D[2] / (2 * aux)) )
#-

### Exponencial

exp(D::Dual) = Dual(exp(D[1]), D[2] * exp(D[1]))
^(b, D::Dual) = Dual(b^D[1], D[2] * log(b) * b^D[1])
#-

### Logaritmo

log(D::Dual) = Dual(log(D[1]), D[2] / D[1])
log(b, D::Dual) = Dual( log(b, D[1]), D[2] / (log(b) * D[1]) )
#-

### Trigonométricas

sin(D::Dual) = Dual(sin(D[1]), D[2] * cos(D[1]))
cos(D::Dual) = Dual(cos(D[1]), - D[2] * sin(D[1]))
tan(D::Dual) = Dual(tan(D[1]), D[2] / cos(D[1])^2)
#-

### Trigonométricas inversas

asin(D::Dual) = Dual( asin(D[1]), D[2] / sqrt(1 - D[1]^2) )
acos(D::Dual) = Dual( acos(D[1]), - D[2] / sqrt(1 - D[1]^2) )
atan(D::Dual) = Dual( atan(D[1]), D[2] / (1 + D[1]^2) )
#-

### Hiperbólicas

sinh(D::Dual) = Dual(sinh(D[1]), D[2] * cosh(D[1]))
cosh(D::Dual) = Dual(cosh(D[1]), D[2] * sinh(D[1]))
tanh(D::Dual) = Dual( tanh(D[1]), D[2] / cosh(D[1])^2 )
#-

## Hiperbólicas inversas

asinh(D::Dual) = Dual( asinh(D[1]), D[2] / sqrt(1 + D[1]^2) )
acosh(D::Dual) = Dual( acosh(D[1]), D[2] / sqrt(D[1]^2 - 1) )
atanh(D::Dual) = Dual(atanh(D[1]), D[2] / (1 - D[1]^2))
#-

# - Muestren que su implementación da los resultados que se esperan 
# usando pruebas como hicieron en ejercicios anteriores.

@testset "Funciones sobre Duales" begin
    
    @testset "Raíz" begin
        @test sqrt( dual(1) ) == Dual(1, 1 / 2)
        @test sqrt( dual(4) ) == Dual(2, 1 / 4)
        @test sqrt( dual(9) ) == Dual(3, 1 / 6)
    end
    
    @testset "Exponencial" begin
        @test exp( dual(0) ) == Dual(1, 1)
        @test exp( dual(2) ) == Dual(exp(2), exp(2))
        @test 2^( dual(1)) == Dual(2, 2 * log(2) )
        @test 3^( dual(3)) == Dual(27, 27 * log(3) )
    end
    
    @testset "Logaritmo" begin
        @test log( dual(1) ) == Dual(0, 1)
        @test log( dual(exp(1)) ) == Dual(1, 1 / exp(1))
        @test log(10, dual(10^3)) == Dual(log(10, 10^3), 1 / (log(10) * 10^(3))) 
        @test log(2, dual(1024) ) == Dual(10, 1 / (log(2) * 1024) )
    end

    @testset "Trigonométricas" begin
        @test sin( dual(0) ) == Dual(0, 1)
        @test sin( dual(π / 2) ) == Dual(1, cos(π / 2))
        @test cos( dual(π / 2) ) == Dual(cos(π / 2), -1)
        @test cos( dual(π) ) == Dual(-1, -sin(π))
        @test tan( dual(5 * π / 4) ) == Dual(tan(5 * π / 4), sec(5 * π / 4)^2)
        @test tan( dual(0) ) == Dual(0, 1)
    end
    
    @testset "Trigonométricas Inversas" begin
        @test asin( dual(0) ) == Dual(0, 1)
        @test asin( dual(1 / 2) ) == Dual( asin(1 / 2), 2 / sqrt(3))
        @test acos( dual(0) ) == Dual(π / 2, - 1)
        @test acos( dual(1 / 2) ) == Dual( acos(1 / 2), - 2 / sqrt(3))
        @test atan( dual(0) ) == Dual(0, 1)
        @test atan( dual(1) ) == Dual(π / 4, 1 / 2)
    end
    
    @testset "Hiperbólicas" begin
        @test sinh( dual(0) ) == Dual(0, 1)
        @test sinh( dual(log(2)) ) == Dual(3 / 4, 5 / 4)
        @test cosh( dual(0) ) == Dual(1, 0)
        @test cosh( dual(log(3)) ) == Dual(5 / 3, 4 / 3)
        @test tanh( dual(0) ) == Dual(0, 1)
        @test tanh( dual(log(5)) ) == Dual(12 / 13, sech(log(5))^2)
    end
    
    @testset "Hiperbílicas Inversas" begin
        @test asinh( dual(1) ) == Dual(asinh(1), 1 / sqrt(2))
        @test asinh( dual(sqrt(3)) ) == Dual(asinh(sqrt(3)), 1 / sqrt(1 + sqrt(3)^2))
        @test acosh( dual(sqrt(2)) ) == Dual(acosh(sqrt(2)), 1 / sqrt(sqrt(2)^2 - 1))
        @test acosh( dual(2) ) == Dual(acosh(2), 1 / sqrt(3))
        @test atanh( dual(1 / sqrt(2)) ) == Dual(atanh(1 / sqrt(2)), 1 /( 1 - (1 / sqrt(2))^2 ))
        @test atanh( dual(1 / 2) ) == Dual(atanh(1 / 2), 4 / 3)
    end
    
end;
#-

# - Calculen la derivada de $h(x)=\sin(x^3−2/x^6)$ en $x_0=2$. ¿Qué 
# tan preciso es el resultado? (Pueden usar cualquier otra manera 
# de obtener el resultado correcto, sólo tienen que ser claros 
# en la explicación.)

# De la regla de la cadena se tiene que
# 
# $$ h'(x) = \left( 3 x^2 + \frac{12}{x^7} \right) \cos\left( x^3 - \frac{2}{x^6} \right) .$$

h_prime(x) = (3 * x^2 + 12 / x^7) * cos(x^3 - 2 / x^6)
h_prime(2)
#-

Dh(x) = sin(dual(x)^3 - 2 / dual(x)^6)
Dh(2)
#-

abs(Dh(big(2))[2] - h_prime(big(2)))
#-

# Tanto por el método analítico como usando duales, se obtiene 
# que $h'(2) = -1.384934905523464$.

# - Grafiquen, para $x_0\in[1,5]$ la función $h^\prime(x)$.

using Pkg; Pkg.activate("../")  # activa el "ambiente" de paquetes usados
Pkg.instantiate()  # descarga las dependencias de los paquetes
using Plots
#-

der(D::Dual) = D.der
x = 1:10^(-3):5
y1 = der.(Dh.(x))
y2 = h_prime.(x)
Δy = abs.(y1 - y2)
min(Δy...), max(Δy...)
#-

# En los puntos evaluados, el cálculo de $h'(x)$ usando duales, 
# difiere a lo más en decimoquinta cifra decimal. Por esta razón,
# debe ser imposible distinguir entre las gráficas hechas por ambos métodos.

plot(x, y1, legend = :bottomleft, ylabel = "h'(x)", xlabel ="x", label = "Dual", lw = 3)
plot!(x, y2, label = "Analítica", ls = :dash, lw = 3)
#-

# ## 4
# 
# Argumenten qué podrían hacer para extender la idea de los `Dual` 
# y calcular derivadas aún más altas. (Como ejemplo concreto, consideren 
# el obtener la derivada 18 de funciones como las que hemos usado arriba.)
#- 

# Ya se ha hecho bastante trabajo, así que se podría trabajar con duales 
# de tal forma que las partes función y derivada de un dual fuera las 
# derivadas diecisite y dieciocho de una función. Ahora el único trabajo 
# se vuelvo llegar a dichas derivadas a partir de la función misma...
#
# Una primera, que Luis me terminó de aclarar, es la de extender la 
# idea de dual de tal forma que considera dervidas de orden superior.
# Se se desea trabajar hasta con la $n$ ésima derivada, entonces el 
# objeto de interés no sería un par ordenadado sino todo un vector de
# $n + 1$ entradas, donde la entrada $m$ corresponde a la $m$ ésima derivada
# de $f(x)$ evaluada en $x_0$. Esto es
#
# $$ \mathbb{D}f(x_0) = \big( f^{(0)}(x_0), f^{(1)}(x_0), f^{(2)}(x_0), \dots, f^{(n)}(x_0) \big) = f^{(0)}(x_0) + \epsilon f^{(1)}(x_0) + \epsilon^2 f^{(2)}(x_0) + ... + \epsilon^n f^{(n)}(x_0) ,$$
#
# donde se ha preservado la notación $\mathbb{D}f(x_0)$ para los duales
# normales y donde el exponente indica el orden de la derivada. Nótese 
# que ahora se considera que $\epsilon$ es tal que $\epsilon^{n + 1} = 0$.
# 
# La ventaja de este método es que no agrega ninguna dificultad a la hora 
# de definir los nuevos duales para la función constane y la función 
# identidad, ya que el resto de entradas tendrán el mismo valor de cero.
# Donde entra el trabajo es en redefinir las operaciones entre duales
# así como las funciones sobre duales. De hecho, para obtener una 
# derivada de orden dieciocho, este trabajo se vuelve monumental, por lo 
# que éste no es un método adecuado para proceder.
#
# 
