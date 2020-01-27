clf
for a = 0.1:0.1:1;
t = 0:0.1:10;
x0 = [1; 5];
x1 = [10;5];
x2 = [100;5];

x3 = [1; 10];
x4 = [1;50];
x5 = [1;500];
figure
ax1 = subplot(3,2,1);
ax2 = subplot(3,2,2);
ax3 = subplot(3,2,3);
ax4 = subplot(3,2,4);
ax5 = subplot(3,2,5);
ax6 = subplot(3,2,6);
u = a*sin(5*t)+(1-a)*cos(0.5*t);
lsim(ax1,sys,u,t,x0)
title({'\alpha = ', num2str(a);'x_0 =',x0})
lsim(ax3,sys,u,t,x1)
title(x1)
lsim(ax5,sys,u,t,x2)
title(x2)
lsim(ax2,sys,u,t,x3)
title(x3)
lsim(ax4,sys,u,t,x4)
title(x4)
lsim(ax6,sys,u,t,x5)
title({'\alpha = '; a;'x_5 ='; x5})
end
figure
bodeplot(sys);