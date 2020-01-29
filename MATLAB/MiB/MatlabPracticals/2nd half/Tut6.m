clc
clear all
%tutorial 6 , 1st from Tom Ouldridge
%Q1
T = zeros(8,8);
T(1,1) = 0.5;
T(2,1) = 0.5;
T(2,2) = 0.3;
T(3,2) = 0.7;
T(2,3) = 0.7;
T(4,3) = 0.3;
T(5,4) = 0.5;
T(6,4) = 0.5;
T(3,5) = 0.4;
T(6,5) = 0.6;
T(7,6) = 1;
T(6,7) = 0.4;
T(8,7) = 0.6;
T(1,8) = 1;
%Q2
T10 = (T^10); %T^10 is the proper matrix multiplication where as .^ will just do T10(1,1) = T(1) *T(1)...
p_init = [0;1;0;0;0;0;0;0];
p10 = T10*p_init
%Q3
[V,D] = eig(T);
ss = V(:,1);
steps_to_ss = ss/sum(ss)


%Q4
U = T;
U(:,8) = []; %we take state 8 as absorbing which is translated to removing row and column 8
U(8,:) = [];
W = inv(eye(7) - U); %fundamental matrix
time_toS8 = sum(W(:,1)) %time to state 8 starting from 1, sum of first column
%Q5

U2=[0 0 0.4 0 0 0;  0.3 0 0 0 0 0;
    0 0.5 0 0 0 0;  0 0.5 0.6 0 0.4 0;
    0 0 0 1 0 0;  0 0 0 0 0.6 0];


W2 = inv(eye(6)-U2);
R2 = T([1,2],:);
R2(:,[1,2]) = [];

p2before1 = R2*W2 
p2before1_starting4=p2before1(2,2) 
%once the system reaches 2 from state 4 it cannot go anywhere else 
%That's why we say the system is absorbing it only comes back to itself
%so we're sure it reaches 2 before it reaches 1 :) Corinne heleped on this