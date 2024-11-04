function selectrange(obj,~,~)
axes(obj.ax1)
limx = xlim;
xx = ceil(limx(1)):floor(limx(2));
obj.xdata = max([1,xx(1)]):min([length(obj.data0),xx(end)]);
if ~isnan(obj.data0)
    obj.data = obj.data0(obj.xdata);
    obj.xdata = xx;
    obj.N = length(obj.data);
else
    return
end

obj.smoothnupdate;
end