function out = g(beta, h, T)
for i = 1:length(h)
    if h(i) <= T
        out(i) = 0;
    elseif h(i)>T && h(i)<=(T+1/beta)
        out(i) = beta*(h(i)-T);
    else
        out(i) =1;
    end
end
    
end

