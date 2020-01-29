%% Script for YPD/YNB final experiment

clc
clear all
close all
%%
data = readmatrix('YPD_YNB_finalexperiment.xlsx');

%get time vector from 'X h Y min' format, I do this because mesaurement
%time is not regular due to the plate reader software concatenating
%succesive data
T = readcell('YPD_YNB_finalexperiment.xlsx','Range','E12:KK12');
S = string(T);
Hour = zeros(1,293);
minute = zeros(1,293);
for i = 1:length(T)
    TimeVec(i,:) = textscan(S(i),'%f %s %f %s');
    Hour(i) =  TimeVec{i,1};
    if ~isempty(TimeVec{i,3})
        minute(i) = TimeVec{i,3};
    end
end
%% PARAMETERES AND DATA INFO
replicates = 3;

%get raw data
OD.raw = data(:,5:297);
%get time vector (measurement every 17 minutes)
[OD.wells,OD.measurements]= size(OD.raw);

%make timevector
timevector_minutes = 60*Hour+minute;
timevector_hours = timevector_minutes/60;

%Sampling frequency
Fs = OD.measurements/(timevector_minutes(end)*60);

%timevector vector used
timevector =timevector_hours;
timestep = timevector(2)-timevector(1);

OD.rawYPD = OD.raw(1:48,:);
OD.rawYNB = OD.raw(49:96,:);

%% Chop data because cells start to die, take measurement until 44 hours
I = find(timevector > 44);
index_at_44 = I(1);
OD.rawYPD = OD.raw(1:48,1:index_at_44);
OD.rawYNB = OD.raw(49:96,1:index_at_44);
timevector = timevector(1:index_at_44);

%% plot 48 wells in YPD and 48 wells in YNB
%
% plot48(timevector,OD.rawYPD)
% plot48(timevector,OD.rawYNB)

%% blank all data

BlankYPD = mean(OD.rawYPD(46:48,:));
BlankYNB = mean(OD.rawYNB(46:48,:));
OD.blankedYPD = OD.rawYPD-BlankYPD;
OD.blankedYNB = OD.rawYNB-BlankYNB;

%% plot 48 wells in YPD and 48 wells in YNB
%
% plot48(timevector,OD.blankedYPD)
% plot48(timevector,OD.blankedYNB)


%% PLOT OF A FEW

colours = distinguishable_colors(16);
j = 1;
for i = 1:replicates:48-replicates+1
    if i == 10
        OD.avgYPD(j,:) = mean(OD.blankedYPD(i:i+1,:));
        OD.stdYPD(j,:) = std(OD.blankedYPD(i:i+1,:));
    elseif i == 19
        OD.avgYPD(j,:) = mean(OD.blankedYPD([i,i+2],:));
        OD.stdYPD(j,:) = std(OD.blankedYPD([i,i+2],:));
    elseif i == 22
        OD.avgYPD(j,:) = mean(OD.blankedYPD(i:i+1,:));
        OD.stdYPD(j,:) = std(OD.blankedYPD(i:i+1,:));
    elseif i ==40
        OD.avgYPD(j,:) = mean(OD.blankedYPD(i:i+1,:));
        OD.stdYPD(j,:) = std(OD.blankedYPD(i:i+1,:));
    elseif i ==43
        OD.avgYPD(j,:) = mean(OD.blankedYPD(i:i+1,:));
        OD.stdYPD(j,:) = std(OD.blankedYPD(i:i+1,:));
    end
    OD.avgYPD(j,:) = mean(OD.blankedYPD(i:i+2,:));
    OD.stdYPD(j,:) = std(OD.blankedYPD(i:i+2,:));
    
    if i == 4
        OD.avgYNB(j,:) = mean(OD.blankedYNB(i:i+1,:));
        OD.stdYNB(j,:) = std(OD.blankedYNB(i:i+1,:));
    elseif i == 37
        OD.avgYNB(j,:) = mean(OD.blankedYNB([i,i+2],:));
        OD.stdYNB(j,:) = std(OD.blankedYNB([i,i+2],:));
    end
    OD.avgYNB(j,:) = mean(OD.blankedYNB(i:i+2,:));
    OD.stdYNB(j,:) = std(OD.blankedYNB(i:i+2,:));
    
    j = j+1;
end

%subplot(1,2,1)
figure
for i = [3,11,13:16]
plot(timevector,OD.avgYPD(i,:),'LineWidth',2)%,'Color',colours(i,:))
hold on
end
%legend({'Y3','Y2900','Y195','Y5017','Y5196','Y5077','BLANK'},'Location','best')
legend({'Y3','Y2900','Y5017','Y5196','Y5077','BLANK'},'Location','best')
ylim([0 2.5])
xlim([0 55])
grid on
xlabel('Time (hours)')
ylabel('OD_{600}')
title 'Growth in YPD'
pbaspect([1 1 1])
% subplot(1,2,2)
figure
for i = [3,11,13:16]
plot(timevector,OD.avgYNB(i,:),'LineWidth',2,'Color',colours(i,:))
hold on
end
% legend({'Y3','Y2900','Y195','Y5017','Y5196','Y5077','BLANK'},'Location','best')
legend({'Y3','Y2900','Y5017','Y5196','Y5077','BLANK'},'Location','best')
ylim([0 2.5])
grid on
xlabel('Time (hours)')
ylabel('OD_{600}')
title 'Growth in YNB'
pbaspect([1 1 1])
%%
load('BoundedrawYPDshort-4paramsGompsvariables.mat')
for i = 1:45
    growthrate(i) = params(i).B(1).*params(i).B(2)/exp(1);
    %     growthrate(i) = params(i).B(2)/exp(1);
end
load('linearblanksrawYPDvariables.mat')
for i = 46:48
    growthrate(i) = params(i).B(2);
end
%bar(growthrate)

hYPD5017 = ttest2(growthrate(31:33),growthrate(37:39),'Alpha',0.02);
hYPD5077 = ttest2(growthrate(31:33),growthrate(43:44),'Alpha',0.02);
hYPD5196 = ttest2(growthrate(31:33),growthrate(40:41),'Alpha',0.02);
hYPDY1 = ttest2(growthrate(31:33),growthrate(1:3));
hYPDY2 = ttest2(growthrate(31:33),growthrate(4:6));
hYPDY3 = ttest2(growthrate(31:33),growthrate(7:9));
hYPDY4 = ttest2(growthrate(31:33),growthrate(10:11));
hYPDY5 = ttest2(growthrate(31:33),growthrate(13:15));
hYPDY6 = ttest2(growthrate(31:33),growthrate(16:18));
hYPDY7 = ttest2(growthrate(31:33),growthrate([19,21]));
hYPDY8 = ttest2(growthrate(31:33),growthrate(22:23));
hYPDY9 = ttest2(growthrate(31:33),growthrate(25:27));
hYPDY10 = ttest2(growthrate(31:33),growthrate(28:30));

%YPD WELLS REMOVED: wells 12,20,24,42,45
growthrateYPD.Blank.avg = mean(growthrate(46:48));
growthrateYPD.Blank.std = std(growthrate(46:48));
growthrateYPD.Y195.avg = mean(growthrate(34:36));
growthrateYPD.Y195.std = std(growthrate(34:36));
growthrateYPD.Y2900.avg = mean(growthrate(31:33));
growthrateYPD.Y2900.std = std(growthrate(31:33));
growthrateYPD.Y1.avg = mean(growthrate(1:3));
growthrateYPD.Y1.std = std(growthrate(1:3));
growthrateYPD.Y2.avg = mean(growthrate(4:6));
growthrateYPD.Y2.std = std(growthrate(4:6));
growthrateYPD.Y3.avg = mean(growthrate(7:9));
growthrateYPD.Y3.std = std(growthrate(7:9));
growthrateYPD.Y4.avg = mean(growthrate(10:11));
growthrateYPD.Y4.std = std(growthrate(10:11));
growthrateYPD.Y5.avg = mean(growthrate(13:15));
growthrateYPD.Y5.std = std(growthrate(13:15));
growthrateYPD.Y6.avg = mean(growthrate(16:18));
growthrateYPD.Y6.std = std(growthrate(16:18));
growthrateYPD.Y7.avg = mean(growthrate([19,21]));
growthrateYPD.Y7.std = std(growthrate([19,21]));
growthrateYPD.Y8.avg = mean(growthrate(22:23));
growthrateYPD.Y8.std = std(growthrate(22:23));
growthrateYPD.Y9.avg = mean(growthrate(25:27));
growthrateYPD.Y9.std = std(growthrate(25:27));
growthrateYPD.Y10.avg = mean(growthrate(28:30));
growthrateYPD.Y10.std = std(growthrate(28:30));
growthrateYPD.Y5017.avg = mean(growthrate(37:39));
growthrateYPD.Y5017.std = std(growthrate(37:39));
growthrateYPD.Y5196.avg = mean(growthrate(40:41));
growthrateYPD.Y5196.std = std(growthrate(40:41));
growthrateYPD.Y5077.avg = mean(growthrate(43:44));
growthrateYPD.Y5077.std = std(growthrate(43:44));


% clear -vars growthrate
% load('rawYNBshort-4paramsGompsvariables.mat')
% for i = [1:33,37:45]
%     growthrate(i) = params(i).B(1).*params(i).B(2)/exp(1);
%     %     growthrate(i) = params(i).B(2)/exp(1);
% end
% load('linearYNBvariables.mat')
% for i = [34:36,46:48]
%     growthrate(i) = params(i).B(2);
% end
% 
% 
% % YNB WELLS REMOVED: 6, 38
% growthrateYNB.Blank.avg = mean(growthrate(46:48));
% growthrateYNB.Blank.std = std(growthrate(46:48));
% growthrateYNB.Y195.avg = mean(growthrate(34:36));
% growthrateYNB.Y195.std = std(growthrate(34:36));
% growthrateYNB.Y2900.avg = mean(growthrate(31:33));
% growthrateYNB.Y2900.std = std(growthrate(31:33));
% growthrateYNB.Y1.avg = mean(growthrate(1:3));
% growthrateYNB.Y1.std = std(growthrate(1:3));
% growthrateYNB.Y2.avg = mean(growthrate(4:5));
% growthrateYNB.Y2.std = std(growthrate(4:5));
% growthrateYNB.Y3.avg = mean(growthrate(7:9));
% growthrateYNB.Y3.std = std(growthrate(7:9));
% growthrateYNB.Y4.avg = mean(growthrate(10:12));
% growthrateYNB.Y4.std = std(growthrate(10:12));
% growthrateYNB.Y5.avg = mean(growthrate(13:15));
% growthrateYNB.Y5.std = std(growthrate(13:15));
% growthrateYNB.Y6.avg = mean(growthrate(16:18));
% growthrateYNB.Y6.std = std(growthrate(16:18));
% growthrateYNB.Y7.avg = mean(growthrate(19:21));
% growthrateYNB.Y7.std = std(growthrate(19:21));
% growthrateYNB.Y8.avg = mean(growthrate(22:24));
% growthrateYNB.Y8.std = std(growthrate(22:24));
% growthrateYNB.Y9.avg = mean(growthrate(25:27));
% growthrateYNB.Y9.std = std(growthrate(25:27));
% growthrateYNB.Y10.avg = mean(growthrate(28:30));
% growthrateYNB.Y10.std = std(growthrate(28:30));
% growthrateYNB.Y5017.avg = mean(growthrate([37,39]));
% growthrateYNB.Y5017.std = std(growthrate([37,39]));
% growthrateYNB.Y5196.avg = mean(growthrate(40:42));
% growthrateYNB.Y5196.std = std(growthrate(40:42));
% growthrateYNB.Y5077.avg = mean(growthrate(43:45));
% growthrateYNB.Y5077.std = std(growthrate(43:45));

elements = fields(growthrateYPD);

for  i = 3:numel(elements)
    avgsYPD(i-2) = growthrateYPD.(elements{i}).avg;
    stdsYPD(i-2) = growthrateYPD.(elements{i}).std;
end

% for  i = 1:numel(elements)
%     avgsYNB(i) = growthrateYNB.(elements{i}).avg;
%     stdsYNB(i) = growthrateYNB.(elements{i}).std;
% end

figure
y = [avgsYPD'];%,avgsYNB'];
err = [stdsYPD'];%,stdsYNB'];
b = bar(y,'FaceColor','flat');
for k = 1:size(y,2)
    if k == 1
        b(k).CData = [210 105 30]/255; %brown (YPD)
    elseif k == 2 %pale beige
        b(k).CData = [245 222 179]/255;
    end
end
hold on
% errorbar(1:16,avgsYPD,stdsYPD,'.')
% errorbar(1:16,avgsYNB,stdsYNB,'.')
%

ngroups = size(y, 1);
nbars = size(y, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, y(:,i), err(:,i), 'k.');
end
hold off
xticks(1:14)
xtickangle(45)
xticklabels(elements(3:16));
legend({'Grown in YPD','Standard deviation'})
xlabel('Samples in the study')
ylabel('Absolute growth rate (OD\cdot t^{-1})')
grid on

%%
for i = 1:45
    growthrate(i) = params(i).B(2)/exp(1);
    ODmax(i) = params(i).B(3);
    growthrateconf(i,:) = params(i).confint(:,2)/exp(1)-growthrate(i);
    ODmaxconf(i,:) = params(i).confint(:,3)-ODmax(i);
    %     errorbar(growthrate(i),ODmax(i),ODmaxconf(i,1),ODmaxconf(i,2),growthrateconf(i,1),growthrateconf(i,2))
end

countOD = 0;
goodones ={};
colours = distinguishable_colors(15);
j = 1;
for i = 1:45
    if ODmaxconf(i,2) <=0.12
          if growthrateconf(i,2) <= 0.015
        if i/3 <= j
            h(j,mod(i,3)+1) = errorbar(growthrate(i),ODmax(i),ODmaxconf(i,1),ODmaxconf(i,2),growthrateconf(i,1),growthrateconf(i,2),'Color',colours(j,:),'DisplayName',num2str(j));
            hold on
        end
        countOD = countOD +1;
        goodones{i} = num2str(i);
              end
    end
    
    if mod(i,3) == 0
        j = j+1;
    end
end
goodones = goodones(~cellfun('isempty',goodones));
l = legend