%% data processing plate reader; Luis Chaves June 2019
% Before importing excel data into this algortihm make sure you separate
% raw data and blank data with an empty column

clc
clear 
close all
%%
data = readmatrix('Allstrains_YPD_YND_serioustry_1.xlsx');
%% BANK OF PARAMETERES AND DATA INFO 
replicates = 3;
%find all Nans
Nans = find(isnan(data(1,:)));
%get index of last value which is raw data, before NaN
rawdata_end = Nans(4)-1;
%get raw data vector
rawdata.raw = data(:,5:rawdata_end);
%get time vector (measurement every 20 minutes)
[rawdata.wells,rawdata.measurements]= size(rawdata.raw);

    
timevector_minutes = 0:20:20*rawdata.measurements-1;
timevector_hours = timevector_minutes./60;

%Sampling frequency
Fs = rawdata.measurements/(timevector_minutes(end)*60);

%timevector vector used 
timevector =timevector_hours;
timestep = timevector(2)-timevector(1);
%% plot 96 wells

plot96(timevector,rawdata.raw)


%% fit all to sigmoidal 
% 
% for a = 1:rawdata.wells
%     subplot(8,12,a)
%     params(a,:) = sigm_fit(timevector,rawdata.raw(a,:));
% end
% params.min(:) = params(:,1);
% params.max(:) = params(:,2);
% params.x50(:) = params(:,3);
% params.slope(:) = params(:,4);

%% fourier analysis
% T = 1/Fs;             % Sampling period       
% L = rawdata.measurements;             % Length of signal
% t = (0:L-1)*T;        % Time vector
% Y = fft(rawdata.raw(1,:));
% 
% P2 = abs(Y/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% f = Fs*(0:(L/2))/L;
% plot(f,P1) 
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')

% %% filter data4
% for i = 1:rawdata.wells
%     rawdata.filteredrawdata(i,:) = lowpass(rawdata.raw(i,:), 2*10^(-4));
% end
% 

%% combine replicates
% 
% j = 1;
% for i = 1:replicates:96-replicates+1
% rawdata.group_avg(j,:) = mean(rawdata.raw(i:i+2,:));
% rawdata.groups_std(j,:) = std(rawdata.raw(i:i+2,:));
% j = j+1;
% end

%% little trick to delete contamination in blank (not for final report data)
% avgblank2  = mean(rawdata.group_avg(32,:));
% gitter = rawdata.group_avg(32,:) - avgblank2;
% blank = mean(rawdata.group_avg(16,1:40));
% newblank = gitter + blank;
% rawdata.group_avg(16,:) = newblank;

%% plot replicate data
% 
% for a = 1:rawdata.wells/replicates
%     ax2(a) = subplot(8,4,a);
%     plot(timevector,rawdata.group_avg(a,:))
% end
% linkaxes(ax2(:),'xy');
% ax2(1).YLim = [0,2.4];
% ax2(1).XLim = [0,timevector(end)];
% %% Fourier analysis and filtering
% 
% plot(timevector, rawdata.group_avg(1,:))
% hold on
% pause(0.5)
% for a = 0.5
%     rawdata.filtered_data = lowpass(rawdata.group_avg(1,:),a,Fs);
%     plot(timevector,y)
%     pause(0.5)
% end
% 

%% calculate growth rate
for a = 1:rawdata.wells/replicates
rawdata.growthrate(a,:) = diff(rawdata.group_avg(a,:));
end


%% blank data
% 
% rawdata.blanked_avgs(1:16,:) = rawdata.group_avg(1:16,:) - rawdata.group_avg(16,:);
% rawdata.blanked_avgs(17:32,:) = rawdata.group_avg(17:32,:) - rawdata.group_avg(32,:);
% 

%% smooth this data
for a = 1:rawdata.wells/replicates
rawdata.smoothblanked_avgs(a,:) = smooth(rawdata.blanked_avgs(a,:),15,'lowess');
end

%% smooth growth rate
for a = 1:rawdata.wells/replicates
growthrate(a,:) = smooth(growthrate(a,:));
end

%% modified Gompertz fit
close all
params = [];
% x = -1:0.01:1;
% y = 1./(1+exp(-10*x));

% [params,fval,exitflag,output] = Fits(x,y,1)

for a = 1:96
     subplot(10,10,a)
    [params(a,:),fval(a)] = Fits(timevector,rawdata.raw(a,:),1,1);
end
figure
bar(params(:,2))

