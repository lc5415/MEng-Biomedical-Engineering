function m = rate_based(g,tspan,m0)
t = tspan; %time in milliseconds
tau = 5;
m(1) = m0;

for i = 1:length(t)-1
    %this is for a single neuron, for more neurons this will be nested in 
    %another for loop
    m(i+1) = m(i)+((t(i+1)-t(i))/tau)*(-m(i)+g);
    %this should be g(h) but g would be called with h as input
    %before this function being called
end
end

