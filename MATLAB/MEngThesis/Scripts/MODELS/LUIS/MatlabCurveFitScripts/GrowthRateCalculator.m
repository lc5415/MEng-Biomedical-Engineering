function [growthrate,indices,notreach] = GrowthRateCalculator(timevector,data,option)
%For option 2 calculate growth rate every n
timestep = timevector(2)-timevector(1);
%timestep = 0.33;
[wells,measurements] = size(data);
if option == 1
    for a = 1:wells
        growthrate(a,:) = diff(data(a,:))/timestep;
        %          j = 1;
        %         for t = 1:1:measurements-2
        %         growthrate(a,j) = (data(a,t+2)-data(a,t))/timestep;
        %         j = j+1;
    end
    
elseif option == 2
    n = 5;
    timestep = timevector(n)-timevector(1);
    
    for a = 1:wells
        j = 1;
        for t = 1:n:measurements-n
            growthrate(a,j) = (data(a,t+n)-data(a,t))/timestep;
            j = j+1;
        end
    end
elseif option == 3
    notreachmax = [];
    notreachmin = [];
    startsabovemin =[];
    growthrate = zeros(wells,3);
    indices = zeros(wells,4);
    for a = 1:wells
        
        if max(data(a,:)) ~= min(data(a,:))
            % does not take into account minimum starting values above 0.1
            
            if any(data(a,:)>=0.1) && min(data(a,:))<=0.1
                startpoint =  find(data(a,:)<=0.1);
            elseif min(data(a,:))>0.1
                startpoint = 1;
                startsabovemin = [startsabovemin;a];
            else
                startpoint = find(min(data(a,:)));
                notreachmin = [notreachmin;a];
            end
            
            if any(data(a,:)>=1)
                endpoint = find(data(a,:) >= 1);
            else
                endpoint = find(max(data(a,:)));
                notreachmax = [notreachmax;a];
            end
            
            index_min = startpoint(end);
            index_max = endpoint(1);
            
            
            %         value_min = data(a,index_min);
            %         value_max = data(a,index_max);
            %         timestep = timevector(index_max)-timevector(index_min);
            indices(a,:) = [1 index_min index_max length(timevector)];
            for c = 1:3
                growthrate(a,c) = (data(a,indices(a,c+1))-data(a,indices(a,c)))/(timevector(indices(a,c+1))-timevector(indices(a,c)));
            end
        end
        notreach.min = notreachmin;
        notreach.max = notreachmax;
        notreach.bigmin = startsabovemin;
    end
end
end
