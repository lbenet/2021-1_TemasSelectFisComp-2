module SeriesTaylor
export Taylor, serie, trig, coeficientes, paso, Horner, paso_Taylor, paso_integracion, integrador_taylor, integrador, graficador

"""
Definición de polinomios de Taylor, donde

orden es el orden del polinomio de Taylor.
polim es un arreglo unidimensional de orden + 1
    entradas. La i+1 ésima entrada es el coeficiente
    de la i ésima potencia del polinomio.
"""
struct Taylor{T <: Number}
    orden :: Int
    polim :: Array{T,1}
    
    Taylor(polim) = new{eltype(polim)}(length(polim) - 1, polim)
    Taylor(orden, polim) = new{eltype(polim)}(orden, vcat( polim, zeros(eltype(polim), orden + 1 - length(polim) ) ) )
end

serie(T::Taylor) = T.polim

import Base: +, -, *, /, inv, ==, exp, log, sin, cos, ^, isapprox

+(T::Taylor) = T
+(c::Number, T::Taylor) = Taylor( vcat([T.polim[1] + c], T.polim[2:end]) )
+(T::Taylor, c::Number) = +(c::Number, T::Taylor)
+(T1::Taylor, T2::Taylor) = Taylor( T1.polim + T2.polim )

-(T::Taylor) = Taylor( -T.polim )
-(c::Number, T::Taylor) = Taylor( vcat([-T.polim[1] + c], -T.polim[2:end]) )
-(T::Taylor, c::Number) = Taylor( vcat([T.polim[1] - c], T.polim[2:end]) )
-(T1::Taylor, T2::Taylor) = Taylor( T1.polim - T2.polim )

*(c::Number, T::Taylor) = Taylor( c * T.polim )
*(T::Taylor, c::Number) = *(c::Number, T::Taylor)

inv(T::Taylor) = Taylor(T.orden, [one( eltype(T.polim) )]) / T

/(c::Number, T::Taylor) = c * inv(T)
/(T::Taylor, c::Number) = Taylor( T.polim / c )

==(T1::Taylor, T2::Taylor) = T1.polim == T2.polim
isapprox(T1::Taylor, T2::Taylor) = T1.polim ≈ T2.polim

function *(T1::Taylor, T2::Taylor)
    polim = eltype( promote(T1.polim[1], T2.polim[1]) )[]
    
    for i in 1:T1.orden+1
        aux = T1.polim[1:i] .* reverse(T2.polim[1:i])
        push!(polim, sum(aux))
    end
    
    return Taylor(polim)
end

function /(T1::Taylor, T2::Taylor)
    aux1 = inv(T2.polim[1])
    polim = [aux1 * T1.polim[1]]
    
    for i in 2:T1.orden+1
        aux2 = sum( polim[1:i-1] .* reverse(T2.polim[2:i]) )
        push!(polim, aux1 * (T1.polim[i] - aux2) )
    end
    
    return Taylor(polim)
end

# function ^(T::Taylor, n::Int)
#     n == 0 && return Taylor(T.orden, [one( eltype(T.polim) )])
#     n == 1 && return T
# 
#     if n > 1
#         T * T^(n - 1)
#     elseif n < 0
#         (inv(T))^abs(n)
#     end
# end

function exp(T::Taylor)
    polim = [exp(T.polim[1])]
    
    for i in 2:T.orden+1
        push!(polim, inv(i-1) * sum([j for j in (i-1):-1:1] .* reverse(T.polim[2:i]) .* polim[1:i-1]) )
    end
    
    return Taylor(polim)
end

function log(T::Taylor)
    p0 = T.polim[1]
    polim = [log(p0)]
    
    for i in 2:T.orden+1
        push!(polim, inv(p0) * ( T.polim[i] - inv(i-1) * sum([j for j in 0:i-2] .* reverse(T.polim[2:i]) .* polim[1:i-1])) )
    end
    
    return Taylor(polim)
end

function ^(T::Taylor, α)
    p0 = T.polim[1]
    orden = T.orden
    
    if p0 == 0 && α == Int(α) && α>0
        orden_min = zero(Int)
        
        for i in 2:orden+1
            if T.polim[i] != 0
                orden_min = i-1
                break
            end
        end
        
        nuevo_orden_min = α * orden_min
        if orden_min == 0 || nuevo_orden_min > orden
            polim = [zero(eltype(T))]
        else
            T_aux = Taylor(T.polim[orden_min+1:end])^α
            polim = vcat(zeros(eltype(T_aux.polim), nuevo_orden_min), T_aux.polim[1:orden + 1 - nuevo_orden_min])
        end
    else
    
        polim = [p0^α]

        for i in 2:T.orden+1
            push!(polim, inv((i-1)*p0) * sum([α*(i-1-j)-j for j in 0:i-2] .* reverse(T.polim[2:i]) .* polim[1:i-1]) )
        end
    end

    return Taylor(polim)
end

"""
Devuelve una tupla de dos entradas, siendo la primera el coseno
de la serie de Taylor T y el segundo el seno de ésta misma serie.
"""
trig(T::Taylor) = (aux = exp(im*T); (Taylor(real(aux.polim)), Taylor(imag(aux.polim))))
cos(T::Taylor) = Taylor(real(exp(im*T).polim))
sin(T::Taylor) = Taylor(imag(exp(im*T).polim))


"""
Calcula los coeficientes x_k de la serie de Taylor de la solución x.

Argumentos:
    f -> función a la que es igual la derivada de x con respecto del tiempo.
    x0 -> la condición inicial.
    p -> orden de la serie de Taylor.
"""
function coeficientes(f, t, x0::Array, p)
    n = length(x0)
    polim = Array{promote_type(Float64,eltype(x0)),1}(x0)
    aux(polim::Array) = [Taylor(p, permutedims(reshape(polim,n,:))[:,i]) for i in 1:n]

    for i in 1:p
        polim = vcat(polim, getindex.(serie.(f(t, aux(polim))), i) / i)
    end
    
    return aux(polim)
end

"""
Calcula el paso de integración para el método de Taylor tomando en
cuenta el radio de convergencia y los dos últimos coeficientes de
la serie de Taylor de la solución.

Argumentos:
    T -> serie de Taylor.
    ϵ -> cota para el residuo.
"""
function paso(T::Taylor, ϵ)
    p = T.orden
    aux = T.polim[p:p+1]
    aux = ϵ * (abs ∘ inv).(aux)
    aux = [aux[i]^(1 / (p+i)) for i in 1:2]
    return minimum(aux)
end

function paso(T::Array{<: Taylor, 1}, ϵ)
    return minimum(paso.(T, ϵ))
end

"""
Suma un polinomio mediante el método de Horner.

Argumentos:
    T -> serie de Taylor.
    h -> punto en el que se evalúa el polinomio.
"""
function Horner(T::Taylor, h)
    p = T.orden
    polim = T.polim
    suma = polim[p] + h*polim[p+1]

    for i in p-1:-1:1
        suma = polim[i] + h*suma
    end

    return suma
end

"""
Integra una ecuación diferencial ordinaria de primer grado
en un paso de tiempo, por el método de Taylor.

Argumentos:
    f -> función a la que es igual la derivada de x con respecto del tiempo.
    x0 -> la condición inicial.tiempo en el que se desea conocer la solución.
    t -> tiempo inicial.
    tf -> tiempo final
    p -> orden de la serie de Taylor.
    ϵ -> cota para el residuo de una serie de Taylor.
"""
function paso_Taylor(f, x0, t0, tf, p, ϵ)
    T = coeficientes(f, t0, x0, p)
    return min(tf, t0 + paso(T, ϵ)), T
end

function paso_integracion(f, x0::Array, t0, tf, p, ϵ)
    t, T = paso_Taylor(f, x0, t0, tf, p, ϵ)
    return t, Horner.(T, t-t0)
end

"""
Integra una ecuación diferencial ordinaria de primer grado
desde un tiempo inicial hasta uno final, por el método de Taylor.

Argumentos:
    f -> función a la que es igual la derivada de x con respecto del tiempo.
    x0 -> la condición inicial.tiempo en el que se desea conocer la solución.
    t -> tiempo inicial.
    tf -> tiempo final
    p -> orden de la serie de Taylor.
    ϵ -> cota para el residuo de una serie de Taylor.
"""
function integrador_Taylor(f, x0::Array, t0, tf, p = 29, ϵ = 1e-32)
    tiempos = typeof(ϵ)[t0]
    series = Array{Taylor{promote_type(Float64,eltype(f(t0,x0)))},1}([])

    while t0 < tf
        t, T = paso_Taylor(f, x0, t0, tf, p, ϵ)
        push!(tiempos, t)
        series = vcat(series, T)
        x0 = Horner.(T, t-t0)
        t0 = t
    end

    return tiempos, series
end

function integrador(f, x0::Array, t0, tf, p = 29, ϵ = 1e-32)
    datos = promote_type(eltype(f(t0, x0)), typeof(ϵ))[t0, x0...]

    while t0 < tf
        t0, x0 = paso_integracion(f, x0, t0, tf, p, ϵ)
        push!(datos, t0, x0...)
    end

    return permutedims(reshape(datos,1 + length(x0),:))
end

"""
Regresa los datos para graficar la solución a una ecuación diferencial integrada por el método de Taylor..

Argumentos:
    f -> función a la que es igual la derivada de x con respecto del tiempo.
    x0 -> la condición inicial.tiempo en el que se desea conocer la solución.
    t0 -> tiempo inicial.
    tf -> tiempo final
    Δt -> paso en la gráfica
    p -> orden de la serie de Taylor.
    ϵ -> cota para el residuo de una serie de Taylor.
"""
function graficador(f, x0::Array, t0, tf, Δt, p = 29, ϵ = 1e-32)
    n = length(x0)
    tiempos, series = integrador_Taylor(f, x0, t0, tf, p, ϵ)
    datos = promote_type(eltype(tiempos), eltype(series).parameters[1])[]
    
    for i in 1:length(tiempos)-1
        t = tiempos[i]:Δt:tiempos[i+1]
        
        for τ in t
            push!(datos, τ, Horner.(series[1+(i-1)*n:i*n], τ - tiempos[i])...)
        end
    end
    
    return permutedims(reshape(datos,n+1,:))
end

end