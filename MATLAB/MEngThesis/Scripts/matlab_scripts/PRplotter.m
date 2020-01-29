clear all 
close all 
clc
%% 
file = uigetfile('*.xlsx');
data = xlsread(file, 'A45:CU111');
OD = data(:,1:98);
% B = data(:,16:27);
% C = data(:,28:39);
% D = data(:,40:51);
% E = data(:,52:63);
% F = data(:,64:75);
% G = data(:,76:87);
% H = data(:,88:98);
time = data(:,1);
prompt1 = 'How many biological replicates do you have?';
replicates = input(prompt1);
prompt2 = 'How many different samples are you measuring?';
samples = input(prompt2);
prompt3 = 'Would you like your graphs to be plotted by one-by-one or groupped by samples? Please reply 0 or 1';
option = input(prompt3);
%% 
if option == 0
    %individual plots in subplot format
elseif option == 1
    %all plots in the same graph with errorbars
else 
    'Please run the program again and type 0 or 1'
end
%% 

S.fh = figure('units','pixels',...
              'position',[200 200 30*12 30*8],...
              'menubar','none',...
              'numbertitle','off',...
              'name','Well selection',...
              'resize','on');
          count = 1;
for a = 1:12
    for b = 1:8
        S.pb(a,b) = uicontrol('style','toggle',...
                 'units','pixels',...
                 'position',[30*(a-1) 240-30*b 30 30],...
                 'fontsize',14,...
                 'string',num2str(count),...
                 'callback',{@pb_call,S,a,b});
             count = count +1;
    end
end

% function [] = pbcall(varargin,index1,index2)
% S = varargin{3};
% a = index1;
% b = index2;
% 


%%
%hold on
grid on
legend('show')
count = 0;

index = reshape(1:48, 6, 8).';
index2 = reshape(1:48,8,6);



for i =1:6
    for j = 0:7
        %index(j+1,i)
        subplot(8,6,index(j+1,i))
        
        plot(time,OD(:,i+(12*j)))
        ylim([0 0.7])
        if count ~= 10
        title(['Well ', num2str(i+(12*j)), ' - Y',num2str(index2(j+1,i))])
        else 
        title(['Well ', num2str(i+(12*j)), ' - Y2900'])
        end
        count = count+1;
        if i == 1
           y = ylabel(char(65+j),'Rotation',0);
           set(y, 'Units', 'Normalized', 'Position', [-0.2, 0.5, 0]);
        end
        if i+(12*j) == 85
            xlabel('Time (minutes')
        end
        if count == 18
            break
        end
    end
end
