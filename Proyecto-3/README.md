# Proyecto Individual 3 - Laboratorio de Control Automático

Script desarrollado en MATLAB para el análisis del Lugar de las Raíces
(Root Locus) y la obtención de un sistema compensado a partir de una nueva
distribución de polos seleccionada por el usuario.

El programa recibe los polos y ceros de una función de transferencia,
construye la planta en forma racional, genera el Root Locus y permite
seleccionar gráficamente las nuevas posiciones deseadas de los polos.

A partir de esta nueva distribución, el script calcula la nueva ecuación
característica y obtiene el compensador equivalente C(s) como complemento
de la planta original.

---

## Requisitos

Para ejecutar el script se necesita:

- MATLAB
- Symbolic Math Toolbox

El programa utiliza funciones de cálculo simbólico como:

- `syms`
- `sym`
- `poly2sym`
- `simplify`
- `expand`
- `collect`
- `vpa`

Por lo tanto, **Symbolic Math Toolbox debe estar instalado**.

### Instalación de Symbolic Math Toolbox

En caso de no tenerlo instalado:

1. Abrir MATLAB.
2. Ir a la pestaña `Home`.
3. Seleccionar `Add-Ons`.
4. Buscar `Symbolic Math Toolbox`.
5. Seleccionarlo e instalarlo.

La instalación depende de que la licencia utilizada tenga acceso al toolbox.

También se puede verificar si está instalado ejecutando:

```matlab
ver
