clc 
clear
%QUESTION 1

xE(1) = 5; %variable initialization
k = 0.25; 
h1 = 0.01;
t1 = [0:h1:10]; %timespan+ step
for n=1:length(t1) -1 
    xE(n+1) = xE(n) - k*h1*(xE(n));
end

plot(t1,xE);
title('QUESTION 1');
hold;

%analytical solution
xA = xE(1)*exp(-k*t1); 

plot(t1,xA); %both graphs are plot on the same graph although 
            %the difference is barely noticeable at small zoom
MSE1 = mean((xA-xE).^2)

%QUESTION 2 ; the step has now a value of 0.001

h2 = 0.001;
t2 = [0:h2:10];
xE2(1) = 5;
for i=1:length(t2) -1 
    xE2(i+1) = xE2(i) - k*h2*(xE2(i));
end
figure
plot(t2,xE2);
title('QUESTION 2');
hold;

%analytical solution
xA2 = xE2(1)*exp(-k*t2); %xA2 has a larger length than xA

plot(t2,xA2); %both graphs are plot on the same graph although 
            %the difference is barely noticeable at small zoom
MSE2 = mean((xA2-xE2).^2)