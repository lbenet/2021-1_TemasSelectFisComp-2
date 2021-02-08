module RungeKutta
export K, paso_RK4, RK4

"""
Calcula la K(t, x, h) del método de Runge Kutta.

Argumentos:
    f -> función a la que es igual la derivada de x con respecto del tiempo.
    x -> valor de la solución a la ecuación diferencial.
    h -> paso de integración.
"""
function K(f, t, x, H)
    h = H/2
    T = t + h
    k1 = f(t, x)
    k2 = f(T, x + h*k1)
    k3 = f(T, x + h*k2)
    k4 = f(t + H, x + H*k3)
    return (k1 + 2*k2 + 2*k3 + k4)/6
end

"""
Integra una ecuación diferencial ordinaria de primer grado
en un paso de tiempo, por el método de Runge Kutta.

Argumentos:
    f -> función a la que es igual la derivada de x con respecto del tiempo.
    x0 -> la condición inicial.tiempo en el que se desea conocer la solución.
    t -> tiempo inicial.
    tf -> tiempo final
    p -> orden de la serie de Taylor.
    ϵ -> cota para el residuo de una serie de Taylor.
"""
function paso_RK4(f, x0, t0, tf, h)
    h = min(h, tf - t0)
    return t0 + h, x0 + h * K(f, t0, x0, h)
end

"""
Integra una ecuación diferencial ordinaria de primer grado
desde un tiempo inicial hasta uno final, por el método de
Runge Kutta.

Argumentos:
    f -> función a la que es igual la derivada de x con respecto del tiempo.
    x0 -> condición inicial.
    t -> tiempo en el que se desea conocer la solución.
    h -> paso de integración.
"""
function RK4(f, x0, t0, tf, h = 1e-4)
    datos = promote_type(eltype(x0), typeof(h))[t0, x0...]

    while t0 < tf
        t0, x0 = paso_RK4(f, x0, t0, tf, h)
        push!(datos, t0, x0...)
    end

    return permutedims(reshape(datos,length(x0)+1,:))
end

end