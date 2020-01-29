function [ParamsOut,fvalOut,I,f,B0] = Fits2a(t,y,plotflag)
%%function selection
% this function will make Fits1a iterate through the different model
% options and get the fval for each. Fits1a outputs the minimum fval for
% each option after iterating through a set of initial values.

% optimization values into structure opt

for option = 1:4
    [params(option).B(:),fval(option),B0] = Fits1a(t,y,option,0);
end

[fvalOut,I] = min(fval);
ParamsOut = params(I).B;


set(0,'DefaultFigureVisible','off')
%%Plotting and image saving
if plotflag == 1
    f(1) = figure;
    subplot(2,1,1)
    plot(t,y,'p','DisplayName','Raw Data')
    hold on
    for option = 1:4 %I
%         figure(f(1));
%         set(0, 'CurrentFigure', f(1))
        subplot(2,1,1)
        %%function statement
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
            % % b(1) = A,  B(2) = mu,  b(3) = lambda
            myfun = @(b,t) b(1)./(1+ exp((4.*b(2)./b(1)).*(b(3)-t)+2)) + b(4);
            number_of_params = 4;
            
        elseif option == 4 % linear regression
            % b(1) = y-intercept b(2) = slope
            myfun = @(b,t) b(1)+b(2)*t;
            number_of_params = 2;
        end
        
        plot(t,myfun(params(option).B,t),'LineWidth',2,'DisplayName',['Model ',num2str(option),' Score:',num2str(fval(option))])
        %        title({['Model',num2str(option)];['fval: ',num2str(fvalOut)];[' Parameters: ', num2str(ParamsOut)]})
        title({['Model ',num2str(I)];['fval: ',num2str(fval(I))];[' Parameters: ', num2str(params(I).B)]})
        xlabel('Time')
        ylabel('OD600')
        legend('Location','best')
        
        if option == I
%             f(2) = figure;
subplot(2,1,2)
            plot(myfun(params(I).B,t),y-myfun(params(I).B,t),'o')
            hold on
            xL = get(gca, 'XLim');
            plot(xL, [0 0], '--')
            title('Residuals plot')
            xlabel('Predicted value')
            ylabel('Observed - Predicted')
        end
    end
end
end



