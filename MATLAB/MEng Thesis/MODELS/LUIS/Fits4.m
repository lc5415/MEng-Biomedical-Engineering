function Fits4(timevector,data,foldername)
[wells,measurements] = size(data);

%% Section 1: perform curve fitting on the data proposed 
[params,fval,I] = Fits3(timevector,data,foldername);
%extract max growth rate as main parameter of interest from data
maxgrowthrate.raw = zeros(wells,1);

for i  = 1:length(params)
maxgrowthrate.raw(i) = params(i).B(2);
end

%% Section 2: perform LOWESS, RLOWESS and Savitzky-Golay filter on data 
%  and get max growth rate from there

% STILL UNSURE OF THIS METHOD, EVEN WHEN APPLYING SMOOTHING THERE TURNS OUT
% TO BE NOISE CORRUPTING THE SIGNAL

% smooth_data_lowess(a,:) = zeros(wells,measurements);
% smooth_data_loess(a,:) = zeros(wells,measurements);
% smooth_data_rlowess(a,:) = zeros(wells,measurements);
% smooth_data_rlowess(a,:) = zeros(wells,measurements);
% smooth_SG(a,:) = zeros(wells,measurements);
% 
% for a = 1:wells
% smooth_data.lowess(a,:) = smooth(data(a,:),'lowess'); 
% smooth_data.loess(a,:) = smooth(data(a,:),'loess');
% smooth_data.rlowess(a,:) = smooth(data(a,:),'rlowess');
% smooth_data.rloess(a,:) = smooth(data(a,:),'rloess');
% smooth_data.SG(a,:) = sgolayfilt(data(a,:),2,5);
% G(a,:,:) = GrowthRateCalculator(timevector,[smooth.lowess;smooth.loess;smooth.rlowess;smooth.rloess;smooth.SG],1);
% end

%% Section 3: plot bar plot for each max growth rate for each well

% bar(maxgrowthrate.raw)
% replicates = 3;
% j = 1;
% maxgrowthrate.replicates.avg = zeros(wells/replicates);
% maxgrowthrate.replicates.std = zeros(wells/replicates);
% for i = 1:replicates:96-replicates+1
% maxgrowthrate.replicates_avg(j,:) = mean(maxgrowthrate.raw(i:i+2,:));
% maxgrowthrate.replicates_std(j,:) = std(maxgrowthrate.raw(i:i+2,:));
% j = j+1;
% end
% 
% errorbar(maxgrowthrate.replicates_avg([1:13,15:24,26:end]),maxgrowthrate.replicates_std([1:13,15:24,26:end]))


end

