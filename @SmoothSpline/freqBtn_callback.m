function freqBtn_callback(obj,~,~)

if isnan(obj.data)
    return
end

if obj.lambda<=16*(1+sqrt(2))
    fc = 2*asin(((sqrt(2)-1)*obj.lambda)^(1/4)/2)/2/pi;
else
    fc = 0;
end
H = obj.lambda./(obj.lambda+16*sin((0:floor(obj.N/2))*pi/obj.N).^4);
Hfc = obj.lambda./(obj.lambda+16*sin((fc*pi)).^4);
%H = H/max(H);
F = abs(fft(obj.data));
F = F(1:floor(obj.N/2)+1);
F = F/max(F);

x = linspace(0,1,obj.N);
x = x(1:floor(obj.N/2)+1);
fg = figure;
plot(x,F,'LineWidth',1); hold on
plot(x,H,'LineWidth',1); hold on
plot(fc,Hfc,'*r','LineWidth',1); hold on
plot([0,fc,fc],[Hfc,Hfc,0],':k','LineWidth',1); hold on
grid on; xlim([0,0.5]); ylim([0,1])
xlabel('Normalized Frequency','FontWeight','bold');
title(['cut off freq: ',num2str(fc,'%.4f')]);
set(fg,'Units','normalized','Position',[0.2,0.2,0.6,0.6])

if fc<0.001
    obj.freqBox.String = num2str(fc,'%.2e');
else
    obj.freqBox.String = num2str(fc,'%.6f');
end
%     waitfor(f);
%     handles.freqBox.String = '';
end