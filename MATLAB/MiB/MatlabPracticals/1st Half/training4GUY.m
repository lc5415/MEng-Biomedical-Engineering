%Bistable switch
clear all
close all

%Define parameters
params.alf  = 1;
params.bet  = 1;
params.gam  = 0.3;
x0          = [1 2]; %Any initial condition

%Call ODE solver
t       = [0:0.01:200];
[t, x]  = ode45(@(t,x)toggleODE(t,x,params),t,x0);

plot(t,x,'linewidth',2)
title('Time courses')
xlabel('Time t');
ylabel('Concentrations x and y');


%Compute nullclines
yp1 = [0:0.01:10];
xp1 = params.alf./params.gam./(1 + yp1.^4);
xp2 = [0:0.01:10];
yp2 = params.bet./params.gam./(1 + xp2.^4);


%Plot nullclines, overlaid with phase plane
figure
plot(xp1,yp1,'r','linewidth',2),hold
plot(xp2,yp2,'b','linewidth',2);
plot(x(:,1),x(:,2),'k')
plot(x(1,1),x(1,2),'ko')

%Again, but with new initial condition
x0      = [2,1];
[t, x]  = ode45(@(t,x)toggleODE(t,x,params),t,x0);
plot(x(:,1),x(:,2),'k')
plot(x(1,1),x(1,2),'ko')
xlabel('Concentration x')
ylabel('Concentration y')
title('Nullclines and phase plane')
axis([0 4 0 4])

%Again, but with random initial conditions
figure
plot(xp1,yp1,'r','linewidth',2),hold
plot(xp2,yp2,'b','linewidth',2);
x0r = 3*rand([100,2]);%20 Initial conditions, try with more to see the basins of attraction
for i=1:size(x0r,1)
    [t, x] = ode45(@(t,x)toggleODE(t,x,params),t,x0r(i,:));
    plot(x(:,1),x(:,2),'k')
    plot(x(1,1),x(1,2),'ko')
end
xlabel('Concentration x')
ylabel('Concentration y')
title('Nullclines and phase plane')
axis([0 4 0 4])
