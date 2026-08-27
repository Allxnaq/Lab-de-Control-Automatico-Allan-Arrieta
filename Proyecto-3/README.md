# Proyecto Individual 3 - Laboratorio de Control Automático

Script desarrollado en MATLAB para el análisis del Lugar de las Raíces (**Root Locus**) y la obtención de un sistema compensado a partir de una nueva distribución de polos seleccionada por el usuario.

El programa recibe los polos y ceros de una función de transferencia, construye la planta en forma racional, genera el Root Locus y permite seleccionar gráficamente nuevas posiciones para los polos del sistema.

A partir de esta nueva distribución, el script calcula la nueva ecuación característica y obtiene el compensador equivalente `C(s)` como complemento de la planta original.

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
```

y comprobando que aparezca:

```text
Symbolic Math Toolbox
```

No se requiere Simulink ni Control System Toolbox para ejecutar este script.

---

## Archivo principal

```text
proyecto3_control.m
```

---

## Uso del script

1. Abrir `proyecto3_control.m` en MATLAB.
2. Ejecutar el script.
3. Introducir los polos de la función de transferencia como un vector.
4. Introducir los ceros de la función de transferencia de la misma forma.
5. El programa construirá la función de transferencia y mostrará el Root Locus.
6. El usuario podrá ajustar el zoom de la gráfica antes de seleccionar cada nuevo polo.
7. Después de ajustar la vista, deberá presionar `ENTER` en la ventana de comandos.
8. Se selecciona la nueva posición del polo haciendo clic sobre el plano S.
9. El programa mostrará los polos seleccionados hasta ese momento.
10. El programa preguntará si se desea agregar otro polo.
11. Cuando se finalice la selección, se construirá la nueva ecuación característica.
12. Finalmente, se calculará el compensador equivalente `C(s)`.

---

## Formato de entrada

Los polos y ceros deben ingresarse entre corchetes y separados por espacios.

Ejemplo:

```text
Ingrese los polos de G(s) como un vector ([num num num]): [-1 -4]
Ingrese los ceros de G(s) como un vector (use [] si no hay): []
```

Otro ejemplo con ceros:

```text
Ingrese los polos de G(s) como un vector ([num num num]): [-1 -3 -5]
Ingrese los ceros de G(s) como un vector (use [] si no hay): [-2]
```

Si la función de transferencia no posee ceros, debe utilizarse:

```text
[]
```

El programa considera funciones de transferencia propias, por lo que el número de ceros no puede ser mayor que el número de polos.

Si el formato ingresado no es válido, el programa finaliza y muestra un mensaje indicando el error.

---

## Funcionamiento

### 1. Construcción de la función de transferencia

A partir de los polos y ceros ingresados, el programa construye automáticamente los polinomios:

```text
N(s): Numerador
D(s): Denominador
```

y posteriormente forma la función de transferencia:

```text
G(s) = N(s) / D(s)
```

Por ejemplo, para:

```text
Polos: [-1 -4]
Ceros: []
```

se obtiene:

```text
G(s) = 1 / (s^2 + 5*s + 4)
```

---

### 2. Ecuación característica

Se construye la ecuación característica correspondiente a:

```text
1 + Kp*G(s) = 0
```

la cual puede expresarse como:

```text
D(s) + Kp*N(s) = 0
```

El programa muestra tanto la ecuación característica desarrollada como sus coeficientes.

Para el ejemplo anterior se obtiene:

```text
s^2 + 5*s + Kp + 4 = 0
```

---

### 3. Root Locus

El script calcula las raíces de la ecuación característica para diferentes valores de la ganancia `Kp` y construye el Lugar de las Raíces.

En la gráfica se identifican:

- Polos originales de la planta.
- Ceros originales de la planta.
- Trayectoria del Root Locus.
- Frontera de estabilidad `Re(s) = 0`.

El Root Locus se obtiene directamente a partir del cálculo de las raíces para diferentes valores de `Kp`.

---

## Selección interactiva de polos

Después de generar el Root Locus, el programa permite seleccionar gráficamente nuevas posiciones para los polos.

La selección se realiza un polo a la vez.

Antes de seleccionar cada polo:

1. El programa habilita el zoom de MATLAB.
2. El usuario puede acercar o alejar la gráfica hasta visualizar correctamente la región deseada.
3. Cuando la vista sea adecuada, se debe presionar `ENTER` en la ventana de comandos.
4. El zoom se desactiva.
5. El usuario debe hacer clic sobre la nueva ubicación del polo.
6. El programa muestra los polos seleccionados hasta ese momento.

Posteriormente aparece la pregunta:

```text
Desea agregar otro polo? [s/n]:
```

Si se responde:

```text
s
```

el programa vuelve a habilitar el zoom para seleccionar otro polo.

Si se responde:

```text
n
```

se finaliza la selección y se continúa con el cálculo del sistema compensado.

---

## Polos complejos conjugados

Si se selecciona gráficamente un polo complejo, el programa agrega automáticamente su complejo conjugado.

Por ejemplo, si se selecciona aproximadamente:

```text
-2.5 + 0.86i
```

también se agrega automáticamente:

```text
-2.5 - 0.86i
```

De esta forma se obtiene un par de polos complejos conjugados y la nueva ecuación característica mantiene coeficientes reales.

Por ejemplo:

```text
Polos definidos hasta el momento:

-2.5000 + 0.8600i
-2.5000 - 0.8600i
```

---

## Nueva ecuación característica

Una vez finalizada la selección de polos, el programa construye el nuevo polinomio característico utilizando las posiciones seleccionadas.

Para polos cercanos a:

```text
-2.5 + 0.86i
-2.5 - 0.86i
```

se obtiene aproximadamente:

```text
s^2 + 5*s + 7 = 0
```

Las pequeñas diferencias numéricas que puedan aparecer se deben a la precisión del clic realizado sobre la gráfica.

Para reducir estos pequeños errores numéricos, los coeficientes obtenidos mediante la selección gráfica son redondeados antes de construir la ecuación característica final.

---

## Obtención del compensador

La planta original se expresa como:

```text
G(s) = N(s) / D(s)
```

Una vez definida la nueva ecuación característica mediante los polos seleccionados, el programa calcula el compensador equivalente `C(s)` como complemento de la planta original.

El compensador se obtiene a partir de la relación entre la nueva ecuación característica y la función de transferencia original.

El programa muestra directamente la expresión calculada para:

```text
C(s)
```

---

## Compensador proporcional

Si el compensador obtenido no depende de `s`, el programa lo identifica como un compensador proporcional.

En este caso:

```text
C(s) = Kp
```

Por ejemplo:

```text
--- Compensador obtenido C(s) ---
2.9897

El compensador obtenido es proporcional.
Kp = 2.98970
```

Esto significa que el sistema puede alcanzar aproximadamente la distribución de polos seleccionada utilizando únicamente una ganancia proporcional.

---

## Compensadores dependientes de `s`

Si el compensador obtenido depende de `s`, el programa muestra su expresión e indica que no corresponde únicamente a una ganancia proporcional `Kp`.

Ejemplo:

```text
--- Compensador obtenido C(s) ---
s^2 + 3*s + 5

El compensador obtenido depende de s.
Por lo tanto, no corresponde solamente a una ganancia Kp.
```

En estos casos, el resultado representa un compensador más general cuya respuesta depende de la variable `s`.

---

## Ejemplo de prueba

Para la planta:

```text
Polos: [-1 -4]
Ceros: []
```

se obtiene:

```text
G(s) = 1 / (s^2 + 5*s + 4)
```

La ecuación característica original es:

```text
s^2 + 5*s + Kp + 4 = 0
```

Después de generar el Root Locus, el usuario puede ajustar el zoom y seleccionar aproximadamente:

```text
-2.5 + 0.86i
```

El programa agrega automáticamente el complejo conjugado:

```text
-2.5 - 0.86i
```

La nueva ecuación característica obtenida es aproximadamente:

```text
s^2 + 5*s + 7 = 0
```

y el compensador calculado es cercano a:

```text
Kp = 3
```

Por lo tanto, para esta selección particular, el compensador obtenido corresponde aproximadamente a un controlador proporcional con ganancia:

```text
C(s) = 3
```

---

## Resumen del funcionamiento

El flujo general del programa es:

```text
Polos y ceros
      |
      v
Construcción de G(s)
      |
      v
Ecuación característica
      |
      v
Root Locus
      |
      v
Selección gráfica de nuevos polos
      |
      v
Nueva ecuación característica
      |
      v
Cálculo del compensador C(s)
```

El script permite:

- Ingresar los polos y ceros de una planta.
- Validar el formato de entrada.
- Verificar que la función de transferencia sea propia.
- Construir la función de transferencia en forma racional.
- Obtener la ecuación característica.
- Generar el Root Locus.
- Visualizar los polos y ceros originales.
- Visualizar la frontera de estabilidad.
- Ajustar el zoom antes de cada selección.
- Seleccionar nuevas ubicaciones de polos mediante clics.
- Agregar automáticamente polos complejos conjugados.
- Seleccionar varios polos en diferentes regiones del plano S.
- Construir la nueva ecuación característica.
- Calcular el compensador equivalente `C(s)`.
- Identificar cuando el compensador obtenido corresponde únicamente a una ganancia proporcional `Kp`.
