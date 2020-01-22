function out = h_input(theta0, theta, c, epsilon)
out = c*[(1-epsilon)+epsilon*cos(2*(theta-theta0))];
end