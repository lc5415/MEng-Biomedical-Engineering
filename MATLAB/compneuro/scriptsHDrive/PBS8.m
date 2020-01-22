%% PBS 8 COMP NEURO
%% 1.1
clc
clear all
n = 2;
p = 4;
patterns = zeros(p,n);
w = rand(1,n);
x = zeros(p,n);
mu = 1:patterns;
a = 1; %learning rate
x = [0 0;0 1;1 0;1 1];
%OR gate
% y_t = [0;1;1;1];
%XOR gate
y_t = [0;1;1;0];
y_out = zeros(p,1);
b = 1;%bias
iterations = 1:10;
E = ones(1,length(iterations));


it = 1;
for i = iterations
    %update weight for each pattern example
    w = w + a*x(it,:)*(y_t(it)-y_out(it));
    %for all patterns calculate output
    for j = 1:p
    y_out(j) = heaviside(w*x(j,:)'-b);
    end
    % calculate error for 
    E(i) = sum((y_t-y_out).^2);
    
    %update it
    it = it +1;
    
    %reset it
    if mod(i,p) == 0
        it = 1;
    end
end
   plot(1:10,E)
    ylabel('Error')
    xlabel('Iteration')
    

%perceptron error does not converge for XOR gate because it is not linearly
%separable

%% 1.2

% this code creates a perceptron of with n input neurons and we are feeding
% p possible patterns int it which help the system be trained. the
% perceptron error may not converge when exposed to too many patterns as it
% will be harder for it to find exact values for all weights( n number of
% weights) when there are many many patterns
clc
clear all
 close all
% number of input neurons x and hence weights w
n = 100;
%limit of iterations for which we will run or program, the program can be
%changed to use a while loop
iterations = 1:2000;
a = 1; %learning rate
b = 1;%bias
%set random seed generator for consistency
rng(2019)
%initialise time_to_zero variable which will store iterartion at which
%error goes to 0
time_to_zero =[];
% patterns: number of patterns per iteration
patterns = [10 25 50 75];
for p = patterns

w = rand(1,n);
%randomly generate input vector of dims p x n
x = rand(p,n)>.5;
y_t = rand(p,1)>.5;
y_out = zeros(p,1);


E = zeros(1,length(iterations));


it = 1;
for i = iterations
    %update weight for each pattern example
    w = w + a*x(it,:)*(y_t(it)-y_out(it));
    %for all patterns calculate output
    for j = 1:p
    y_out(j) = heaviside(w*x(j,:)'-b);
    end
    % calculate error for the system given
    E(i) = sum((y_t-y_out).^2);
    
    % this bit breaks the code and records the iteration step at which
    % the algorithm reaches 0
    if E(i) == 0 
        E(i:end) = 0;
        
        break
      %use break for code efficiency if you don't wanna plot the error vs
      %iterations plot
%         break
    end

    %update it
    it = it +1;
    
    %reset it
    if mod(i,p) == 0
        it = 1;
    end
end

%this bit records the time (iteration) at which the Error reached 0
 time_to_zero = [time_to_zero,i];

%plotter
txt = ['p = ',num2str(p)];
   plot(iterations,E,'DisplayName',txt)
   hold on
    ylabel('Error')
    xlabel('Iteration')
    

end
legend show
grid on
figure
plot(patterns, time_to_zero)
ylabel('Iteration at which E = 0')
xlabel('Number of patterns fed into the perceptron p')