function init_gui(obj)
warning off;
%% Figure
obj.f= figure('Units','normalized','Position',[0.1,0.1,0.8,0.8], ...
    'MenuBar','none','ToolBar','none','NumberTitle','off', ...
    'Name','Data Smooth');

%% Axes
obj.ax1 = axes(obj.f,"Units","normalized","Position",[0.06,0.1275,0.91,0.695]);
obj.L0 = plot(NaN,NaN,'LineWidth',0.5); hold on; grid on
obj.L1 = plot(NaN,NaN,'LineWidth',1); hold on; grid on
ylabel('Data','FontWeight','bold')

%% Pannel
datapannel = uipanel('Parent',obj.f,'Units','normalized',...
    'Position',[0.28-0.1,0.85,0.20,0.06]);
parapannel = uipanel('Parent',obj.f,'Units','normalized',...
    'Position',[0.51,0.8357,0.4531,0.073],...
    'Title','parameters','FontUnits','normalized',...
    'FontWeight','bold','FontSize',0.2);
btnpannel = uipanel('Parent',obj.f,'Units','normalized',...
    'Position',[0.81,0.915,0.153,0.07]);
linepannel = uipanel('Parent',obj.f,'Units','normalized',...
    'Position',[0.51,0.9135,0.29,0.073],...
    'Title','linewidth','FontUnits','normalized',...
    'FontWeight','bold','FontSize',0.2);
freqpannel = uipanel('Parent',obj.f,'Units','normalized',...
    'Position',[0.387,0.835,0.1165,0.15],...
    'Title','cutoff freq','FontUnits','normalized',...
    'FontWeight','bold','FontSize',0.1);

%% Var selection
varsname = ['Select';evalin('base', 'who')];

obj.menuBox = uicontrol(datapannel,'Style','popupmenu','Units','normalized',...
    'Position',[0.4,0.16,0.5,0.6],'String',varsname,...
    'FontUnits','normalized','FontSize',0.6);

txt1 = uicontrol(datapannel,"Style",'text','Units','normalized',...
    'Position',[0.1,0.1,0.2,0.6],'FontUnits','normalized',...
    'FontSize',0.6,'HorizontalAlignment','center','FontWeight','bold');
txt1.String = 'Data:';

%% Cutoff

obj.freqBox = uicontrol(freqpannel,"Style","edit",'Units','normalized',...
    'Position',[0.1,0.55,0.8,0.32],'FontUnits','normalized',...
    'FontSize',0.6,'HorizontalAlignment','center','Enable','off');
freqBtn = uicontrol('Parent',freqpannel,'Units','normalized',...
    'FontUnits','normalized','String','Freq View',...
    'Style','pushbutton','Position',[0.1,0.12,0.8,0.32],...
    'BackgroundColor',[0.85,0.85,0.85],'ForegroundColor',[0,0,0],...
    'FontSize',0.55,'FontName','Calibri','FontWeight','bold',...
    'HorizontalAlignment','center');


%% Sigma, Lambda, GCV

sigmatxt = copyobj(txt1,parapannel);
sigmatxt.String = 'sigma:';
sigmatxt.Position = [0.03,0.1,0.1,0.6];

obj.sigmaBox = uicontrol(parapannel,"Style","edit",'Units','normalized',...
    'Position',[0.14,0.16,0.18,0.6],'FontUnits','normalized',...
    'FontSize',0.6,'HorizontalAlignment','center');

lambdatxt = copyobj(sigmatxt,parapannel);
lambdatxt.String = 'lambda:';
lambdatxt.Position = [0.35,0.1,0.12,0.6];

obj.lambdaBox = copyobj(obj.sigmaBox,parapannel);
obj.lambdaBox.Position = [0.48,0.16,0.18,0.6];

obj.sigma = 0.5;
obj.lambda = obj.sigma2lambda(obj.sigma);
obj.sigmaBox.String = '0.5';
obj.lambdaBox.String = num2str(obj.lambda,'%.2e');

gcvtxt = copyobj(sigmatxt,parapannel);
gcvtxt.String = 'GCV:';
gcvtxt.Position = [0.68,0.1,0.12,0.6];

obj.gcvBox = copyobj(obj.sigmaBox,parapannel);
obj.gcvBox.Position = [0.8,0.16,0.16,0.6];
obj.gcvBox.Enable = "inactive";

%% line width

l0txt = copyobj(sigmatxt,linepannel);
l0txt.String = 'original:';
l0txt.Position = [0.033,0.1,0.2,0.6];

obj.l0Box = copyobj(obj.sigmaBox,linepannel);
obj.l0Box.Position = [0.2765,0.16,0.17,0.6];
obj.l0Box.String = '0.5';

l1txt = copyobj(sigmatxt,linepannel);
l1txt.String = 'Spline:';
l1txt.Position = [0.5315,0.1,0.2,0.6];

obj.l1Box = copyobj(obj.sigmaBox,linepannel);
obj.l1Box.Position = [0.759,0.16,0.17,0.6];
obj.l1Box.String = '1';

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

obj.slider = uicontrol('Parent',obj.f,'Units','normalized',...
    'FontUnits','normalized','Style','slider',...
    'Position',[0.05/2,0.0187,0.887,0.045],...
    'SliderStep',[0.001,0.01],'Min',0);

obj.powerBox = uicontrol(obj.f,"Style","edit",'Units','normalized',...
    'Position',[0.924,0.0188,0.05,0.043],'FontUnits','normalized',...
    'FontSize',0.5,'HorizontalAlignment','center');
p = 5;
obj.powerBox.String = num2str(p,'%d');
obj.slider.Value = 0.5^(1/p);
obj.slider.Max = (1-(1e-8))^(1/p);

%% Resize
pos1 = [0.92,0.792,0.049,0.0272];
resizeBtn = uicontrol('Parent',obj.f,'Units','normalized',...
    'FontUnits','normalized','String','Resize',...
    'Style','pushbutton','Position',pos1,...
    'BackgroundColor',[1,1,1],'ForegroundColor',[0,0,0],...
    'FontSize',0.7,'FontName','Calibri','FontWeight','bold',...
    'HorizontalAlignment','center');

pos2 = [pos1(1)-pos1(3)-0.001,pos1(2),pos1(3),pos1(4)];
yonBtn = copyobj(resizeBtn,obj.f);
yonBtn.Position = pos2;
yonBtn.String = 'zoom-y';

pos3 = [pos2(1)-pos2(3)-0.001,pos2(2),pos2(3),pos2(4)];
xonBtn = copyobj(resizeBtn,obj.f);
xonBtn.Position = pos3;
xonBtn.String = 'zoom-x';

pos4 = [pos3(1)-pos3(3)-0.001,pos3(2),pos3(3),pos3(4)];
zonBtn = copyobj(resizeBtn,obj.f);
zonBtn.Position = pos4;
zonBtn.String = 'zoom';

pos5 = [pos4(1)-pos4(3)-0.001,pos4(2),pos4(3),pos4(4)];
panBtn = copyobj(resizeBtn,obj.f);
panBtn.Position = pos5;
panBtn.String = 'pan';

pos6 = [pos5(1)-pos5(3)-0.001,pos5(2),pos5(3),pos5(4)];
homeBtn = copyobj(resizeBtn,obj.f);
homeBtn.Position = pos6;
homeBtn.String = 'home';


rangeBtn = copyobj(resizeBtn,obj.f);
rangeBtn.Position = [0.45,0.79,0.1,0.03];
rangeBtn.String = 'Select Range';
%%
titletxt = uicontrol(obj.f,"Style",'text','Units','normalized',...
    'Position',[0.0407,0.867,0.1313,0.083],'FontUnits','normalized',...
    'FontSize',0.4,'HorizontalAlignment','center','FontWeight','bold',...
    'String',{'Data','Smoothing'});

titletxt2 = copyobj(titletxt,obj.f);
titletxt2.String = 'Select Data:';
titletxt2.FontSize = 0.6;
titletxt2.Position = [0.287-0.1,0.919,0.0873,0.039];
%%

refreshBtn = uicontrol('Parent',obj.f,'Units','normalized',...
    'FontUnits','normalized','String','Refresh',...
    'Style','pushbutton','Position',[0.394-0.1,0.925,0.0857,0.0327],...
    'BackgroundColor',[0.85,0.85,0.85],'ForegroundColor',[0,0,0],...
    'FontSize',0.55,'FontName','Calibri','FontWeight','bold',...
    'HorizontalAlignment','center');

%%
obj.contBtn = uicontrol('Parent',obj.f,'Units','normalized',...
    'FontUnits','normalized','String','Continous Change',...
    'Style','radiobutton','FontSize',0.85,'FontWeight','normal',...
    'Position',[0.025,0.07,0.12,0.02],'Value',1);

%% Assign Callback
set(obj.f,'ButtonDownFcn',@obj.refresh)
set(obj.f,'CloseRequestFcn',@obj.closefig)

set(obj.menuBox,'callback',@obj.menoBox_callback);
set(obj.lambdaBox,'callback',@obj.lambdaBox_callback);
set(obj.sigmaBox,'callback',@obj.sigmaBox_callback);
set(obj.powerBox,'callback',@obj.powerBox_callback);
set(obj.l0Box,'callback',@obj.l0Box_callback);
set(obj.l1Box,'callback',@obj.l1Box_callback);

set(exportBtn,'callback',@obj.exportBtn_callback);
set(refreshBtn,'callback',@obj.refresh);
set(autoBtn,'callback',@obj.autosmooth)
set(resizeBtn,'callback',@obj.autozoom)
set(xonBtn,'callback',@obj.zoomx)
set(yonBtn,'callback',@obj.zoomy)
set(zonBtn,'callback',@obj.zoomany)
set(panBtn,'callback',@obj.panon)
set(homeBtn,'callback',@obj.home)
set(titletxt,'ButtonDownFcn',@obj.mywarning)

set(obj.slider,'Callback',@obj.slider_callback)
set(obj.contBtn,'Callback',@obj.contBtn_callback)
set(freqBtn,'Callback',@obj.freqBtn_callback)
set(rangeBtn,'Callback',@obj.selectrange)


%%

obj.el = addlistener(obj.slider,'ContinuousValueChange',...
    @(src,~)obj.slider_callback());


end