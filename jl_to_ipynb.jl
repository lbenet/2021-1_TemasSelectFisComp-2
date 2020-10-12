# jl_to_ipynb.jl
#
# Correr desde la línea de comandos
# > julia jl_to_ipynb.jl 1-IntrodJulia.jl
#
# Esto producirá el archivo "1-IntrodJulia.ipynb" en el directorio "notebooks/"
#

file = "./clases/" * basename(ARGS[1])
@show(file)

# Verificando que es un archivo con extensión `.jl`
@assert file[end-2:end] == ".jl" """\n
Error: El archivo debe ser un archivo con extensión `.jl`
"""

using Pkg
Pkg.activate(".")

using Literate
Literate.notebook(file; execute=false)
outfile = ARGS[1][1:end-3] * ".ipynb"
mv(outfile, "./notebooks/" * outfile)
println("Done")
