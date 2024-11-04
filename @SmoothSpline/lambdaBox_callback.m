function lambdaBox_callback(obj,~,~)

lambdastr = obj.lambdaBox.String;
obj.lambda = eval(lambdastr);
obj.sigma = obj.lambda2sigma(obj.lambda);

if obj.sigma<0.001
    obj.sigmaBox.String = num2str(obj.sigma,'%.2e');
else
    obj.sigmaBox.String = num2str(obj.sigma,'%.6f');
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

obj.smoothnupdate;

end