%%% Team Members: Francesco Guagliardo, Luis
%%% Chaves Rodriguez, Daniele Olmeda, Arun Paul
%%% Bayes implementation
function  [modelParameters] = positionEstimatorTraining(trainingData)

% Arguments:

% - training_data:
%     training_data(n,k)              (n = trial id,  k = reaching angle)
%     training_data(n,k).trialId      unique number of the trial
%     training_data(n,k).spikes(i,t)  (i = neuron id, t = time)
%     training_data(n,k).handPos(d,t) (d = dimension [1-3], t = time)

%
%time_range = 1:360;%280:480;
%[data_formatted, labels] = tidy_spikes(trainingData,time_range);
[n,k] = size(trainingData);
[i,t] = size(trainingData(1,1).spikes);

% cov_condintioning = 18;
% train_times = 320:20:endtime;
cov_condintioning = 27;
train_times = 320:20:400;

data_formatted_per_train_time = struct;
tic
for end_t = 1:1:length(train_times)
    [data_formatted, labels] = tidy_spikes(trainingData,1:train_times(end_t));
    data_formatted_per_train_time(end_t).data_formatted = data_formatted;
    num_train_pts = size(data_formatted,1);
    % param(1).smth is not class 1, pram(2).smth is class 1, param(3) is
    % not class 2 and param(4) is class 2 and so on
    parameters = struct;
    parameters.num_classes = k;
    id = 1;
    for c = 1:k
        logical_arr = logical(labels==c);
        %divide classes (NC is no class,
        train_NC = data_formatted(~logical_arr,:); % no class is NC
        train_C = data_formatted(logical_arr,:); % yes class is C
        
        % priors: p(class)
        parameters(id).prior = size(train_NC,1)/num_train_pts;
        parameters(id+1).prior  = 1-parameters(id).prior;
        
        %means
        parameters(id).mu = mean(train_NC);
        parameters(id+1).mu = mean(train_C);
        
        %covariances
        parameters(id).s = cov(train_NC)+eye(size(train_NC,2))*cov_condintioning;
        parameters(id+1).s = cov(train_C)+eye(size(train_NC,2))*cov_condintioning;
        
        %upadte id for next class
        id = id+2;
        
    end
    data_formatted_per_train_time(end_t).parameters = parameters;
end
toc
% regressor
data_formatted_train = prepare_regressor_data(trainingData,'train');
r = 13;
fix_pos = 8;

for ang = 1:k
    %get x positin from processed training data
    x_position = data_formatted_train(ang).out(:,1);
    %get y position from processed training data
    y_position = data_formatted_train(ang).out(:,2);
    
    % get length of data
    length_data_in = length(data_formatted_train(1).in);
    %get processed spike data and concatenate to a colum of ones to prepare it
    %for the regress function
    processed_electrodes = [ones(length_data_in,1),data_formatted_train(ang).in];
    
    params_x = train_regressor(x_position,processed_electrodes,r,1);
    params_y = train_regressor(y_position,processed_electrodes,r,1);
    %store coefficient for this movement
    coeffs(:,:,ang) = [params_x,params_y];
    
    % get max and mins for x and y in order to later bound estimations
    
    max_x = max(x_position);
    if max_x < 0, max_x = max_x +fix_pos;
    else,  max_x = max_x -fix_pos; end
    max_y = max(y_position);
    if max_y < 0, max_y = max_y +fix_pos;
    else,  max_y = max_y -fix_pos; end
    min_x = min(x_position);
    if min_x < 0, min_x = min_x +fix_pos;
    else,  min_x = min_x -fix_pos; end
    min_y = min(y_position);
    if min_y < 0, min_y = min_y +fix_pos;
    else,  min_y = min_y -fix_pos; end
    
    maxs_mins(:,:,ang) = [ min_x max_x;min_y max_y];
    
end
modelParameters.train_in = data_formatted_per_train_time;
modelParameters.labels = labels;
% regressor
modelParameters.coeffs = coeffs;
modelParameters.extremes = maxs_mins;
modelParameters.new_dim = r;
end

% format the data in a way
function [data_formatted, labels] = tidy_spikes(data_to_format,range)
[n,k] = size(data_to_format);
[i,t] = size(data_to_format(1,1).spikes);

% output in train_trials trials x 98
labels = zeros(n*k,1);
dimensions = 1:i;%[3,4,7,18,27,31,33,34,36,41,55,68,69,75,81,90,92,98];
i = length(dimensions);
data_formatted = zeros(n*k,i);
count = 1;
for a = 1:k
    for t = 1:n % number of trials
        for el = 1:i
            data_formatted(count,el) = red_dim(data_to_format(t,a).spikes(dimensions(el),range));
        end
        labels(count,1) = a;
        count = count +1;
    end
end

end

% function to agglomerate the data
function reduced_dimension_data = red_dim(data_in)

reduced_dimension_data = sum(data_in);

end

function b = train_regressor(y,X,r,option)
% this linear regressor takes as an input your feature space, concated to a
% vector of ones as the constant term which will give the bias or
% "y-intercept"
% we consider y and X given as column vector where time is in the rows

if option == 0
    b = inv(X'*X)*X'*y;
else
    [Ur,Sr,Vr] = svds(X,r);
    b = Vr/Sr*Ur'*y;
end
end

function data_out = prepare_regressor_data(data_to_format, train_or_test)
% train_or_test = 'train' prepares training data, train_or_test = 'test'

% get data size: n: trials(100), k: movements/angles(8), i: electrodes (98), t:
% time (variable length)
[n,k] = size(data_to_format);
[i,t] = size(data_to_format(1,1).spikes);

%use only "useful" electrodes
dimensions = 1:i;%[3,4,7,18,27,31,33,34,36,41,55,68,69,75,81,90,92,98];
%[3,4,7,18,27,31,33,34,36,41,55,68,69,75,81,90,92,98];
%[3,4,18,34,36,96];%1:i; %electrodes used, some are useless so we shouldn't use them

end_time = 540; %ms
start_time = 320; %ms
step_time = 20; %ms
%time vector over which spikes will be calculated, they will be calculated
%in the form: sum(spikes(1:320)), sum(spikes(1:340))...
times = start_time:step_time:end_time;
% dim_reducer "combines" electrodes by adding the spikes of every
% consecutive 3, dim_reducer MUST BE A FACTOR OF THE NUMBER OF ELECTRODES
% WE ARE USING, OTHERWISE TROUBLE
dim_reducer = 1;%14; % final dimensions will be initial dimensions / dim_reducer
if strcmp(train_or_test,'train')
    % .in(20,30) contains the sum of the spikes up to time 320ms of
    % electrode number 30 for trial 20.
    % .in(120,30) contains the sum of the spikes up to time 340ms
    % (if step_time = 20) electrode 30 for trial 20
    % .out(20,:) contains the x and y position for trial 20 at time stamp
    % 320ms, .out(120,:) contains the x and y for trial 20 at time stamp
    % 340 ms and so on.
    %                    Electrode 1 | Electrode 2 | Electrode 3 ...
    %Trial 1 - 1:320ms  | sum(spikes)|
    %Trial 2 - 1:320ms  |
    %Trial 3 - 1:320ms
    %       .
    %       .
    %       .
    %Trial 100 - 1:320ms
    %Trial 1 - 1:340ms
    %Trial 2 - 1:340ms
    %       .
    %       .
    %       .
    %Trial 100 - 1:540ms
    
    for a = 1:k
        %cumulative sums: initialise with 100 (# of trials)*12 (recording
        %times for every trial) rows and as many columns as you are using
        %electrodes
        data_formatted(a).in = zeros(n*length(times),length(dimensions));
        %data_formatted(a).out = zeros(length(times),2); %x,y
        %data_out(a).in = zeros(n*length(times),reduced_dimensions);
        %output is the x,y trajectories over time
        data_out(a).out = zeros(length(times),2); %x,y
        count = 1;
        %for all times (every 20 ms)
        for tim = times
            for t = 1:n % number of trials
                %store handposition for every trial and every movement at
                %precised time (320, 340, 360 ... 540)
                data_out(a).out(count,:) = data_to_format(t,a).handPos(1:2,tim);
                
                %for all electrodes sum input data (data_to_format) from 1
                %to tim (1 to 320, 1 to 340, 1 to 360...)
                for el = dimensions
                    data_formatted(a).in(count,el==dimensions) = sum(data_to_format(t,a).spikes(el,1:tim));
                end
                %increase handpos storage vector
                count = count +1;
            end
        end
        % reduce data by combining data for every consecutive electrodes,
        % this will be part of the function output along with the x and y
        % positions. reduce_feat_dim takes as input the formatted data for
        % all original dimensions and the dim_reducer factor
        data_out(a).in = reduce_feat_dim(data_formatted(a).in,dim_reducer);
        
        %[data_out(a).in, coeff_pca] = reduce_feat_dim(data_formatted(a).in, 8);
        %data_out(a).coeff_pca=coeff_pca;
        data_out(a).coeff_pca=0;
    end
    
    %if only preparing data for testing regressor then just sum spikes over
    %dimensions (# of electrodes) and then reduce dimensions
elseif strcmp(train_or_test,'test')
    data_formatted = zeros(1,length(dimensions));
    for el = dimensions
        data_formatted(el==dimensions) = sum(data_to_format.spikes(el,:));
    end
    % reduce data
    data_out = reduce_feat_dim(data_formatted,dim_reducer);%data_formatted;%reduce_feat_dim(data_formatted,0.65);
    %data_out = data_formatted;
else
    warning('Insert either train or test')
end
end

function reduced_features = reduce_feat_dim(features,sum_int)
%features is a obervations x dimensions vector and the dimensions are
%reduced by summing over dimensions sum_int by sum_int
new_dim = size(features,2)/sum_int;
%reduced feature space is created
reduced_features = zeros(size(features,1),new_dim);
start_idx = 1;
for i = 1:new_dim
    reduced_features(:,i)= sum(features(:,start_idx:start_idx+sum_int-1),2);
    %index changes every sum_int (in example case = 3),in this case
    %new_dimension(1) = old_dimension(1)+old_dimension(2)+old(dimension(3)
    start_idx = start_idx+sum_int;
end

end




