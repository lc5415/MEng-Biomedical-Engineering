 function dvdt  = cwfunction(v,a,b)

dvdt = [ a+v(1).^2*v(2)-(b+1)*v(1); b*v(1)-v(1).^2*v(2)];

end

