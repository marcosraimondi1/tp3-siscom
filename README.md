# Modo Real vs Modo Protegido

## Desafios

### 1. UEFI y coreboot

- **¿Qué es UEFI? ¿como puedo usarlo? Mencionar además una función a la que podría llamar usando esa dinámica.**
  
La Unified Extensible Firmware Interface (UEFI, interfaz unificada de firmware extensible) es una especificación que define una interfaz entre el sistema operativo y el firmware. UEFI reemplaza la antigua interfaz del Sistema Básico de Entrada y Salida (BIOS) estándar. Es compatible con sistemas que solo soportan BIOS, soporta tabla de particiones GUID (GPT) y es independiente de la arquitectura y controladores de la CPU. Presenta una interfaz de usuario amigable. 

Para usar UEFI, se mecesota una placa base compatible con UEFI y un sistema operativo compatible con UEFI instalado en la computadora. La mayoría de las distribuciones de Linux y versiones recientes de Windows son compatibles con UEFI. 

Acceder al firmware UEFI:
1. Inicio del sistema (boot): Al encender la computadora, presionar la tecla adecuada para acceder al menú de inicio o al menú de arranque. Esto varía según el fabricante de la placa base, pero comúnmente se usa una de las teclas como F2, F10, F12, Esc o Supr.
2. Configuración de UEFI: Una vez en el menú de arranque, seleccionar la opcion para acceder a la configuración del firmware o del UEFI. Esto también puede variar según el fabricante de la placa base.
3. Exploración de opciones: Dentro del firmware UEFI, se puede encontrar diferentes opciones de configuración relacionadas con el arranque, la seguridad, la gestión de dispositivos, etc. Se puede explorar estas opciones y ajustarlas.

- **¿Menciona casos de bugs de UEFI que puedan ser explotados?**

[EthicalHacking](https://blog.ehcgroup.io/2022/02/02/16/16/06/12663/docenas-de-fallas-de-seguridad-descubiertas-en-el-firmware-uefi-utilizado-por-varios-proveedores/cve/ehacking/) : Se detectaron 23 vulnerabilidades de seguridad de alta gravedad en diferentes implementaciones de UEFI. La vulnerabilidad es "SMM Callout (Privilege Escalation)", el código SMM se ejecuta en el nivel de privilegio más alto y es invisible para el sistema operativo, si es atacado por un código para engañar a otro código con mayores privilegios para realizar actividades no autorizadas.  También se pueden eludir las funciones de seguridad e instalar malware de una manera que sobreviva a las reinstalaciones del sistema operativo y logre una persistencia a largo plazo en los sistemas comprometidos

- **¿Qué es Converged Security and Management Engine (CSME), the Intel Management Engine BIOS Extension (Intel MEBx)?**

Converged Security and Management Engine (CSME): El Intel® CSME es un controlador de seguridad y administración basado en hardware que está aislado de la CPU (Unidad Central de Procesamiento). Entre sus principales funciones: 
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

- **¿Que es un linker? ¿que hace?**
- **¿Que es la dirección que aparece en el script del linker?¿Porqué es necesaria?**
- **Compare la salida de objdump con hd, verifique donde fue colocado el programa dentro de la imagen.**
- **Grabar la imagen en un pendrive y probarla en una pc y subir una foto**
- **¿Para que se utiliza la opción --oformat binary en el linker?**


### 3. Modo Protegido

- **Crear un código assembler que pueda pasar a modo protegido (sin macros).**
- **¿Cómo sería un programa que tenga dos descriptores de memoria diferentes, uno para cada segmento (código y datos) en espacios de memoria diferenciados?**
- **Cambiar los bits de acceso del segmento de datos para que sea de solo lectura,  intentar escribir, ¿Que sucede? ¿Que debería suceder a continuación? (revisar el teórico) Verificarlo con gdb.**
- **En modo protegido, ¿Con qué valor se cargan los registros de segmento ? ¿Porque?**

