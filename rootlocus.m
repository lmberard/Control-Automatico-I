%ROOT LOCUS IN MATLAB BY BRIAN DOUGLAS

%Primero hay que declarar la variable s
s = tf('s')

%Formas de escribir la funcion:
%1)Mandarle de una:
GH = 1 /(s*(s+4)*(s^2+4*s+20))
%esto me lo va a poner entero jaja thats what she said 

%2)funcion tf usando los coeficientes de los polinomios
num = 1;
den = [1 8 36 80]; 
GH_tf = tf(num, den)

%3) funcion zpk(zero,poles,gain)
GH_zpk = zpk([], [-4,-2+4i, -2-4i],1)
%Tiene 4 polos y ningun cero. Ganancia 1

%Polos y ceros
polos = pole(GH)
ceros = zero(GH)
pzmap(GH)

%Para ver como varia el pzmap segun la ganancia k:
for k = 1:10:101
    pzmap(feedback(GH*k,1))
    hold on
end 
%Pero con esto es medio paja de ver bien el rango piola de k
%=> FUNCION RLOCUS
hold off 
rlocus(GH)
grid on
%Si apreto boton derecho en alguna parte del rlocus me va a tirar toda la
%data (gain, pole, damping, %overshoot, frequency)

%lo malo del rlocus es que no se puede ver como todas las roots se mueven
%al mismo tiempo, solo se tiene control sobre una.tampoco se puede ver bien
%el efecto del compensador en el sistema
%=> SISOTOOL
%Para usar esto hay que tener instalar el paquete de toolbox (ver en la
%pestaña de apps si tengo el control System Designer)
%Edit arquitecture=> ahi me fijo si el diagram coicide con lo que tengo y
%asocio G a GH y el resto lo dejo en 1 (para este ejemplo)
%sino directamente hacer:
sisotool(GH)

%COSAS CHETAS DEL SISOTOOL:
%para que figure el grid => preferences
%ahora si muevo las roots en el root locus, se mueven todos los polos y veo
%como afecta en el bode y un par de giladas mas en TIEMPO REAL SEGUN COMO
%MUEVO => CHETO
%En new plot hay pa agregar el impulso y un par de cosas mas
%en cada plot click derecho sobre la parte donde esta el grafico:
    %Design requirement 
    %en el bode y el root locus:
        %agregar/sacar polos/ceros (esto es como meterle filtros, de hecho
            %hay opciones de notch, lead, lag)
        %editar compensador (me actualiza en tiempo real, ver como queda
            %despues de agregar/sacar polos
%recomendacion: asociar los requirements en no se el step o el impulse o
%donde sea y despues ir moviendo y agregando esto para ver si cumple con lo
%que necesito


