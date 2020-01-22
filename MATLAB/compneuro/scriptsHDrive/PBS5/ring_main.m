N = 50;
neurons = linspace(-pi/2,pi/2,N);

theta0 = 0;
c=3;
epsilon = 0.1;
h = 0
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

% h = -15:1:15;

g_out = g(beta,h,T);
figure
plot(h,g_out)
%% Step 2: Modelling the neurons





