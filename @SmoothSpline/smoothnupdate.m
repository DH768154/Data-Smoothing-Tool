function smoothnupdate(obj,~,~)

axes(obj.ax1)

if isnan(obj.data)
    axes(obj.ax1)
    obj.L1.XData = nan;
    obj.L1.YData = nan;
    return
end

[obj.gcv,spline] = obj.smoothsplineN(obj.data,obj.sigma);
obj.gcvBox.String = num2str(obj.gcv,'%.4e');

axes(obj.ax1)
obj.L1.XData = obj.xdata;
obj.L1.YData = spline;
drawnow;

end