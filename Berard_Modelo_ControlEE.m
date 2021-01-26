%Facultad de Ingenieria
%Universidad de Buenos Aires
%Control Automatico I
%Trabajo Practico N°4
%Lucia Berard
%Padron 101213
%lberard@fi.uba.ar

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Modelo
clear all; close all; clc;
s = tf('s');

%Descripcion en espacios de estado
A = [0 1 0;42.5 0 20;0 0 -4];
B = [0 0 1]'; 
C = [1 0 0];
D = 0;
xo = [0;0;0.5];

%Transferencia del sistema - Estabilidad
[numerador, denominador] = ss2tf(A,B,C,D); 
fprintf('Transferencia del sistema:\n');
transf = tf(numerador, denominador,1)
polos = pole(transf)
[ceros, ganancia] = zero(transf)
I = eye(3);
H = C*inv((s*I)-A)*B+D;

%Verificacion con Nyquist - Estabilidad
nyqlog(H)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Control en espacio de estados-------------------------------------------
%% Realimentacion espacio de estados
autov_ee = [-20 -10 -10]; %polos para el lazo
%autov_ee = [-20 -20 -20];
%Funcion acker para obtener el gain segun esos polos
k_f = acker(A,B, autov_ee)

%% Realimentacion en espacio de estados con accion integral
%Matriz A_a es 4x4 con la matriz A a la izquierda arriba, abajo -C y la
%cuarta columna se completa con ceros
A_a = [A zeros(3,1);-C 0] 

%B_a 4x1 con valores de b1, b2, b3, -d=0;
B_a = [B;-D] 
%Agrego otro polo:
k_a = acker(A_a,B_a,[-20 -10 -10 -10])
%k_a = acker(Aa,Ba,[-20 -20 -20 -20]);

k_g = k_a(1:3) %tres primeros
k_i = -k_a(end) %ultimo invertido

%% Observador
L = acker(A',C',[-70 -70 -70])'

