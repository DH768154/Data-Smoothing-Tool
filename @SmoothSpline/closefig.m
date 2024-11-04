function closefig(obj,~,~)
answer = questdlg('Close GUI ?','closefunc',...
    'Close', ...
    'Cancel', ...
    'Close');
switch answer
    case 'Close'
        warning on
        delete(obj.f);
end
end