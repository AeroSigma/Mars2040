function [ Launch_Cost_Module ] = Launch_Cost(IMLEO)
%Calculate the launch cost for the entire resupply mission based on IMLEO.
%The code calculates costs and adds these into the SC_Class definition.

%Rates based on "Estimating the Life Cycle Cost of Space Systems"
%Harry Jones, ICES Conference 2015.

rate = 5000; % USD per kg, (Shuttle=25000, Falcon Heavy=1600, SLS=7140)  

Launch_Cost_Module = 1e-6*rate*IMLEO; %Launch Cost in Millions of Dollars   


end
