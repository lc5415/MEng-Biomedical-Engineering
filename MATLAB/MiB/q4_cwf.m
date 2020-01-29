 function F = testf2(v)
kx = 5000;
ky = 5000;
Kx = 0.5;
Ky = 0.5;
K1 = 0.3;
K2 = 0.3;
kd =0.7;
F  = [kx*(1/(1+K1*Ky*v(2).^2))-kd*v(1);ky*(1/(1+K2*Kx*v(1).^2))-kd*v(2)];
% F(1)= kx*(1/(1+K1*Ky*v(2).^2))-kd*v(1);
% F(2) = ky*(1/(1+K2*Kx*v(1).^2))-kd*v(2);
end


