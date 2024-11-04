function autozoom(obj,~,~)

axes(obj.ax1)
limx = xlim;
xrange = ceil(limx(1)):floor(limx(2));
xrange = max([1,xrange(1)]):min([length(obj.data0),xrange(end)]);
if ~isnan(obj.data0)
    datac = obj.data0(xrange);
end

xdatac = obj.L1.XData';
spline = obj.L1.YData(xdatac>=xrange(1)&xdatac<=xrange(2))';

limy = [min([datac;spline]),max([datac;spline])];
dy = limy(2)-limy(1);
if ~isnan(dy)
    axes(obj.ax1)
    ylim([-1,1]*dy*0.05+limy)
    xlim([xrange(1),xrange(end)])
end
end