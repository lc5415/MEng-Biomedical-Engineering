clc
clear

I = [2,9,11,15,100];
t = 0:1:100; %time in ms
tau = 10; %tau = 10 ms
R = 1; %1 ohm
mu_th = 10; %mu threshold at which the neuron potential resets to 0

for i = 1:length(I)
    v(1) = 0;
for n=1:length(t)-1
    if v(n) > 10
        v(n+1) = 0;
    else
        v(n+1) = v(n) + ((t(n+1)-t(n))/tau)*(-v(n)+R*I(i));
    end
end
subplot(length(I),1,i)
plot(t,v)
ylim([0 20])
end