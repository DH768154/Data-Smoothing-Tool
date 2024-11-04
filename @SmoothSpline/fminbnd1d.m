function [x,varargout] = fminbnd1d(func,bound,varargin)

%% Input
if nargin >= 3
    tau = varargin{1};
else
    tau = 0;
end
tau = max([tau,(2.22e-16)^0.5]);

if nargin == 4
    maxloop = varargin{2};
else
    maxloop = 1000;
end

%% Output
if nargout >= 2
    x_iter = NaN(maxloop,1);
end
if nargout == 3
    y_iter = NaN(maxloop,1);
end

%% Initialize
r = 2/(3+sqrt(5)); % Golden Ratio
count = 0; 
m1 = bound(1) + (bound(2)-bound(1))*r;
m2 = bound(1) + bound(2) - m1;

%%
while bound(2)-bound(1)>tau && count<maxloop
    count = count+1;

    fm1 = func(m1);
    fm2 = func(m2);

    if fm2 > fm1
        bound(2) = m2;
        m2 = m1;
        m1 = bound(1) + (bound(2)-bound(1))*r;
    else
        bound(1) = m1;
        m1 = m2;
        m2 = bound(1) + bound(2) - m1;
    end

    %% Optional Output for debug
    if nargout >= 2
        x_iter(count)=mean(bound);
    end
    if nargout == 3
        y_iter(count) = func(x_iter(count));
    end
end

%% Output
x = mean(bound);

%% Optional Output for debug
if nargout >= 2
varargout{1} = x_iter(1:count);
end
if nargout == 3
varargout{2} = y_iter(1:count);
end
end