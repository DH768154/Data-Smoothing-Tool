function sigmaBox_callback(obj,~,~)

sigmastr = obj.sigmaBox.String;
obj.sigma = eval(sigmastr);

obj.lambda = obj.sigma2lambda(obj.sigma);
if obj.lambda<0.001
    obj.lambdaBox.String = num2str(obj.lambda,'%.2e');
else
    obj.lambdaBox.String = num2str(obj.lambda,'%.6f');
end

if obj.lambda <= 16*(1+sqrt(2))
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


obj.smoothnupdate;
end