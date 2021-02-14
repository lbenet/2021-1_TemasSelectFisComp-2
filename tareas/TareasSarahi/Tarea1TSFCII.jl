# # $$\textit{Tarea 1, Método de Newton}$$
# $$\textit{García González Yesenia Sarahí}$$


using Pkg; Pkg.activate("../../")
#-
Pkg.instantiate()
#-
Pkg.add("Plots")
#-

# ### Ejercicio 1
#-

# #### Función Método de Newton
#-
"""
   Newton(f,df,x0,N)

Definición del método de Newton, donde los argumentos son: 
f - Función de la que obtendremos sus raíces
df - Derivada de f
x0 - Punto del dominio de f donde comienza la iteración
N - Número de iteraciones

La función devuelve una aproximación a la raíz de f más cercana a x0
...
"""

function Newton(f,df,x0,N) 
    x1=0.0
    for i in 1:N
        x1=x0-(f(x0)/df(x0)) #Newton
        x0=x1 #renombramos la x0 inicial
    end
    return x1 #devolvemos la raíz 
end

#-
g(x)=x^2-2
dg(x)=2x
#-

#probamos Newton en la función, (la solución es raíz de dos)
Newton(g,dg,1,9) 

#-

#Para ver qué tan preciso fue el resultado, hacemos la diferencia entre raíz de dos y lo obtenido
sqrt(2)-Newton(g,dg,1,10)
#-

# Notemos que la diferencia entre la aproximación de la raíz obtenida con el Método de Newton y la raíz real es del orden $10^{-6}$
#-

# #### Error y convergencia
#-

using Plots
#-
"""
   errorlocal(f,df,x0,N,xreal)

Definición del método de Newton, donde los argumentos son: 
f - Función de la que obtendremos sus raíces
df - Derivada de f
x0 - Punto del dominio de f donde comienza la iteración
N - Número de iteraciones
xreal - Raíz exacta de la función f
La función devuelve la diferencia entre la aproximación del método de Newton y la 
raíz exacta en función del número de iteraciones que realiza la función Newton.
...
"""

function errorlocal(f,df,x0,N,xreal) 
#Definimos dos listas vacías para llenarlas con la raíz obtenida por el método de Newton para una N dada y con el log(N) simplemente para graficar en escala logarítmica
    listax0=BigFloat[] 
    listaN=Float64[]
    
    for i=1:N
        push!(listaN,log(i)) #Llenamos la lista con log(i)
        Ne=Newton(f,df,x0,i) 
        push!(listax0,abs(Ne-xreal)) #Llenamos la lista de x0's para N dada
        
    end
    return(listaN,listax0) #Guardamos las dos listas en una lista 
end

#-

#Error en función del número de pasos.

xreal=BigFloat(sqrt(2))
EL=errorlocal(g,dg,1,50,xreal)
#Graficamos las raíces obtenidas por el método de newton en función del número de pasos
scatter(EL[1],EL[2], xlabel="ln(N)", ylabel="MétodoNewton(N)", title = "Error Newton", color="blue", label="Error", 
    legend = true, linewidth = 1, grid = true)
#-

# En la gráfica anterior se aprecia que el error es inversamente proporcional al número de iterados. Es decir, Newton converge a medida que N$\rightarrow\infty$.
# Nota: graficamos en función de $ln(N)$ para apreciar mejor la región cercana al cero.
#-

# $\textit{Ejercicio 2}$
#-

# #### Dependencia de la raíz encontrada en términos de la condición inicial para $f(x)=x^2-2$
#-

#creamos dos listas vacías para guardar las raíces obtenidas en función de la condición inicial x0 y la x0
m=Float64[] 
m1=Int[]
for i= -3:0.125:3 #cada valor que tome i es una condición inicial
    push!(m,Newton(g,dg,i,10)) #llenamos la lista de las raíces en función de la x0
    push!(m1,i)  #llenamos con las x0
end
#-

#Graficamos las raíces obtenidas por el método de newton en función del número de la cond. inicial
scatter(m1,m, xlabel="x0", ylabel="MétodoNewton(x0)", title = "Método Newton", color="blue", 
    legend = true, linewidth =0.5, grid = true)
#-

# La función $x^{2}-2$ tiene dos raíces. En la gráfica anterior se aprecia que para $x_0$<0, el método de Newton aproxima la raíz $x=-\sqrt{2}$ y para $x_0$>0, aproxima la raíz $x=\sqrt{2}$. \\
# La raíz obtenida sí depende de la condición inicial. El método regresará una u otra raíz dependiendo de cuál esté más cerca a la $x_0$
#-

# #### Dependencia de la raíz encontrada en términos de la condición inicial para f(x)=(x-1)(x-2)(x-3) 
#-

h(x)=(x-1)*(x-2)*(x-3) #difinimos la nueva función
dh(x)=11-12*x + 3*x^2 #definimos su derivada
#-

#creamos dos listas vacías para guardar las raíces obtenidas en función de la condición inicial x0 y la x0
l=Float64[]
l1=Int[]
for i= 1:0.01:3 #cada valor que tome i es una condición inicial
    push!(l,Newton(h,dh,i,15)) #llenamos la lista de las raíces en función de la x0
    push!(l1,i) #llenamos con las x0
end
#-

#Graficamos las raíces obtenidas por el método de newton en función del número de la cond. inicial
scatter(l1,l, xlabel="x0", ylabel="Newton(x0)", title = "Método Newton(x_0)", color="blue", 
    legend = true, linewidth =0.5, grid = true)
#-

# El paso se eligió arbitrariamente (antes era $0.125$, ahora $0.01$), lógicamente, cuanto más pequeño es, más puntos hay en la gráfica. 

#-

# La función $(x-1)(x-2)(x-3)$ tiene tres raíces. En la gráfica anterior de aprecia que para $x_0$<1.5, el método de Newton aproxima la raíz $x=1$ y para 1.5<$x_0$<2.5, aproxima la raíz $x=2$ y para $x_0$>2.5 aproxima la raíz $x=3$. \
# La raíz obtenida sí depende de la condición inicial. El método regresará una u otra raíz dependiendo de cuál esté más cerca a la $x_0$



