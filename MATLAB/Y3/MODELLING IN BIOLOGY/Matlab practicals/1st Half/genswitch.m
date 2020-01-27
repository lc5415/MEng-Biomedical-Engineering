 function dvdt  = genswitch(v,a,b,g )

dvdt = [ a/(1+v(2).^4) - g*v(1) ; b/(1+v(1).^4)-g*v(2)];

end

