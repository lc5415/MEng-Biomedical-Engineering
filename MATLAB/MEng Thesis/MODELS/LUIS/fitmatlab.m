function [params,gof,output,f] = fitmatlab(timevector,data,model)

f = figure('units','normalized','outerposition',[0 0 1 1]);
for model = model
    if model == 1
        
        %Gompertz from 1998 gibson paper
         myfun = @(C,B,A,M,t) A+C.*exp(-exp(-B.*(t-M)));
        % W0 form of the U Gompertz from 2017 Gompertz review
%myfun = @(A,slope,Ti,t) A.*(exp(-exp(-exp(1).*slope.*(t-Ti)./A)));
        o = fitoptions('Method','NonLinearLeastSquares','StartPoint',[2 0.2 0.1 10],'Robust','Bisquare');
    elseif model == 2
        %logistic found in wikipedia
        myfun = @(A,slope,A0,t) A./(1+ ((A-A0)./A0).*exp(-slope*t));
        o = fitoptions('Method','NonLinearLeastSquares','StartPoint',[2 0.1 0.2],'Robust','Bisquare');
    else
        myfun = @(A0,slope,t) A0+slope*t;
        o = fitoptions('Method','NonLinearLeastSquares','StartPoint',[0 0.1],'Lower',[0 0],'Robust','Bisquare');
    end
    
    g = fittype(myfun,'independent','t');
    
    [y,gof(1),output(1)] = fit(timevector',data',g,o);
    params(1).B(:) = coeffvalues(y);
    params(1).confint(:,:) = confint(y);
    
    
    subplot(2,1,1)
    plot(y,timevector,data)
    title({['Model ',num2str(1)];['GOF- SSE:',num2str(gof(1).sse),' R-square:',num2str(gof(1).rsquare),' DFE:',num2str(gof(1).dfe),' adjRsquare:',num2str(gof(1).adjrsquare),' RMSE:',num2str(gof(1).rmse)];['params',num2str(params(1).B)]})
    legend('Location','best')
    
    subplot(2,1,2)
    if model == 1
        plot(myfun(params(model).B(1),params(model).B(2),params(model).B(3),params(model).B(4),timevector),output(model).residuals,'.')
    elseif model == 2
        plot(myfun(params(model).B(1),params(model).B(2),params(model).B(3),timevector),output(model).residuals,'.')
    else 
         plot(myfun(params(1).B(1),params(1).B(2),timevector),output(1).residuals,'.')
    end
    hold on
    xL = get(gca, 'XLim');
    plot(xL, [0 0], '--')
    title('Residuals plot')
    xlabel('Predicted value')
    ylabel('Observed - Predicted')
end

end
