# Modo Real vs Modo Protegido

## Desafios

### 1. UEFI y coreboot

- **¿Qué es UEFI? ¿como puedo usarlo? Mencionar además una función a la que podría llamar usando esa dinámica.**

La Unified Extensible Firmware Interface (UEFI, interfaz unificada de firmware extensible) es una especificación que define una interfaz entre el sistema operativo y el firmware. UEFI reemplaza la antigua interfaz del Sistema Básico de Entrada y Salida (BIOS) estándar. Es compatible con sistemas que solo soportan BIOS, soporta tabla de particiones GUID (GPT) y es independiente de la arquitectura y controladores de la CPU. Presenta una interfaz de usuario amigable. 

Para usar UEFI, se necesita una placa base compatible con UEFI y un sistema operativo compatible con UEFI instalado en la computadora. La mayoría de las distribuciones de Linux y versiones recientes de Windows son compatibles con UEFI. 

Acceder al firmware UEFI:
1. Inicio del sistema (boot): Al encender la computadora, presionar la tecla adecuada para acceder al menú de inicio o al menú de arranque. Esto varía según el fabricante de la placa base, pero comúnmente se usa una de las teclas como F2, F10, F12, Esc o Supr.
2. Configuración de UEFI: Una vez en el menú de arranque, seleccionar la opcion para acceder a la configuración del firmware o del UEFI. Esto también puede variar según el fabricante de la placa base.
3. Exploración de opciones: Dentro del firmware UEFI, se puede encontrar diferentes opciones de configuración relacionadas con el arranque, la seguridad, la gestión de dispositivos, etc. Se puede explorar estas opciones y ajustarlas.

- **¿Menciona casos de bugs de UEFI que puedan ser explotados?**

[EthicalHacking](https://blog.ehcgroup.io/2022/02/02/16/16/06/12663/docenas-de-fallas-de-seguridad-descubiertas-en-el-firmware-uefi-utilizado-por-varios-proveedores/cve/ehacking/) : Se detectaron 23 vulnerabilidades de seguridad de alta gravedad en diferentes implementaciones de UEFI. La vulnerabilidad es "SMM Callout (Privilege Escalation)", el código SMM se ejecuta en el nivel de privilegio más alto y es invisible para el sistema operativo, si es atacado por un código para engañar a otro código con mayores privilegios para realizar actividades no autorizadas.  También se pueden eludir las funciones de seguridad e instalar malware de una manera que sobreviva a las reinstalaciones del sistema operativo y logre una persistencia a largo plazo en los sistemas comprometidos

- **¿Qué es Converged Security and Management Engine (CSME), the Intel Management Engine BIOS Extension (Intel MEBx)?**

Converged Security and Management Engine (CSME): El Intel® CSME es un controlador de seguridad y administración basado en hardware que está aislado en la CPU (Unidad Central de Procesamiento). Entre sus principales funciones: 
  - Inicialización de silicio: El firmware del CSME se almacena en la memoria no volátil (NVM) como parte del firmware del sistema, que incluye la BIOS, parches de microcódigo, módulo de código de autenticación (ACM) y otros componentes.
  - Gestión: El CSME permite la administración remota y local del sistema, incluida la configuración, actualización y diagnóstico. Esto es útil para tareas como la administración de flotas de computadoras en una empresa.
  - Seguridad: El CSME proporciona funciones de seguridad críticas, como la autenticación de firmware, la protección de claves y la detección de amenazas. 

Intel Management Engine BIOS Extension (Intel MEBx): es una extensión de la BIOS que permite a los administradores configurar y administrar la Intel Management Engine (ME) en sistemas basados en procesadores Intel. Proporciona una interfaz gráfica o de línea de comandos para configurar opciones de seguridad, administración y energía relacionadas con la ME. A través del Intel MEBx, los administradores pueden habilitar o deshabilitar funciones específicas de la ME, establecer contraseñas de acceso y configurar opciones de red para la administración remota

- **¿Qué es coreboot? ¿Qué productos lo incorporan? ¿Cuales son las ventajas de su utilización?**

Coreboot es un proyecto de software destinado a reemplazar el firmware propietario (BIOS o UEFI) que se encuentra en la mayoría de las computadoras. Su objetivo es proporcionar un firmware ligero diseñado para realizar solo las tareas mínimas necesarias para cargar y ejecutar un sistema operativo moderno de 32 o 64 bits. A diferencia del firmware propietario, Coreboot ofrece auditabilidad y control máximo sobre la tecnología. Es completamente transparente y no contiene spyware ni software de monitoreo.

Entre sus ventajas:
    - Código abierto: Coreboot es completamente de código abierto.
    - Control sobre el hardware: Al utilizar Coreboot, tienes el control completo sobre tu hardware, especialmente frente a las restricciones impuestas por empresas como Microsoft e Intel.
    - Independencia de proveedores: Coreboot permite evitar las limitaciones impuestas por los fabricantes de hardware y sus requisitos de seguridad, lo que a menudo obliga a comprar nuevos componentes.
    - Seguridad y privacidad: Al ser transparente y de código abierto, Coreboot reduce el riesgo de vulnerabilidades ocultas o puertas traseras.
    - Personalización: se puede adaptar Coreboot a necesidades específicas.

### 2. Linker

- **¿Qué es un linker? ¿Qué hace?**
  
Linker es una herramienta de software utilizada en el proceso de compilación de programas. Su función principal consiste en vincular o enlazar varios archivos objetos generados por el compilador en un único archivo ejecutable o en una biblioteca compartida. Esta tarea implica combinar los archivos y resolver las referencias cruzadas entre ellos, garantizando la correcta conexión entre las definiciones de funciones y variables utilizadas en diferentes partes del programa. 

![Linker](https://github.com/AndyTaborda/tp3-siscom/blob/main/linker.png)
  
- **¿Qué es la dirección que aparece en el script del linker? ¿Porqué es necesaria?**

La dirección que aparece en el script del linker es **0x7c00**. Esta dirección es importante porque indica al linker dónde debe cargar el código en la imagen de disco generada. En este caso, 0x7c00 es la dirección a la que el BIOS carga el sector de arranque al iniciar el sistema desde un disco. Esta direccion permite calcular correctamente las direcciones a las que se salta cuando se hacen operaciones de jump por ejemplo. 

Es necesaria porque el sector de arranque (512 bytes) tiene una ubicación específica en la imagen del disco y debe ser cargado en memoria en una dirección conocida para que el BIOS pueda transferir el control al código de arranque correctamente. Si no especificamos esta dirección, el código puede no ejecutarse correctamente o el sistema podría no arrancar en absoluto.

- **Grabar la imagen en un pendrive y probarla en una pc y subir una foto**

(No logramos hacer que la pc arranque desde el USB, se muestran resultados del emulador qemu)

Para crear la imagen se utiliza los siguientes codigos, instrucciones y comandos:

main.S:
```asm
.code16
    mov $msg, %si
    mov $0x0e, %ah
loop:
    lodsb
    or %al, %al
    jz halt
    int $0x10
    jmp loop
halt:
    hlt
msg:
    .asciz "hello world"
```

link.ld:
```
SECTIONS
{
    /* The BIOS loads the code from the disk to this location.
     * We must tell that to the linker so that it can properly
     * calculate the addresses of symbols we might jump to.
     */
    . = 0x7c00;
    .text :
    {
        __start = .;
        *(.text)
        /* Place the magic boot bytes at the end of the first 512 sector. */
        . = 0x1FE;
        SHORT(0xAA55)
    }
}
```

Para crear la imagen y probarla en qemu:
```sh
as -g -o main.o main.S
ld --oformat binary -o main.img -T link.ld main.o
qemu-system-x86_64 -hda main.img
```

Resultado:

![image](https://github.com/marcosraimondi1/tp3-siscom/assets/69517496/f8fa7282-1792-49b3-a8cf-629ca975dbd1)

- **Compare la salida de objdump con hd, verifique donde fue colocado el programa dentro de la imagen.**

El comando objdump -S main.o se utiliza principalmente para analizar y depurar archivos objetos. Proporciona un desmontaje del código objeto, mostrando el ensamblador y el código fuente original si está disponible. Esto es útil para analizar el código de un programa, inspeccionar el ensamblado generado por el compilador, depurar problemas de código y comprender el flujo de ejecución.

Salida de objdump:

![image](https://github.com/marcosraimondi1/tp3-siscom/assets/69517496/3ce9fb84-e688-4e74-b70a-1f06435ee101)

Algo destacable con la ejecución de este comando es que la dirección de inicio del programa es 0x0 y no 0x7c00. Esto ocurre porque se está generando un archivo binario que carece de la información sobre la dirección de inicio específica en la que debe cargarse en la memoria del procesador. El formato binario generado por objcopy -o contiene simplemente una imagen de memoria de lo que debe ser cargado, a menudo con relleno, pero sin información sobre la dirección de inicio (la direccion de 0x7c00 sirve en el linker para calcular las direcciones de saltos pero no se agrega esa informacion en los binarios).

Por su parte, hd main.img se utiliza para mostrar el contenido binario de un archivo. "hd", que refiere a hex dump, muestra el archivo en formato hexadecimal permitiendo examinar el contenido byte por byte. Es comúnmente utilizado para inspeccionar archivos binarios, como imágenes de disco o archivos ejecutables. Es útil para verificar la integridad del archivo, buscar patrones específicos dentro del contenido binario y comprender su estructura interna.

Salida de hd:

![image](https://github.com/marcosraimondi1/tp3-siscom/assets/69517496/11426e6a-3cba-44ac-b328-669d9129d7b8)

En este caso, el mensaje de “hello world” se encuentra en los bytes 65 6c 6c 6f 20 77 6f 72     6c 64 00 66 2e 0f 1f 84.

La primera línea de bytes corresponde  a las instrucciones ejecutadas en x86 assembly
be 0f 7c: el valor de 0x7c0f se mueve al registro SI.
b4 0e:  el valor de 0x0e se mueve  al registro AH.
ac: Lodsb carga el byte apuntado por SI en AL y aumenta SI.
08 c0: verifica si AL es 0.
74 04: si AL = 0, salta a halt.
cd 10:  Int 0x10, imprime el valor de AL en pantalla.
eb f7: salta a loop.


- **Depuración de ejecutables con llamadas a BIOS**

Al iniciar la depuración se debe utilizar el programa qemu para lanzar la imagen con unas flags las cuales permiten su debugeo desde el gdb. El comando para la compilación es el siguiente: 

```sh
qemu-system-x86_64  -fda main.img -boot a -s -S -monitor stdio
```

Luego se debe abrir desde otra terminal el gdb y utilizar el comando “target remote localhost:1234” para poder debugear desde la terminal con gdb el programa en asm:

![image](https://github.com/marcosraimondi1/tp3-siscom/assets/69517496/3895d160-c895-4e82-971b-0dd7018785d6)

Una vez adentro se colocan 2 breakpoints (en 0x7c00 y en 0x7c0c):

![image](https://github.com/marcosraimondi1/tp3-siscom/assets/69517496/718ecfc6-60a6-4152-87c6-7fbd9450dbfb)

Con estos breakpoints colocados estratégicamente logramos ir mediante la instrucción “continue” en gdb ir avanzando e ir viendo la impresión de a una letra por vez en la consola de qemu.

![image](https://github.com/marcosraimondi1/tp3-siscom/assets/69517496/9d91b334-f35a-4789-ab9f-21ba3b86f353)


- **¿Para qué se utiliza la opción --oformat binary en el linker?**

La opción --oformat binary en el linker (ld) se utiliza para especificar el formato del archivo de salida. El linker genera un archivo binario sin ningún formato específico de objeto ejecutable. Esto significa que el archivo resultante contendrá simplemente los datos y código que se han enlazado, sin ningún encabezado ni información adicional específica del formato del archivo ejecutable.

### 3. Modo Protegido

- **Crear un código assembler que pueda pasar a modo protegido (sin macros).**

Se utiliza como base el codigo de ensablador [ejemplo impresion](https://github.com/cirosantilli/x86-bare-metal-examples/blob/master/common.h#L135) de la macro PROTECTED_MODE. Se consideran los siguientes pasos para entrar en modo protegido:
1. Deshabilitar interrupciones
2. Cargar la GDT
3. Fijar el bit más bajo del CR0 en 1
4. Saltar a la sección de código de 32 bits
5. Configurar el resto de los segmentos

Utilizando el codigo de [protected_mode.S](./protected_mode.S) y siguiendo los mismo pasos para crear la imagen y correrla en qemu se obtiene el resultado:

![image](https://github.com/marcosraimondi1/tp3-siscom/assets/69517496/db2319d7-c7ec-4e73-b0fe-a087d672205a)


- **¿Cómo sería un programa que tenga dos descriptores de memoria diferentes, uno para cada segmento (código y datos) en espacios de memoria diferenciados?**

Para crear un programa con dos descriptores de memoria diferentes (uno para código y otro para datos), se deben utilizar los registros de segmento adecuados (DS y CS) para apuntar a los segmentos correspondientes en la memoria. Esto asegurará que el procesador pueda acceder a las instrucciones y datos de forma correcta.

- **Cambiar los bits de acceso del segmento de datos para que sea de solo lectura,  intentar escribir, ¿Que sucede? ¿Que debería suceder a continuación? (revisar el teórico) Verificarlo con gdb.**

Se cambio mediante el bit de Escribible (W) los permisos de acceso al segmentos de data. En este caso definimos que el segmento de data pasa a ser solo de lectura:
```sh
gdt_data:
    .word 0xfff         /* limit 15-0 */
    .word 0x0           /* base  15-0 */
    .byte 0x0           /* base  23-16 */
   /* .byte 0b10010010    /* (b0)A=0, W=1, ED=0, E=0, S=1, DPL=00, (b7)P=1 */
    .byte 0b10010000    /* (b0)A=0, W=0 (Read Only), ED=0, E=0, S=1, DPL=00, (b7)P=1 */
    .byte 0b11001111    /* (b0-b3)limit=0xff, AVL=0, 0=0, D/B=1, G=1 */
    .byte 0x0           /* base  31-24 (bits 24-31) */
```

Si observamos y comparamos la ejecución antes y después de que se cambian los permisos de acceso se veria asi:

<div style="display: flex; flex-direction: row;">
  <p>W=1        |       W=0</p>
  <img src="https://github.com/marcosraimondi1/tp3-siscom/assets/69517496/52acd543-5bb7-4ad5-b45f-f364fce5c31a"
    width=200
    height=400
    />
  <img src="https://github.com/marcosraimondi1/tp3-siscom/assets/69517496/dfa52580-a102-49e6-9073-d3669dd39c67"
    width=200
    height=400
    />
</div>

Observamos un cambio al ejecutar la instrucción 0x7c43 ya que la ejecución del programa toma otro curso: 

![image](https://github.com/marcosraimondi1/tp3-siscom/assets/69517496/3891028d-50ef-465e-bce6-88cc6028fdbd)

La instrucción 0x7c45 debe ser la siguiente instrucción a ser apuntada por el eip, pero por temas de acceso el eip salta a la siguiente sección a traves de una excepcion del sistema que evita el acceso de escritura al querer realizar una operacion del tipo mov:

El mecanismo de proteccion, genera una excepcion si se intenta cargar SS (registro del segmento de pila) con el valor de un selector cuyo descriptor asociado esta definido como no escribible (W=0).

![image](https://github.com/marcosraimondi1/tp3-siscom/assets/69517496/cb7a3546-0c29-4573-bff3-80df8e10ec7d)


- **En modo protegido, ¿Con qué valor se cargan los registros de segmento ? ¿Porque?**

En modo protegido, los registros de segmento (CS, DS, ES, FS, GS, SS) deben cargarse con selectores de segmento válidos. Cada selector de segmento apunta a una entrada en la tabla de descriptores de segmento global (GDT). Esta tabla contiene descripciones de segmentos que especifican la base, el límite y los atributos de los segmentos de memoria.

La razón para cargar los registros de segmento con selectores válidos es garantizar que el procesador pueda acceder a la memoria de manera adecuada, aplicando los permisos y atributos especificados en las entradas de la GDT. Esto es fundamental para mantener la protección y seguridad del sistema, así como para garantizar un acceso eficiente a la memoria.

En codigo assembler:
```asm
/* Those movs are mandatory because they update the descriptor cache */
/* se cargan los registros de segmento con el selector de segmento correspondiente */
    mov $DATA_SEG, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss
```
