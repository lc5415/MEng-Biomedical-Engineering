function y = IandF(x,t,I)
tau = 10; %tau = 10 ms
R = 1; %1 ohm
mu_th = 10; %mu threshold at which the neuron potential resets to 0
tau*(y-x)/t = -x+R*I;
end
