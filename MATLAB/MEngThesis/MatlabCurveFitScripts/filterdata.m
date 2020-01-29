function filtered_data = filterdata(data,option)
filtered_data = lowpass(data,Fpass,Fs);
end

