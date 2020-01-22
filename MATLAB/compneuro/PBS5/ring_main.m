N = 50;
neurons = linspace(-pi/2,pi/2,N);

theta0 = 0;
c=1.2;
epsilon = 0.1;
h = 0;
for i = 1:length(neurons)
    h(i) = h_input(theta0, neurons(i), c, epsilon);
end

plot(neurons, h)
xlabel('Neuron preferred orientation (rad)')
ylabel('External input from hypthalamus')
title(['For \theta = ',num2str(theta0),' radians'])

%% Q1.3 and Q1.4
T = 0;
beta = 0.1;

%h = -15:1:15;
%h = linspace(-15,15,50);
g_out = g(beta,h,T);
figure
% plot(h,g_out)
%% Step 2: Modelling the neurons

epsilon = 0.9;
c = 1.5;
tspan = 0:1:30;
m0 = 0;
m = zeros(length(tspan),N);
hold on
for k = 1:N
m(:,k) = rate_based(g_out(k),tspan, m0);
end
% for k = 1:N
%     plot(tspan,m(:,k),'DisplayName',num2str(k))
% end
%legend show
image(500.*m)
colorbar

%% 3 










