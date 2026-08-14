clear;
clc;
close all;

% ============================================================
% Proyecto Individual 1 - Laboratorio de Control Automatico
% Modelo de primer orden de un motor DC
% ============================================================

% ============================================================
% Entrada y validacion de parametros
% ============================================================

% Kt: constante de par del motor
while true
    entrada = input("Ingrese Kt [N*m/A]: ", "s");
    Kt = str2double(entrada);

    if isfinite(Kt) && Kt > 0
        break;
    else
        fprintf("Error: Kt debe ser un numero positivo.\n");
    end
end

% Ra: resistencia de armadura
while true
    entrada = input("Ingrese Ra [ohm]: ", "s");
    Ra = str2double(entrada);

    if isfinite(Ra) && Ra > 0
        break;
    else
        fprintf("Error: Ra debe ser un numero positivo.\n");
    end
end

% b: coeficiente de friccion
while true
    entrada = input("Ingrese b [N*m*s/rad]: ", "s");
    b = str2double(entrada);

    if isfinite(b) && b >= 0
        break;
    else
        fprintf("Error: b debe ser un numero mayor o igual que cero.\n");
    end
end

% Kb: constante de fuerza contraelectromotriz
while true
    entrada = input("Ingrese Kb [V*s/rad]: ", "s");
    Kb = str2double(entrada);

    if isfinite(Kb) && Kb > 0
        break;
    else
        fprintf("Error: Kb debe ser un numero positivo.\n");
    end
end

% J: momento de inercia
while true
    entrada = input("Ingrese J [kg*m^2]: ", "s");
    J = str2double(entrada);

    if isfinite(J) && J > 0
        break;
    else
        fprintf("Error: J debe ser un numero positivo.\n");
    end
end

% ============================================================
% Calculo de los parametros del sistema
% ============================================================

denominator = Ra*b + Kt*Kb;

KM = Kt / denominator;
tau = Ra*J / denominator;

% Mostrar resultados
fprintf("\n--- Parametros calculados ---\n");
fprintf("KM  = %.6f\n", KM);
fprintf("tau = %.6f s\n", tau);

% ============================================================
% Funcion de transferencia
% ============================================================

fprintf("\n--- Funcion de transferencia ---\n");
fprintf("G(s) = %.6f / (%.6f*s + 1)\n", KM, tau);


% ============================================================
% Respuesta al escalon unitario
% ============================================================

t_final = 6*tau;
t = linspace(0, t_final, 1000);

y = KM * (1 - exp(-t/tau));

% ============================================================
% Valores caracteristicos de la respuesta
% ============================================================

valor_final = KM;

% Respuesta en t = tau
y_tau = KM * (1 - exp(-1));

% Respuesta en t = 5*tau
y_5tau = KM * (1 - exp(-5));

% Error restante en t = 5*tau respecto al valor final
error_5tau = valor_final - y_5tau;

% Tiempo de asentamiento exacto para banda del 2 %
ts = -tau * log(0.02);

% Limites de la banda del 2 %
lim_inf = 0.98 * valor_final;
lim_sup = 1.02 * valor_final;

% ============================================================
% Grafica de la respuesta
% ============================================================

figure;

% Respuesta del sistema
h1 = plot(t, y, "LineWidth", 2);
hold on;
grid on;

% Valor final
h2 = yline(valor_final, "--", "LineWidth", 1.2);

% Banda del 2 %
h3 = yline(lim_inf, ":", "LineWidth", 1.2);
yline(lim_sup, ":", "LineWidth", 1.2, ...
    "HandleVisibility", "off");

% Punto en t = tau
h4 = plot(tau, y_tau, "o", ...
    "MarkerSize", 8, ...
    "LineWidth", 2);

xline(tau, "--", "HandleVisibility", "off");

% Punto en t = 5*tau
h5 = plot(5*tau, y_5tau, "s", ...
    "MarkerSize", 8, ...
    "LineWidth", 2);

xline(5*tau, "--", "HandleVisibility", "off");

% Tiempo de asentamiento
h6 = xline(ts, "-.", "LineWidth", 1.5);

% Etiquetas sobre puntos importantes
text(tau, y_tau, ...
    sprintf("  t = \\tau\n  y = %.3f", y_tau), ...
    "VerticalAlignment", "bottom");

text(5*tau, y_5tau, ...
    sprintf("  t = 5\\tau\n  y = %.3f", y_5tau), ...
    "VerticalAlignment", "bottom");

text(ts, lim_inf, ...
    sprintf("  t_s = %.3f s", ts), ...
    "VerticalAlignment", "top");

% Titulos
title("Respuesta al escalon unitario");
xlabel("Tiempo [s]");
ylabel("Velocidad angular [rad/s]");

% Limites para dejar espacio visual
ylim([0 1.08*valor_final]);

% Leyenda simplificada
legend([h1 h2 h3 h4 h5 h6], ...
    "Respuesta del sistema", ...
    "Valor final teorico", ...
    "Banda del 2 %", ...
    "Respuesta en t = \tau", ...
    "Valor esperado en t = 5\tau", ...
    "Tiempo de asentamiento", ...
    "Location", "southeast");

hold off;

fprintf("\n--- Metricas de la respuesta ---\n");
fprintf("y(tau)       = %.6f rad/s\n", y_tau);
fprintf("y(5*tau)     = %.6f rad/s\n", y_5tau);
fprintf("Valor final  = %.6f rad/s\n", valor_final);
fprintf("Diferencia respecto al valor final en 5tau = %.6f rad/s\n", error_5tau);
fprintf("ts (2%%)      = %.6f s\n", ts);