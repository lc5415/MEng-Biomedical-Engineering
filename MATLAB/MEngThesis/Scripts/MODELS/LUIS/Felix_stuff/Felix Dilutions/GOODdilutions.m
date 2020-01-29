%% Calculate dilutions for Felix Robot

clear all; clc; %#ok<CLALL>

%% Open .txt File

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open the .txt output file from the plate-reader. Format of this file should be the following:
% A1;0.152
% A2;0.313
% etc for the appropriate wells
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileID = fopen('today.txt'); % change to the name of the working file
%first column of C is the names, second column is the original OD from the
%plate reader
C = textscan(fileID,'%s %f','Delimiter',';');
fclose(fileID);

%% Define M9 index to correct ABS600

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Need to subtract the media background to obtain the "real ABS600". Be
% careful that this is not OD600, it's the value of the absorbance given by
% the plate-reader. Pathlength correction can be used to obtain a
% conversion to OD600 (or need to do a calibration curve, typically need to
% multiply ABS600 by 4 to obtain OD600).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Plot how to place boxes inside Felix machine 
figure
subplot(2,3,1)
text(0,0.5,'Mixing Plate')
yticklabels('')
xticklabels('')
subplot(2,3,2)
text(0,0.5,'Overnight Plate')
title('please ensure components are placed as shown below in the Felix upper tray')
yticklabels('')
xticklabels('')
subplot(2,3,3)
text(00,0.5,'H_2O Reservoir')
xticklabels('')
yticklabels('')
subplot(2,3,4)
text(0,0.5,'Final Plate')
xticklabels('')
yticklabels('')
subplot(2,3,5)
text(0,0.5,'Ethanol Reservoir')
yticklabels('')
xticklabels('')
subplot(2,3,6)
text(0,0.5,'Media Reservoir')
xticklabels('')
yticklabels('')
 
%%
idx_m9 = [1 2 3];%[4 12 20];
C{1,2}(idx_m9)
C{1,2} = [C{1,2}] - mean(C{1,2}(idx_m9));

figure
ODplate = reshape(C{:,2},[8,12]);
f1 = microplateplot(ODplate);
whiteToBlack = [linspace(1,0,256)', linspace(1,0,256)',linspace(1,0,256)'];
colormap(whiteToBlack)
colorbar

%% Calculate volume of fresh media to add in the mixing plate

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate how much fresh media should be added to the mixing plate after
% 50uL (ask the user) of cells have been transfered from the diluted overnight 
% plate to the mixing plate. At the end, we want to make sure that there is at
% least 100uL of cells in each well and that there is less than 300uL
% (maximum volume that a plate can contain: to be adapted if using a 
% different plate).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%97 rows are needed as the first row needs to include: Well_ID,
%Media_Volume
Felix = cell(97,2);
Felix{1,1} = 'Well_ID,';
Felix{1,2} = 'Media_Volume,';
Felix_plate = zeros(8,12);
mask_vector = cell(96,1);
mask = cell(8,12);

% Ask the user how much cells are being transfered from the diluted overnight plate
% to the mixing plate. (Default is 50ul)

prompt = 'What is the volume of cells that you are transfering from the diluted overnight plate to the mixing plate? ';
Vcells = input(prompt);
prompt2 = 'What is your desired OD in the final plate?';
OD = input(prompt2);
counter1 = 1;
counter2 = 1;

for i = 1:length(C{1,2})
    
    if C{1,2}(i) < OD
        
        warning{counter1} = C{1,1}{i}; %#ok<*SAGROW>
        mask_vector{i} = 'X'; 
        counter1 = counter1 + 1;
        
        if Vcells >= 50
            C{1,3}(i) = Vcells; % if the user doesn't want to set up a new diluted overnight plate, do a 1:2 dilution if enough cells to reach colume of 100uL in the well
        else
            C{1,3}(i) = 100; % if the user doesn't want to set up a new diluted overnight plate, add 100uL in the well to be sure the reach the minimum volume required (100uL)
        end
    else
 
        Vtot = (Vcells*C{1,2}(i))/OD; % final volume in the mixing plate well (in uL)
        C{1,3}(i) = Vtot - Vcells; % volume of media to add(in uL)
        
        if Vtot >= 300
            warning2{counter2} = C{1,1}{i};
            mask_vector{i} = 'O';
            counter2 = counter2+1;
        end
    end
    
    %well names into 1st column
    Felix{i+1,1} = C{1,1}{i};
    %volume into 2nd column
    Felix{i+1,2} = C{1,3}(i);
end

%% Make felix columns into plate (for visualisation only)
%use this for Felix as matlab doesnt like vector to cell change
for i = 1:8
    for j = 1:12
        Felix_plate(i,j) = Felix{i*j+1,2}; 
    end
end


% for i = 1:8
%     for j = 1:12
%         mask{i,j} = mask_vector{i*j}; 
%     end
% end

mask = reshape(mask_vector,[8,12]);

%% Plot plate reader 
figure
microplateplot(Felix_plate)
whiteToRed = [ones(256,1), linspace(1,0,256)',linspace(1,0,256)'];
colormap(whiteToRed)
colorbar

figure
microplateplot(Felix_plate,'TEXTLABEL',mask)
whiteToRed = [ones(256,1), linspace(1,0,256)',linspace(1,0,256)'];
colormap(whiteToRed)
colorbar

%% Write dilution file for Felix Robot

fileID = fopen('test.txt','w');
formatSpec = '%s, %.0f \r\n';
[nrows,ncols] = size(Felix);
for row = 1:nrows
    fprintf(fileID,formatSpec,Felix{row,:});
end
fclose(fileID);
type test.txt;

% %% Print warnings
% 
% % ABS600 is too low, give a warning so that the user can increase concentration 
% % of these wells in a nex diluted overnight plate.
% 
% msgbox(sprintf(['WARNING!! ABS600 of the following wells is below', num2str(OD),':\n\n %s \n\nYou might want to increase cell density of these wells in your diluted overnight plate.'],...
%             strjoin(warning,'\n ')),'Warning');
%         
% % Give a warning if final volume in the well is above 300uL, in which case
% % the user should dilute the overnights by a larger dilution factor.
% 
% if exist('warning2','var')
%     msgbox(sprintf('WARNING!! Total volume of the following wells in the mixing plate will be above 300uL:\n\n %s \n\nYou might want to dilute the overnights in the diluted overnight plate by a larger dilution factor.',...
%             strjoin(warning2,'\n ')),'Warning');
% end
%         