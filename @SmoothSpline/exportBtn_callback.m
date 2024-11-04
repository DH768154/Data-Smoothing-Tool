function exportBtn_callback(obj,~,~)

axes(obj.ax1)
limx = xlim;
out_indx = [ceil(limx(1)),floor(limx(2))];

[~,spline] = obj.smoothsplineN(obj.data,obj.sigma);
ripple = obj.data - spline;

prompt = {'Data: ','Spline: ','Ripple: ','\sigma: ','gcv: '};
dlgtitle = 'Output Name';
dims = [1 50];
definput = {'data_trim_','spline_trim_','ripple_trim_','sigma_','gcv_'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
if isempty(answer)
    return
end

assignin('base', answer{1}, obj.data);
assignin('base', answer{2}, spline);
assignin('base', answer{3}, ripple);
assignin('base', answer{4}, obj.sigma);
assignin('base', answer{5}, obj.gcv);
assignin('base', 'out_indx', out_indx);
end