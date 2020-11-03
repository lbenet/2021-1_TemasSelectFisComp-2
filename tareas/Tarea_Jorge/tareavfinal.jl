using Pkg; Pkg.activate("../")  # activa el "ambiente" de paquetes usados
Pkg.instantiate()  # descarga las dependencias de los paquetes

# # $$\textbf{Solución al ejercicio 1}$$
# Creamos la función del metodo de Newton, acepta 4 parametros que describimos a continuación
#
# - f la función la cual queremos calcular las raíces 
# - fprime la derivada de la funcion f
# - condición inicial o adivinanza de la que va a partir el calculo 
# - itera indicar el número de iteraciones que va a usar el método de Newton

function newton(f,fprime,x0,itera) 
    x = x0 - (f(x0)/fprime(x0)) #metodo de newton 
    cont= 0.0 #iniciamos un contador 
    while cont < itera #inicimos las iteraciones 
        x= x0 - (f(x0)/fprime(x0)) #metodo de newton iteraciones 
        x0 = x #actualizamos el valor x0 
        cont = cont + 1  #aumentamos el valor del contador 
    end 
    return x #raíz aproximada
end  

#Definimos la función f(x) y su derivada.

f(x)=x^2-2

fprime(x)=2x

newton(f,fprime,50.0,1000)

using Plots
# Creamos la función para calcular el error 
# - r_aprox es una arreglo donde guardamos el numero de iteraciones y la aproximacion de cada raiz con cada iteracion 
#-
#r=x* una de las raices de la funcion f(x)
#r=x* una de las raices de la funcion f(x)
function con_newton(f,fprime,x0,itera)
     r_aprox=[]
    x=x0
    for j in 1.0:itera
        push!(r_aprox, (j,x))
        x=newton(f,fprime,x0,j)
        #println(r_aprox)
    end 
    return r_aprox
end 

con_newton(f,fprime, 10.0,7)

#graficamos nuestros datos obtenidos
#
#- en el arreglo i guardamos las iteraciones 
#- en el arreglo r guardamos la aproximacion de la raiz 
#- en el arreglo r_error guardamos el error de la funcion |xn - x*|
#- ademas definimos una raiz de la funcion f, para obtener el arreglo anterior y medir la precision 
#- graficamos el error 
#- graficamos la raiz calculada


i=[]
r=[]
r_error=[]
iteraciones=10.0
r_real=sqrt(2)
aprox= con_newton(f,fprime,10.0,iteraciones,r_real)
for j in 1:iteraciones
push!(r,aprox[j][2])
push!(i,aprox[j][1])
end

for j in 1:iteraciones
   # while abs(r[j]-r_real) > 1
    push!(r_error, abs(r[j]-r_real) )
    push!(i_error, j)
    #println(j)
    #end
end

scatter(i,r, xlabel="Iteraciones",ylabel="Aproximacion",title="Convergencia de newton", color="red",label="Raíz aproximada",
legend=true,grid=true)
scatter!(i,r_error, color="blue",label="Error",legend=true)

# # $$\textbf{Solución al ejercicio 2}$$
# Realiamos el calculo para difentes condiciones condiciones iniciales 
# - usamos un ciclo for para recorrer de 1 a 3 en pasos de 0.125
# - guardamos en el arreglo i el rango que recorre las condiciones iniciales 
# - guardamos la raiz calculada en el arreglo d

iteraciones=10.0
i=[]
d=[]
for j in -3:0.125:3
raiz = newton(f,fprime,j,iteraciones)
    push!(d, raiz)
    push!(i, j)
end 

scatter(i,d, xlabel="Condicion Inicial",ylabel="Aproximacion",title="Condicion inicial vs raíz aproximda",
    color="red",label="Raíz aproximada",
legend=true,grid=true)

#Repetimos las funciones anteriores con las nuevas funciones g(x) y gprime(X)

g(x) = (x-1)*(x-2)*(x-3)
gprime(x)= 3x^2 -12x + 11

iteraciones=20.0
i=[]
d=[]
for j in 1:0.025:3
raiz = newton(g,gprime,j,iteraciones)
    push!(d, raiz)
    push!(i, j)
end 

scatter(i,d, xlabel="Condicion Inicial",ylabel="Aproximacion",title="Condicion inicial vs raíz aproximda",
    color="red",label="Raíz aproximada",legend=true,grid=true)

# Podemos observar que, como es de esperarse tenemos 3 raices diferentes debido a que tenemos una ecuacion de tercer grado
# dependiendo de la condicion inicial