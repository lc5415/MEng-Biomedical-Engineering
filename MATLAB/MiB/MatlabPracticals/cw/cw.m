clc
clear all 
close all
%%
%QUESTION 1

a = 1;
b = 1;

tspan = [0 200];

[t,v] = ode45(@(t,v) cwfunction(v,a,b),tspan,[1,2]);

plot (t,v(:,1),t,v(:,2),'linewidth',2)
legend('x(t)','y(t)')
%%
%QUESTION 2 
syms x y fx fy
x = 0:0.01:4;
y = 0:0.01:4;
fy = b./y;%x2 = 
fx = ((b+1)*x-a)/(x.^2);% x1 = 
figure
hold on
grid on
plot(x,fx,'linewidth',2)
plot(fy,y,'linewidth',2)
%legend('Nullcline for x', 'Nullcline for y')

func = @tut3Q2;
sol(1,:) = fsolve(func,[0,0]); %Solution 1
sol(2,:) = fsolve(func,[0,4]); %Solution 2
sol(3,:) = fsolve(func,[4,0]); %Solution 3

plot(sol(1,1),sol(1,2),'k-o','linewidth',2); %Solution 1 
plot(sol(2,1),sol(2,2),'k-o','linewidth',2); %Solution 2
plot(sol(3,1),sol(3,2),'k-o','linewidth',2); %Solution 3
legend('Nullcline for x', 'Nullcline for y','Solution 1', 'Solution 2','Solution 3','AutoUpdate','off')
%%
%QUESTION 3
plot(v(:,1),v(:,2),'g','linewidth',2)   %phase plane for x0 = [1,2]
plot(v(1,1),v(1,2),'go','linewidth',2)

[t,v] = ode45(@(t,v) cwfunction(v,a,b,g),tspan,[2,1]);

plot(v(:,1),v(:,2),'g','linewidth',2)    %phase plane for x0 = [2,1]
plot(v(1,1),v(1,2),'go','linewidth',2)
xlabel('Concentration x')
ylabel('Concentration y')
title('Nullclines and phase plane')


%The point in the middle is an unstable fixed point where as the other two
%on the sies are attctive fixed points as can be seen from the simulation
%where the rajectoies of the curves starting at the initial values tend to
%the attractive points
%%
%QUESTION 4
figure
hold on
plot(x,fx,'linewidth',2)
plot(fy,y,'linewidth',2)
plot(sol(1,1),sol(1,2),'k-o','linewidth',2); %Solution 1 
plot(sol(2,1),sol(2,2),'k-o','linewidth',2); %Solution 2
plot(sol(3,1),sol(3,2),'k-o','linewidth',2); %Solution 3
legend('Nullcline for x', 'Nullcline for y','Solution 1', 'Solution 2','Solution 3','AutoUpdate','off')
x0r = rand([80 2]); %so that all the values are ot only between 0 and 1
for i = 1:size(x0r,1)
    [t,v] = ode45(@(t,v) cwfunction(v,a,b,g),tspan,x0r(i,:));
    plot(v(:,1),v(:,2),'g','linewidth',1);
    plot(v(1,1),v(1,2),'go','linewidth',1);
end

xlabel('Concentration x')
ylabel('Concentration y')
title('Nullclines and phase plane')

    

