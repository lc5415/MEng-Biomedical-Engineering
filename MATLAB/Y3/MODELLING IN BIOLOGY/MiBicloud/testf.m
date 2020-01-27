function F = testf( v )
%v(1) is x, v(2) is y
kx = 5000;
ky = 5000;
Kx = 0.5;
Ky = 0.5;
K1 = 0.3;
K2 = 0.3;
kd =0.7;
F(1) = (kx/kd)*(1/(1+K1*Ky*v(2)^2));
F(2) = (ky/kd)*(1/(1+K2*Kx*v(1)^2));

end


