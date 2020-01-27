clc
clear all
delete(findall(0,'Type','figure'))
%Q1
x = [-2:0.1:2];
v = 2.*((x+1).^2).*((x-1).^2);
plot(x,v)
xlabel('Displacement x')
ylabel('Potential V')
%% 

%Q2

t_step = 0.01;
t = 0:t_step:1000;
x1(1)= 0;
for i = 1:1000/t_step
        x1(i+1) = x1(i) -(0.1*[2*(2*x1(i) - 2)*(x1(i) + 1)^2 + 2*(2*x1(i) + 2)*(x1(i) - 1)^2])*t_step + normrnd(0,sqrt(2*t_step/10));
end
figure
plot(t,x1)
xlabel('Time')
ylabel('Position')
%% 

%Q3
t2_step = 0.2;
t2 = 0:t2_step:10000;
x2(1)= 0;
for i = 1:10000/t2_step
        x2(i+1) = x2(i) -(0.1*[8*x2(i)*(x2(i)^2-1)])*t2_step + normrnd(0,sqrt(2*t2_step/10));
        v2(i) = 2*((x2(i)+1)^2)*((x2(i)-1)^2);
end
figure
plot(t2,x2)
xlabel('Time')
ylabel('Position')

average_energy = mean(v2)
%% 

%Q4
t3_step = 0.01;
t3 = 0:t3_step:1000;
x3(1)= 0;
%BDTOT(1)=0;
for i = 1:1000/t3_step
        x3(i+1) = x3(i) -(0.1*[8*x3(i)*(x3(i)^2-1)])*t3_step + normrnd(0,sqrt(2*t3_step/10));
        v3(i) = 2*((x3(i)+1)^2)*((x3(i)-1)^2);
        BD(i) = exp(-v3(i));
        %BDTOT(i+1) = BDTOT(i)+BD(i);
end
figure
histogram(x3)

%increasing the number of time steps incerases the accuracy of our model

%Q5
for i = 1:1000/t3_step
BDD(i) = BD(i)/sum(BD);
end
% BDD =BD./sum(BD) --> also works(element.wise division)
figure
x4 = x3(1:1000/t3_step);
plot(x4,BDD)