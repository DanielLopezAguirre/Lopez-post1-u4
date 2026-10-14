; programa2.asm - Laboratorio Post2 Unidad 4
; Ensamblar: nasm -f obj programa2.asm -o programa2.obj -l programa2.lst
; Enlazar:   alink programa2.obj -oEXE -o programa2.exe -entry main

%include "macros.asm"

section .data
    titulo          db "=== Macros y Control de Flujo ===", 0Dh, 0Ah, 24h
    linea_a         db "[Linea A] Primera impresion", 0Dh, 0Ah, 24h
    linea_b         db "[Linea B] Segunda impresion", 0Dh, 0Ah, 24h
    msg_suma        db "La suma 1+2+3 es: ", 24h
    msg_mayor       db "El valor mayor es: ", 24h
    msg_iguales     db "Los valores son iguales.", 0Dh, 0Ah, 24h
    msg_fin         db "Fin del programa.", 0Dh, 0Ah, 24h
    separador_corto db "---", 0Dh, 0Ah, 24h
    msg_menor_igual db "AX es menor o igual: ", 24h
    msg_mayor2      db "AX es mayor: ", 24h

section .text
    global main

main:
    mov  ax, seg titulo
    mov  ds, ax

    ; 1. Encabezado
    print_str titulo

    ; 2. repetir_str
    repetir_str linea_a, 3

    ; 3. Suma 1+2+3 = 6
    mov  cx, 3
    call sumar_serie
    mov  bx, ax
    print_str msg_suma
    mov  ax, bx
    print_digito
    nueva_linea

    ; 4. Comparar 9 vs 4
    mov  ax, 9
    mov  bx, 4
    call comparar_e_imprimir

    ; 5. Comparar 5 vs 5
    mov  ax, 5
    mov  bx, 5
    call comparar_e_imprimir

    ; 7. Bloque decorativo con %rep
    bloque_decorativo 3

    ; 8. Comparacion con JLE
    mov  ax, 3
    mov  bx, 8
    call comparar_menor_o_igual

    ; 6. Final
    print_str msg_fin
    fin_dos

; ---------- Procedimientos ----------

sumar_serie:
    push cx
    xor  ax, ax
.paso:
    add  ax, cx
    loop .paso
    pop  cx
    ret

comparar_e_imprimir:
    push ax
    push bx
    mov  bp, sp             ; [bp]=BX, [bp+2]=AX

    cmp  ax, bx
    je   .son_iguales
    jg   .ax_mayor

    print_str msg_mayor
    mov  ax, [bp]
    print_digito
    nueva_linea
    jmp  .fin_comp

.ax_mayor:
    print_str msg_mayor
    mov  ax, [bp+2]
    print_digito
    nueva_linea
    jmp  .fin_comp

.son_iguales:
    print_str msg_iguales

.fin_comp:
    pop  bx
    pop  ax
    ret

comparar_menor_o_igual:
    push ax
    push bx
    mov  bp, sp

    cmp  ax, bx
    jle  .menor_o_igual

    print_str msg_mayor2
    mov  ax, [bp+2]
    print_digito
    jmp  .fin_cmp2

.menor_o_igual:
    print_str msg_menor_igual
    mov  ax, [bp+2]
    print_digito

.fin_cmp2:
    nueva_linea
    pop  bx
    pop  ax
    ret