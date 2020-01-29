function plot48(timevector,data)
figure('units','normalized','outerposition',[0 0 1 1])
for i = 1:length(data(:,1))
    ax(i) = subplot(4,12,i);
    plot(timevector,data(i,:),'.')
end

linkaxes(ax(:),'xy');
% ax(1).YLim = [0,2.4];
% ax(1).XLim = [0,timevector(end)];
end

