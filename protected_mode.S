/* Enter protected mode.  */
/* Must come before they are used. */
.equ CODE_SEG, gdt_code - gdt_start
.equ DATA_SEG, gdt_data - gdt_start

.code16
go_to_protected_mode:
    cli /* deshabilitar interrupciones */

    /* Tell the processor where our Global Descriptor Table is in memory. */
    lgdt gdt_descriptor

    /* Set PE (Protection Enable) bit in CR0 (Control Register 0), to enter protected mode. */
    mov %cr0, %eax  /* eax = cr0 */
    orl $0x1, %eax  /* eax = eax | 0x01 ; sets PE to enable protected mode */
    mov %eax, %cr0  /* cr0 = eax */

    /* saltar a la seccion de codigo de 32 bits */
    ljmp $CODE_SEG, $protected_mode

/* GDT */
/* Code and Data segments are both necessary beacause: */
/* - it is impossible to write to the code segment */
/* - it is impossible execute the data segment */
gdt_start:

/* null segment entry to fill the unusable entry 0 */
gdt_null: 
    .long 0x0
    .long 0x0

/* code segment  */
gdt_code:
    .word 0xffff        /* limit 15-0                                      */
    .word 0x0           /* base  15-0                                      */
    .byte 0x0           /* base  23-16                                      */
    .byte 0b10011010    /* (b0)A=0, R=1, C=0, E=1, S=1, DPL=00, (b7)P=1   */
    .byte 0b11001111    /* (b0-b3)limit=0xff, AVL=0, 0=0, D/B=1, G=1      */
    .byte 0x0           /* base  31-24 (bits 24-31)                        */

/* Code Segment esta configurado de la siguiente forma:
*  -    base = 0x0
*  -    limit = 0xfffff
*  -    G = 1, se multiplica el limite x 4kB, por lo que el limite es el maximo de 4GB
*  -    DPL = 00, nivel de privilegio maximo
*  -    P = 1, segmento cargado en memoria principal
*  -    S = 1, tipo de segmento "normal" (para codigo, datos o pila)
*  -    Bits de Tipo = E=1 (segmento de codigo), C=0 (nonConforming, no cambia su nivel de privilegio al ser accedido), R=1 (Legible)
*  -    D/B = 1, operandos de 32 bits
*/

/* data segment */
gdt_data:
    .word 0xfff         /* limit 15-0 */
    .word 0x0           /* base  15-0 */
    .byte 0x0           /* base  23-16 */
    .byte 0b10010010    /* (b0)A=0, W=1, ED=0, E=0, S=1, DPL=00, (b7)P=1 */
    .byte 0b11001111    /* (b0-b3)limit=0xff, AVL=0, 0=0, D/B=1, G=1 */
    .byte 0x0           /* base  31-24 (bits 24-31) */

/* Data Segment esta configurado de la siguiente forma:
*  -    base = 0x0
*  -    limit = 0xfffff
*  -    G = 1, se multiplica el limite x 4kB, por lo que el limite es el maximo de 4GB
*  -    DPL = 00, nivel de privilegio maximo
*  -    P = 1, segmento cargado en memoria principal
*  -    S = 1, tipo de segmento "normal" (para codigo, datos o pila)
*  -    Bits de Tipo = E=0 (segmento de datos), ED=0 (crecimiento creciente), W=1 (Escribible)
*  -    D/B = 1, direcciones efectivas de 32 bits
*/

gdt_end:

gdt_descriptor:
    .word gdt_end - gdt_start /* size de la gdt */
    .long gdt_start

vga_current_line:
    .long 10

.code32
protected_mode:
    /* Setup the other segments. */
    /* Those movs are mandatory because they update the descriptor cache */
    /* se cargan los registros de segmento con el selector de segmento correspondiente */
    mov $DATA_SEG, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss

    /* se inicializa la pila en 0x7000 */
    mov $0X7000, %ebp /* ebp = 0x7000 */
    mov %ebp, %esp    /* esp = ebp */
    call vga_print_string

    /* verificamos que estemos en modo protegido */
    mov %cr0, %eax          /* eax = cr0 */
    test $0x1, %eax         /* Realizar una operación AND entre el valor de CR0 y 0x1 */
    jnz we_are_in           /* Saltar a 'we_are_in' si el bit PE está activado (no es cero) */

    hlt /* si no esta en modo protegido, detemos el procesador */

we_are_in:
    call vga_print_string
    hlt

message:
    .asciz "El maldito lo logro"

vga_print_string:
    mov $message, %ecx  /* Carga el parámetro s en ecx */
    mov vga_current_line, %eax

    /* 160 == 80 * 2 == line width * bytes per character on screen */
    mov $160, %edx
    mul %edx
    /* 0xb8000 == magic video memory address which shows on the screen. */
    lea 0xb8000(%eax), %edx
    /* White on black. */
    mov $0x0f, %ah
loop:
    mov (%ecx), %al
    cmp $0, %al
    je end
    mov %ax, (%edx)
    add $1, %ecx
    add $2, %edx
    jmp loop
end:
    incl vga_current_line /* inc vga current line */
    ret
