%% PBS9 - SYNAPTIC PLASTICTY
% TEMPORAL DIFFERENCE (TD) LEARNING
%%% code copied from dopamine.m provided in BB
close all
%cue at second 5, reward at second 20

Trials=100; %number of trials
Time=20;    %total time
rewTime=20; %reward time
cueTime=5; %start cue
endCueTime=rewTime; %end cue
n=endCueTime-cueTime+1; %cue duration

X= eye(n);
X=[zeros(n,cueTime-1), X, zeros(n,Time-endCueTime)];

V=zeros(Time,Trials);
w = zeros(n,1); %weights
r = zeros(Time,Trials); %reward
r(rewTime,[1:50,52:100])=1;
delta = zeros(Time, Trials); %prediction error


gamma= 1;
alpha= 0.6;

%% 
%t=time, i=trial
for i=1:Trials
    V(:,i)= w'*X; %value function
    ShiftedV = [V;zeros(1,100)];
    delta(:,i)= r(:,i)+gamma*ShiftedV(2:21,i)-V(:,i);%prediction error
    w= w + alpha*sum(X*delta(:,i)); %weights
end


%% Plot 

%Plot prediction error
figure
surf(delta')
ylabel('trials')
xlabel('time')
zlabel('prediction error')
shading interp
colorbar

%Plot value function 
figure
surf(V)
xlabel('trials')
ylabel('time')
zlabel('V')
shading interp
colorbar

%plot 6 before trials
figure
plot(delta(:,1))
hold on
plot(delta(:,2))
plot(delta(:,3))
plot(delta(:,4))
plot(delta(:,5))
plot(delta(:,6))
