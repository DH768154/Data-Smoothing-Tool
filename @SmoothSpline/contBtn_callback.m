function contBtn_callback(obj,~,~)
if obj.contBtn.Value == 1
    obj.el = addlistener(obj.slider,'ContinuousValueChange',...
        @(obj,~)slider_callback(obj));
else
    delete(obj.el);
end
end