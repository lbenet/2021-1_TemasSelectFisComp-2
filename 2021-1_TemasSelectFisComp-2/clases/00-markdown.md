# Markdown básico

Ref: [Markdown guide](https://www.markdownguide.org/basic-syntax/)

`Markdown` es un lenguaje *ligero* que permite tener un formato básico en texto. La idea del lenguaje es tener un lenguaje que permita ser leído directamente, sin ser intrusivo. En algún sentido, es ideal para tomar notas, y es el lenguaje de marcado que se utiliza en el [Jupyter notebook](https://https://jupyter.org/). Es un poco como `TeX/LaTeX`, pero sin los problemas de compilación, y se está usando cada vez más en cosas ligadas con la Web.

Para usarlo sólo necesitan descargar un editor de Markdown, que se encargará de procesarlo.  En case de que lo quieran, la siguiente liga tiene un tutorial: https://www.markdowntutorial.com/

---

## Sintaxis básica

- Encabezados:
	# `# H1`
	## `## H2`
	...
	###### `###### H6` 
	
- **Negritas**: `**negritas**`

- *Cursivas*: `*cursivas*`

---

- Citas: `> blah, blah, blah`
	>  Gravitation is not responsible for people falling in love.
	>  
	>  *A. Einstein*

- Listas ordenadas/numeradas:
	1. `1. Primer punto`
	2. `2. Segundo punto`

- Listas no ordenadas:
	- `- Primer enunciado`
	- `- Segundo`

- `Código:` `` `Código` `` (se utilizan las `` ` ``)

---

- [Ligas a páginas web](https://www.qwant.com/?q=Avoid%20using%20google&t=web): `[titulo (que se lee)](https://pagina.web)`

- Imágenes: `![título de la imagen](image.jpg)`

Aunque no lo tienen todas las versiones/dialectos, uno puede escribir fórmulas usando el formato `TeX/LaTeX`. Por ejemplo,
`$$ E= \hbar\omega $$` resultará en:
$$ E= \hbar\omega $$

---

## Algunos consejos

- Usen un espacio después de `# ` en los encabezados
- Los párrafos se inician **simpre** sin usar la tecla `<TAB>`.
- Para terminar un párrafo, la línea debe terminar con dos o más espacios, seguidos de `<return>`  


Para más opciones/información: https://www.markdownguide.org/cheat-sheet/