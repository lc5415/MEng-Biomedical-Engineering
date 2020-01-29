%Q1
function [Rnew,Fnew,Deltat] = RabsFoxs( R,F,a,b,c,g )
%pop is a vector containing R and F; pop(1) = R;pop(2)=F

rates = [a*R b*R*F g*R*F c*F];
totalrate = sum(rates);
Deltat = exprnd(1/totalrate); %maximun unnormalized probability 
Rnew = R;
Fnew = F;

eventprob = rand*totalrate; %the event happening falls between 0 and totalrate
temp = 0;
reactid = 0;
for i=1:4
    temp = temp+rates(i); 
    if temp>eventprob %if the chosen rate is not bigger than eventprob go to the next one
        reactid=i;
        break
    end
end

if reactid == 1
    Rnew = Rnew+1;
end
if reactid == 2
    Rnew = Rnew-1;
end
if reactid == 3
    Fnew = Fnew+1;
end
if reactid == 4
    Fnew = Fnew-1;
end

if Rnew <0
    Rnew = 0;
end
if Fnew <0
    Fnew = 0;
end
   
    
end

