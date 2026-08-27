# Proyecto Individual 3 - Laboratorio de Control Automático

Script desarrollado en MATLAB para el análisis del lugar de las raíces
(Root Locus) y el diseño interactivo de una nueva distribución de polos
para obtener la ecuación característica de un sistema compensado.

El programa recibe los polos y ceros de una función de transferencia,
construye la planta en forma racional, genera el Root Locus y permite al
usuario seleccionar gráficamente las nuevas posiciones deseadas de los
polos.

A partir de la nueva distribución se calcula la ecuación característica
del sistema compensado y el compensador equivalente C(s).

## Requisitos

Para ejecutar el programa se necesita:

- MATLAB
- Symbolic Math Toolbox

No se requiere Simulink ni Control System Toolbox.

### Instalación de Symbolic Math Toolbox

Si Symbolic Math Toolbox no se encuentra instalado:

1. Abrir MATLAB.
2. Ir a la pestaña `Home`.
3. Seleccionar `Add-Ons`.
4. Abrir el explorador de complementos.
5. Buscar `Symbolic Math Toolbox`.
6. Seleccionar el toolbox e instalarlo.

La instalación está sujeta a que la licencia de MATLAB utilizada tenga
acceso a Symbolic Math Toolbox.

Para comprobar los productos instalados se puede ejecutar en la ventana
de comandos:

```matlab
ver
