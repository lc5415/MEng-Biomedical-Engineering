

%QUESTION 4 

%% (a)
%Declaration of parameters
kx = 5000;
ky = 5000;
Kx = 0.5;
Ky = 0.5;
K1 = 0.3;
K2 = 0.3;
kd =0.7;
%Declaration of variables. Note x = fy and y = fx.
syms x y fx fy
x = 0:0.001:8000;
y = 0:0.001:8000;
%Nullclines by setting x-dot and y-dot to 0 and rearranging
fy = (kx/kd)*(1./(1+K1*Ky*y.^2));%Nullcline for x
fx =(ky/kd)*(1./(1+K2*Kx*x.^2));%Nullcline for y

%plot of x-nullcline
figure
hold on
grid on
plot(fy,y,'linewidth',2)
xlabel('x')
ylabel('y')
ylim([0 40])
title('Figure 1: x-nullcline')

%plot of y-nullcline
figure
hold on
grid on
plot(x,fx,'linewidth',2)
xlabel('x')
ylabel('y')
xlim([0 40])
title('Figure 2: y-nullcline')


%Plot of both nullclines on the same graph,
%an increase from 0 to 40 in x makes y go
% to about a value of 7000 and vice versa. 
% That is the reason why both nullclines cannot be visualized 
%very well on the same plot.


figure
hold on
grid on
plot(x,fx,'linewidth',2)
plot(fy,y,'linewidth',2)
xlabel('x')
ylabel('y')
xlim([-100 7500])
ylim([-100 7500])
title('Figure 4: Phase plane of the system with start points trajectories')

%This section underneath is the computation of the fixed points and their
%plotting on the graph.
func = @testf2;
sol(1,:) = fsolve(func,[40,40]); %Solution 1
sol(2,:) = fsolve(func,[0,7142]);%Solution 2
sol(3,:) = fsolve(func,[7142,0]);%Solution 3
plot(sol(1,1),sol(1,2),'k-o','linewidth',2); %Solution 1 
plot(sol(2,1),sol(2,2),'k-o','linewidth',2); %Solution 2
plot(sol(3,1),sol(3,2),'k-o','linewidth',2); %Solution 3
legend('Nullcline for y', 'Nullcline for x','Solution 1', 'Solution 2','Solution 3','AutoUpdate','off')

%Jacobian matrix to find stability of each fixed point
%Jacobian for FP1
ddxdx = -kd;%top-left corner
ddxdy= -kx*2*K1*Ky*sol(1,2)*(1+K1*Ky*(sol(1,2))^2)^-2;   %top-right corner
ddydx = -ky*2*K2*Kx*sol(1,1)*(1+K2*Kx*(sol(1,1))^2)^-2;   %bottom-left corner
ddydy = -kd;   %bottom-right corner
Jacobian1 = [ddxdx ddxdy;ddydx ddydy]
eig_FP1 = eig(Jacobian1)

%Jacobian for FP2
ddxdx = -kd;%top-left corner
ddxdy= -kx*2*K1*Ky*sol(2,2)*(1+K1*Ky*(sol(2,2))^2)^-2;   %top-right corner
ddydx = -ky*2*K2*Kx*sol(2,1)*(1+K2*Kx*(sol(2,1))^2)^-2;   %bottom-left corner
ddydy = -kd;   %bottom-right corner
Jacobian2 = [ddxdx ddxdy;ddydx ddydy]
eig_FP2 = eig(Jacobian2)

%Jacobian for FP3
ddxdx = -kd;%top-left corner
ddxdy= -kx*2*K1*Ky*sol(3,2)*(1+K1*Ky*(sol(3,2))^2)^-2;   %top-right corner
ddydx = -ky*2*K2*Kx*sol(3,1)*(1+K2*Kx*(sol(3,1))^2)^-2;  %bottom-left corner
ddydy = -kd;   %bottom-right corner
Jacobian3 = [ddxdx ddxdy;ddydx ddydy]
eig_FP3 = eig(Jacobian3)



%% (b)

tspan= [0 100];
x0r = 7500*rand([50 2]); %All random values are in the range [0;7500]

%This for-loop plots the starting position and trajectory of all random 
%starting points.
for i = 1:size(x0r,1)
    [t,v] = ode45(@(t,v) testf2(v),tspan,x0r(i,:));
    plot(v(:,1),v(:,2),'g','linewidth',0.5);
    plot(v(1,1),v(1,2),'go','linewidth',0.5);
end

%plot of the separatrix
r = 0:0.01:7000;
p = 0:0.01:7000;
plot(r,p,'--')