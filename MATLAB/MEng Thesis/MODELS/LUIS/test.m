% y=[10 12.5 15 17.5 20 22.5 25 27.5 30 32.5 35 37.5 40 42.5 45 47.5 50];
% t=[62.1 77.3 92.5 104 112.9 121.9 125 129.4 134 138.2 142.3 143.2 144.6 147.2 147.8 149.1 150.9];
t = -1:0.1:1;
y = 1./(1+exp(-10*t))+0.1*rand(1,length(t))+10;
% y = ones(length(t));
% % b(1) = A,  B(2) = mu,  b(3) = lambda
%mgompertz = @(b,t) b(1) .* exp(-exp((b(2) .* exp(1))./b(1)) .* (b(3)-t) + 1);
%b(4) added for initial OD
mgompertz =  @(b,t) b(1) .* exp(-exp(((b(2) * exp(1))./b(1)) .* (b(3)-t) + 1))+b(4);
[B,resnorm] = fminsearch(@(b) norm(y - mgompertz(b,t)), rand(4,1))
figure
plot(t, y, 'p')
hold on
plot(t, mgompertz(B,t), '-r')
grid on
