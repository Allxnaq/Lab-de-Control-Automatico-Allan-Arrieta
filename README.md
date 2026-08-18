Hola
Podria por favor agregar su nombre completo y su ID.
Gracias, 

Luis C. Rosales A. 

# Proyecto Individual 1 - Laboratorio de Control Automático

Script desarrollado en MATLAB para la simulación paramétrica de un sistema de primer orden correspondiente al modelo simplificado de un motor de corriente directa.

## Uso del script

1. Abrir el archivo `proyecto1_control.m` en MATLAB.
2. Ejecutar el script.
3. Ingresar los parámetros solicitados en la ventana de comandos:
   - `Kt`: constante de par del motor [N*m/A]
   - `Ra`: resistencia de armadura [ohm]
   - `b`: coeficiente de fricción [N*m*s/rad]
   - `Kb`: constante de fuerza contraelectromotriz [V*s/rad]
   - `J`: momento de inercia del motor y la carga [kg*m^2]
4. El programa valida los parámetros ingresados.
5. El script calcula y muestra:
   - Ganancia general `KM`
   - Constante de tiempo `tau`
   - Función de transferencia del sistema
6. Finalmente, se genera la gráfica de respuesta al escalón unitario mostrando:
   - Valor final teórico
   - Banda de asentamiento del 2 %
   - Respuesta en `t = tau`
   - Valor esperado en `t = 5*tau`
   - Tiempo de asentamiento

## Archivo principal

`proyecto1_control.m`
