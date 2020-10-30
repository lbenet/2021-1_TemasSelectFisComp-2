## $$\textbf{Tarea 1}$$
#$$\textit{García González Yesenia Sarahí}$$


#using Pkg; Pkg.activate("../")

#Pkg.instantiate()
# $\textit{1. Método de Newton}$
#function Newton(f,df,x0,N)
#    c=0
#    x1=0.0
#    while c<N
#        x1=x0-(f(x0)/df(x0))
#        x0=x1
#        c=c+1
#    end
#    return x1
#end

#g(x)=x^2-2
#dg(x)=2x

#Newton(g,dg,1,10)

#$\textit{2. Error y convergencia}$

#function errorlocal(f,df,x0,N,xreal)
#    listax0=[]
#    listaN=[]
    
#    for i=1:N
#        push!(listaN,i)
#        Ne=Newton(f,df,x0,N)
#        push!(listax0,Ne)
#    end
#    return(listaN,listax0)
#end

#using Plots
#gr(size=(300,200))

#plotattr("size")

#Error en función del número de pasos.

#xreal=sqrt(2)
#EL=errorlocal(g,dg,1,50,xreal)

#scatter(EL[1],EL[2], xlabel="x", ylabel="f(x)", title = "Error Newton", color="blue", label="Error", 
#    legend = true, linewidth = 1, grid = true)

#$\textit{3. Dependencia de la raíz encontrada en términos de la condición inicial para }f(x)=x^2-2 $

#m=[]
#m1=[]
#for i= -3:0.125:3
#    push!(m,Newton(g,dg,i,10))
#    push!(m1,i)
#end

#plot(m1,m, xlabel="x", ylabel="f(x)", title = "Error Newton", color="blue", label="Error", 
#    legend = true, linewidth = 1, grid = true)

#$\textit{4. Dependencia de la raíz encontrada en términos de la condición inicial para }f(x)=(x-1)(x-2)(x-3) $

#h(x)=(x-1)*(x-2)*(x-3)
#dh(x)=11-12*x + 3*x^2


#l=[]
#l1=[]
#for i= 1:0.125:3
#    push!(l,Newton(h,dh,i,15))
#    push!(l1,i)
#end

#scatter(l1,l, xlabel="x", ylabel="f(x)", title = "Error Newton", color="blue", label="Error", 
#    legend = true, linewidth = 1, grid = true)



