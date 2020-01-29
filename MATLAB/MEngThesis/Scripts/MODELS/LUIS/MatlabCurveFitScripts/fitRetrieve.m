function fitRetrieve(timevector,data,model,foldername)
tic
destdirectory = foldername;
mkdir(destdirectory);   %create the directory

[wells,measurements] = size(data);
set(0,'DefaultFigureVisible','off')
for a = 1:48
    [params(a,:,:),gof(a,:,:),output(a,:,:),f(a)] = fitmatlab(timevector,data(a,:),1);
    saveas(f(a),[pwd ['/',foldername,'/Well',num2str(a),'.png']]);
end

save([pwd ['/',foldername,'variables']],'params','gof','output')
set(0,'DefaultFigureVisible','on')
toc
end


