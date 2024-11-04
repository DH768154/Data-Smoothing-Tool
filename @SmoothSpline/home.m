function home(obj,~,~)

spline = obj.L1.YData';

limy = [min([obj.data0;spline]),max([obj.data0;spline])];
dy = limy(2)-limy(1);
if ~isnan(dy)
    axes(obj.ax1)
    ylim([-1,1]*dy*0.05+limy)
    xlim([1,length(obj.data0)])
end
end  