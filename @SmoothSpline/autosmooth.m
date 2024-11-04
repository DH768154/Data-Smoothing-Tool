function autosmooth(obj,~,~)

if all(isnan(obj.data))
    return
end

fun = @(x) obj.smoothsplineN(obj.data,x);

%% Do not need Toolbox
sigma_min = obj.sigmalimit(length(obj.data),13);
obj.sigma = obj.fminbnd1d(fun,[sigma_min,0.99]);

%%
% Update Sigma and Lambda
if obj.sigma<0.001
    obj.sigmaBox.String = num2str(obj.sigma,'%.2e');
else
    obj.sigmaBox.String = num2str(obj.sigma,'%.6f');
end
obj.lambda = obj.sigma2lambda(obj.sigma);
if obj.lambda<0.001
    obj.lambdaBox.String = num2str(obj.lambda,'%.2e');
else
    obj.lambdaBox.String = num2str(obj.lambda,'%.6f');
end

if obj.lambda<=16*(1+sqrt(2))
    fc = 2*asin(((sqrt(2)-1)*obj.lambda)^(1/4)/2)/2/pi;
else
    fc = 0;
end
if fc<0.001
    obj.freqBox.String = num2str(fc,'%.2e');
else
    obj.freqBox.String = num2str(fc,'%.6f');
end

obj.slider.Value = obj.sigma^(1/obj.p);
smoothnupdate(obj)


end