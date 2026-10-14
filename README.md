# Lopez-post1-u4

## Descripción
Laboratorio unidad 4: programa NASM con segmentos y salida DOS (Parte 1) y macros con control de flujo (Parte 2).

## Prerrequisitos
- DOSBox 0.74+
- NASM 2.14+
- ALINK

## Compilación y ejecución
nasm -f obj programa.asm -o programa.obj
alink programa.obj -oEXE -o programa.exe -entry main
Ejecutar programa.exe dentro de DOSBox

## Desición técnica 1
La decisión técnica es utilizar EQU para definir la constante ANCHO_LINEA, porque representa un valor numérico que será utilizado como argumento de TIMES para determinar la cantidad de caracteres que se imprimirán en una línea. EQU permite al ensamblador reconocer el símbolo como una constante numérica, verificar su uso en expresiones aritméticas y detectar errores relacionados con su definición. En cambio, %define realiza una sustitución de texto antes de que NASM comience el ensamblado, por lo que puede introducir errores si el texto sustituido es ambiguo o está mal formado. Por ejemplo, si ANCHO_LINEA se utiliza posteriormente en una comparación numérica, EQU ofrece una definición más clara y adecuada para este propósito. Sin embargo, %define sería preferible si se necesitara reutilizar literalmente un fragmento de código o texto, como una secuencia de instrucciones repetidas o una expresión textual compleja. Por tanto, EQU es la opción más apropiada para ANCHO_LINEA, mientras que %define resulta útil para la reutilización de texto o código.

## Desición técnica 2
La decisión técnica es utilizar `TIMES 40 DB '='` en la sección `.data`, porque permite generar automáticamente los 40 caracteres sin tener que escribirlos manualmente uno por uno. Esto facilita el mantenimiento del programa, ya que, si se necesita cambiar el ancho de la línea, basta con modificar el valor de la constante `ANCHO_LINEA`. Por otra parte, reservar 40 bytes con `RESB 40` en la sección `.bss` y llenarlos mediante un bucle `LOOP` sería una alternativa funcional, pero innecesaria en este caso. La línea decorativa contiene siempre el mismo carácter y no cambia entre ejecuciones, por lo que resulta más eficiente definir su contenido durante el ensamblado. Con `TIMES`, los 40 bytes ya están inicializados en la imagen del ejecutable y no es necesario ejecutar instrucciones adicionales para construir la línea al iniciar el programa. En cambio, con `RESB` y `LOOP`, se deben ejecutar instrucciones para escribir cada carácter en memoria antes de imprimirlo. Por estas razones, `TIMES` en `.data` es la solución más sencilla y adecuada para este programa.
