import Pkg; Pkg.add("Plots")


using Plots

x = -3:0.2:3
y = x.^2 .- 2
scatter(x,y) 

function newton(f,df, x)
    x0 = x
    c = 0
    x1 = 0.0
    while abs(f(x0)) > 0.00005
        x1 = x0 - f(x0)/df(x0)
        x0 = x1
        c = c+1
    end
    return x1, c
end
    
    

f(x) = x^2 -2


df(x) = 2x

f(1)

f(1.4142)

df(2)

f

newton(f,df,1)

test = Float64[]

typeof(test)

push!(test, 1)

push!(test,2.0)

delta = Float64[]

raiz = Float64[]

function newton(f,df, x, raiz, delta)
    x0 = x
    c = 0
    x1 = 0.0
    while abs(f(x0)) > 0.00005
        
        x1 = x0 - f(x0)/df(x0)
        push!(raiz, x1)
        push!(delta, abs(x1 - x0))
        x0 = x1
        c = c+1
    end
    return x1, c
end

newton(f,df,5.0,raiz,delta)

raiz

delta


