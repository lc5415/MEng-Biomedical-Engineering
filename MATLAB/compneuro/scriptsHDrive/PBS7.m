%% PBS7

x1 = [0 20]';
x2 = [20 0]';

T = 10000; %time in ms
n = 10e-6;
% y = 10;
y0 = 10;
tau = 50; %ms
dt = 1;
w = zeros(2,T);
w(:,1) = [0.5; 0.5];
%theta = randi(20);
theta = zeros(1,T);
y = zeros(1,T);
prob = 0.5;

for t = 1:dt:T-1

    if rand(1)>prob
        x = x1;
    else
        x = x2;
    end
    %y(t) = dot(w(:,t),x);
    %the line below is correct
   y(t) = w(:,t)'*x;
    %
    w(:,t+1) = dt*n*x*y(t)*(y(t)-theta(t)) + w(:,t);
    theta(t+1) = (dt/tau)*(-theta(t)+(y(t)^2/y0)) + theta(t);
    
    
    if w(1,t+1) < 0 
        w(1,t+1) = 0;
    end
    
    if w(2,t+1)<0
        w(2,t+1) = 0;
    end
    
    
end



%%
subplot(3,1,1)
plot(1:T,y)
ylabel('Output neuron rate')
subplot(3,1,2)
plot(1:T,w)
ylabel('Weight for input neurons')
legend('1','2')
subplot(3,1,3)
plot(1:T,theta)
ylabel('Sliding threshold')
xlabel('Time (ms)')


