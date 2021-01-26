%Facultad de Ingenieria
%Universidad de Buenos Aires
%Control Automatico I
%Trabajo Practico N°4
%Lucia Berard
%Padron 101213
%lberard@fi.uba.ar

clear all; close all; clc;
s = tf('s');

%% Diseño por Loop Shaping------------------------------------------------

%% Separo H(s) en fase mínima y pasa todo
H = 20/((s+6.519)*(s+4)*(s-6.519));
Hmp = 20/((s+6.519)^2*(s+4));
Hap = (s+6.519)/(s-6.519);

%% Diseño del controlador. 
% Polos de la fase minima => ceros del controlador
% Polo en cero (integral)
% Polo doble en -100 (#polos >= #ceros)
C = (1/s)*(s+6.519)^2*(s+4)/((s+100)^2); 

%% Para obtener el valor de k:
%Bode para observar phase margin
% figure
% bode(L)
% title('Diagrama de Bode del sistema a lazo abierto k=1');
% grid on

%Se agrega una red de adelanto de fase para que cumpla el margen mayor a 60
R = 100*(s+10)/(s+1000);
figure
hold on
L = C*H;
bode(L)
L = R*C*H;
bode(L)
title('Diagrama de Bode del sistema a lazo abierto con k = 1');
legend('Sin red','Con red')
grid on
hold off

%Root-Locus para observar overshoot
figure
rlocus(L)
grid on

%Se vario el valor de la ganancia y se eligio 80.4dB para mantener buen
%margen > 60° y overshoot < 20%
k = db2mag(80.4);
C = k*C;
L = R*C*H;
figure
bode(L) %68.9 margen de fase
title('Diagrama de Bode del sistema a lazo abierto con k = 80.4 dB y red de adelanto de fase');
grid on

figure
step(feedback(L,1)) %overshoot 19.8%
title('Respuesta al escalón a lazo cerrado con k = 80.4 dB')
grid on


%% Digitalizacion
T_s = 1/340;
M = (1-s*T_s/4)/(1+s*T_s/4);
L = R*C*H*M;
figure
bode(L)
title('Diagrama de Bode del sistema a lazo abierto con Ts = 1/340 s');
grid on

figure
step(feedback(L,1))
title('Respuesta al escalon a lazo cerrado con Ts = 1/340 s')
grid on

%% Margen de estabilidad
lambda = 1 + C*H;
S = 1/lambda;

figure
bode(S)
title('Diagrama de Bode de la funcion de sensibilidad S(s)');
grid on

s_m = 1/getPeakGain(S)
