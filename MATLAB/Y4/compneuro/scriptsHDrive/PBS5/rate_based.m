function m = rate_based(g)
t = 0:1:1000; %time in milliseconds
tau = 5;

m(1) = 0;

for i = 1:length(t)-1
    %this is for a single neuron, for more neurons this will be nested in 
    %another for loop
    m(i+1) = m(i)+((t(i+1)-t(i))/tau)+g;
    %this should be g(h) but g would be called with h as input
    %before this function being called
end
end

