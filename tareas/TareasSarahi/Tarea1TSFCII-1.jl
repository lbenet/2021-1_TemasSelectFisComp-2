#using Pkg; Pkg.activate("../")
#
#Pkg.instantiate()

#function Newton(f,df,x0,N) #Definimos el método de Newton (necesita una función, su derivada, un x0 inicial y el número de #iteraciones)
#    c=0 #iniciamos un contador en cero 
#    x1=0.0
#    while c<N #si el contador es menor que el núemro de pasos deaseado, el ciclo continua
#        x1=x0-(f(x0)/df(x0)) #Newton
#        x0=x1 #renombramos la x0 inicial
#        c=c+1 #aumentamos en uno el contador a cada ciclo realizado
#    end
#    return x1 #devolvemos la raíz 
#end

#g(x)=x^2-2 #definimos la función (x^2-2)
#dg(x)=2x #su derivada

#Newton(g,dg,1,10) #probamos Newton en la función, (la solución es raíz de dos)

#sqrt(2)-Newton(g,dg,1,10)

#function errorlocal(f,df,x0,N,xreal) #definimos la función error, (necesita una función, su derivada, un x0 inicial, el número de #iteraciones y la raíz raíz rea)
#    #Definimos dos listas vacías para llenarlas con la raíz obtenida por el método de Newton para una N dada y con esa N
#    listax0=[] 
#    listaN=[]
    
#    for i=1:N
#        push!(listaN,i) #Llenamos la lista de N's
#        Ne=Newton(f,df,x0,N) 
#        push!(listax0,Ne) #Llenamos la lista de x0's para N dada
#    end
#    return(listaN,listax0) #Guardamos las dos listas en una lista 
#end

#using Plots
#gr(size=(240,150,1))

#xreal=sqrt(2)
#EL=errorlocal(g,dg,1,50,xreal)
##Graficamos las raíces obtenidas por el método de newton en función del número de pasos
plot(EL[1],EL[2], xlabel="N", ylabel="MétodoNewton(N)", title = "Error Newton", color="blue", label="Error", 
    legend = true, linewidth = 1, grid = true)

#creamos dos listas vacías para guardar las raíces obtenidas en función de la condición inicial x0 y la x0
#m=[] 
#m1=[]
#for i= -3:0.125:3 #cada valor que tome i es una condición inicial
#    push!(m,Newton(g,dg,i,10)) #llenamos la lista de las raíces en función de la x0
#    push!(m1,i)  #llenamos con las x0
#end

##Graficamos las raíces obtenidas por el método de newton en función del número de la cond. inicial
#scatter(m1,m, xlabel="x0", ylabel="MétodoNewton(x0)", title = "Método Newton", color="blue", 
#    legend = true, linewidth =0.5, grid = true)


#h(x)=(x-1)*(x-2)*(x-3) #difinimos la nueva función
#dh(x)=11-12*x + 3*x^2 #definimos su derivada


##creamos dos listas vacías para guardar las raíces obtenidas en función de la condición inicial x0 y la x0
#l=[]
#l1=[]
#for i= 1:0.125:4 #cada valor que tome i es una condición inicial
#    push!(l,Newton(h,dh,i,15)) #llenamos la lista de las raíces en función de la x0
#    push!(l1,i) #llenamos con las x0
#end

##Graficamos las raíces obtenidas por el método de newton en función del número de la cond. inicial
#scatter(l1,l, xlabel="x0", ylabel="MétodoNewton(x0)", title = "Método Newton", color="blue", 
#    legend = true, linewidth =0.5, grid = true)




