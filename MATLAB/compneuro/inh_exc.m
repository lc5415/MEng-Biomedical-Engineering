function dv = inh_exc(t,v)
wee = 1;
wei = 2;
wii = 1;
wie = -2;
Ii = 10;
Ie = 1;

dv = [-v(1)+ g(wee*v(1)+wei*v(2)+Ie); -v(2)+g(wie.*v(1)+wii.*v(2)+Ii)];
end




