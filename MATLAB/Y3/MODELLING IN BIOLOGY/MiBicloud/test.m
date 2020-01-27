kx = 5000;
ky = 5000;
Kx = 0.5;
Ky = 0.5;
K1 = 0.3;
K2 = 0.3;
kd =0.7;

%QUESTION 2 
syms x y fx fy
x = 0:0.01:11000;
y = 0:0.01:11000;
fy = (kx/kd)*(1./(1+K1*Ky*y.^2));%x = 
fx =(ky/kd)*(1./(1+K2*Kx*x.^2));% y = 
figure
hold on
grid on
plot(x,fx,'linewidth',2)

plot(fy,y,'linewidth',2)
xlabel('x')
ylabel('y')
xlim([0 7500])
ylim([0 7500])
title('Phase plane of the system')

%%
func = @testf2;
sol(1,:) = fsolve(func,[40,40]); %Solution 1
sol(2,:) = fsolve(func,[0,7142]);
sol(3,:) = fsolve(func,[7142,0]);
plot(sol(1,1),sol(1,2),'k-o','linewidth',2); %Solution 1 
plot(sol(2,1),sol(2,2),'k-o','linewidth',2); %Solution 2
plot(sol(3,1),sol(3,2),'k-o','linewidth',2); %Solution 3
legend('Nullcline for s', 'Nullcline for r','Solution 1', 'Solution 2','Solution 3','AutoUpdate','off')
tspan= [0 100];
x0r = 7500*rand([20 2]); %so that all the values are ot only between 0 and 1
for i = 1:size(x0r,1)
    [t,v] = ode45(@(t,v) testf2(v),tspan,x0r(i,:));
    plot(v(:,1),v(:,2),'g','linewidth',1);
    plot(v(1,1),v(1,2),'go','linewidth',1);
end