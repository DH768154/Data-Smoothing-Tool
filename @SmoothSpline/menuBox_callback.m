function menuBox_callback(obj,~,~)
varind = obj.menuBox.Value;
dataname = obj.menuBox.String{varind};
cvar = evalin('base', 'who');
if ~ismember(dataname,cvar)
    return
end
obj.data0 = evalin('base', dataname);

[r,c] = size(obj.data0);
if r~=1 && c~=1
    error('1d data only')
end

obj.data0 = obj.data0(:);
obj.data = obj.data0;
obj.N = length(obj.data);
obj.xdata = 1:obj.N;
obj.updataL0(obj);
obj.smoothnupdate;

end