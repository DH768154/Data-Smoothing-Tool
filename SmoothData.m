function SmoothData()
% v1.0 | 03-01-2024
% v1.1 | refresh variable in workspace
% v1.2 | add auto calculation using fmincon, require toolbox
% v1.3 | slider listener on/off
% v1.4 | export result to work space
% v1.5 | change linewidth
% v1.6 | only calculate data in current xlim range
% v1.7 | add resize/home/zoomx/zoomy...
% v1.8 | new function to do auto calculation, do not require toolbox
% v1.9 | output selected indx and ripple
%
warning off;
%% Figure
f= figure('Units','normalized','Position',[0.1,0.1,0.8,0.8], ...
    'MenuBar','none','ToolBar','none','NumberTitle','off', ...
    'Name','Data Smooth','CloseRequestFcn',@closefig);

%% Axes
ax1 = axes(f,"Units","normalized","Position",[0.06,0.1275,0.91,0.695]);
L0 = plot(NaN,NaN,'LineWidth',0.5); hold on; grid on
L1 = plot(NaN,NaN,'LineWidth',1); hold on; grid on
ylabel('Data','FontWeight','bold')

%% Pannel
datapannel = uipanel('Parent',f,'Units','normalized',...
    'Position',[0.28,0.85,0.20,0.06]);
parapannel = uipanel('Parent',f,'Units','normalized',...
    'Position',[0.51,0.8357,0.4531,0.073],...
    'Title','parameters','FontUnits','normalized',...
    'FontWeight','bold','FontSize',0.2);
btnpannel = uipanel('Parent',f,'Units','normalized',...
    'Position',[0.81,0.915,0.153,0.07]);
linepannel = uipanel('Parent',f,'Units','normalized',...
    'Position',[0.51,0.9135,0.29,0.073],...
    'Title','linewidth','FontUnits','normalized',...
    'FontWeight','bold','FontSize',0.2);

%% Var selection
varsname = ['Select';evalin('base', 'who')];

menuBox = uicontrol(datapannel,'Style','popupmenu','Units','normalized',...
    'Position',[0.4,0.16,0.5,0.6],'String',varsname,...
    'FontUnits','normalized','FontSize',0.6);

txt1 = uicontrol(datapannel,"Style",'text','Units','normalized',...
    'Position',[0.1,0.1,0.2,0.6],'FontUnits','normalized',...
    'FontSize',0.6,'HorizontalAlignment','center','FontWeight','bold');
txt1.String = 'Data:';

%% Sigma, Lambda, GCV

sigmatxt = copyobj(txt1,parapannel);
sigmatxt.String = 'sigma:';
sigmatxt.Position = [0.03,0.1,0.1,0.6];

sigmaBox = uicontrol(parapannel,"Style","edit",'Units','normalized',...
    'Position',[0.14,0.16,0.18,0.6],'FontUnits','normalized',...
    'FontSize',0.6,'HorizontalAlignment','center');

lambdatxt = copyobj(sigmatxt,parapannel);
lambdatxt.String = 'lambda:';
lambdatxt.Position = [0.35,0.1,0.12,0.6];

lambdaBox = copyobj(sigmaBox,parapannel);
lambdaBox.Position = [0.48,0.16,0.18,0.6];

sigma = 0.5;
lambda = sigma2lambda(sigma);
sigmaBox.String = '0.5';
lambdaBox.String = num2str(lambda,'%.2e');

gcvtxt = copyobj(sigmatxt,parapannel);
gcvtxt.String = 'GCV:';
gcvtxt.Position = [0.68,0.1,0.12,0.6];

gcvBox = copyobj(sigmaBox,parapannel);
gcvBox.Position = [0.8,0.16,0.16,0.6];
gcvBox.Enable = "inactive";

%% line width

l0txt = copyobj(sigmatxt,linepannel);
l0txt.String = 'original:';
l0txt.Position = [0.033,0.1,0.2,0.6];

l0Box = copyobj(sigmaBox,linepannel);
l0Box.Position = [0.2765,0.16,0.17,0.6];
l0Box.String = '0.5';

l1txt = copyobj(sigmatxt,linepannel);
l1txt.String = 'Spline:';
l1txt.Position = [0.5315,0.1,0.2,0.6];

l1Box = copyobj(sigmaBox,linepannel);
l1Box.Position = [0.759,0.16,0.17,0.6];
l1Box.String = '1';

%% Auto Smooth Btn
autoBtn = uicontrol('Parent',btnpannel,'Units','normalized',...
    'FontUnits','normalized','String','Auto',...
    'Style','pushbutton','Position',[0.055,0.15,0.32,0.7],...
    'BackgroundColor',[0.85,0.85,0.85],'ForegroundColor',[0,0,0],...
    'FontSize',0.55,'FontName','Calibri','FontWeight','bold',...
    'HorizontalAlignment','center');

%% export to work space Btn
exportBtn = copyobj(autoBtn,btnpannel);
exportBtn.Position = [0.44,0.15,0.5,0.7];
exportBtn.String = 'Export';

%% Slider

slider = uicontrol('Parent',f,'Units','normalized',...
    'FontUnits','normalized','Style','slider',...
    'Position',[0.05/2,0.0187,0.887,0.045],...
    'SliderStep',[0.001,0.01],'Min',0);

powerBox = uicontrol(f,"Style","edit",'Units','normalized',...
    'Position',[0.924,0.0188,0.05,0.043],'FontUnits','normalized',...
    'FontSize',0.5,'HorizontalAlignment','center');
p = 5;
powerBox.String = num2str(p,'%d');
slider.Value = 0.5^(1/p);
slider.Max = (1-(1e-8))^(1/p);

%% Resize
pos1 = [0.92,0.792,0.049,0.0272];
resizeBtn = uicontrol('Parent',f,'Units','normalized',...
    'FontUnits','normalized','String','Resize',...
    'Style','pushbutton','Position',pos1,...
    'BackgroundColor',[1,1,1],'ForegroundColor',[0,0,0],...
    'FontSize',0.7,'FontName','Calibri','FontWeight','bold',...
    'HorizontalAlignment','center');

pos2 = [pos1(1)-pos1(3)-0.001,pos1(2),pos1(3),pos1(4)];
yonBtn = copyobj(resizeBtn,f);
yonBtn.Position = pos2;
yonBtn.String = 'zoom-y';

pos3 = [pos2(1)-pos2(3)-0.001,pos2(2),pos2(3),pos2(4)];
xonBtn = copyobj(resizeBtn,f);
xonBtn.Position = pos3;
xonBtn.String = 'zoom-x';

pos4 = [pos3(1)-pos3(3)-0.001,pos3(2),pos3(3),pos3(4)];
zonBtn = copyobj(resizeBtn,f);
zonBtn.Position = pos4;
zonBtn.String = 'zoom';

pos5 = [pos4(1)-pos4(3)-0.001,pos4(2),pos4(3),pos4(4)];
panBtn = copyobj(resizeBtn,f);
panBtn.Position = pos5;
panBtn.String = 'pan';

pos6 = [pos5(1)-pos5(3)-0.001,pos5(2),pos5(3),pos5(4)];
homeBtn = copyobj(resizeBtn,f);
homeBtn.Position = pos6;
homeBtn.String = 'home';

%%
titletxt = uicontrol(f,"Style",'text','Units','normalized',...
    'Position',[0.057,0.85,0.17,0.117],'FontUnits','normalized',...
    'FontSize',0.4,'HorizontalAlignment','center','FontWeight','bold',...
    'String',{'Data','Smoothing'});

titletxt2 = copyobj(titletxt,f);
titletxt2.String = 'Select Data:';
titletxt2.FontSize = 0.6;
titletxt2.Position = [0.287,0.919,0.0873,0.039];
%%

refreshBtn = uicontrol('Parent',f,'Units','normalized',...
    'FontUnits','normalized','String','Refresh',...
    'Style','pushbutton','Position',[0.394,0.925,0.0857,0.0327],...
    'BackgroundColor',[0.85,0.85,0.85],'ForegroundColor',[0,0,0],...
    'FontSize',0.55,'FontName','Calibri','FontWeight','bold',...
    'HorizontalAlignment','center');

%%
contBtn = uicontrol('Parent',f,'Units','normalized',...
    'FontUnits','normalized','String','Continous Change',...
    'Style','radiobutton','FontSize',0.85,'FontWeight','normal',...
    'Position',[0.025,0.07,0.12,0.02],'Value',1);

%% Assign Callback
set(f,'ButtonDownFcn',@refresh)

set(menuBox,'callback',@menoBox_callback);
set(lambdaBox,'callback',@lambdaBox_callback);
set(sigmaBox,'callback',@sigmaBox_callback);
set(exportBtn,'callback',@exportBtn_callback);
set(powerBox,'callback',@powerBox_callback);
set(refreshBtn,'callback',@refresh);
set(l0Box,'callback',@l0Box_callback);
set(l1Box,'callback',@l1Box_callback);
set(autoBtn,'callback',@autosmooth)
set(resizeBtn,'callback',@autozoom)
set(xonBtn,'callback',@zoomx)
set(yonBtn,'callback',@zoomy)
set(zonBtn,'callback',@zoomany)
set(panBtn,'callback',@panon)
set(homeBtn,'callback',@home)
set(titletxt,'ButtonDownFcn',@mywarning)
set(slider,'Callback',@slider_callback)
set(contBtn,'Callback',@contBtn_callback)

%%  GUI Data
handles.f = f;
handles.ax1 = ax1;
handles.L0 = L0;
handles.L1 = L1;
handles.l0Box = l0Box;
handles. l1Box= l1Box;
handles.data = NaN;
handles.data0 = NaN;
% handles.spline = NaN;
handles.sigma = sigma;
handles.lambda = lambda;
handles.gcv = NaN;
handles.menuBox = menuBox;
handles.sigmaBox = sigmaBox;
handles.lambdaBox = lambdaBox;
handles.gcvBox = gcvBox;
handles.slider = slider;
% handles. = ;
handles.p = p;
handles.powerBox = powerBox;
handles.contBtn = contBtn;

handles.el = addlistener(handles.slider,'ContinuousValueChange',...
    @(obj,~)slider_callback(f));

guidata(f,handles);
%addlistener(ax1, 'XLim', 'PostSet', @(obj,~)getxrange(f));
end
%%
function contBtn_callback(hobj,~)
handles = guidata(hobj);
if handles.contBtn.Value == 1
    handles.el = addlistener(handles.slider,'ContinuousValueChange',...
        @(obj,~)slider_callback(hobj));
else
    delete(handles.el);
end
guidata(hobj,handles);
end

%%
function slider_callback(hobj,~)
handles = guidata(hobj);
sigma = handles.slider.Value^handles.p;

if sigma<0.001
    handles.sigmaBox.String = num2str(sigma,'%.2e');
else
    handles.sigmaBox.String = num2str(sigma,'%.6f');
end

lambda = sigma2lambda(sigma);

if lambda<0.001
    handles.lambdaBox.String = num2str(lambda,'%.2e');
else
    handles.lambdaBox.String = num2str(lambda,'%.6f');
end

handles.lambda = lambda;
handles.sigma = sigma;
guidata(hobj,handles)

smoothnupdate(hobj);
end

%%
function closefig(hObject,~)
answer = questdlg('Close GUI ?','My Title',...
    'Close', ...
    'Cancel', ...
    'Close');
switch answer
    case 'Close'
        warning on
        delete(hObject);
end
end

%% Select Data
function menoBox_callback(hobj,~)
handles = guidata(hobj);
%varsname = handles.varsname;
varind = handles.menuBox.Value;
dataname = handles.menuBox.String{varind};
cvar = evalin('base', 'who');
if ~ismember(dataname,cvar)
    return
end
data0 = evalin('base', dataname);

[r,c] = size(data0);
if r == 2 && (c*2) == numel(data0)
    data0 = data0(2,:)';
elseif c == 2 && (r*2) == numel(data0)
    data0 = data0(:,2);    
elseif numel(data0) == r || numel(data0) == c
    data0 = reshape(data0,[],1);
end

% 
% if numel(data0) == size(data0,2)
%     data0 = data0';
% end

handles.dataname = dataname;
handles.data0 = data0;
guidata(hobj,handles)

updataL0(handles);
smoothnupdate(hobj)
end
%% 
function refresh(hobj,~)
handles = guidata(hobj);
varsname = ['Select';evalin('base', 'who')];
handles.menuBox.String = varsname;

end
%% Update Original Data
function updataL0(handles)

data0 = handles.data0;
axes(handles.ax1)
handles.L0.XData = 1:length(data0);
handles.L0.YData = data0;

limy = [min(data0),max(data0)];
dy = limy(2)-limy(1);
if ~isnan(dy)
axes(handles.ax1)
ylim([-1,1]*dy*0.05+limy)
xlim([1,length(data0)])
drawnow;
ylim('manual')
end
end

%% Update Filted data
function smoothnupdate(hobj,~)
handles = guidata(hobj);

sigma = handles.sigma;
data0 = handles.data0;


axes(handles.ax1)
limx = xlim;
xrange = ceil(limx(1)):floor(limx(2));
xrange = max([1,xrange(1)]):min([length(data0),xrange(end)]);
if ~isnan(data0)
    data = data0(xrange);
else
    axes(handles.ax1)
    handles.L1.XData = nan;
    handles.L1.YData = nan;
    return
end


[gcv,spline] = smoothsplineN(data,sigma);
handles.gcvBox.String = num2str(gcv,'%.4e');

axes(handles.ax1)
handles.L1.XData = xrange;
handles.L1.YData = spline;
drawnow;

% handles.spline = spline; % Not nesseary to save
handles.gcv = gcv;
guidata(hobj,handles)
end

%% Update Filted data
function autosmooth(hobj,~)
handles = guidata(hobj);
data0 = handles.data0;

axes(handles.ax1)
limx = xlim;
xrange = ceil(limx(1)):floor(limx(2));
xrange = max([1,xrange(1)]):min([length(data0),xrange(end)]);
if ~isnan(data0)
    data = data0(xrange);
end

fun = @(x) smoothsplineN(data,x);
%% Need Toolbox
% options = optimoptions('fminunc','Algorithm','quasi-newton',...
%     'Display','none');
% 
% % Initial Guess
% sigma0 = 0.5;
% 
% % fmincon Function
% [sigma_c, ~] = fmincon(fun, sigma0, ...
%     [], [], [], [], 0, 0.99, [], options);
%% Do not need Toolbox
sigma_min = sigmalimit(length(data),13);
sigma = fminbnd1d(fun,[sigma_min,0.99]);

%%
%%
% Update Sigma and Lambda
if sigma<0.001
    handles.sigmaBox.String = num2str(sigma,'%.2e');
else
    handles.sigmaBox.String = num2str(sigma,'%.6f');
end
lambda = sigma2lambda(sigma);
if lambda<0.001
    handles.lambdaBox.String = num2str(lambda,'%.2e');
else
    handles.lambdaBox.String = num2str(lambda,'%.6f');
end

% value to handles
handles.slider.Value = sigma^(1/handles.p);
handles.lambda = lambda;
handles.sigma = sigma;
guidata(hobj,handles)

smoothnupdate(hobj)


end
%%
function l0Box_callback(hobj,~)
handles = guidata(hobj);
l0width = eval(handles.l0Box.String);
axes(handles.ax1)
handles.L0.LineWidth = l0width;
end

function l1Box_callback(hobj,~)
handles = guidata(hobj);
l1width = eval(handles.l1Box.String);
axes(handles.ax1)
handles.L1.LineWidth = l1width;
end

%% Sigma to Lambda, Lambda to Sigma
function lambdaBox_callback(hobj,~)
handles = guidata(hobj);
lambdastr = handles.lambdaBox.String;
lambda = eval(lambdastr);
sigma = lambda2sigma(lambda);

if sigma<0.001
    handles.sigmaBox.String = num2str(sigma,'%.2e');
else
    handles.sigmaBox.String = num2str(sigma,'%.6f');
end

handles.slider.Value = sigma^(1/handles.p);

handles.lambda = lambda;
handles.sigma = sigma;
guidata(hobj,handles)

smoothnupdate(hobj);

end
%%
function sigmaBox_callback(hobj,~)
handles = guidata(hobj);
sigmastr = handles.sigmaBox.String;
sigma = eval(sigmastr);

lambda = sigma2lambda(sigma);
if lambda<0.001
    handles.lambdaBox.String = num2str(lambda,'%.2e');
else
    handles.lambdaBox.String = num2str(lambda,'%.6f');
end

handles.slider.Value = sigma^(1/handles.p);

handles.lambda = lambda;
handles.sigma = sigma;
guidata(hobj,handles)

smoothnupdate(hobj);
end

%% 
function powerBox_callback(hobj,~)
handles = guidata(hobj);
p = eval(handles.powerBox.String);

sigma = handles.sigma;
handles.slider.Value = sigma^(1/p);
handles.slider.Max = (1-(1e-8))^(1/p);
handles.p = p;
guidata(hobj,handles)

end

%%
function exportBtn_callback(hobj,~)
handles = guidata(hobj);
sigma = handles.sigma;
data0 = handles.data0;

axes(handles.ax1)
limx = xlim;
out_indx = [ceil(limx(1)),floor(limx(2))];
%xrange = ceil(limx(1)):floor(limx(2));
xrange = max([1,out_indx(1)]):min([length(data0),out_indx(2)]);
if ~isnan(data0)
    data = data0(xrange);
end

[~,spline] = smoothsplineN(data,sigma);
ripple = data - spline;

prompt = {'Data: ','Spline: ','Ripple: ','\sigma: ','gcv: '};
dlgtitle = 'Output Name';
dims = [1 20];
definput = {'data_trim_','spline_trim_','ripple_trim_','sigma_','gcv_'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
if isempty(answer)
    return
end

assignin('base', answer{1}, data);
assignin('base', answer{2}, spline);
assignin('base', answer{3}, ripple);
assignin('base', answer{4}, sigma);
assignin('base', answer{5}, handles.gcv);
assignin('base', 'out_indx', out_indx);
end

%%
function autozoom(hobj,~)
handles = guidata(hobj);

data0 = handles.data0;
axes(handles.ax1)
limx = xlim;
xrange = ceil(limx(1)):floor(limx(2));
xrange = max([1,xrange(1)]):min([length(data0),xrange(end)]);
if ~isnan(data0)
    data = data0(xrange);
end

xdata = handles.L1.XData';
spline = handles.L1.YData(xdata>=xrange(1)&xdata<=xrange(2))';

limy = [min([data;spline]),max([data;spline])];
dy = limy(2)-limy(1);
if ~isnan(dy)
    axes(handles.ax1)
    ylim([-1,1]*dy*0.05+limy)
    xlim([xrange(1),xrange(end)])
end
end

function zoomx(hobj,~)
handles=guidata(hobj);axes(handles.ax1); zoom xon; end
function zoomy(hobj,~)
handles=guidata(hobj);axes(handles.ax1); zoom yon; end
function zoomany(hobj,~)
handles=guidata(hobj);axes(handles.ax1); zoom on; end
function panon(hobj,~)
handles=guidata(hobj);axes(handles.ax1); pan on; end

%%
function home(hobj,~)
handles = guidata(hobj);

data0 = handles.data0;
spline = handles.L1.YData';

limy = [min([data0;spline]),max([data0;spline])];
dy = limy(2)-limy(1);
if ~isnan(dy)
    axes(handles.ax1)
    ylim([-1,1]*dy*0.05+limy)
    xlim([1,length(data0)])
end
end

%%
function sigma = lambda2sigma(lambda)
sigma = sqrt(2./(1+sqrt(1+16./lambda)));
end

function lambda = sigma2lambda(sigma)
lambda = 4*sigma.^4./(1-sigma.^2);
end
%% 
function mywarning(~,~)
h = lwl;
waitfor(h);
msgbox(char([19968,20010,20581,24247,...
    30340,31038,20250,19981,24212,35813,21482,26377,19968,31181,22768,...
    38899]),'Error 404','error')
end
%%
function sigma_min = sigmalimit(N,lessdigit)
expectlambda = 16/10^lessdigit*sin((2*N-3)/(4*N-2)*pi)^4;
sigma_min = sqrt(2/(1+sqrt(1+16/expectlambda)));
end