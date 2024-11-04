function updataL0(obj,~,~)
axes(obj.ax1)
obj.L0.XData = 1:length(obj.data0);
obj.L0.YData = obj.data0;

limy = [min(obj.data0),max(obj.data0)];
dy = limy(2)-limy(1);
if ~isnan(dy)
    axes(obj.ax1)
    ylim([-1,1]*dy*0.05+limy)
    xlim([1,length(obj.data0)])
    drawnow;
    ylim('manual')
end
end