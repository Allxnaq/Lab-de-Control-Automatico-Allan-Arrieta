clear;
clc;
close all;

% ============================================================
% Proyecto Individual 3 - Laboratorio de Control Automático
% Root Locus y Compensadores
% ============================================================

% ============================================================
% Entrada y validacion de polos
% ============================================================

entrada_polos = strtrim(input( ...
    "Ingrese los polos de G(s) como un vector ([num num num]): ", ...
    "s"));

% Verificar que la entrada empiece con [ y termine con ]
if ~startsWith(entrada_polos, "[") || ~endsWith(entrada_polos, "]")
    error("Formato de polos invalido. Utilice el formato [num num num].");
end

% Convertir el texto a un vector numerico
polos = str2num(entrada_polos); %#ok<ST2NM>

% Validar el contenido
if isempty(polos) || ~isnumeric(polos) || ...
        ~isvector(polos) || ~all(isfinite(polos))
    error("Los polos ingresados no forman un vector numerico valido.");
end
% ============================================================
% Entrada y validacion de ceros
% ============================================================

entrada_ceros = strtrim(input( ...
    "Ingrese los ceros de G(s) como un vector (use [] si no hay): ", ...
    "s"));

% Verificar que la entrada empiece con [ y termine con ]
if ~startsWith(entrada_ceros, "[") || ~endsWith(entrada_ceros, "]")
    error("Formato de ceros invalido. Utilice el formato [num num] o [].");
end

% Caso sin ceros
if strcmp(entrada_ceros, "[]")
    ceros = [];
else

    % Convertir el texto a un vector numerico
    ceros = str2num(entrada_ceros); %#ok<ST2NM>

    % Validar el contenido
    if isempty(ceros) || ~isnumeric(ceros) || ...
            ~isvector(ceros) || ~all(isfinite(ceros))
        error("Los ceros ingresados no forman un vector numerico valido.");
    end

end
% ============================================================
% Validacion de funcion de transferencia propia
% ============================================================

if length(ceros) > length(polos)
    error("La funcion de transferencia no es propia. El numero de ceros no puede ser mayor que el numero de polos.");
end

% ============================================================
% Construccion de los polinomios de G(s)
% ============================================================

den_G = poly(polos);
num_G = poly(ceros);

fprintf("\n--- Polos y ceros ingresados ---\n");

fprintf("Polos:\n");
disp(polos);

fprintf("Ceros:\n");
disp(ceros);

fprintf("--- Coeficientes del numerador N(s) ---\n");
disp(num_G);

fprintf("--- Coeficientes del denominador D(s) ---\n");
disp(den_G);

% ============================================================
% Ecuacion caracteristica de lazo cerrado
% 1 + Kp*G(s) = 0  ->  D(s) + Kp*N(s) = 0
% ============================================================

% Igualar la longitud del numerador con la del denominador
num_extendido = [zeros(1, length(den_G) - length(num_G)), num_G];

fprintf("\n--- Ecuacion caracteristica de lazo cerrado ---\n");
fprintf("D(s) + Kp*N(s) = 0\n\n");

fprintf("Coeficientes de D(s):\n");
disp(den_G);

fprintf("Coeficientes de N(s) alineados con D(s):\n");
disp(num_extendido);

% ============================================================
% Coeficientes simbolicos de la ecuacion caracteristica
% ============================================================

syms Kp s real

coef_ec = sym(den_G) + Kp*sym(num_extendido);

% Construir la expresion simbolica de la ecuacion caracteristica
D_s = poly2sym(den_G, s);
N_s = poly2sym(num_G, s);

% ============================================================
% Funcion de transferencia en formato racional
% ============================================================

G_s = simplify(N_s / D_s);

fprintf("\n--- Funcion de transferencia G(s) ---\n");
disp(G_s);
ecuacion_caracteristica = expand(D_s + Kp*N_s);

fprintf("\n--- Ecuacion caracteristica desarrollada ---\n");
disp(ecuacion_caracteristica == 0);

fprintf("\n--- Coeficientes de la ecuacion caracteristica ---\n");
disp(coef_ec);

% ============================================================
% Lugar de las raices - Root Locus
% ============================================================

% Valores de ganancia para construir el lugar de las raices
K_valores = [0 logspace(-4, 4, 2000)];

numero_polos = length(polos);

% Matriz para almacenar las raices para cada valor de K
raices_rl = NaN(length(K_valores), numero_polos);

for i = 1:length(K_valores)

    % Ecuacion caracteristica para el valor actual de K
    coef_actuales = den_G + K_valores(i)*num_extendido;

    % Calcular polos de lazo cerrado
    raices_actuales = roots(coef_actuales);

    % Guardar las raices
    raices_rl(i,:) = raices_actuales.';
end

% ============================================================
% Grafica del Root Locus
% ============================================================

figure;
hold on;
grid on;

% Dibujar las posiciones de las raices para cada K
for i = 1:numero_polos
    plot(real(raices_rl(:,i)), imag(raices_rl(:,i)), ".", ...
        "MarkerSize", 5, ...
        "HandleVisibility", "off");
end

% Marcador auxiliar para la leyenda del Root Locus
h_rl = plot(NaN, NaN, ".", ...
    "MarkerSize", 10);

% Polos de lazo abierto
h_polos = plot(real(polos), imag(polos), "x", ...
    "MarkerSize", 10, ...
    "LineWidth", 2);

% Ceros de lazo abierto
if ~isempty(ceros)
    h_ceros = plot(real(ceros), imag(ceros), "o", ...
        "MarkerSize", 9, ...
        "LineWidth", 2);
end

% Frontera de estabilidad
xline(0, "--", ...
    "Re(s) = 0", ...
    "HandleVisibility", "off");

% Ejes
yline(0, "-", ...
    "HandleVisibility", "off");

title("Lugar de las raices - Root Locus");
xlabel("Parte real");
ylabel("Parte imaginaria");

% Leyenda
if isempty(ceros)

    legend([h_rl h_polos], ...
        "Root Locus", ...
        "Polos de lazo abierto", ...
        "Location", "best");

else

    legend([h_rl h_polos h_ceros], ...
        "Root Locus", ...
        "Polos de lazo abierto", ...
        "Ceros de lazo abierto", ...
        "Location", "best");

end

hold off;

% ============================================================
% Seleccion interactiva de nuevos polos
% ============================================================

fprintf("\n--- Seleccion de polos deseados ---\n");
fprintf("Los polos se seleccionaran uno por uno.\n");
fprintf("Antes de cada seleccion podra ajustar el zoom.\n");
fprintf("Si selecciona un polo complejo, su conjugado se agrega automaticamente.\n");

polos_deseados = [];

continuar = true;

while continuar

    % Permitir ajustar la vista
    fprintf("\nAjuste el zoom de la grafica para seleccionar el siguiente polo.\n");

    zoom on;

    input("Cuando termine de ajustar la vista, presione ENTER aqui: ", "s");

    zoom off;

    % Seleccionar UN solo punto
    fprintf("Haga clic en la posicion deseada del polo.\n");

    [x_nuevo, y_nuevo] = ginput(1);

    polo = x_nuevo + 1i*y_nuevo;

    % Si el polo es practicamente real
    if abs(y_nuevo) < 1e-6

        polos_deseados(end+1) = real(polo); 

        hold on;
        plot(real(polo), 0, "p", ...
            "MarkerSize", 12, ...
            "LineWidth", 2);
        hold off;

    % Si el polo es complejo
    else

        polos_deseados(end+1) = polo; 
        polos_deseados(end+1) = conj(polo); 

        hold on;

        plot(real(polo), imag(polo), "p", ...
            "MarkerSize", 12, ...
            "LineWidth", 2);

        plot(real(polo), -imag(polo), "p", ...
            "MarkerSize", 12, ...
            "LineWidth", 2);

        hold off;

    end

    % Mostrar lo que ya se selecciono
    fprintf("\nPolos definidos hasta el momento:\n");
    disp(polos_deseados.');

    % Preguntar si desea agregar otro
    respuesta = lower(strtrim(input( ...
        "Desea agregar otro polo? [s/n]: ", ...
        "s")));

    if strcmp(respuesta, "n")
        continuar = false;
    end

end

% ============================================================
% Mostrar los nuevos polos sobre el Root Locus
% ============================================================

hold on;

h_deseados = plot(real(polos_deseados), imag(polos_deseados), "p", ...
    "MarkerSize", 12, ...
    "LineWidth", 2);

% Actualizar leyenda
if isempty(ceros)

    legend([h_rl h_polos h_deseados], ...
        "Root Locus", ...
        "Polos originales", ...
        "Polos deseados", ...
        "Location", "best");

else

    legend([h_rl h_polos h_ceros h_deseados], ...
        "Root Locus", ...
        "Polos originales", ...
        "Ceros originales", ...
        "Polos deseados", ...
        "Location", "best");

end

hold off;

% ============================================================
% Nueva ecuacion caracteristica del sistema compensado
% ============================================================

coef_ec_compensada = poly(polos_deseados);

% Eliminar pequenos errores numericos producidos por la seleccion grafica
coef_ec_compensada = real(coef_ec_compensada);
coef_ec_compensada = round(coef_ec_compensada, 4);

ec_compensada = poly2sym(coef_ec_compensada, s);
ec_compensada = expand(ec_compensada);

fprintf("\n--- Nueva ecuacion caracteristica ---\n");
disp(vpa(ec_compensada == 0, 5));

fprintf("\nCoeficientes de la nueva ecuacion caracteristica:\n");
disp(coef_ec_compensada);

% ============================================================
% Calculo del compensador equivalente C(s)
% ============================================================

% Ecuacion caracteristica deseada definida por los nuevos polos
D_deseado_s = ec_compensada;

% Calcular el compensador como complemento de la planta
C_s = simplify((D_deseado_s - D_s) / N_s);
C_s = collect(expand(C_s), s);

fprintf("\n--- Compensador obtenido C(s) ---\n");
disp(vpa(C_s, 5));

% Identificar si el compensador es solamente una ganancia proporcional
if ~has(C_s, s)

    fprintf("\nEl compensador obtenido es proporcional.\n");
    fprintf("Kp = %.5f\n", double(C_s));

else

    fprintf("\nEl compensador obtenido depende de s.\n");
    fprintf("Por lo tanto, no corresponde solamente a una ganancia Kp.\n");

end
