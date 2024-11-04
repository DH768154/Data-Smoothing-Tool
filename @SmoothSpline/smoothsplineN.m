function [gcv,s] = smoothsplineN(y,sigma)
% no array for gcv

if numel(y) == size(y,2)
    y = y';
end

if any(isnan(y))
    gcv = NaN;
    s = NaN(size(y));
    warning('NaN  in the Data')
    return
end
%%

r = 4*sigma^4/(1-sigma^2); % sigma to lambda
N = length(y);

%% Condition Number

if r ~= 0
    [lessdigit,cond_est] = DecreaseDigit(N,r);

    if 16-lessdigit < 5
        warning(['\n\nCondition Number : %.3e\n',...
            'Decrease Correct Digits: %.0f\n',...
            '\nResults Inaccurate !\n '],cond_est,lessdigit)
    end
end

%% Lambda == 0, Use Linear Regression

% If Lambda is too small, 1/fi will be equal to zero in Matlab
% lambda + Some Number == 0 will output ture.
% This will be handled in the loop, not here

if r == 0
    s = kxpb(y);
    warning('Lambda == 0, Using Linear Regression')
    gcv = 1/N*(y-s)'*(y-s)/1;
    return
end

%% HW2 Loop 1: 1 to N Slove e,f,w

[e,invf,w,flag] = get_efw(N,r,y);

if ~flag
    s = kxpb(y); % Just use Linear Regression
    den = 1;
    warning('f(i) = Inf, Using Linear Regression')
else
    % HW2 Loop 2: N to 1
    s = NaN(N,1);
    s(N) = w(N);
    s(N-1) = w(N-1) - e(N-1)*s(N);

    for i = N-2:-1:1
        s(i) = w(i) - e(i)*s(i+1) - 1/invf(i)*s(i+2);
    end
end

%% HW3 GCV denom

if flag

    if N>=1000
        den = (1-sigma/(2-sigma^2))^2;

    else

        f = 1./invf;

        g_pre = f(N);
        h = -e(N-1)*g_pre;
        g_aft = f(N-1)-e(N-1)*h;
        traceInvA = (g_pre+g_aft)*2;

        for i = 1:ceil(N/2)-2
            p = -e(N-1-i)*h - f(N-1-i)*g_pre;
            h = -e(N-1-i)*g_aft-f(N-1-i)*h;
            g_pre = g_aft;
            g_aft = f(N-1-i)-e(N-1-i)*h-f(N-1-i)*p;

            traceInvA = traceInvA+2*g_aft;
        end

        traceInvA = traceInvA-g_aft*(mod(N,2)~=0);
        den = (1-1/N*r*traceInvA)^2;
    end
    % debug
    % den_check = (1-1/N*r*trace(smoothA(N,r)\eye(N)))^2;
end

%% GCV

gcv = 1/N*(y-s)'*(y-s)/den;

end

%% Main Function End


%% Find e,f,w
function [e,invf,w,flag] = get_efw(N,r,y)

%% Initialize

invf = NaN(N,1);
e = NaN(N-1,1);
w = NaN(N,1);
flag = true;

%% Loop 1: 1 to N Slove e,f,w

invf(1) = r+1;
e(1) = -2/invf(1);
w(1) = 1/invf(1)*r*y(1);

invf(2) = r+5 - e(1)^2*invf(1);
e(2) = -1/invf(2)*(e(1)+4);
w(2) = 1/invf(2)*(r*y(2)-e(1)*w(1)*invf(1));

for i = 3:N
    c1 = (i == N)*1 + (i == N-1)*5 + (i < N-1)*6;
    c2 = (i == N-1)*2 + (i < N-1)*4;
    invf(i) = r+c1 - e(i-1)^2*invf(i-1) - 1/invf(i-2);

    % input lambda is not 0 but very close to 0
    % curve changes rapidly, but I need it to be continous
    if abs(invf(i)) <= 1e-14
        flag = false;
        return
    end

    if i~=N
        e(i) = -1/invf(i)*(e(i-1)+c2);
    end
    w(i) = 1/invf(i)*(r*y(i)-e(i-1)*w(i-1)*invf(i-1)-w(i-2));
    % Notice, not work if lambda = 0, Since In Matlab, 0 * Inf = NaN
end

end

%% Linear Regression
% Solve k*x + b = y
function s = kxpb(y)

N = length(y);
x = [0:N-1;ones(1,N)]';
kb = x\y;
s = x*kb;
end

%% Decrease Digits
function [lessdigit,cond_est] = DecreaseDigit(N,lambda)
cond_est = 16*sin((2*N-3)./(4*N-2)*pi).^4./lambda+1;
lessdigit = ceil(log10(cond_est));
end