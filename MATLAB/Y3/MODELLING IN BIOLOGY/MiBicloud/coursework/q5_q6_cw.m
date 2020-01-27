clear all
clc
%Q5
%% b
%Declaration of Transition Matrix
T = [0.99 0.0075 0 0.0075;0.0075 0.99 0.0025 0;0 0.0025 0.99 0.0025;0.0025 0 0.0075 0.99];
Transition_Matrix = (T)
%Eigenvalues and Eigenvectors of T
[V,D] = eig(T);
Eigen_Vectors = V
Eigen_Values = [D(1,1) D(2,2) D(3,3) D(4,4)]
%Eigenvalue equal to 1
Eigenvalue_of_Interest = D(2,2)
%Corresponding eigenvector
Stationary_Distribution = V(:,2)/sum(V(:,2))
%Flux from A to C
flux_btwn_AC = Stationary_Distribution(1)*T(1,2)-Stationary_Distribution(2)*T(2,1)

%% c
U = T;
U(:,4) = []; %we take state 4 as absorbing
U(4,:) = [];
W = inv(eye(3) - U); %fundamental matrix
time_to_T_from_C = sum(W(:,2))

%% d
U2 = [0.99 0.0025;0.0025 0.99]
W2 = inv(eye(2)-U2) %fundamental matrix
R = [0 0.0075;0.0075 0]

pTbeforeA = R*W2 
pTbeforeA_startingC=pTbeforeA(2,2) 

%% Q6 
tic
%(a)
T = [0.99 0.0075 0 0.0075;0.0075 0.99 0.0025 0;0 0.0025 0.99 0.0025;0.0025 0 0.0075 0.99];
TransitionMatrix_after20steps = T^20

%(b)

%Starting sequence
%A is 1, C is 2, G is 3, T is 4
Sequence0 = [1 2 2 4 3 1 2 2 1]
%number of generations
n = 0; 

% 10000 simulations
for i=1:100000
%Declaration of a Sequence that will change after each generation
Sequence = Sequence0;

%while any of the nucleotides from Sequence is equal to Sequence0 the
%code will keep running (i.e. another generation will exist)
while Sequence(1)== Sequence0(1) || Sequence(2)== Sequence0(2) || Sequence(3)== Sequence0(3) || Sequence(4)== Sequence0(4) || Sequence(5)== Sequence0(5) || Sequence(6)== Sequence0(6) || Sequence(7)== Sequence0(7) || Sequence(8)== Sequence0(8) || Sequence(9)== Sequence0(9)

    for a = 1:9

        %%check what nucleotide is the initial one
        if Sequence(a) == 1
            start = 1; 
        end
        if Sequence(a) == 2
            start = 2; 
        end
        if Sequence(a) == 3
            start = 3; 
        end
        if Sequence(a) == 4
            start = 4; 
        end

        eventprob = rand; %random number between 0 and 1
        temp = 0; %temporary variable that is goning to hold the increasing
        reactid = 0;
        for c=1:4
            %the probabilty will be chosen from the previously selected
            %start column and this for loop will browse through every
            %row c
            temp = temp+T(c,start);  %goes to starting nucleotide column
            if temp>=eventprob
                %if the chosen rate is not bigger than 
                %eventprob go to the next one
                reactid=c;
                break
            end
        end

        %Change nucleotide
        if reactid == 1
            Sequence(a) = 1;
        end
        if reactid == 2
            Sequence(a) = 2;
        end
        if reactid == 3
            Sequence(a) = 3;
        end
        if reactid == 4
            Sequence(a) = 4;
        end


    end
    n = n+1; %%adds up for every generation
end

end
%Average number of generation over number of simulations.
avgNumber_of_Generations = n/100000 
toc