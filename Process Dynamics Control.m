clc;
clear;
close all;

%% DEFINE PROCESS MODEL

K = 2;
tau = 3;
zeta = 0.6;

s = tf('s');

G = K/(tau^2*s^2 + 2*zeta*tau*s + 1);

disp("Process Transfer Function:")
G

%% OPEN LOOP STEP RESPONSE

figure
step(G)
title('Open Loop Step Response')
grid on

%% FREQUENCY RESPONSE

figure
bode(G)
grid on
title('Bode Plot')

figure
nyquist(G)
grid on
title('Nyquist Plot')

%% STABILITY MARGINS

[Gm,Pm,Wcg,Wcp] = margin(G);

fprintf('Gain Margin = %.3f\n',Gm)
fprintf('Phase Margin = %.3f degrees\n',Pm)
fprintf('Gain Crossover Frequency = %.3f rad/s\n',Wcg)
fprintf('Phase Crossover Frequency = %.3f rad/s\n',Wcp)

figure
margin(G)
title('Gain and Phase Margin')

%% ROOT LOCUS

figure
rlocus(G)
title('Root Locus')
grid on

%% PID CONTROLLER WITH DERIVATIVE FILTER

Kp = 4;
Ki = 1.5;
Kd = 0.8;
N  = 20;   % derivative filter coefficient

C = pid(Kp,Ki,Kd,N);

disp("PID Controller:")
C

%% CLOSED LOOP SYSTEM

T = feedback(C*G,1);

figure
step(T)
title('Closed Loop Step Response')
grid on

%% OPEN vs CLOSED LOOP

figure
step(G,'r',T,'b')
legend('Open Loop','Closed Loop')
title('Open vs Closed Loop Response')
grid on

%% PERFORMANCE METRICS

info = stepinfo(T);

fprintf('\nClosed Loop Performance\n')
fprintf('Rise Time = %.3f sec\n',info.RiseTime)
fprintf('Settling Time = %.3f sec\n',info.SettlingTime)
fprintf('Overshoot = %.3f %%\n',info.Overshoot)

%% DIFFERENT INPUT RESPONSES

t = 0:0.01:20;

% Ramp input
u = t;

figure
lsim(T,u,t)
title('Closed Loop Ramp Response')
grid on

% Sinusoidal input
u = sin(t);

figure
lsim(T,u,t)
title('Closed Loop Sinusoidal Response')
grid on

%% DISTURBANCE REJECTION

disturbance = 0.5*sin(0.5*t);

figure
lsim(T,disturbance,t)
title('Disturbance Rejection')
grid on

%% CONTROL EFFORT

U = minreal(C/(1 + C*G));

figure
step(U)
title('Control Effort')
grid on

disp("Control analysis completed successfully.")
