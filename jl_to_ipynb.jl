# jl_to_ipynb.jl
#
# Correr desde la línea de comandos:
# 
#     julia jl_to_ipynb.jl clases/1-IntrodJulia.jl
#
# Esto producirá el archivo "1-IntrodJulia.ipynb" en el directorio "notebooks/"
#

file = basename(ARGS[1])

# Verificando que es un archivo con extensión `.jl`
@assert file[end-2:end] == ".jl" """\n
Error: El archivo debe ser un archivo con extensión `.jl`
"""

using Pkg
Pkg.activate(".");

using Literate
outdir = pwd() * "/notebooks/"
Literate.notebook("./clases/" * file, outdir; execute=false)
println("Done")
