clear;
clc;
close all;

% ============================================================
% Proyecto Individual 2 - Laboratorio de Control Automático
% Routh-Hurwitz y Root Locus
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
% 1 + K*G(s) = 0  ->  D(s) + K*N(s) = 0
% ============================================================

% Igualar la longitud del numerador con la del denominador
num_extendido = [zeros(1, length(den_G) - length(num_G)), num_G];

fprintf("\n--- Ecuacion caracteristica de lazo cerrado ---\n");
fprintf("D(s) + K*N(s) = 0\n\n");

fprintf("Coeficientes de D(s):\n");
disp(den_G);

fprintf("Coeficientes de N(s) alineados con D(s):\n");
disp(num_extendido);

% ============================================================
% Coeficientes simbolicos de la ecuacion caracteristica
% ============================================================

syms K s real

coef_ec = sym(den_G) + K*sym(num_extendido);

% Construir la expresion simbolica de la ecuacion caracteristica
D_s = poly2sym(den_G, s);
N_s = poly2sym(num_G, s);

ecuacion_caracteristica = expand(D_s + K*N_s);

fprintf("\n--- Ecuacion caracteristica desarrollada ---\n");
disp(ecuacion_caracteristica == 0);

fprintf("\n--- Coeficientes de la ecuacion caracteristica ---\n");
disp(coef_ec);

% ============================================================
% Construccion automatica de la tabla de Routh-Hurwitz
% ============================================================

n = length(coef_ec) - 1;        % Grado de la ecuacion
num_columnas = ceil((n + 1)/2);

routh = sym(zeros(n + 1, num_columnas));

% Primera fila: coeficientes de s^n, s^(n-2), s^(n-4), ...
fila1 = coef_ec(1:2:end);
routh(1, 1:length(fila1)) = fila1;

% Segunda fila: coeficientes de s^(n-1), s^(n-3), ...
fila2 = coef_ec(2:2:end);
routh(2, 1:length(fila2)) = fila2;

% Calculo de las filas restantes
for i = 3:n+1

    for j = 1:num_columnas-1

        routh(i,j) = simplify( ...
            (routh(i-1,1)*routh(i-2,j+1) ...
            - routh(i-2,1)*routh(i-1,j+1)) ...
            / routh(i-1,1));

    end

end

fprintf("\n--- Tabla de Routh-Hurwitz ---\n");
disp(routh);

% ============================================================
% Analisis de estabilidad mediante Routh-Hurwitz
% ============================================================

primera_columna = simplify(routh(:,1));

fprintf("\n--- Primera columna de Routh ---\n");
disp(primera_columna);

% Condicion de estabilidad:
% Todos los elementos de la primera columna deben ser positivos

condiciones = primera_columna > 0;

fprintf("\n--- Condiciones de estabilidad ---\n");
disp(condiciones);

% ============================================================
% Resolver las condiciones de estabilidad
% ============================================================

sol_estabilidad = solve(condiciones, K, ...
    "ReturnConditions", true);

fprintf("\n--- Rango de estabilidad ---\n");
% Reemplazar el parametro auxiliar de solve por K para mostrarlo
rango_estabilidad_K = sol_estabilidad.conditions;

if isempty(sol_estabilidad.parameters) && isempty(sol_estabilidad.conditions)
    fprintf("No existe ningun valor de K que haga estable al sistema.\n");
else
    if ~isempty(sol_estabilidad.parameters)
        rango_estabilidad_K = subs( ...
            rango_estabilidad_K, ...
            sol_estabilidad.parameters, ...
            K);
    end
    disp(rango_estabilidad_K);
end

% ============================================================
% Rango estable para ganancias K >= 0
% ============================================================

condiciones_root_locus = [condiciones; K >= 0];

sol_root_locus = solve(condiciones_root_locus, K, ...
    "ReturnConditions", true);
fprintf("\n--- Rango estable para K >= 0 ---\n");

% Reemplazar el parametro auxiliar de solve por K
rango_root_locus_K = sol_root_locus.conditions;

if isempty(sol_root_locus.parameters) && isempty(sol_root_locus.conditions)
    fprintf("No existe ningun valor de K >= 0 que haga estable al sistema.\n");
else
    if ~isempty(sol_root_locus.parameters)
    rango_root_locus_K = subs( ...
        rango_root_locus_K, ...
        sol_root_locus.parameters, ...
        K);
    end

    disp(rango_root_locus_K);
end

% ============================================================
% Conclusion del analisis de estabilidad
% ============================================================

% Combinar todas las condiciones de Routh en una sola expresion
condicion_total = condiciones(1);

for i = 2:length(condiciones)
    condicion_total = condicion_total & condiciones(i);
end

% Comprobar si las condiciones se cumplen para todo K >= 0
estable_todo_K_positivo = isAlways( ...
    (K < 0) | condicion_total, ...
    "Unknown", "false");

fprintf("\n--- Conclusion del analisis ---\n");

if estable_todo_K_positivo

    fprintf("El sistema es estable para todo K >= 0.\n");
    fprintf("Justificacion: todos los elementos de la primera columna ");
    fprintf("de la tabla de Routh-Hurwitz permanecen positivos ");
    fprintf("para ganancias K no negativas.\n");

else

    fprintf("El sistema NO es estable para todos los valores de K >= 0.\n");
    fprintf("El rango de estabilidad obtenido mediante ");
    fprintf("Routh-Hurwitz es:\n");

    disp(rango_root_locus_K);

end

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