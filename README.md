#  EL-3313 Taller de Diseño Digital  
## Laboratorio 1: Introducción al diseño digital con HDL y herramientas EDA de síntesis  

Repositorio del **Laboratorio 1** del curso **EL-3313 Taller de Diseño Digital (II Semestre 2025, ITCR)**.  
Este repositorio contiene los diseños en **SystemVerilog**, testbenches, simulaciones y documentación asociados a los ejercicios planteados en el instructivo oficial.  

---

##  Contenido del laboratorio
Los ejercicios desarrollados son:  

1. **Switches, botones y LEDs**  
   - Control de grupos de interruptores y LEDs con botones de la tarjeta FPGA.  
   - Implementación de lógica combinacional y testbench.  

2. **Multiplexor 4-to-1 parametrizable**  
   - Diseño de un MUX genérico para distintos anchos de palabra (4, 8 y 16 bits).  
   - Testbench autovalidado con conjuntos de datos.  

3. **Decodificador para display de 7 segmentos**  
   - Conversión de valores binarios a hexadecimal en display.  
   - Multiplexación de entradas con switches y botones.  

4. **Sumador y análisis de ruta crítica**  
   - Ripple-Carry Adder (RCA) parametrizable.  
   - Comparación con Carry-Lookahead Adder (CLA).  
   - Validación con restricciones de tiempo.  

5. **Unidad Aritmética Lógica (ALU)**  
   - ALU parametrizable de *n* bits.  
   - Operaciones: AND, OR, NOT, suma, resta, incremento, decremento, XOR, corrimientos, máximo y mínimo.  
   - Implementación con banderas de estado (Zero, Carry, etc.).  

---

## Herramientas utilizadas
- **Lenguaje**: [SystemVerilog](https://standards.ieee.org/standard/1800-2017.html)  
- **Entorno EDA**: Vivado / Quartus (según disponibilidad del curso).  
- **Simulación**: Testbenches a nivel **behavioral** y **post-síntesis**.  
- **Control de versiones**: Git + GitHub.  

---
