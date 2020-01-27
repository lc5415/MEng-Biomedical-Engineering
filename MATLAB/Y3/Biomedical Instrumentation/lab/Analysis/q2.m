A = xlsread('LAb 1 - measurement 1.xlsx')
figure
hold on
db1(:) = 20*log10(A(:,2));
db2(:) = 20*log10(A(:,3));
f(:) = log10(A(:,1));
loglog(f(:),db1(:),'b')
loglog(f(:),db2(:),'r')
loglog(f(:),db1(:),'bo')
loglog(f(:),db2(:),'ro')
grid on
xlabel('log_{10} of frequency')
ylabel('Amplitude drop (in dB)')
legend('Measurement 1','Measurement 2')
%title('Log-log plot of db drop vs. frequency for Measurements 1 & 2')
xlim([-0.35 1.05])
%%

figure
hold on
db3(:,1) = 20*log10(A(:,6));
db4(:,1) = 20*log10(A(:,7));
f1(:,1) = log10(A(:,5));
loglog(f1(:),db3(:),'b')
loglog(f1(:),db4(:),'r')
loglog(f1(:),db3(:),'bo')
loglog(f1(:),db4(:),'ro')
grid on
xlabel('log_{10} of frequency')
ylabel('Amplitude drop (in dB)')
legend('Measurement 3','Measurement 4')
%title('Log-log plot of db drop vs. frequency for Measurements 3 & 4')
%xlim([-0.35 1.05])
%ylim([-1.4 0.05])
%%

figure
hold on
db5(:) = 20*log10(A(:,10));
%db2(:) = 20*log10(m5(:,3));
f2(:) = log10(A(:,9));
loglog(f2(:),db5(:),'k')
%loglog(f(:),db2(:),'r')
loglog(f2(:),db5(:),'ko')
%loglog(f(:),db2(:),'ro')
grid on
xlabel('log_{10} of frequency')
ylabel('Amplitude drop (in dB)')
legend('Measurement 5')
%title('Log-log plot of db drop vs. frequency for Measurement 5')
%xlim([-0.35 1.05])
%ylim([-1.4 0.05])


