clear all
delete(findall(0,'Type','figure'))
tic
%%Q2
a = 1;
b = 0.01;
c = 0.4;
g = 0.002;
Rnew(1)=100;
Fnew(1)=10;
totaltime(1)=0;
%foxriptime(1,1:simulations)=0; this method requires too much time
hold on;
%for n = 1:simulations
for i = 2:100000
    if ((Rnew(i-1)+Fnew(i-1))>0)
        [Rnew(i),Fnew(i),Deltat(i)] = RabsFoxs(Rnew(i-1),Fnew(i-1),a,b,c,g);
        totaltime(i)=totaltime(i-1)+Deltat(i);
    else
        break
    end
end
plot(totaltime,Rnew,'LineWidth',1.2)
plot(totaltime,Fnew,'LineWidth',1.2)
legend('Rabits','Foxes')
xlabel('Time')
ylabel('Population')
%%
%Q3
avTime=0;
simulations = 100;
for n=1:simulations
R = 100;
F= 10;
t = 0;
while F>0   %%Tom Ouldridge Implementation
    rold=R;
    fold=F;
    dt=0;
    [R,F,dt] = RabsFoxs(R,F,a,b,c,g);
    t=t+dt;
end
avTime = avTime+t;
end

avTime = avTime/simulations
elapsedTime = toc

%     legend('Rabbits','Foxes')
%     xlabel('Time')
%     ylabel('Population')




