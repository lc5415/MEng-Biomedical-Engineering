A = [-0.5 -0.8;0.8 0];
B = [1 ; 0];
C = [2 6];
D = 0;

x0 = [25;0];

sys = ss(A,B,C,D);
initialplot(sys,x0);
figure;
impulse(sys);

lsiminfo(impulse(sys))
