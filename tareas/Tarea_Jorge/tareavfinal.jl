using Pkg; Pkg.activate("../..")  # activa el "ambiente" de paquetes usados
Pkg.instantiate()  # descarga las dependencias de los paquetes

# # $$\textbf{Solución al ejercicio 1}$$
# Creamos la función del método de Newton, el cual acepta 4 parámetros que se describen a continuación
#
# - f la función la cual queremos calcular las raíces 
# - fprime la derivada de la funcion f
# - condición inicial o adivinanza de la que va a partir el cálculo 
# - itera indicar el número de iteraciones que va a usar el método de Newton

function newton(f,fprime,x0,itera) 
 x = x0 - (f(x0)/fprime(x0)) #metodo de newton 
    for i in 1:itera #Iniciamos el número de iteraciones que se van a hacer 
        x= x0 - (f(x0)/fprime(x0)) #Método de newton: iteraciones 
        x0 = x #actualizamos el valor x0 
    end 
 return x #raíz aproximada
end  

#Definimos la función f(x) y su derivada.

f(x)=x^2-2

fprime(x)=2x

newton(f,fprime,50.0,1000)

using Plots

# Creamos una nueva función, para observar la convergencia del método de Newton
# en función del número de iteraciones, tenemos ahora los sig. párametros
# - r_aproximada es una arreglo donde guardamos la aproximacion de cada raíz con cada iteración 
# - i es un arreglo donde simplemente guardamos el número de iteraciones

function convergencia_newton(f,fprime,x0,itera)
   global r_aproximada = Float64[]
   global i = Int64[]
   x=x0
    for j in 1.0:itera
        push!(i, j)
        push!(r_aproximada, x)
        x=newton(f,fprime,x0,j)
    end 
 return (i, r_aproximada)
end 

# Comprabamos que la función "convergencia_newton" funciona, 
# donde ingresamos la función f, su derivada fprime, la condición inicial x0 y 
# por último el número de iteraciones que se van a realizar

convergencia_newton(f,fprime, 10,7)

#Graficamos los datos obtenidos anteriormente, implementamos una nueva función
# que acepta como parámetros:
# la función a la cual queremos obtener una raíz: f
# la derivada de la función: fprime
# Una de las raíces reales de la función: r_real
# La condición inicial: x0
# El número de iteraciones que se van a realizar
# La salida de esta función nos mostrará la gráfica del error y
# de la raíz aproximada en función del número de iteraciones

function gr_error_raiz(f,fprime,r_real,x0,iteraciones)
    
    r_error = Float64[] #arreglo donde guardamos |xn - x*|
    aprox = convergencia_newton(f,fprime,x0,iteraciones) #llamamos a la función para generar la aproximación de la raíz 
    
      for j in 1:iteraciones
            push!(r_error, abs(aprox[2][j]-r_real) )
      end
    
a = scatter(aprox[1],aprox[2], xlabel="Iteraciones",ylabel="Aproximacion",title="Convergencia de newton", 
color="red",label="Raíz aproximada",legend=true,grid=true)
scatter!(aprox[1],r_error, color="blue",label="Error",legend=true) #graficamos nuestros resultados
  return a
end

# # $$\textbf{Solución al ejercicio 2}$$
# Realizamos el cálculo para difentes condiciones iniciales, creando una nueva función 
# llamda "newton_ci_cf(f,fprime,iteraciones,ci,cf,paso), donde usa parámetros que ya hemos definido anteriormente,
# y los nuevos parámetros, son los que vamos a describir
# la función acepta un parámetro llamdo ci que es la condición inicial
# y como es de esperarse cf es la condición final
# donde vamos a recorrer este intervalo (ci,cf) en tamaños de pasos del parémtro paso 
#como salida de esta función, nos mostrara la raíz calculada por el método de Newton en función de las condiones iniciales 

function newton_ci_cf(f,fprime,iteraciones,ci,cf,paso)
it = Float64[]
rz = Float64[]
  for j in ci:paso:cf
     raiz = newton(f,fprime,j,iteraciones)
     push!(rz, raiz)
     push!(it, j)
  end 
b=scatter(it, rz, xlabel="Condicion Inicial",ylabel="Aproximacion",title="Condicion inicial vs raíz aproximda",
    color="red",label="Raíz aproximada",legend=true,grid=true)
return b
end

#Repetimos la función anterior con las nuevas funciones g(x) y gprime(X)

g(x) = (x-1)*(x-2)*(x-3)
gprime(x)= 3x^2 -12x + 11
newton_ci_cf(g,gprime,15,1,3,0.025)

# Podemos observar que, como es de esperarse tenemos 3 raices diferentes debido a que tenemos una ecuacion de tercer grado
# dependiendo de la condicion inicial, es curioso ya que como se observa en la gráfica, hay intervalos donde la raíz da ciertos
# brincos, si ahora iteramos cerca de estos puntos de interés observamos lo siguiente

newton_ci_cf(g,gprime,15,1.3,1.7,0.004)

# Como observamos para el primer punto de interés el método de newton converge para pequeños intervalos a diferentes puntos, como se observa # en la gráfica, depende de la condición inicial, tenemos dos puntos interesantes pues sabemos que la derivada en el intervalo (1,2) es
# cero, esto haría que falle el método de newton para ciertos valores, el otro punto es que el punto medio de las raíces, es justo donde 
# el método tiene problema, entonces debido a esta situación es que el método de Newton tiene un comportamiento diferente al esperado, lo mismo pasa exactamente para el otro punto de interés, es decir, para 2.5, esto debido a que la derivada es cero, como se observa en la siguiente gráfica 

newton_ci_cf(g,gprime,15,2.3,2.7,0.004)