; programa.asm — Laboratorio Post1 Unidad 4
; Propósito: demostrar directivas de sección, datos y constantes en NASM
; Laboratorio NASM - Unidad 4, Parte 1
; Segmentos, directivas, salida DOS y TIMES
; Ensamblar: nasm -f obj programa.asm -o programa.obj
; Enlazar:    alink programa.obj -oEXE -o programa.exe -entry main

CR          EQU 0Dh
LF          EQU 0Ah
TERMINADOR  EQU 24h
ITERACIONES EQU 5
ANCHO_LINEA EQU 40

section .data
    bienvenida  db "=== Laboratorio NASM - Unidad 4 ===", CR, LF, TERMINADOR
    separador   db "----------------------------------------", CR, LF, TERMINADOR
    etiqueta_a  db "Variable A (byte): ", TERMINADOR
    etiqueta_tabla db "Tabla de bytes: ", TERMINADOR
    fin_msg     db CR, LF, "Programa finalizado correctamente.", CR, LF, TERMINADOR

    linea_gruesa:
        TIMES ANCHO_LINEA DB '='
        DB CR, LF, TERMINADOR

    var_byte    db 42
    var_word    dw 1234h
    var_dword   dd 0DEADBEEFh
    tabla_bytes db 10, 20, 30, 40, 50

    ; Variables auxiliares para convertir un byte a decimal
    centenas    db 0
    resto       db 0

section .bss
    buffer      resb 80
    resultado   resw 1

section .text
    global main

main:
    ; Inicializar DS para acceder a los datos
    mov ax, seg bienvenida
    mov ds, ax

    ; Mensajes iniciales
    mov ah, 09h
    mov dx, bienvenida
    int 21h

    mov ah, 09h
    mov dx, separador
    int 21h

    ; Imprimir el valor decimal de var_byte (42)
    mov ah, 09h
    mov dx, etiqueta_a
    int 21h

    mov al, [var_byte]
    call imprimir_byte_decimal
    call nueva_linea

    ; Recorrer la tabla e imprimir cada elemento en decimal
    mov ah, 09h
    mov dx, etiqueta_tabla
    int 21h

    lea si, [tabla_bytes]
    mov cx, ITERACIONES

imprimir_tabla:
    mov al, [si]
    call imprimir_byte_decimal

    mov ah, 02h
    mov dl, ' '
    int 21h

    inc si
    loop imprimir_tabla

    call nueva_linea

    ; Mensaje final y linea decorativa solicitada
    mov ah, 09h
    mov dx, fin_msg
    int 21h

    mov ah, 09h
    mov dx, linea_gruesa
    int 21h

    ; Terminar correctamente en DOS
    mov ax, 4C00h
    int 21h

; -----------------------------------------
; imprimir_byte_decimal
; Entrada: AL = valor de 0 a 255
; Imprime el valor en decimal usando INT 21h, funcion 02h.
; -----------------------------------------
imprimir_byte_decimal:
    push ax
    push bx
    push dx

    xor ah, ah
    mov bl, 100
    div bl              ; AL = centenas, AH = resto
    mov [centenas], al
    mov [resto], ah

    cmp byte [centenas], 0
    je comprobar_decenas
    mov dl, [centenas]
    add dl, '0'
    mov ah, 02h
    int 21h

comprobar_decenas:
    mov al, [resto]
    xor ah, ah
    mov bl, 10
    div bl              ; AL = decenas, AH = unidades
    mov [resto], ah

    ; Si hubo centenas, se imprimen decenas incluso si son cero.
    cmp byte [centenas], 0
    jne imprimir_decenas
    ; Si no hubo centenas, omitir decenas cero.
    cmp al, 0
    je imprimir_unidades

imprimir_decenas:
    mov dl, al
    add dl, '0'
    mov ah, 02h
    int 21h

imprimir_unidades:
    mov dl, [resto]
    add dl, '0'
    mov ah, 02h
    int 21h

    pop dx
    pop bx
    pop ax
    ret

nueva_linea:
    mov ah, 02h
    mov dl, CR
    int 21h
    mov dl, LF
    int 21h
    ret
