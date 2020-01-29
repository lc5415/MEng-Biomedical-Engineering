%%% Team Members: Francesco Guagliardo, Luis
%%% Chaves Rodriguez, Daniele Olmeda, Arun Paul
%%% Bayes
function [x, y, new_param] = positionEstimator(test_data, modelParameters)

% **********************************************************
%
% You can also use the following function header to keep your state
% from the last iteration
%
% function [x, y, newModelParameters] = positionEstimator(test_data, modelParameters)
%                 ^^^^^^^^^^^^^^^^^^
% Please note that this is optional. You can still use the old function
% declaration without returning new model parameters.
%
% *********************************************************

% - test_data:
%     test_data(m).trialID
%         unique trial ID
%     test_data(m).startHandPos
%         2x1 vector giving the [x y] position of the hand at the start
%         of the trial
%     test_data(m).decodedHandPos
%         [2xN] vector giving the hand position estimated by your
%         algorithm during the previous iterations. In this case, N is
%         the number of times your function has been called previously on
%         the same data sequence.
%     test_data(m).spikes(i,t) (m = trial id, i = neuron id, t = time)
%     in this case, t goes from 1 to the current time in steps of 20
%     Example:
%         Iteration 1 (t = 320):
%             test_data.trialID = 1;
%             test_data.startHandPos = [0; 0]
%             test_data.decodedHandPos = []
%             test_data.spikes = 98x320 matrix of spiking activity
%         Iteration 2 (t = 340):
%             test_data.trialID = 1;
%             test_data.startHandPos = [0; 0]
%             test_data.decodedHandPos = [2.3; 1.5]
%             test_data.spikes = 98x340 matrix of spiking activity

[i,t] = size(test_data(1,1).spikes);
input_len = size(test_data,1);

input_time = size(test_data.spikes,2);
% up_to = 360;
% if input_time < up_to
%     time_range = 1:input_time;%280:480;
% else
%     time_range = 1:up_to;%280:480;
% end
train_times = 320:20:400;
up_to = find(train_times==input_time);
if isempty(up_to)
    up_to = length(train_times);
end

% up_to = length(train_times);
%[test_data_formatted, ~] = tidy_spikes(test_data,time_range);
[test_data_formatted, ~] = tidy_spikes(test_data,1:train_times(up_to));
label = zeros(size(test_data,1),1);
parameters = modelParameters.train_in(up_to).parameters; % parameters up to that point

for i = 1:input_len %iterate input datapoints
    id = 1;
    prediction = zeros(parameters(1).num_classes,1);
    for c = 1:parameters(1).num_classes % iterate classes
        %probabilty p( x | class) --> pxc
        pxc_NC = multivar_gauss(test_data_formatted(i,:),parameters(id).mu,parameters(id).s);
        pxc_C = multivar_gauss(test_data_formatted(i,:),parameters(id+1).mu,parameters(id+1).s);
        
        % posterior probability for data point i p(C | x)
        pcx_NC = pxc_NC * parameters(id).prior;
        pcx_C = pxc_C * parameters(id+1).prior;
        
        if pcx_NC < pcx_C % yes class x
            prediction(c,1) = pcx_C;
        end
        id = id+2;
    end
    [~, predicte_label] = max(prediction);
    label(i,1) = predicte_label;
end % iterate input data points

%label = direc;
% regressor
test_input = prepare_regressor_data(test_data,'test');
coeffs = modelParameters.coeffs;
maxmins = modelParameters.extremes;
r = modelParameters.new_dim;

params_x = coeffs(:,1,label);
params_y = coeffs(:,2,label);

[Urx,Srx,Vrx] = svds([1,test_input]',r);
prediction(1) = params_x'*Urx*Srx*Vrx';
[Ury,Sry,Vry] = svds([1,test_input]',r);
prediction(2) = params_y'*Ury*Sry*Vry';

 %prediction(1) = params_x'*[1,test_input]';
 %prediction(2) = params_y'*[1,test_input]';

% max min check
maxmins = modelParameters.extremes;
min_x = maxmins(1,1,label);
max_x = maxmins(1,2,label);
min_y = maxmins(2,1,label);
max_y = maxmins(2,2,label);
if prediction(1) > max_x,  prediction(1) = max_x; end
if prediction(2) > max_y,   prediction(2) = max_y; end
if prediction(1) < min_x, prediction(1) = min_x; end
if prediction(2) < min_y,  prediction(2) = min_y; end



x = prediction(1);
y = prediction(2);
%x = modelParameters.mean_vals(label).mean_pos(1,t);
%y = modelParameters.mean_vals(label).mean_pos(2,t);
modelParameters.test_label = label;
new_param = modelParameters;
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

% multivariate gaussian
function phi = multivar_gauss(x,mu,covar)
k = length(covar);
A = 1/sqrt((2*pi)^k*det(covar));
phi = A*exp(-0.5*(x-mu)*covar^-1*(x-mu)');
%phi = A*exp(-0.5*(x-mu)*pinv(covar)*(x-mu)');
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


