%% SCRIPT FINAL STARCH EXP
clc
clear
close all
%%
data = readmatrix('starchfinalexp.xlsx');
%time is not regular due to the plate reader software concatenating
%succesive data
T = readcell('starchfinalexp.xlsx','Range','E12:NP12');
S = string(T);
% Hour = zeros(1,293);
% minute = zeros(1,293);
for i = 1:length(T)
    TimeVec(i,:) = textscan(S(i),'%f %s %f %s');
    Hour(i) =  TimeVec{i,1};
    if ~isempty(TimeVec{i,3})
        minute(i) = TimeVec{i,3};
    end
end

%%
%% PARAMETERES AND DATA INFO
replicates = 3;

%get raw data
OD.raw = data(:,5:5+length(T)-1);
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

%%
plot96(timevector,OD.raw)

%%
%chop data
% I = find(timevector > 50);
% index_at_50 = I(1);
% OD.raw = OD.raw(:,1:index_at_50);
% timevector = timevector(1:index_at_50);
%

%% sort data

elements = {'Y1','Y2','Y3','Y4','Y5','Y6','Y7','Y8','Y9','Y10','Y2900','Y195','Y5017','Y5196','Y5O77','BLANK'};

i = 1;
for j = 1:numel(elements)/2
    OD.rawSC.(elements{j}) = OD.raw(i:i+2,:);
    i = i +12;
end

i=4;
for j = (numel(elements)/2)+1:numel(elements)
    OD.rawSC.(elements{j}) = OD.raw(i:i+2,:);
    i=i+12;
end

i = 7;
for j = 1:numel(elements)/2
    OD.rawCocul.(elements{j}) = OD.raw(i:i+2,:);
    i = i+12;
end

i=10;
for j = (numel(elements)/2)+1:numel(elements)
    OD.rawCocul.(elements{j}) = OD.raw(i:i+2,:);
    i = i+12;
end

%%
figure('units','normalized','outerposition',[0 0 1 1])
hold on
count = 1;
for i = 1:10
    for j = 3
        ax(count) = subplot(3,4,count+1);
        
        plot(timevector,smooth(OD.rawSC.(elements{i})(j,:),'rlowess'),'LineWidth',2);
        pbaspect([1 1 1])
        hold on
        
        plot(timevector,smooth(OD.rawSC.(elements{15})(j,:),'rlowess'),'LineWidth',2);
        pbaspect([1 1 1])
        plot(timevector,smooth(OD.rawCocul.(elements{i})(j-1,:),'rlowess'),'LineWidth',2);
        pbaspect([1 1 1])
        plot(timevector,smooth(OD.rawSC.(elements{13})(3,:),'rlowess'),'LineWidth',2);
        pbaspect([1 1 1])
        if count == 1
            legend({'(GA) OD_0=0.25','(AA) OD_0=0.25','(GA)+(AA) OD_0= 0.5 (1:1)','(GA+AA) OD_0 = 0.25'},'Location','best')
        end
        title(['Y',num2str(i)])
        hold on
        grid on
        count = count +1;
    end
end

ax(12) = subplot(3,4,12);
plot(timevector,smooth(OD.rawSC.(elements{11})(3,:),'rlowess'),'k.','LineWidth',2);
hold on
grid on
plot(timevector,smooth(OD.rawSC.(elements{12})(3,:),'rlowess'),'g.','LineWidth',2);
legend({'Y2900 OD_0=0.25','Y195 OD_0=0.25'},'Location','best')
pbaspect([1 1 1])
title('Y195 - Y2900')

linkaxes(ax(:),'y');

%%
figure
count = 1;
plot(timevector,smooth(OD.rawSC.(elements{13})(3,:),'rlowess'),'LineWidth',2);

hold on
plot(timevector,smooth(OD.rawCocul.(elements{13})(1,:),'rlowess'),'LineWidth',2);

plot(timevector,smooth(OD.rawSC.(elements{11})(3,:),'rlowess'),'LineWidth',2);

plot(timevector,smooth(OD.rawSC.(elements{15})(3,:),'rlowess'),'LineWidth',2);

legend({'(GA+AA) OD_0=0.25','(GA+AA)+(AA) OD_0=1 1:1','Y2900 OD_0= 0.25','(AA) OD_0 = 0.25'},'Location','best')
grid on


ylabel('OD_{600}')
xlabel('Time (in hours)')


