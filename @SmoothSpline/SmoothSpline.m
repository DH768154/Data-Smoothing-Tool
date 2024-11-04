classdef SmoothSpline < handle
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
% v1.91| Add select range, frequency response | 11-02-2024
% v2.0 | Rewrite everything using Class | 11-03-2024
% using class, no need for handles = guidata(hobj) and guidata(hobj,handles);

    properties(SetAccess = private)
        data = NaN;
        xdata = NaN;
        data0 = NaN;
        N = NaN;
        sigma;
        lambda;
        gcv = NaN;
        p = 5; % Slider Power
    end

    properties(Access = private)
        f; % GUI Figure
        ax1; % axes
        L0; % Raw Data Line
        L1; % Spline
        l0Box; % Raw Data Line Width
        l1Box; % Spline Line Width

        menuBox; % Select Data Box
        sigmaBox;
        lambdaBox;
        gcvBox;
        slider;

        powerBox;
        contBtn;
        freqBox;
        el; % slider addlistener
    end

    %%
    methods
        function obj = SmoothSpline()
            warning off;
            obj.init_gui;
        end
    end

    %%
    methods (Access = private)
        selectrange(obj,~,~); % select calculation range
        freqBtn_callback(obj,~,~); % plot frequency response
        contBtn_callback(obj,~,~); % slider using continue change or not
        slider_callback(obj,~,~); % update all result with slider move
        closefig(obj,~,~); % close gui
        menuBox_callback(obj,~,~); % select data from workspace
        refresh(obj,~,~); % refresh data from workspace
        updataL0(obj,~,~); % update raw data in axes
        smoothnupdate(obj,~,~); % updata smoothing result
        autosmooth(obj,~,~); % auto smoothing using gcv score
        lambdaBox_callback(obj,~,~); % calculate cutoff freq and sigma using lambda
        sigmaBox_callback(obj,~,~); % calculate cutoff freq and lambda using sigma
        exportBtn_callback(obj,~,~); % export data to workspace
        autozoom(obj,~,~); % auto zoom data
        home(obj,~,~); % original zoom data

        % Change linewidth for original data
        function l0Box_callback(obj,~,~)
            l0width = eval(obj.l0Box.String);
            axes(obj.ax1)
            obj.L0.LineWidth = l0width;
        end

        % Change linewidth for smoothing data
        function l1Box_callback(obj,~,~)
            l1width = eval(obj.l1Box.String);
            axes(obj.ax1)
            obj.L1.LineWidth = l1width;
        end

        % Change slider scale
        function powerBox_callback(obj,~,~)
            obj.p = eval(obj.powerBox.String);
            obj.slider.Value = obj.sigma^(1/obj.p);
            obj.slider.Max = (1-(1e-8))^(1/obj.p);
        end

        function zoomx(obj,~,~)
            axes(obj.ax1); zoom xon; end
        function zoomy(obj,~,~)
            axes(obj.ax1); zoom yon; end
        function zoomany(obj,~,~)
            axes(obj.ax1); zoom on; end
        function panon(obj,~,~)
            axes(obj.ax1); pan on; end

    end
    %%
    methods (Static,Access = private)
        [gcv,s] = smoothsplineN(y,sigma); % Core Smoothing Function
        [x,varargout] = fminbnd1d(func,bound,varargin); % fminbnd without toolbox

        % lambda to sigma
        function sigma = lambda2sigma(lambda)
            sigma = sqrt(2./(1+sqrt(1+16./lambda)));
        end

        % sigma to lambda
        function lambda = sigma2lambda(sigma)
            lambda = 4*sigma.^4./(1-sigma.^2);
        end

        % calculate min allowable sigma
        function sigma_min = sigmalimit(N,lessdigit)
            expectlambda = 16/10^lessdigit*sin((2*N-3)/(4*N-2)*pi)^4;
            sigma_min = sqrt(2/(1+sqrt(1+16/expectlambda)));
        end

        function mywarning(~,~)
            h = lwl;
            waitfor(h);
            msgbox(char([19968,20010,20581,24247,...
                30340,31038,20250,19981,24212,35813,21482,26377,19968,31181,22768,...
                38899]),'Error 404','error')
        end
    end
end

