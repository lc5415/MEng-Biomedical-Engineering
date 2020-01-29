%% Script to analyse plate-reader data from 03/06/2019

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Strain: BW25113
% Constructs: pJBL5939+AB161 (comparator with the original target)
%             AB179+AB161 (comparator with deoptimised broken target [v1])
%             AB180+AB161 (comparator with deoptimised target [v2])
% Media: M9 0.8% fructose without Casaminoacids
% Level of C6-HSL induction: 0M, 10e-13M, 10e-12M, 10e-11M, 10e-10M,
%                            10e-9M, 10e-8M, 10e-7M, 10e-6M
% Plate-reader: COM2
% Temperature: 37ºC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Define indexes for each construct (in the rates matrixes)

idx_m9 = [1,2,3];

pJBL_0 = [1+12,2+12,3+12]; % empty DH10BGFP strain + 0M C6
pJBL_1 = [4,5,6]; % Original STAR Target + 0M C6
pJBL_2 = [7,8,9]; % Original STAR Target + 10e-13M C6
pJBL_3 = [10,11,12]; % Original STAR Target + 10e-12M C6
pJBL_4 = [4+12,5+12,6+12]; % Original STAR Target + 10e-11M C6
pJBL_5 = [7+12,8+12,9+12]; % Original STAR Target + 10e-10M C6
pJBL_6 = [10+12,11+12,12+12]; % Original STAR Target + 10e-9M C6
pJBL_7 = [1+12*2,2+12*2,3+12*2]; % Original STAR Target + 10e-8M C6
pJBL_8 = [4+12*2,5+12*2,6+12*2]; % Original STAR Target + 10e-7M C6
pJBL_9 = [7+12*2,8+12*2,9+12*2]; % Original STAR Target + 10e-6M C6

AB179_0 = [1+12,2+12,3+12]; % empty DH10BGFP strain + 0M C6
AB179_1 = [10+12*2,11+12*2,12+12*2]; % Broken Deoptimised STAR Target + 0M C6
AB179_2 = [1+12*3,2+12*3,3+12*3]; % Broken Deoptimised STAR Target + 10e-13M C6
AB179_3 = [4+12*3,5+12*3,6+12*3]; % Broken Deoptimised STAR Target + 10e-12M C6
AB179_4 = [7+12*3,8+12*3,9+12*3]; % Broken Deoptimised STAR Target + 10e-11M C6
AB179_5 = [10+12*3,11+12*3,12+12*3]; % Broken Deoptimised STAR Target + 10e-10M C6
AB179_6 = [1+12*4,2+12*4,3+12*4]; % Broken Deoptimised STAR Target + 10e-9M C6
AB179_7 = [4+12*4,5+12*4,6+12*4]; % Broken Deoptimised STAR Target + 10e-8M C6
AB179_8 = [7+12*4,8+12*4,9+12*4]; % Broken Deoptimised STAR Target + 10e-7M C6
AB179_9 = [10+12*4,11+12*4,12+12*4]; % Broken Deoptimised STAR Target + 10e-6M C6

AB180_0 = [1+12,2+12,3+12]; % empty DH10BGFP strain + 0M C6
AB180_1 = [1+12*5,2+12*5,3+12*5]; % Deoptimised STAR Target + 0M C6
AB180_2 = [4+12*5,5+12*5,6+12*5]; % Deoptimised STAR Target + 10e-13M C6
AB180_3 = [7+12*5,8+12*5,9+12*5]; % Deoptimised STAR Target + 10e-12M C6
AB180_4 = [10+12*5,11+12*5,12+12*5]; % Deoptimised STAR Target + 10e-11M C6
AB180_5 = [1+12*6,2+12*6,3+12*6]; % Deoptimised STAR Target + 10e-10M C6
AB180_6 = [4+12*6,5+12*6,6+12*6]; % Deoptimised STAR Target + 10e-9M C6
AB180_7 = [7+12*6,8+12*6,9+12*6]; % Deoptimised STAR Target + 10e-8M C6
AB180_8 = [10+12*6,11+12*6,13+12*6]; % Deoptimised STAR Target + 10e-7M C6
AB180_9 = [1+12*7,2+12*7,3+12*7]; % Deoptimised STAR Target + 10e-6M C6

% End of index definition section

%% Import Data

load('BW_179_180_161_03_06_2019.mat');

% Import the OD data
OD = OD700 - min(min(OD700(idx_m9)));

% Add time to OD, GFP and RFP data
timeLength = size(OD700,1);
t = 0;
inc = 0;

for n = 2:timeLength
    t = [t inc+0.25]; %#ok<AGROW>
    inc = inc + 0.25;
end

OD = horzcat(t',OD(1:length(t'),:));
RFP = horzcat(t',RFP(1:length(t'),:));

% Replace NaNs with 0s
OD(isnan(OD)) = 0;
RFP(isnan(RFP)) = 0;

% end of Import data section

%% Calculate the growth rate, and the RFP production rate per cell

timeLength = length(0.25:0.25:t(end-1));
timeIDX = 1;
timeIdx = 0;

growth_rate = zeros(1,96);
G_rate = cell(3,10);
rfp_rate = cell(3,10);

for time = 0.25:0.25:t(end-1)
    
    timeIdx = timeIdx + 1;

    for n = 1:96
        idx30 = find(t==time-0.25);
        idx60 = find(t==time);
        idx90 = find(t==time+0.25);
        growth_rate(n) = (log(OD(idx90,n+1))-log(OD(idx30,n+1)))/0.5;
        RFP_rate(n) = ((RFP(idx90,n+1)-RFP(idx30,n+1))/0.5)/OD(idx60,n+1);
    end

%% Find Average and Error

% Compute mean and std for library
for j = 1:3 % S6, AS6, Comp6
    
    for i = 1:10
       
        if j == 1
            idx =  eval(matlab.lang.makeValidName(strcat('pJBL_',int2str(i-1))));
        elseif j == 2
            idx =  eval(matlab.lang.makeValidName(strcat('AB179_',int2str(i-1))));
        else
            idx =  eval(matlab.lang.makeValidName(strcat('AB180_',int2str(i-1))));
        end
        
        G_rate{j,i}(timeIdx,:) = growth_rate(idx); % record growth rate
        rfp_rate{j,i}(timeIdx,:) = RFP_rate(idx); % record RFP production rate per cell 
    end
end

% End of calculating rates section

%%%%% Plot bar graph %%%%%
if ismember(time,[1 1.5 2]) 

    figure;
    names = {'Original STAR Target','Deoptimised STAR Target'};
    %names = {'Original STAR Target','Broken Deoptimised STAR Target','Deoptimised STAR Target'};
    legend_barweb = {'WT ','AHL[0M] ','AHL[10e-13M] ','AHL[10e-12M] ','AHL[10e-11M] ',...
        'AHL[10e-10M] ','AHL[10e-9M] ','AHL[10e-8M] ','AHL[10e-7M] ','AHL[10e-6M] '};

    % Growth Rate Subplot
    subplot(3,1,1);
    
    growth = cell2mat(cellfun(@(x) mean(x(timeIdx,:),2),G_rate([1,3],:),'UniformOutput',0));
    growth_std = cell2mat(cellfun(@(x) mean(std(x(timeIdx,:),0,2),2),G_rate([1,3],:),'UniformOutput',0));
    
    barweb(growth, growth_std, 0.8, names, ['Growth Rate ' int2str(time) 'h Post-Induction'], [], ...
        'Growth Rate [h^{-1}]', [0.992, 0.894, 0.305], 'xy', legend_barweb, 2,'axis');

    set(gca,'FontSize',14,'FontWeight','bold','linewidth',1.5); ylim([0 0.65]);
    h = get(gca,'position'); set(gca,'position',[h(1), h(2), h(3), 0.2]);
    
    % RFP Production Subplot
    subplot(3,1,2);
    
    rfp = cell2mat(cellfun(@(x) mean(x(timeIdx,:),2),rfp_rate([1,3],:),'UniformOutput',0));
    rfp_std = cell2mat(cellfun(@(x) mean(std(x(timeIdx,:),0,2),2),rfp_rate([1,3],:),'UniformOutput',0));
    
    barweb(rfp, rfp_std, 0.8, names, ['mRFP Production Rate per Cell ' int2str(time) 'h Post-Induction'], [], ...
        {'mRFP Production Rate', 'per Cell [F.U.ABS_{700}^-1h^{-1}]'}, [0.960, 0, 0], 'xy', legend_barweb, 2,'axis');

    set(gca,'FontSize',14,'FontWeight','bold','linewidth',1.5); ylim([0 1.5e5]);
    h = get(gca,'position'); set(gca,'position',[h(1), h(2)-0.1, h(3), 0.2]);
end

end

%% Plot production rates

colour = hsv(10);
colour(2,:) = [1, 0.7, 0];
tEND = 12; %t(end);
LEGEND = {'WT','AHL[0M]','AHL[10e-13M]','AHL[10e-12M]','AHL[10e-11M]',...
        'AHL[10e-10M]','AHL[10e-9M]','AHL[10e-8M]','AHL[10e-7M]','AHL[10e-6M]'};

%% OD & Growth Rate Figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OD Plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(10);

for j = 1:3
    
    subplot(2,3,j);
    
    for i = 1:10
  
        if j == 1
            idx =  eval(matlab.lang.makeValidName(strcat('pJBL_',int2str(i-1))));
            Title = {'OD of Original STAR Target'};
        elseif j == 2
            idx =  eval(matlab.lang.makeValidName(strcat('AB179_',int2str(i-1))));
            Title = {'OD of Broken Deoptimised STAR Target '};
        else
            idx =  eval(matlab.lang.makeValidName(strcat('AB180_',int2str(i-1))));
            Title = {'OD of Deoptimised STAR Target '};
        end

        p(i) = stdshade(OD(:,idx+1)',0.5,colour(i,:),OD(:,1),1); %#ok<*SAGROW>
        hold on
    end
    
    grid on; axis square; xlim([0.25 tEND-1]); ylim([0 0.4]);
    set(gca,'FontSize',16,'FontWeight','bold','linewidth',2,'TickLength',[0.02,0.02]);
    xlabel('Time [h]'); legend(p(:),LEGEND,'location','NorthWest');
    ylabel({'ABS_{700}'}); title(Title);hold off;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Growth Plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(10);

for j = 1:3
  
    subplot(2,3,j+3);
    
    for i = 1:10
    
        if j == 1
            Title = {'Growth Rate of Original STAR Target'};
        elseif j == 2
            Title = {'Growth Rate of Broken Deoptimised STAR Target '};
        else
            Title = {'Growth Rate of Deoptimised STAR Target '};
        end

        p(i) = stdshade(G_rate{j,i}',0.5,colour(i,:),OD(2:end-1,1),1);
        hold on
    end
    
    grid on; axis square; xlim([0.25 tEND-1]); ylim([-0.1 0.8]);
    set(gca,'FontSize',16,'FontWeight','bold','linewidth',2,'TickLength',[0.02,0.02]);
    xlabel('Time [h]'); legend(p(:),LEGEND,'location','NorthEast');
    ylabel({'Growth Rate [h^{-1}]'}); title(Title);hold off;
end

%% mRFP/cell & mRFP Capacity Figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OD Plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(12);

for j = 1:3
    
    subplot(2,3,j);
    
    for i = 1:10
        
        if j == 1
            idx =  eval(matlab.lang.makeValidName(strcat('pJBL_',int2str(i-1))));
            Title = {'mRFP/Cell of Original STAR Target'};
        elseif j == 2
            idx =  eval(matlab.lang.makeValidName(strcat('AB179_',int2str(i-1))));
            Title = {'mRFP/Cell of Broken Deoptimised STAR Target '};
        else
            idx =  eval(matlab.lang.makeValidName(strcat('AB180_',int2str(i-1))));
            Title = {'mRFP/Cell of Deoptimised STAR Target '};
        end

        p(i) = stdshade((RFP(:,idx+1)./OD(:,idx+1))',0.5,colour(i,:),OD(:,1),1); %#ok<*SAGROW>
        hold on
    end
    
    grid on; axis square; xlim([0.25 tEND-1]); ylim([0 4e5]);
    set(gca,'FontSize',16,'FontWeight','bold','linewidth',2,'TickLength',[0.02,0.02]);
    xlabel('Time [h]'); legend(p(:),LEGEND,'location','SouthEast');
    ylabel({'F.U. ABS_{700}^{-1}'}); title(Title);hold off;
end

%%%%%%%%%%%%%%%%%%%%%%%%% mRFP Production Rate per Cell Plots %%%%%%%%%%%%%%%%%%%%%%%%%%%

for j = 1:3
  
    subplot(2,3,j+3);
    
    for i = 1:10
        
        if j == 1
            Title = {'mRFP Production Rate','per Cell of Original STAR Target'};
        elseif j == 2
            Title = {'mRFP Production Rate','per Cell of Broken Deoptimised STAR Target'};
        else
            Title = {'mRFP Production Rate','per Cell of Deoptimised STAR Target'};
        end

        p(i) = stdshade(rfp_rate{j,i}',0.5,colour(i,:),OD(2:end-1,1),1);
        hold on
    end
    
    grid on; axis square; xlim([0.25 tEND-1]); ylim([-1e4 3e5]);
    set(gca,'FontSize',16,'FontWeight','bold','linewidth',2,'TickLength',[0.02,0.02]);
    xlabel('Time [h]'); legend(p(:),LEGEND,'location','NorthEast');
    ylabel({'mRFP Production Rate','per Cell [h^{-1}]'}); title(Title);hold off;
end

%% Total mRFP Capacity Figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OD Plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

concentrations = [0,10e-13,10e-12,10e-11,10e-10,10e-9,10e-8,10e-7,10e-6];
titles = {'Original STAR Target Static Input-Output Curve';...
    'Deoptimised STAR Target Static Input-Output Curve'};

for j = 1:2
    for i = 2:10
        if j == 1
            idx =  eval(matlab.lang.makeValidName(strcat('pJBL_',int2str(i-1))));
        else
            idx =  eval(matlab.lang.makeValidName(strcat('AB180_',int2str(i-1))));
        end
        TF{j}(i-1,:) = [concentrations(i-1),RFP(17,idx+1)];
    end
end


for i = 1:2
    
    f = @(F,x) F(1)./(F(2)+exp(-F(3).*x));
    F_fitted = nlinfit(TF{i}(:,1),mean(TF{i}(:,2:end),2),f,[0 0 0]);
    disp(['F = ',num2str(F_fitted)])
    
    figure
    hAx = axes;
    hAx.XScale = 'log';
    hold all
    errorbar(TF{i}(:,1),mean(TF{i}(:,2:end),2),std(TF{i}(:,2:end),0,2),'ko','linewidth',2);
    hold on; ylim([0,7e4]);
    plot(linspace(10e-13,10e-5,1e6),f(F_fitted,linspace(10e-13,10e-5,1e6)),'k','linewidth',2);
    title(titles{i});xlabel('3OC6-HSL Concentration [M]');ylabel('Total mRFP [F.U.]');
    set(gca,'FontSize',16,'FontWeight','bold','linewidth',2,'TickLength',[0.02,0.02]);
    set(gcf,'position',[10,10,450,350])
end
