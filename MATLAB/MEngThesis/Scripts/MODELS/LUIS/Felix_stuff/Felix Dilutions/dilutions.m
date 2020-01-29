%% Calculate dilutions for Felix Robot
tic

%% Ask user for final desired OD

prompt = 'What is your desired final OD?\n';
ODfinal = input(prompt);

%% Open .txt File
fileID = fopen('OD_TEST2.txt'); % change to the name of the working file
C = textscan(fileID,'%s %f','Delimiter',';');
fclose(fileID);

%% Define M9 index to correct ABS600
idx_m9 = [12];
C{1,2} = [C{1,2}] - mean(C{1,2}(idx_m9));

%% Felix adds 50uL of cells to each well
% Calculate the volume of media that Felix has to dispense to obtained OD(final) 

Felix = cell(96,2);
for i = 1:length(C{1,2})
    if C{1,2}(i) < ODfinal % non ideal because this means that the sample won't have the good OD, return error
        
        
        prompt = 'Well';
        ODfinal = input(prompt);
        C{1,3}(i) = 150;
        
    else
        C{1,3}(i) = (50*C{1,2}(i))/0.1; % in uL
    end
    Felix{i,1} = C{1,1}{i};
    Felix{i,2} = C{1,3}(i);
end

% %% Calculate volume of fresh media to add to 100uL of overnight culture
% Felix = cell(96,2);
% for i = 1:length(C{1,2})
%     if C{1,2}(i) < 0.1
%         C{1,3}(i) = 50; % ABS600 too low so take only cells (no new media)
%     else
%         C{1,3}(i) = (50*C{1,2}(i))/0.1; % in uL
%     end
%     Felix{i,1} = C{1,1}{i};
%     Felix{i,2} = C{1,3}(i);
% end


%% Write dilution file for Felix Robot

fileID = fopen('test_dilutions_LUIS.txt','w');
formatSpec = '%s, %f\n';
[nrows,ncols] = size(Felix);
for row = 1:nrows
    fprintf(fileID,formatSpec,Felix{row,:});
end
fclose(fileID);
type test_dilutions_LUIS.txt

toc