function [ Value, Total_Cost ] = Value(Science, Dev_Cost, Launch_Cost)
%Calculate the value for the entire resupply mission based on science utility and cost.

Total_Cost = Dev_Cost+Launch_Cost; % $M

Value = Science/Total_Cost; % Science/$M  

end
