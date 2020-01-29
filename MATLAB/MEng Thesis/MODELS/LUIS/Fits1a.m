function [Bout,fvalout,B0] = Fits1a(t,y,option,plotflag)
%% function selection
if option == 1 %Gompertz
    % % b(1) = A,  B(2) = mu,  b(3) = lambda, b(4): initial OD
    %from 2010 grofit R package paper, in the 2017 this is described as the
    %Zwitering mdoification
    %     myfun = @(b,t) b(1) .* exp(-exp(((b(2) * exp(1))./b(1)) .* (b(3)-t) + 1))+b(4);
    % from 2017 Gompertz review, note b(2) or growth rate here is relative
    % growth rate and it must timed by the max growth rate b(1) or A and
    % divided by exp(1)
    %  myfun = @(b,t) b(1).*exp(-exp(-b(2).*(t-b(3)))) + b(4);
    
    % Universal Gompertz as defined in 2017 review
    myfun = @(b,t) b(1).*exp(-exp(-exp(1).*b(2).*(t-b(3))./b(1)));
    number_of_params = 3;
    
elseif option == 2 %modified Gompertz
    % % b(1) = A(stationary phase),  B(2) = mu(slope)
    % b(3) = lambda(lag phase)
    % b(4) = alpha, b(5) = t shift
    myfun = @(b,t) b(1) .* exp(-exp(((b(2) * exp(1))./b(1)) .* (b(3)-t) + 1)) + b(1).*exp(b(4).*(t-b(5)));
    number_of_params = 5;
    
elseif option == 3 %logistic
    % % b(1) = A,  B(2) = mu,  b(3) = lambda, b(4): initial OD
    myfun = @(b,t) b(1)./(1+ exp((4.*b(2)./b(1)).*(b(3)-t)+2)) + b(4);
    number_of_params = 4;
    
elseif option == 4 % linear regression
    % b(1) = y-intercept b(2) = slope
    myfun = @(b,t) b(1)+b(2)*t;
    number_of_params = 2;
end

%% solve for selected function
% options for plotting fminsearch tolerance and iterations
options = optimset('TolFun',1e-4,'TolX',1e-4,'MaxIter',10000,'MaxFunEvals',10000)%'Display','iter','PlotFcns',@optimplotfval)

% use line below if interested in seeing information about optimisation
% path
% [B,resnorm,exitflag,output] = fminsearch(@(b) norm(y - gompertz(b,t)), rand(3,1),options);

%number of observations/measurements
N = length(t);

% choose cost function of choice (Root Mean Square error, Residual sum of
% squares, Akaike Information Criterion...)
% (1): Root mean square error or norm
RMS = @(b) norm(y - myfun(b,t));
% (2)L Residual sum of squares
RSS = @(b) sum((y- myfun(b,t)).^2);
% (2): Akaike Information Criterion
AIC = @(b) N*log10(sum((y- myfun(b,t)).^2)/N)+2*number_of_params;

%% initial values using "LHS" + solve underneath

% parameters for all models
% linear model 2 parameters
% 1A: y-intercept
% 1B: slope

% Gompertz and Logistic:
% 2A: MAX OD
% 2B: SLOPE
% 2C: LAG PHASE
% 2E: Initial OD

% Modified Gompertz
% 3A: MAX OD
% 3B: SLOPE
% 3C: LAG PHASE
% 3D: alpha   %NOT SURE THE PHYSICAL MEANING OF THESE YET
% 3E: T SHIFT % NOT SURE THE PHYSICAL MEANING OF THESE YET

% if no value is expected give B0
B0 = [0.01 0.1 1 10];


if number_of_params == 2
    B = zeros(3,3,number_of_params);
    fval = zeros(3,3);
    for i = 1:length(B0)
        for j = 1:length(B0)
            [B(i,j,:),fval(i,j)] = fminsearch(AIC, [B0(i),B0(j)],options);
        end
    end
elseif number_of_params == 3
    B = zeros(3,3,3,number_of_params);
    fval = zeros(3,3,3);
    for i = 1:length(B0)
        for j = 1:length(B0)
            for k = 1:length(B0)
                [B(i,j,k,:),fval(i,j,k)] = fminsearch(AIC, [B0(i),B0(j),B0(k)],options);
            end
        end
    end
elseif number_of_params == 4
    B = zeros(3,3,3,3,number_of_params);
    fval = zeros(3,3,3,3);
    for i = 1:length(B0)
        for j = 1:length(B0)
            for k = 1:length(B0)
                for l = 1:length(B0)
                    [B(i,j,k,l,:),fval(i,j,k,l)] = fminsearch(AIC, [B0(i),B0(j),B0(k),B0(l)],options);
                end
            end
        end
    end
elseif number_of_params == 5
    B = zeros(3,3,3,3,3,number_of_params);
    fval = zeros(3,3,3,3,3);
    for i = 1:length(B0)
        for j = 1:length(B0)
            for k = 1:length(B0)
                for l = 1:length(B0)
                    for m = 1:length(B0)
                        [B(i,j,k,l,m,:),fval(i,j,k,l,m)] = fminsearch(AIC, [B0(i),B0(j),B0(k),B0(l),B0(m)],options);
                    end
                end
            end
        end
    end
end

%take minimum fval from all iterations and output that and the parameters
%for that fval
[fvalout,fvalmin_index] = min(fval,[],'all','linear');
if number_of_params == 2
    [ind1, ind2] = ind2sub(size(fval),fvalmin_index);
    Bout = B(ind1,ind2,:);
elseif number_of_params == 3
    [ind1, ind2,ind3] = ind2sub(size(fval),fvalmin_index);
    Bout = B(ind1,ind2,ind3,:);
elseif number_of_params == 4
    [ind1,ind2,ind3,ind4] = ind2sub(size(fval),fvalmin_index);
    Bout = B(ind1,ind2,ind3,ind4,:);
elseif number_of_params == 5
    [ind1, ind2,ind3,ind4,ind5] = ind2sub(size(fval),fvalmin_index);
    Bout = B(ind1,ind2,ind3,ind4,ind5,:);
end


% plot if flag has been raised
if plotflag == 1
    plot(t,y,'p')
    hold on
    plot(t,myfun(Bout,t),'r','DisplayName','AIC')
end

end

