# `git` básico

<img src="https://raw.githubusercontent.com/louim/in-case-of-fire/master/in_case_of_fire.png" title="In case of fire..." width="250" height="200" align="center">

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

Los comandos `git add <archivo>` y `git commit -m "<mensaje>"` son dos de los comandos esenciales del flujo de trabajo con `git`.

El comando `git log` muestra los cambios en el repositorio, en el sentido de mostrar la bitácora del proyecto.


## Servidores remotos

Hasta ahora todos comandos de `git` que hemos usado muestran un efecto local, esto es, en nuestra máquina. Ahora mostraremos cómo hacer que el repositorio local se sincronice con uno remoto.

Primero que nada, consideraremos la situación de un repositorio del que somos "dueños", o en el que tenemos privilegios de "escribir". Lo que hay que hacer es definir el repositorio remoto. Esto se hace con el comando `git remote`. Como ejemplo, para sincronizar con el repositorio del curso (que existe porque lo creé de antemano), lo que *yo* hago es

	git remote add origin git@github.com:lbenet/2021-1_TemasSelectFisComp-2.git

Esto comando define (localmente) un alias ("origin") que corresponde a la dirección `git@github.com:lbenet/2021-1_TemasSelectFisComp-2.git`. Otra alternativa de dirección del repositorio remoto puede ser `https://github.com/lbenet/2021-1_TemasSelectFisComp-2.git`. Hay  pequeñas diferenencias entre ambas, pero ahora no entraremos en los detalles.

Uno puede definir no uno, sino varios repositorios remotos, por la razón que sea (por ejemplo, porque no somos dueños del repositorio remoto, sino un "fork"). Para ver qué servicios remotos se tienen dados de alta (respecto a un repositorio `git` local) se ejecuta el comando `git remote -v`.

La idea ahora es, entonces, sincronizar a ese repositorio remoto. Si tenemos cambios locales que queremos *subir* al repositorio remoto, uno utiliza el comando 

	git push origin <rama>

Este comando sincronizará el repositorio local con el que tenemos configurado como "origin" usando la rama `<rama>`; hablaremos de las ramas después.  Noten que la primera vez que ejecuten este comando, `git` puede "protestar" y les dice qué hacer.

Si, en cambio, queremos sincronizar los cambios que hay en el servidor remoto, que por ahora bautizaré "remoto", con lo que tenemos localmente, tendremos que usar el comando

	git pull remoto <rama>
	
Para el funcionamiento del curso, es importante que definan localmente un servidor remoto con la página "oficial" del curso, del cual sincronizarán localmente a su máquina (con `git pull`), por ejemplo, con las notas del curso o las tareas. Para ustedes poder enviar (desde GitHub) su tarea, deberán *subir* los cambios (con `git push`) a su propio "fork" del curso, o al de un compañero con el que trabajen (y donde tengan derecho a hacer cambios). Lo importante es que esto involucra a dos servidores remotos distintos.

Finalmente, si ustedes quieren clonar (localmente) un repositorio remoto, lo deben hacer con `git clone <direccion_ip>`. En concreto, para clonar el curso usaremos:

	git clone https://github.com/lbenet/2021-1_TemasSelectFisComp-2.git

Este comando configura local y adecuadamente el servidor remoto.


## Ramas

Parte del verdadero poder de `git` está en su capacidad de crear *ramas* (*branches*). Una situación en la que a uno le puede  interesar crear una rama es, por ejemplo, cuando uno quiere hacer una prueba de una idea o de algún  algoritmo, y  no se quiere que esta prueba *altere* el contenido principal del repositorio o "rompa" nada de lo que ya sirve. Uno entonces hace la prueba en una *rama*. 

La manera más sencilla de entender el trabajo que se hace en una rama es pensar en que es una copia íntegra e independiente del repositorio respecto al punto en el que se creó la rama. Sin embargo, lo que hace `git` es mucho más eficiente que una copia de todo.

Hay que empezar señalando que la rama *principal* de un repositorio se llama *master* --este nombre cambiará seguramente en los siguientes meses--; ésa es la rama donde *la última versión* del repositorio se encuentra. Para saber en qué rama estamos, uno puede usar `git status`. Otra alternativa, aún más informativa en términos de las ramas es `git branch -v`, y que da información de todas las ramas que hay localmente.

Para crear una nueva rama, uno puede utilizar el comando

	git  checkout -b <nombre_rama>
	
lo que además nos cambia a la rama recién creada. Si, por ejemplo, queremos cambiarnos a la rama *master*, por la razón que sea, debemos usar el comando `git checkout master`. Al usar `git push` se sincronizarán los cambios locales con el repositorio remoto.

Es una buena práctica (e importante) trabajar en ramas; uno se evita muchos dolores de cabeza!

**Ejercicio 2:**
	Hagan el tutorial [Learn git branching](https://learngitbranching.js.org/). Este tutorial no sólo aclara lo que significa trabajar en ramas, sino ayuda a aclarar cómo resolver conflictos, que sí ocurren, y es muy bueno explicando `git rebase`.


## Resumen del flujo de trabajo

Si se quiere contribuir a un repositorio en el que no tienen privilegios para escribir:
- Hagan un *fork* del repositorio; esto creará una copia en GitHub en su cuenta, del repositorio que les interesa.
- Clonen *su* copia del repositorio a su máquina.

Para contribuir a un repositorio que existe en su cuenta de GitHub:
- Creen  una nueva rama donde trabajarán en las modificaciones (`git checkout -b <nombre_rama>`).
- Agreguen los cambios (usando `git add` y `git commit -m "..."`).
- Suban los cambios al repositorio que está en su cuenta de GitHub usando `git push <alias> <nombre_rama>`.
- Creen el "pull request" (desde su fork) al repositorio original.


## Ligas de interés

- [Think like (a) git](http://think-like-a-git.net/): Excelente descripción, enfatizando los aspectos interesantes y no triviales en términos de teoría de redes.

- [Become a git guru](https://www.atlassian.com/git/tutorials/): Tutorial muy detallado.

- [Documentación oficial](http://git-scm.com/doc)  de `git`: Este es el sitio oficial con toda la documentación sobre `git`.

- [Guías en GitHub](https://guides.github.com/) con mucha información útil, al interactuar desde GitHub.

- [Cheat sheat](https://training.github.com/downloads/github-git-cheat-sheet/)

- [Esta liga](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) describe cómo debe ser el estilo de escritura de los mensajes en los *commits*.
