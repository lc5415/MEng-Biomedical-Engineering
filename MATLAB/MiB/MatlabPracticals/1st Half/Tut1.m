% t = 0:10;
% syms x(t)
% k = 3/5;
% ode = diff(x,t) == -k*x;
% cond = x(0) == 4;
% xSol(t) = dsolve(ode,cond) %analytical approach, 
                            %could also work by hand

%Q1
tspan = [0 10];
x0 = 4;
k = 3/5;
[t,x] = ode45(@(t,x) -k*x,tspan,x0); %numerical approach
plot(t,x)

%Q2
y = 4*exp(-0.6*t);
plot(t,x,t,y) %analytical approach/ by hand
                %zoom to see the difference if you dont believe it 
MSE = (1/45)*sum((x-y).^2) %go to y array or t array 
                            %to see there are 45 values

%Q3

dt = t(2:end)-t(1:end-1);
figure
plot(t(1:end-1),dt)
