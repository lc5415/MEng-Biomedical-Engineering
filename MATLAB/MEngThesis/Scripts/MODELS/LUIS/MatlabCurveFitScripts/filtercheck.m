function [maxgrowthrate,indices] = filtercheck(timevector,rawdata,index,fpass)
filteredrawdata(index,:) = lowpass(rawdata.raw(index,:), fpass);

smoothcurve = smooth(rawdata.raw(index,:));
smoothcurve = smoothcurve';
timestep = timevector(2)-timevector(1);
raw_growth = GrowthRateCalculator(timestep,rawdata.raw(index,:),1);
filtered_growth = GrowthRateCalculator(timestep,filteredrawdata(index,:),1);
smooth_growth = GrowthRateCalculator(timestep,smoothcurve,1);

figure
subplot(2,1,1)
plot(timevector, rawdata.raw(index,:))
hold on
plot(timevector, filteredrawdata(index,:))
plot(timevector, smoothcurve)
subplot(2,1,2)
hold off
plot(timevector(1:end-1),raw_growth)
hold on
plot(timevector(1:end-1),filtered_growth)
plot(timevector(1:end-1),smooth_growth)

[maxgrowthrate(1),indices(1)] = max(raw_growth);
[maxgrowthrate(2),indices(2)] = max(filtered_growth);
[maxgrowthrate(3),indices(3)] = max(smooth_growth);

end

