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
#-
#Definimos la estructura paramétrica llamada Dual
struct Dual{T <: Real}
    fun :: T
    der :: T
end
#-

#-
#Promoción automática cuando las entradas del dual no son del mismo tipo
Dual(x,y) = ( i = promote(x,y); Dual(i[1], i[2])) 
#-

#- 
#ejemplo de promoción automática 
x=Dual(1/3,2) 
#-

#-
#Los campos de Dual son der y fun
fieldnames(Dual) 
#-

#-
#definimos dos funciones fun y der que extraen los elementos del campo fun y der respectivamente que Dual contiene

function fun(Dual)
    return(Dual.fun)
end
function der(Dual)
    return(Dual.der)
end
#-

#-
#Ejemplo de la función fun 
print(fun(x))
#-

#-
#Ejemplo de la función der
print(der(x))
#-
"""
dualconstante 
como primera entrada una constante 
en consecuencia la segunda entrada es la derivada 
de la constante por lo que es cero
"""
# #### Dual de una constante

#-
#Definimos la función que regresa el dual de una constante
function dualconstante(x)
    return Dual(x, zero(x))
end
#-

#-
#ejemplo de la función dualconstante
dualconstante(3.2)
#-

# #### Dual de la función identidad 

"""
dualidentidad 
en la primera entrada con cualquier argumento 
en la segunda no da la función identidad, es decir, 1. 
"""
#-
#Definimos la función que regresa el dual de la función identidad evaluada en x
function dualidentidad(x)
    return Dual(x, one(x))
end
#-

#-
#ejemplo de la función dualconstante
dualidentidad(4)
#-

# #### Test

#-
#se promueve automaticamente
using Test
@testset "Definicion de las estructuras duales" begin 
    @test Dual(1/3, 2) == Dual(1/3, 2.0) 
    @test Dual(99.9, 0) == Dual(99.9, 0.0)
    @test dualconstante(3.2) == Dual(3.2, 0)
    @test dualidentidad(4) == Dual(4, 1)
end
#-

#-
#dual de una constante
using Test
@testset "Definicion de las estructuras duales" begin 
    @test dualconstante(1/3) == Dual(1/3,0.0) #Dual de una constante 
end
#-

#-
#dual de la función identidad
using Test
@testset "Definicion de las estructuras duales" begin 
    @test dualidentidad(4) == Dual(4, 1) #Dual de la identidad
end
#-

# $\textit{Ejercicio 2}$

# ## Aritmética de duales
#
# \begin{eqnarray}
#    \mathbb{D}{u} \pm \mathbb{D}{w} &=& \big( u_0 \pm w_0, \, u'_0\pm w'_0 \big),\\
#    \mathbb{D}{u} \times \mathbb{D}{w} &=& \big( u_0 \cdot w_0,\, u_0 w'_0 +  w_0 u'_0 \big),\\
#    \frac{\mathbb{D}{u}}{\mathbb{D}{w}} &=& \big( \frac{u_0}{w_0},\, \frac{ u'_0 - (u_0/w_0)w'_0}{w_0}\big),\\
#    {\mathbb{D}{u}}^\alpha &=& \big( u_0^\alpha,\, \alpha u_0^{\alpha-1} u'_0 \big).\\
# \end{eqnarray}
#
#
#
# Además, están los operadores unitarios, que satisfacen:
#
# \begin{equation}
#   \pm \mathbb{D}{u} = \big(\pm u_0, \pm u'_0 \big).
# \end{equation}

# - Implementen *todas* las operaciones aritméticas definidas arriba; 
# para `^` consideren sólo potencias enteras. 
# Estas operaciones deben incluir las operaciones aritméticas que 
# involucran un número cualquiera (`a :: Real`) y un dual (`b::Dual`), 
# o dos duales. Esto se puede hacer implementando (sobrecargando)
# los métodos específicos para estos casos (¡y que sirven en cualquier 
# órden!). 

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

# #### Operaciones aritméticas

#-
#Suma
import Base: +
+(D1::Dual, D2::Dual)=Dual(fun(D1)+fun(D2),der(D1)+der(D2))
+(D1::Dual, r::Real)=Dual(fun(D1)+r,der(D1))
+(r::Real,D1::Dual)=Dual(fun(D1)+r,der(D1))
+(D::Dual)=Dual(fun(D),der(D))
#-

#-
#Resta
import Base: -
-(D1::Dual, D2::Dual)=Dual(fun(D1)-fun(D2),der(D1)-der(D2))
-(D1::Dual, r::Real)=Dual(fun(D1)-r,der(D1))
-(r::Real,D1::Dual)=Dual(r-fun(D1),-der(D1))
-(D::Dual)=Dual(-fun(D),-der(D))
#-

#-
#Multiplicación
import Base: *
*(D1::Dual, D2::Dual)=Dual(fun(D1)*fun(D2),fun(D2)*der(D1)+fun(D1)*der(D2))
*(D1::Dual, r::Real)=Dual(fun(D1)*r,r*der(D1))
*(r::Real,D1::Dual)=Dual(fun(D1)*r,r*der(D1))
#-

#-
#División
import Base: /
/(D1::Dual, D2::Dual)=Dual(fun(D1)/fun(D2),(der(D1)-(fun(D1)/fun(D2))*der(D2))/fun(D2))
/(D1::Dual, r::Real)=Dual(fun(D1)/r,der(D1)/r)
/(r::Real,D1::Dual)=Dual(r/fun(D1),(0-(r/fun(D1))*der(D1))/fun(D1))
#-

#-
#Exponenciación 
import Base: ^
^(D1::Dual, i::Int)=Dual(fun(D1)^i,i*(fun(D1)^(i-1))*der(D1))
#-

# #### Equivalencia

#-
#Equivalencia 
import Base: == 
==(D1::Dual, D2::Dual) = (fun(D1) == fun(D2)) && (der(D1) == der(D2))
==(r::Real, D1::Dual) = (r == fun(D1)) && (0 == der(D1))
==(D1::Dual, r::Real) = (fun(D1) == r) && (der(D1) == 0)
#-

#-
#Diferente a la equivalencia
import Base: !=
!=(D1::Dual, D2::Dual) = (fun(D1) != fun(D2)) || (der(D1) != der(D2))
!=(r::Real, D1::Dual) = (r != fun(D1)) || (0 != der(D1))
!=(D1::Dual, r::Real) = (fun(D1) != r) || (der(D1) != 0)
#-

# #### Test2

#-
#Suma
 @testset "Suma de las estructuras duales" begin
        @test Dual(1.3, 1/3) + Dual(3, 2/3) == Dual(4.3, 1.0)
        @test 1.03 + Dual(3, 1) == Dual(4.03, 1.0)
        @test Dual(6.0, 8) + 29 == Dual(35.0, 8.0)
        @test +Dual(6.0, 8) == Dual(6.0, 8)
end;
#-

#-
#Resta
 @testset "Resta de las estructuras duales" begin
        @test Dual(1.3, 1/3) - Dual(3, 1/3) == Dual(-1.7, 0.0)
        @test 0 - Dual(3.0, 1) == Dual(-3.0, -1.0)
        @test Dual(6.0, 8.99) - 3 == Dual(3.0, 8.99)
        @test -Dual(3.0, 1) == Dual(-3.0, -1.0)
end;
#-

#-
#Multiplicación
 @testset "Multiplicación de las estructuras duales" begin
        @test Dual(1, 1) * Dual(3, 3) == Dual(3, 6)
        @test 0 * Dual(3.0, 1) == Dual(0.0, 0.0)
        @test -Dual(6.0, 2) * 3 == Dual(-18.0, -6.0)
end;
#-

#-
#División
 @testset "División de las estructuras duales" begin
        @test Dual(1, 1)/ Dual(1, 1) == Dual(1.0,0.0)
        @test 2 / -Dual(1.0, 1) == Dual(-2, 2)
        @test -Dual(6.0, 2) / -3 == Dual(2.0, 2/3)        
end;
#-

#-
#Exponenciación
 @testset "Exponenciación de las estructuras duales" begin
        @test Dual(1, 1)^4 == Dual(1,4)
        @test Dual(-1.0, 1)^4 == Dual(1.0,-4.0)
end;
#-

#-
#Equivalencia 
 @testset "Equivalencia entre estructuras duales" begin 
    @test Dual(1//4, 1//2) == Dual(0.25, 0.5)
    @test Dual(1, 5) != Dual(5, 1)
end;
#-

# $$f(x) = \frac{3x^2-8x+5}{7x^3-1}$$

# - Evalúen la función `f(x) = (3x^2-8x+5)/(7x^3-1)` en el dual
# `x₀ = 1 + \epsilon`, que representa la variable independiente
# en el punto $x_0=1$. Rehagan este inciso usando un dual
# en el punto $x_0=1$ usando aritmética de racionales.

#-
#Evaluamos f en el dual 1+\epsilon
x=Dual(1,1)
f=(3*x^2-8x+5)/(7*x^3-1)
print(f)
#-

# #### Evaluamos analíticamente la función $f$ y su derivada para verificar el resultado anterior

#-
function funcionf(x)
    (3*x^2-8x+5)/(7*x^3-1)
end
#-

#-
funcionf(1) 
#-

#-
function derivadaf(x)
    (8-6*x-105*x^2+112*x^3-21*x^4)/(-1+7*x^3)^2
end
#-

#-
derivadaf(1)
#-

# Por lo tanto tenermos que los resultados coinciden, ya que tenemos que la primera entra es 0 que corresponde con la función "funcionf" y la segunda entrada -0.333... coincide con la función "derivadaf", el resultado es consistente. 


# #### Aritmética de racionales
#-
funcionf(Dual(1//1,1//1)) 
#-

# Notemos que el resultado es $\frac{-1}{3}$ y no -0.3333333333333333, es decir, es el valor exacto de la derivada y no una proximación como en los casos anteriores.


# $\textit{Ejercicio 3}$

# - Recordando la regla de la cadena, extiendan el uso de `Dual` a 
#las funciones elementales: `sqrt`, `exp`, `log`, `sin`, `cos`,
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

# #### Funciones elementales

#-
import Base: sqrt
sqrt(D::Dual)= Dual(sqrt(fun(D)),(der(D)/(2*sqrt(fun(D)))))
#-

#-
sqrt(Dual(4,1.0))
#-

#-
import Base: exp
exp(D::Dual)= Dual(exp(fun(D)),der(D)*exp(fun(D)))
#-

#-
import Base: log
log(D::Dual)= Dual(log(fun(D)),fun(D)/der(D))
#-

#-
import Base: sin
sin(D::Dual)= Dual(sin(fun(D)),cos(fun(D))*der(D))
#-

#-
import Base: cos
cos(D::Dual)= Dual(cos(fun(D)),-sin(fun(D))*der(D))
#-

#-
import Base: tan
tan(D::Dual)= Dual(tan(fun(D)),der(D)*sec(fun(D)))
#-

#-
import Base: asin
asin(D::Dual)= Dual(asin(fun(D)),der(D)*(1/(1-fun(D)^2)^(1/2)))
#-

#-
import Base: acos
acos(D::Dual)= Dual(acos(fun(D)),der(D)*(-1/(1-fun(D)^2)^(1/2)))
#-

#-
import Base: atan
atan(D::Dual)= Dual(exp(atan(D)),der(D)*(1/(1+fun(D)^2)))
#-

#-
import Base: sinh
sinh(D::Dual)= Dual(sinh(fun(D)),der(D)*cosh(fun(D)))
#-

#-
import Base: cosh
cosh(D::Dual)= Dual(cosh(fun(D)),der(D)*sinh(fun(D)))
#-

#-
import Base: tanh
tanh(D::Dual)= Dual(tanh(fun(D)),der(D)*(1/(cosh(fun(d)))^2))
#-

#-
import Base: asinh
asinh(D::Dual)= Dual(asinh(fun(D)),der(D)*(1/(1+fun(D)^2)^(1/2)))
#-

#-
import Base: acosh
acosh(D::Dual)= Dual(acosh(fun(D)),der(D)*(1/(-1+fun(D)^2)^(1/2)))
#-

#-
import Base: atanh
atanh(D::Dual)= Dual(atanh(fun(D)),der(D)*(1/(1-fun(D)^2)))
#-

# ####Test's 

#-
#Raíz 
 @testset "Raíz cuadrada de duales" begin 
    @test sqrt(Dual(4, 1.0)) == Dual(2, 0.25)
    @test sqrt(Dual(1,1)) == Dual(1, 0.5)
end
#-

#-
#Exponencial 
@testset "Exponencial de Duales" begin 
    @test exp(Dual(0,1)) == Dual(1, 1)
    @test exp(Dual(2,3)) == Dual(exp(2), 3*exp(2))
end
#-

#-
#Logaritmo 
@testset "Logaritmo de Duales" begin 
    @test log(Dual(14,7)) == Dual(log(14), 2)
    @test log(Dual(2,3)) == Dual(log(2), 2/3)
end
#-

#-
#Función sin  
@testset "Función Sin de Duales" begin 
    @test sin(Dual(0,7)) == Dual(0, 7)
    @test sin(Dual(pi/2,1)) == Dual(1, cos(pi/2))
end
#-

#-
#Función cos 
@testset "Función Cos de Duales" begin 
    @test cos(Dual(0,2)) == Dual(1, 0)
    @test cos(Dual(2*pi,2)) == Dual(1,-sin(2*pi)*2)
end
#-

#-
#Función tan  
@testset "Función Tan de Duales" begin 
    @test tan(Dual(1,0)) == Dual(tan(1),0)
    @test tan(Dual(3,5)) == Dual(tan(3),5*sec(3))
end
#-

#-
#Función aSin   
@testset "Función aSin de Duales" begin 
    @test asin(Dual(1,-0.5)) == Dual(asin(1), -Inf )
    @test asin(Dual(0.0,-0.5)) == Dual(0.0, -0.5)
end
#-

#-
#Función aCos  
@testset "Función aCos de Duales" begin 
    @test acos(Dual(0,1)) == Dual(acos(0), -1)
    @test acos(Dual(1,2)) == Dual(0.0, -Inf)
end
#-

#-
#Función aTan 
@testset "Función aTan de Duales" begin 
    @test atan(Dual(1,0)) == Dual(atan(1), 0)
    @test atan(Dual(1,2)) == Dual(atan(1), 1)
end
#-

#-
#Función sinh  
@testset "Función Sinh de Duales" begin 
    @test sinh(Dual(1,0)) == Dual(sinh(1), 0)
    @test sinh(Dual(1,3)) == Dual(sinh(1), 3*cosh(1))
end
#- 

#-
#Función cosh  
@testset "Función Cosh de Duales" begin 
    @test cosh(Dual(1,0)) == Dual(cosh(1), 0)
    @test cosh(Dual(1,3)) == Dual(cosh(1), 3*sinh(1))
end
#-

#-
#Función tanh 
@testset "Función Tanh de Duales" begin 
    @test tanh(Dual(0,2)) == Dual(0, 2)
    @test tanh(Dual(1,2)) == Dual(tanh(1), 2*(1/(cosh(1)^2)))
end
#-

#-
#Función asinh
@testset "Función Tanh de Duales" begin 
    @test asinh(Dual(0,1)) == Dual(0, 1)
    @test asinh(Dual(1,2)) == Dual(asinh(1), 2*(1/(1+1^2)^(1/2)))
end
#-

#-
#Función acosh
@testset "Función aCosh de Duales" begin 
    @test acosh(Dual(2,0)) == Dual(acosh(2),0)
    @test acosh(Dual(2,2)) == Dual(acosh(2), 2*(1/(-1+2^2)^(1/2)))
end
#-

#-
#Función atanh 
@testset "Función aTanh de Duales" begin 
    @test atanh(Dual(0.5,0)) == Dual(atanh(0.5), 0)
    @test atanh(Dual(0.5,2)) == Dual(atanh(0.5), 2*(1/(1-0.5^2)))
end
#-

# $$h(x)=\sin(x^3−2/x^6)\textit{  con x=}2$$

#-
y=Dual(2,1)
hdual=sin(y^3-2/y^6)
print(hdual)
#-

#-
#Para verificar el resultado definimos la función h y su derivada (calculada en wolfram)
h(x)=sin(x^3-2/x^6) 
dh(x)=(3*(4 + x^9)*cos((2 - x^9)/x^6))/x^7
l=[h(2),dh(2)]
print(l)
#-

#-
#Notemos que los resultados son idénticos 
#restamos el valor de la función según el dual y el obtenido analíticamente
#restamos el valor de la derivada según el dual y el obtenido analíticamente
#ambas restas dan cero
[fun(hdual)-l[1],der(hdual)-l[2]]
#-


# #### Gráfica de $h(x)=\sin(x^3−\frac{2}{x^6})$  para $x\in[1,5]$

#-
#Generaremos una lista con los valores de der(hdual) para x0 en (0,5], luego graficaremos la lista en ese intervalo
#Para crear la lista, definimos una lista vacia y con un ciclo for, agregamos los valores de la derivada 
#la derivada la obtenemos usando la función der en sin(j^3-2/j^6) con j el dual i+1epsilon (i cambia en [0,5])

#también generaremos una lista con los valores de la derivada "reales", es decir, la derivada calculada en Wolfram

#lista vacía para la "h' dual" (la derivada de h obtenida con los duales)
Dhdual=[]
#lista vacía para la "h' analítica" (la derivada de h calculada en wolfram)
Dh=[]
#lista vacía para el dominio de h
dom=[] 
#lista vacía para el dominio h en escala logarítmica 
domlog=[]
for i in 0.5:0.001:5
    j=Dual(i,1)
    hdual2=Float64(der(sin(j^3-2/j^6)))
    push!(Dhdual,hdual2) #llenamos con la h'dual evaluada en el dual (i,1)
    push!(Dh,dh(i)) #llenamos con la h analítica evaluada en i
    push!(domlog,log(i)) #llenamos con log(i)
    push!(dom,i) #llenamos con i
    
end
#-

#-
#Ahora graficaremos cada una de las listas (primero por separado, luego en una misma imagen) para compararlas

derivadah=[Dhdual,Dh]

p1=plot(dom,Dhdual,xlabel="x",ylabel="h(x)",title="h' dual",label ="h'(x)") 

p2=plot(dom,Dh,xlabel="x",ylabel="h(x)",title="h' analítica",label ="h'(x)") 

p3=plot(dom,derivadah,xlabel="x",ylabel="h(x)",title="Ambas",label = ["h' dual" "h' analítica"]) 

plot(p1, p2, p3, layout = (3, 1), legend = true)
plot!(size=(600,1200))
#-

# Se puede apreciar que la derivada es una oscilación infinita cerca del cero, por este motivo, a continuación se graficará en escala logarítmica, así se podrá apreciar mejor el comportamiento en esa zona.

#-
#Nuevamente graficaremos cada una de las listas para compararlas (ahora en escala logarítmica).

p1=plot(domlog,Dhdual,xlabel="x",ylabel="h(x)",title="h' dual",label ="h'(x)") 

p2=plot(domlog,Dh,xlabel="x",ylabel="h(x)",title="h' analítica",label ="h'(x)") 

p3=plot(domlog,derivadah,xlabel="x",ylabel="h'(x)",title="Ambas",label = ["h' dual" "h' analítica"]) 

plot(p1, p2, p3, layout = (3, 1), legend = true)
plot!(size=(600,1200))
#-

# Nota, se graficó en el intervalo (0.5,5) pues dado que la función es una oscilación infinita cerca de cero y no es acotada, los valores pequeños en el dominio son, bajo la función, muy grandes. Esto repercute en que la escala de los ejes se hace más grande y no se aprecian las oscilaciones adecuadamente.
# No obstante, los valores de h' dual son idénticos a los de h' analítica aún cerca de cero como se muestra en la siguiente gráfica.

#-
Dhdual2=[]
Dh2=[]
dom2=[]
domlog2=[]
for i in 0.1:0.001:5
    j=Dual(i,1)
    hdual2=Float64(der(sin(j^3-2/j^6)))
    push!(Dhdual2,hdual2)
    push!(Dh2,dh(i))
    push!(domlog2,log(i))
    push!(dom2,i)
    
end

derivadah2=[Dhdual2,Dh2]
plot(dom2,derivadah2,xlabel="x",ylabel="h'(x)",title="Ambas",label = ["h' dual" "h' analítica"]) 
#-



# $\textit{Ejercicio 4}$

# Argumenten qué podrían hacer para extender la idea de los `Dual` 
# y calcular derivadas aún más altas. (Como ejemplo concreto, consideren 
# el obtener la derivada 18 de funciones como las que hemos usado arriba.)
#commit