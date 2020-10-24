# jl_to_ipynb.jl
#
# Correr desde la línea de comandos (como "script") usando:
# 
#     julia jl_to_nb.jl clase.jl
#
# Esto usará el archivo clases/clase.jl y producirá el archivo clase.ipynb en el 
# directorio "notebooks/". Si se quiere generar el Jupyter notebook de las tareas,
# hay que usar
#     $ julia jl_to_nb.jl tarea.jl  false
# que creará el archivo tarea.ipynb en el directorio "tareas/".
# 
# Alternativamente, se puede utilizar desde el REPL:
#     julia> include("jl_to_nb.jl")
# Aparecerá información de cómo usar la función `to_notebook`.
# 

using Pkg
Pkg.activate(".");

using Literate

function to_notebook(::Val{true}, file::String=ARGS[1], in_clases::Bool=true)
    inputfile = basename(file)
    return to_notebook(Val(false), inputfile, in_clases)
end

function to_notebook(::Val{false}, inputfile::String, in_clases::Bool=true)

    # Verificando que es un archivo con extensión `.jl`
    @assert inputfile[end-2:end] == ".jl" """\n
    Error: El archivo debe ser un archivo con extensión `.jl`
    """

    if in_clases
        inputdir = pwd() * "/clases/"
        outdir = pwd() * "/notebooks/"
    else
        inputdir = pwd() * "/tareas/"
        outdir = pwd() * "/tareas/"
    end
    Literate.notebook(inputdir * inputfile, outdir; execute=false)
    println("Done")
end

if length(ARGS) > 0
    # Funciona como script
    if (length(ARGS)==1 || lowercase(ARGS[2]) == "true")
        to_notebook(Val(true), ARGS[1])
    elseif lowercase(ARGS[2]) == "false"
        to_notebook(Val(true), ARGS[1], false)
    else
        throw("El segundo argumento tiene que ser Bool: `true` o `false`")
    end
else
    @info("""\nPara convertir al notebook ejecuta la función\n 

        `to_notebook(Val(false), inputfile, in_clases)`
    
    donde `inputfile` es el nombre del archivo que quieres convertir, 
    e `in_clases::Bool` es un booleano que implica que el archivo está en 
    el directorio "clases/" si es `true`, o está en "tareas/" si es `false`. 
    El archivo de salida se escribe en el directorio "notebooks" o en el 
    directorio "tareas" según se aplique `in_clases`.
    """)
end
