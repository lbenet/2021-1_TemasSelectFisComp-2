function newton(f,df, x)
    x0 = x               
    c = 0       
    x1 = 0.0    
    while abs(f(x0)) > 0.00001
        x1 = x0 - f(x0)/df(x0)
        x0 = x1
        c = c+1
    end
    return x1, c
end

f(x) = x^2 -2

df(x) = 2x

newton(f,df,4.0)

sqrt(2)

raicesf = Float64[]
Delta = Float64[]
npasos = Float64[]

function newton2(f,df, x, raiz, delta, pasos)
    x0 = x
    c = 0
    x1 = 0.0
    while abs(f(x0)) > 0.00005
        x1 = x0 - f(x0)/df(x0)
        push!(raiz, x1)
        push!(delta, abs(x1 - x0))
        x0 = x1
        c = c+1
        push!(pasos,c)
    end
    return pasos, x1, c
end

newton(f,df,8.0,raicesf,Delta,npasos)

using Plots

x = npasos
y = Delta
scatter(x, y, title = "No. pasos vs Delta", xlabel = "Pasos", ylabel = "Delta" , label = "Delta", lw = 3)

cond1 = [i for i in -3:0.125:3] 

function newton3(f,df,cond,raicesf)
    for x in 1:length(cond) 
    x0 = cond[x]
    x1 = 0.0
    while abs(f(x0)) > 0.00005
        x1 = x0 - f(x0)/df(x0)
        x0 = x1
    end
    push!(raicesf,x0)
    end
    return cond, raicesf
end

raices2f = Float64[]

newton3(f,df,pasos1,raices2f)

x = cond1
y = abs.(raices2f)
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3)

g(x) = (x-1)*(x-2)*(x-3)

dg(x) = 3x^2 - 12x + 11

cond2 = [i for i in 1:0.125:3] 

raicesg = Float64[]

newton3(g,dg,cond2,raicesg)

x = cond2
y = abs.(raicesg)
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3)

cond3 = [i for i in 1:0.25:3] 

raices2g = Float64[]

newton3(g,dg,cond3,raices2g)

x = cond3
y = abs.(raices2g)
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3)

cond4 = [i for i in 1:0.105:3] 

raices3g = Float64[]

newton3(g,dg,cond4,raices3g)

x = cond4
y = abs.(raices3g)
scatter(x, y, title = "X0 vs Raíz", xlabel = "Condición inicial", ylabel = "Raíz" , label = "Raíz", lw = 3)

x = 0.5:0.125:3.5
y = (x.-1).*(x.-2).*(x.-3)
scatter(x,y)


