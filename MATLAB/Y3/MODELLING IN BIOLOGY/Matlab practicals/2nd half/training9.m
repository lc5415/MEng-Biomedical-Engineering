%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Modelling in Biology MATLAB Training excercise 9
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
hold off

%%
% Create an ER-graph with N=276 nodes and p=0.054 for link probabilities
ER=zeros(276);
for i = 1:276
    for j=i+1:276 %don't test twice! And don't generate self-links.
        if(rand <0.054) %generate a link with prob 0.054
            ER(i,j) = 1; %update both parts of adjacency matrix.
            ER(j,i)=1;
        end
    end
end
spy(ER)
sum(ER(:))/2
%%  Load matrix A - a social network.
load('SocialNetwork.mat');
spy(A)
sum(A(:))/2
%% Spread of a disease on an ER network

numsteps=100;
pinfect=0.2;

for x=1:100
    susceptible=ones(276,1); %create list of dead/infected/uninfected people.
    infected=zeros(276,1);
    dead=zeros(276,1);

    %infect one person at random
    victim=randi([1,276]);
    susceptible(victim)=0;
    infected(victim)=1;

    deathtoll=zeros(numsteps,1); % set up array to record how many have died

    for n=1:numsteps %simulate for this many steps
        [susceptible,infected,dead]=infect_new(ER,susceptible,infected,dead,pinfect);
        deathtoll(n)=sum(dead)/length(susceptible); %record fraction of people dead over time; percentage of dead over susceptibles
    end
    plot(deathtoll);
    hold on
end

%%
% Spread of a disease on a social network
%repeat above using social network
for x=1:100
    susceptible=ones(276,1);
    infected=zeros(276,1);
    dead=zeros(276,1);

    %infect one person
    victim=randi([1,276]);
    susceptible(victim)=0;
    infected(victim)=1;

    deathtoll=zeros(numsteps,1);

    for n=1:numsteps
        [susceptible,infected,dead]=infect_new(A,susceptible,infected,dead,pinfect);
        deathtoll(n)=sum(dead)/length(susceptible);
    end
    plot(deathtoll,'red');  %only one line but because probability stays at 0.36 for every step
end
hold off


%%
% Repeat above, but make 75% of people immune from the start
for x=1:100
    susceptible=ones(276,1);
    infected=zeros(276,1);
    dead=zeros(276,1);
    immune=zeros(276,1);
    pinfect=0.2;
    vacc_rate=0.75;
    for i =1:length(susceptible)
        if rand<vacc_rate
            immune(i)=1; %set to immune, if not uninfected, can't be infected by my function.
            susceptible(i)=0;
        end
    end

    deathtoll=zeros(numsteps,1);

    %infect one person -- keep trying until you find someone susceptible.
    victim=randi([1,276]);
    while immune(victim)==1
        victim=randi([1,length(susceptible)]);
    end

    susceptible(victim)=0;
    infected(victim)=1;

    for n=1:numsteps
        [susceptible,infected,dead]=infect_new(A,susceptible,infected,dead,pinfect);
       deathtoll(n)=sum(dead)/(length(susceptible)*(1-vacc_rate));
    end
    plot(deathtoll,'green');
    xlabel('Number of steps/"Time"')
    ylabel('Fraction of people dead')
    title('Fraction of people dead over time for x = 100 repetitions')
    hold on
end

%%
% Clustered non-vaccination: repeat above, but make final 75% of people
% immune rather than choosing randomly
for x=1:100
    susceptible=ones(276,1);
    infected=zeros(276,1);
    dead=zeros(276,1);
    immune=zeros(276,1);
    pinfect=0.2;
    vacc_rate=0.75;
    for i =70:length(susceptible)
        immune(i)=1;
        susceptible(i)=0;
    end

    deathtoll=zeros(numsteps,1);

    %infect one person
    victim=randi([1,276]);
    while immune(victim)==1
        victim=randi([1,length(susceptible)]);
    end

    susceptible(victim)=0;
    infected(victim)=1;

    for n=1:numsteps
        [susceptible,infected,dead]=infect_new(A,susceptible,infected,dead,pinfect);
       deathtoll(n)=sum(dead)/(length(susceptible)*(1-vacc_rate));
    end
    plot(deathtoll,'black');
    hold on
    xlabel('Number of steps n')
    ylabel('Fraction of people dead')
    title('Fraction of people dead over time for x = 100 repetitions')
end