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
# Parte 1

## Decisión técnica 1

La decisión técnica es utilizar EQU para definir la constante ANCHO_LINEA, porque representa un valor numérico que será utilizado como argumento de TIMES para determinar la cantidad de caracteres que se imprimirán en una línea. EQU permite al ensamblador reconocer el símbolo como una constante numérica, verificar su uso en expresiones aritméticas y detectar errores relacionados con su definición. En cambio, %define realiza una sustitución de texto antes de que NASM comience el ensamblado, por lo que puede introducir errores si el texto sustituido es ambiguo o está mal formado. Por ejemplo, si ANCHO_LINEA se utiliza posteriormente en una comparación numérica, EQU ofrece una definición más clara y adecuada para este propósito. Sin embargo, %define sería preferible si se necesitara reutilizar literalmente un fragmento de código o texto, como una secuencia de instrucciones repetidas o una expresión textual compleja. Por tanto, EQU es la opción más apropiada para ANCHO_LINEA, mientras que %define resulta útil para la reutilización de texto o código.

## Decisión técnica 2

La decisión técnica es utilizar TIMES 40 DB '=' en la sección .data, porque permite generar automáticamente los 40 caracteres sin tener que escribirlos manualmente uno por uno. Esto facilita el mantenimiento del programa, ya que, si se necesita cambiar el ancho de la línea, basta con modificar el valor de la constante ANCHO_LINEA. Por otra parte, reservar 40 bytes con RESB 40 en la sección .bss y llenarlos mediante un bucle LOOP sería una alternativa funcional, pero innecesaria en este caso. La línea decorativa contiene siempre el mismo carácter y no cambia entre ejecuciones, por lo que resulta más eficiente definir su contenido durante el ensamblado. Con TIMES, los 40 bytes ya están inicializados en la imagen del ejecutable y no es necesario ejecutar instrucciones adicionales para construir la línea al iniciar el programa. En cambio, con RESB y LOOP, se deben ejecutar instrucciones para escribir cada carácter en memoria antes de imprimirlo. Por estas razones, TIMES en .data es la solución más sencilla y adecuada para este programa.

# Parte 2

## Decisión técnica 1

La directiva %rep es una alternativa razonable a LOOP cuando se necesita repetir un bloque de código un número pequeño y fijo de veces, conocido durante la escritura del programa. Por ejemplo, para imprimir tres separadores decorativos, %rep 3 permite generar tres copias independientes del código durante el ensamblado. Esto evita utilizar instrucciones adicionales para controlar un bucle en tiempo de ejecución. Sin embargo, si se utilizara %rep 1000, se generarían mil copias del código, aumentando considerablemente el tamaño del archivo ejecutable.

Por otra parte, la macro repetir_str utiliza LOOP y el registro CX para controlar las repeticiones. Esta opción es adecuada cuando la cantidad de repeticiones se obtiene durante la ejecución, por ejemplo, mediante la lectura de un valor ingresado por el usuario. En ese caso, no se puede determinar necesariamente el número de copias durante el ensamblado. El código expandido de repetir_str contiene instrucciones como mov cx, %2 y loop %%ciclo, mientras que bloque_decorativo no necesita utilizar CX ni LOOP. Por ello, %rep evita el costo de las instrucciones de control del bucle durante la ejecución, aunque genera más código cuando aumenta el número de repeticiones.

## Decisión técnica 2

La macro bloque_decorativo no necesita etiquetas locales con el prefijo %% porque su función consiste en repetir un bloque de código mediante la directiva %rep. Cada repetición genera instrucciones independientes y no existe ningún salto que necesite una etiqueta de destino. Por esta razón, la macro puede invocarse varias veces sin provocar conflictos entre etiquetas.

Sin embargo, si se modificara bloque_decorativo para incluir un salto condicional que omitiera la última copia impresa, sería necesario definir una etiqueta para indicar el destino del salto. En ese caso, se utilizaría el prefijo %% para generar un nombre único por cada expansión de la macro y evitar conflictos si se invoca varias veces. En cuanto al procedimiento comparar_menor_o_igual, utiliza etiquetas como .menor_o_igual y .fin_cmp2. Estas etiquetas son locales al contexto de ensamblado correspondiente y pertenecen a un procedimiento que se define una sola vez, por lo que no se expanden repetidamente como una macro. Por ello, no necesitan el mecanismo %%, que resulta especialmente útil para evitar colisiones entre etiquetas generadas por distintas expansiones de una macro.
