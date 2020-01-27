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
r(rewTime,:)=1;
delta = zeros(Time, Trials); %prediction error


gamma= ;
alpha= ;

%t=time, i=trial
for i=1:Trials
    V(:,i)= ; %value function
    delta(:,i)= ;%prediction error
    w= ; %weights
end


%% Plot 

%Plot prediction error
figure
surf(delta')
ylabel('trials')
xlabel('time')
zlabel('prediction error')

%Plot value function 
figure
surf(V)
xlabel('trials')
ylabel('time')
zlabel('V')