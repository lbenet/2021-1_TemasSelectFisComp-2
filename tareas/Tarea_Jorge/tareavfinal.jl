using Pkg; Pkg.activate("../")  # activa el "ambiente" de paquetes usados
Pkg.instantiate()  # descarga las dependencias de los paquetes

# Solución a la tarea

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

f(x)=x^2-2

fprime(x)=2x

newton(f,fprime,50.0,1000)

using Plots

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

con_newton(f,fprime, 10.0,7,sqrt(2))

i=[]
r=[]
r_error=[]
iteraciones=10
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

