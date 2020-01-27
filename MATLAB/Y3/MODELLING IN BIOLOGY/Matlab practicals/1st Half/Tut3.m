clc
clear

k = 3/16;
h = 0.01;
x = zeros(1000,20);
t = [0:h:10];
x(1,:) = 6;
s =0.2;

%Question 1a
figure;
hold
for i = 1:20
    for n = 1:length(t)-1
        x(n+1,i) = x(n,i) - h*k*x(n,i) + s*sqrt(h)*randn;
    end
plot (t,x);
title('Q1; Implementation of the stochastic Euler algorithm for 20 iterations with x0 = 6');
end

% Question 1b

avg = mean(x,2); % takes average over columns as mean(x,1) would take average over rows
figure;
plot(t,avg)
title('Q1;Average of 20 iterations of Euler Algorithm');


xA = avg(1,1)*exp(-k*t); %analytical solution

MSE = mean((transpose(xA)-avg).^2)


%Question 2 a

k = 3/16;
h2 = 0.01;
x2 = zeros(10001,20);
t2 = [0:h2:100];
x2(1,:) = 0;
s2 =0.1;

%PART 1
figure;
for i2 = 1:20
    for n2 = 1:length(t2)-1
        x2(n2+1,i2) = x2(n2,i2) - h2*k*x2(n2,i2) + s2*sqrt(h2)*randn;
    end
plot(t2,x2);
title('Q2; Implementation of the stochastic Euler algorithm for 20 iterations with x0 = 0');
end

% PART 2

avg2 = mean(x2,2); % takes average over columns as mean(x,1) would take average over rows
figure;
plot(t2,avg2)
title('Q2;Average of 20 iterations of Euler Algorithm');
histogram(x2)
title('Histogram for \sigma = 0.1');

xA2 = avg2(1,1)*exp(-k*t2); %analytical solution

MSE2 = mean((transpose(xA2)-avg2).^2)

%Question 2 b

k = 3/16;
h2 = 0.01;
x3 = zeros(10001,20);
t2 = [0:h2:100];
x2(1,:) = 0;
s3 =5;

%PART 1
figure;
for i2 = 1:20
    for n2 = 1:length(t2)-1
        x3(n2+1,i2) = x3(n2,i2) - h2*k*x3(n2,i2) + s3*sqrt(h2)*randn;
    end
plot(t2,x3);
title('Q3; Implementation of the stochastic Euler algorithm for 20 iterations with x0 = 0');
end

% PART 2

avg3 = mean(x3,2); % takes average over columns as mean(x,1) would take average over rows
figure;
plot(t2,avg3)
title('Q3;Average of 20 iterations of Euler Algorithm');
histogram(x3)
title('Histogram for \sigma = 5');
xA3 = avg3(1,1)*exp(-k*t2); %analytical solution

MSE3 = mean((transpose(xA3)-avg3).^2)

%Question 2c
Mean2 = mean(avg2)
STD2 = std(avg2)
Mean3 = mean(avg3)
STD3 = std(avg3)

%as sigma is bigger in the third scenario the right hand side bit of
%euleur's stochastic equation can take get to values much higher or lower
%than the avergae, and indeed deviate more from that average, as expected.
