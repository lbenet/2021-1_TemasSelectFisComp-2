module SeriesTaylor
export Taylor

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

import Base: +, -, *, /, inv, ==, ^

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

function ^(T::Taylor, n::Int)
    n == 0 && return Taylor(T.orden, [one( eltype(T.polim) )])
    n == 1 && return T
    
    if n > 1
        T * T^(n - 1)
    elseif n < 0
        (inv(T))^abs(n)
    end
end

end