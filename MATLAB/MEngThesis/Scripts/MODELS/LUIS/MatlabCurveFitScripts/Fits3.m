function [params,fval,I] = Fits3(timevector,data,foldername)
tic
destdirectory = foldername;
mkdir(destdirectory);   %create the directory

[wells,measurements] = size(data);
set(0,'DefaultFigureVisible','off')
for a = 1:wells
    [params(a).B,fval(a),I(a),f(a,:),B0] = Fits2a(timevector,data(a,:),1);
    saveas(f(a,1),[pwd ['/',foldername,'/Well',num2str(a),'.png']]);
%     saveas(f(a,2),[pwd ['/',foldername,'/Residuals_Well',num2str(a),'.png']]);
end

save([pwd ['/',foldername,'variables']],'params','fval','I','B0')
toc
end

