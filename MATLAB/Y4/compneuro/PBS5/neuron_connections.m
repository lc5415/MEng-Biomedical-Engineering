function [J,hnew] = neuron_connections(neurons,h,m)
J0 = 86;
J2 = 112;
% J = zeros(N,N);
    for i = 1:length(neurons)
        for j = 1:length(neurons)
            J(i,j) = -J0 + J2*cos(2*(neurons(i)-neurons(j)));
        end
    end
    image(J)
    colorbar
    
    %% DONT'UN desrtand if h is now over time or not as m is a function of time
    for i = 1:length(neurons)
        for j = 1:length(neurons)
    hnew = sum(J(i,j))*m(i)
        end
    end
end

