clc
clear all 
close all
%TRAINING 5
%Q1

tspan =[0 100];
n = [0,0.03,7];
for i = 1:length(n)
[t,v] = ode45(@(t,v) ft5(v,n(i)),tspan,[10,2]); %x is v(1) (i.e. y dot) and y is v(2)
hold on
grid on
plot(t,v(:,2),'linewidth',1.5)
xlabel('Time')
ylabel('y')
title('Temporal behaviour of the damped system for different values of \eta')
end
legend('\eta = 0','\eta = 0.03','\eta = 7')
hold off
%Classic graph of damping
%Q2
figure
grid on
for i = 1:length(n)
[t,v] = ode45(@(t,v) ft5(v,n(i)),tspan,[10,2]); %x is v(1) (i.e. y dot) and y is v(2)
hold on
plot(v(:,2),v(:,1),'linewidth',1.5)
xlabel('y')
ylabel('$\dot{y}$','interpreter','latex')%learnt this here https://uk.mathworks.com/matlabcentral/answers/52520-axes-labels-with-differential-dot
title('Phase plane')
end 
legend('\eta = 0','\eta = 0.03','\eta = 7')
hold off
%phase plane: limit cycle for no damping or tends to 0 for positive values
%of damping

%Q3 : We could say that for a high damping coefficient (e.g 7) the
%attraction is stronger towards the fixed point (the origin).
%when eta = 0 we get a Hopf bifurcation which is when we expect the system
%to switch from one behaviour to the other


