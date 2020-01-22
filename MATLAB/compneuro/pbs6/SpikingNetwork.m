
%%
% Defining network model parameters
vt = 1;                     % Spiking threshold
tau_m = 10;                 % Membrane time constant [ms]
g_m = 1;                    % Neuron conductance
Nsig = 0.25;                 % Variance amplitude of current
Nmean = .75;                % Mean current to neurons
tau_I = 10;                 % Time constant to filter the synaptic inputs
N = 5000;                   % Number of neurons in total
NE = 0.5*N;                 % Number of excitatory neurons
NI = 0.5*N;                 % Number of inhibitory neurons
dt = 1;                     % Simulation time bin [ms]
T = 300/dt;                 % Simulation length 
W = 100/N;                  % Connectivity strength
R = 1/g_m;
rng(100)

%%
% Initialization

v = rand(N,1)*vt;           % membrane potential
vv = zeros(N,1);            % variable that notes if v crosses the threshold
Iback = zeros(N,1);         % building up the external current
SP = 0;                     % recording spike times
Ichem = zeros(N,1);         % current coming from synaptic inputs
Iext = zeros(N,1);     % external current
raster = [];                % save spike times for plotting

% hold on 
IIchem = [];
% loop over the time
for t = 1:T
    Iback = Iback + dt/tau_I*(-Iback +randn(N,1));          % generate a colored noise for the current
    Iext = Iback/sqrt(1/(2*(tau_I/dt)))*Nsig+Nmean;         % rescaling the noise current to have the correct mean and variance

    Ichem(1:NE) = Ichem(1:NE) + dt/tau_I*(-Ichem(1:NE) + W*(sum(vv(1:NE))-vv(1:NE))-W*(sum(vv(NE+1:end)))); % current to excitatory neurons coming from the synaptic inputs
    Ichem(NE+1:end) = Ichem(NE+1:end) + dt/tau_I*(-Ichem(NE+1:end) -W*(sum(vv(NE+1:end))-vv(NE+1:end))+W*(sum(vv(1:NE)))); % current to inhibitory neurons coming from the synaptic inputs
    Itot = Iext+Ichem;
    %%%%%%%%%%% To insert integrate-and-fire model here  %%%%%%%%%%%%%
    %this line is soooo clever, instead of calculating the neuron firing at
    %all time steps for every neuron individually (nested for loops) it
    %calculates the firing state of all 100 neurons at a given time all at
    %once and it only needs the state of the neurons before (i.e. vector v)
    % it is brillianteeee
        v =  v + (dt/tau_I)*(-v+R*Itot);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    vv =(v>=vt);                                        % spike if voltage crosses the threshold    
    
    v = (1-vv).*v;                                      % reset after spike
    SP = find(vv);                                      % find the spike times
    raster=[raster;t*ones(length(SP),1),SP];            % save spike times for plotting
    IIchem = [IIchem,Ichem];
end



% Plot the raster output
h = figure;hold on
plot(raster(:,1)*dt, raster(:,2),'b.')
xlim([100 300])
xlabel('time [ms]','fontsize',20)
ylabel('neuron index','fontsize',20)
set(gca,'fontsize',20);
set(gca,'YDir','normal')

%% step 4
% rng(100)
% v = rand(N,1)*vt;           % membrane potential
% vv = zeros(N,1);            % variable that notes if v crosses the threshold
% Iback = zeros(N,1);         % building up the external current
% SP = [];                     % recording spike times
% Ichem = zeros(N,1);         % current coming from synaptic inputs
% Iext = zeros(N,1);     % external current
% raster = [];
% for t = 1:T
%     Iback = Iback + dt/tau_I*(-Iback +randn(N,1));          % generate a colored noise for the current
%     Iext = Iback/sqrt(1/(2*(tau_I/dt)))*Nsig+Nmean;         % rescaling the noise current to have the correct mean and variance
% 
%     Ichem(1:NE) = Ichem(1:NE) + dt/tau_I*(-Ichem(1:NE) + W*(sum(vv(1:NE))-vv(1:NE))-W*(sum(vv(NE+1:end)))); % current to excitatory neurons coming from the synaptic inputs
%     Ichem(NE+1:end) = Ichem(NE+1:end) + dt/tau_I*(-Ichem(NE+1:end) -W*(sum(vv(NE+1:end))-vv(NE+1:end))+W*(sum(vv(1:NE)))); % current to inhibitory neurons coming from the synaptic inputs
%     Itot = Iext+Ichem;
%     %%%%%%%%%%% To insert integrate-and-fire model here  %%%%%%%%%%%%%
%     %this line is soooo clever, instead of calculating the neuron firing at
%     %all time steps for every neuron individually (nested for loops) it
%     %calculates the firing state of all 100 neurons at a given time all at
%     %once and it only needs the state of the neurons before (i.e. vector v)
%     % it is brillianteeee
%     v =  v + (dt/tau_I)*(-v+R*Itot);
%         if t == 200   
%             v(:) = vt;
%         end
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     vv =(v>=vt);                                        % spike if voltage crosses the threshold    
%     
%     v = (1-vv).*v;                                      % reset after spike
%     SP = find(vv);                                      % find the spike times
%     raster=[raster;t*ones(length(SP),1),SP];            % save spike times for plotting
% end
% 
% 
% % Plot the raster output
% hold on
% plot(raster(:,1)*dt, raster(:,2),'r.')
% xlim([100 300])
% xlabel('time [ms]','fontsize',20)
% ylabel('neuron index','fontsize',20)
% set(gca,'fontsize',20);
% set(gca,'YDir','normal')

%% Step 5
figure
surf(IIchem)
shading interp

%%
clear all 
close all
% Defining network model parameters
vt = 1;                     % Spiking threshold
tau_m = 10;                 % Membrane time constant [ms]
g_m = 1;                    % Neuron conductance
Nsig = 0.25;                 % Variance amplitude of current
Nmean = .75;                % Mean current to neurons
tau_I = 10;                 % Time constant to filter the synaptic inputs
N = 50*10.^[1:4];                   % Number of neurons in total


for N = 50*10.^[1:4]

NE = 0.5*N;                 % Number of excitatory neurons
NI = 0.5*N;                 % Number of inhibitory neurons
dt = 1;                     % Simulation time bin [ms]
T = 300/dt;                 % Simulation length 
W = 100/N;                  % Connectivity strength
R = 1/g_m;

v = rand(N,1)*vt;           % membrane potential
vv = zeros(N,1);            % variable that notes if v crosses the threshold
Iback = zeros(N,1);         % building up the external current
SP = 0;                     % recording spike times
Ichem = zeros(N,1);         % current coming from synaptic inputs
Iext = zeros(N,1);     % external current
raster = [];                % save spike times for plotting

% hold on 
IIchem = [];
% loop over the time
for t = 1:T
    Iback = Iback + dt/tau_I*(-Iback +randn(N,1));          % generate a colored noise for the current
    Iext = Iback/sqrt(1/(2*(tau_I/dt)))*Nsig+Nmean;         % rescaling the noise current to have the correct mean and variance

    Ichem(1:NE) = Ichem(1:NE) + dt/tau_I*(-Ichem(1:NE) + W*(sum(vv(1:NE))-vv(1:NE))-W*(sum(vv(NE+1:end)))); % current to excitatory neurons coming from the synaptic inputs
    Ichem(NE+1:end) = Ichem(NE+1:end) + dt/tau_I*(-Ichem(NE+1:end) -W*(sum(vv(NE+1:end))-vv(NE+1:end))+W*(sum(vv(1:NE)))); % current to inhibitory neurons coming from the synaptic inputs
    Itot = Iext+Ichem;
    %%%%%%%%%%% To insert integrate-and-fire model here  %%%%%%%%%%%%%
    %this line is soooo clever, instead of calculating the neuron firing at
    %all time steps for every neuron individually (nested for loops) it
    %calculates the firing state of all 100 neurons at a given time all at
    %once and it only needs the state of the neurons before (i.e. vector v)
    % it is brillianteeee
        v =  v + (dt/tau_I)*(-v+R*Itot);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    vv =(v>=vt);                                        % spike if voltage crosses the threshold    
    
    v = (1-vv).*v;                                      % reset after spike
    SP = find(vv);                                      % find the spike times
    raster=[raster;t*ones(length(SP),1),SP];            % save spike times for plotting
    IIchem = [IIchem,Ichem];
end
    subplot(2,2,a)
    surf(IIchem)
    title(['N = ',num2str(a)])
    N(a)
end


% Plot the raster output
% h = figure;hold on
% plot(raster(:,1)*dt, raster(:,2),'b.')
% xlim([100 300])
% xlabel('time [ms]','fontsize',20)
% ylabel('neuron index','fontsize',20)
% set(gca,'fontsize',20);
% set(gca,'YDir','normal')