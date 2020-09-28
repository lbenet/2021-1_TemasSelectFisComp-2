# `git` básico

![In case of fire...](https://raw.githubusercontent.com/louim/in-case-of-fire/master/in_case_of_fire.png)

## ¿Qué es `git`?

`git` es un sistema de control de versiones:

- es una herramienta que permite tener acceso al historial completo de un proyecto, de manera eficiente

- es una herramienta que permite colaboración *manteniendo* la autoría

- es de uso local pero se puede subir al internet (ej. GitHub)

**Ejercicio 1:**
	Crear una cuenta en GitHub, y mandarnos su usuario por email. *Nota*: La cuenta que abrirean será *pública*, así que piensen dos veces un buen nombre del usuario.


## Configuración básica (local)

Antes de empezar a usar `git`, lo configuraremos con ciertas opciones *globales* que son importantes en términos de la autoría:

```
> git config --global user.name "Fulanito de Tal"
> git config --global user.email "yo@email.de_verdad.edu"
> git config --global color.ui "auto"
> git config --global github.user "usuario_github"
```

Para ver que hicieron todo bien, pueden usar el comando `git config --list`.

## Primeros pasos en `git`

Ref: https://www.atlassian.com/git/tutorials/setting-up-a-repository

Empezamos por crear un repositorio local en `git`, con el comando `git init`. Este comando crea un directorio local `./.git` que contendrá la información de la historia del repositorio. 

De manera alternativa, uno puede *clonar* un repositorio (por ejemplo que existe en GitHub), usando el comando `git clone <dir_ip>`. Esto creará un directorio local donde hay una copia íntegra del repositorio clonado.

Para saber el estado del  repositorio, uno utiliza `git status`.

Dos comandos muy importantes son `git add` y `git commit`, y esencialmente se encargan de guardar los cambios que se hacen en el repositorio. 

`git add <archivo>` previeve a `git` de la *intención* de guardar los cambios de `<archivo>`, definiendo una "etapa" . En inglés se usa la palabra *staged*.

`git commit -m "mensaje"` crea un nuevo "commit", es decir, una etapa en que los cambios se asumen (comenten) en algún sentido. El mensaje suele ser de una línea y describe los cambios a grandes rasgos; uno puede incluir más información en el mensaje del commit, dejando una leinea en blanco después del primer renglón.

El comando `git log` muestra los cambios en el repositorio.

## Ramas

Parte del verdadero poder de `git` está en su capacidad de crear *ramas* (*branches*). Una situación en la que a uno le puede  interesar crear una rama es, por ejemplo, cuando uno quiere hacer una prueba de una idea, sin que esa prueba *altere* el contenido principal del repositorio. Uno entonces hace la prueba en una *rama*. 

Hay que empezar señalando el hecho de que la rama *principal* de un repositorio se llama *master* --este nombre cambiará seguramente en los siguientes meses--; ésa es la rama donde *la última versión* del repositorio se encuentra. Para saber en qué rama estamos, uno puede usar `git status`. Otra alternativa, aún más informativa en términos de las ramas es `git branch -v`, y que da información de todas las ramas que hay localmente.

Para crear una nueva rama

## `git` collaborativo



