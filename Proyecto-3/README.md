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

y comprobando que aparezca:

Symbolic Math Toolbox

No se requiere Simulink ni Control System Toolbox para ejecutar este script.

Uso del script
Abrir proyecto3_control.m en MATLAB.
Ejecutar el script.
Introducir los polos de la función de transferencia como un vector.
Introducir los ceros de la función de transferencia de la misma forma.
El programa construirá la función de transferencia y mostrará el Root Locus.
El usuario podrá ajustar el zoom de la gráfica.
Después de ajustar la vista, deberá presionar ENTER en la ventana de comandos.
Se selecciona la nueva posición del polo haciendo clic sobre el plano S.
El programa preguntará si se desea seleccionar otro polo.
Cuando se finalice la selección, se construirá la nueva ecuación característica y se calculará el compensador equivalente.
Formato de entrada

Los polos y ceros deben ingresarse entre corchetes y separados por espacios.

Ejemplo:

Ingrese los polos de G(s) como un vector ([num num num]): [-1 -4]
Ingrese los ceros de G(s) como un vector (use [] si no hay): []

Otro ejemplo con ceros:

Ingrese los polos de G(s) como un vector ([num num num]): [-1 -3 -5]
Ingrese los ceros de G(s) como un vector (use [] si no hay): [-2]

Si la función de transferencia no posee ceros, debe utilizarse:

[]

El programa considera funciones de transferencia propias, por lo que el
número de ceros no puede ser mayor que el número de polos.

Funcionamiento

El programa realiza automáticamente las siguientes operaciones:

1. Construcción de la función de transferencia

A partir de los polos y ceros ingresados, se construyen los polinomios:

N(s): Numerador
D(s): Denominador

y posteriormente la función de transferencia:

G(s) = N(s) / D(s)
2. Ecuación característica

Se construye la ecuación característica correspondiente a:

1 + Kp*G(s) = 0

la cual se expresa como:

D(s) + Kp*N(s) = 0

El programa muestra tanto la ecuación desarrollada como sus coeficientes.

3. Root Locus

El script calcula las raíces de la ecuación característica para diferentes
valores de la ganancia Kp y genera el Lugar de las Raíces.

En la gráfica se identifican:

Polos originales de la planta.
Ceros originales de la planta.
Trayectoria del Root Locus.
Frontera de estabilidad Re(s) = 0.
Selección interactiva de polos

Después de generar el Root Locus, el usuario puede seleccionar gráficamente
las nuevas posiciones deseadas de los polos.

Antes de cada selección se permite utilizar el zoom de MATLAB para ajustar
la región de interés.

Cuando la vista esté correctamente ajustada:

Se presiona ENTER en la ventana de comandos.
Se hace clic en la ubicación deseada del nuevo polo.
El programa muestra los polos definidos hasta el momento.
Se pregunta si se desea agregar otro polo.

El programa muestra:

Desea agregar otro polo? [s/n]:

Si se responde:

s

se permite volver a ajustar el zoom y seleccionar otro polo.

Si se responde:

n

se finaliza la selección y se continúa con el cálculo del sistema compensado.

Polos complejos conjugados

Si se selecciona gráficamente un polo complejo, el programa agrega
automáticamente su complejo conjugado.

Por ejemplo, si se selecciona aproximadamente:

-2.5 + 0.86i

también se agrega automáticamente:

-2.5 - 0.86i

Esto permite que la nueva ecuación característica mantenga coeficientes reales.

Nueva ecuación característica

Una vez finalizada la selección de polos, el programa construye el nuevo
polinomio característico a partir de las posiciones seleccionadas.

Por ejemplo, para polos cercanos a:

-2.5 + 0.86i
-2.5 - 0.86i

se obtiene aproximadamente:

s^2 + 5*s + 7 = 0

Las pequeñas diferencias numéricas pueden deberse a la precisión del clic
realizado sobre la gráfica.

Para reducir estos pequeños errores, el programa redondea los coeficientes
obtenidos después de la selección gráfica.

Obtención del compensador

La planta original se expresa como:

G(s) = N(s) / D(s)

Una vez definida la nueva ecuación característica a partir de los polos
seleccionados, el programa calcula el compensador equivalente C(s) como
complemento de la planta original.

El cálculo se realiza a partir de la diferencia entre la ecuación
característica deseada y el denominador original de la planta.

Si el compensador obtenido no depende de s, el programa lo identifica
como un compensador proporcional.

Ejemplo:

--- Compensador obtenido C(s) ---
2.9897

El compensador obtenido es proporcional.
Kp = 2.98970

En este caso:

C(s) = Kp

y por lo tanto corresponde a un controlador proporcional.

Si el compensador obtenido depende de s, el programa muestra su expresión
y señala que no corresponde únicamente a una ganancia proporcional Kp.

Ejemplo general:

El compensador obtenido depende de s.
Por lo tanto, no corresponde solamente a una ganancia Kp.
Ejemplo de prueba

Para la planta:

Polos: [-1 -4]
Ceros: []

se obtiene:

G(s) = 1 / (s^2 + 5*s + 4)

y la ecuación característica:

s^2 + 5*s + Kp + 4 = 0

Después de generar el Root Locus, el usuario puede ajustar el zoom y
seleccionar aproximadamente:

-2.5 + 0.86i

El programa agrega automáticamente el conjugado:

-2.5 - 0.86i

y obtiene una ecuación característica cercana a:

s^2 + 5*s + 7 = 0

El compensador calculado es aproximadamente:

Kp = 3

lo cual corresponde a un compensador proporcional.
