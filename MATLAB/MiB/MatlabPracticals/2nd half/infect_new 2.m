function [susceptible_new,infected_new,dead_new] = infect_new(adjacency,susceptible,infected,dead, ptrans)
% function takes adjacency matrix, transmission probability, and list of susceptible, infected and
% dead people as input. Produces updated list of susceptible, infected and
% dead people


susceptible_new=susceptible;
infected_new=infected;
dead_new=dead;
for i=1:length(infected) % loop over all people
        if infected(i)==1 % pick those that are infected
            for j=1:length(infected) % find their contacts
                if adjacency(i,j)>0 && susceptible(j)>0 && rand<ptrans
                    susceptible_new(j)=0; %infect with suitable probability if susceptible.
                    infected_new(j)=1;
                end
            end
            infected_new(i)=0; %infected people die at end of step.
            dead_new(i)=1;
        end
    end
end
