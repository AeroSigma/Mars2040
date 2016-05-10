% J is provided by SingleTradeFunction
% [ Results.Value ] = SingleTradeFunction (PropType, SurfPower, Site, Food, SurfCrew, Input_ISP, varargin);
tic
nvars = 10; %number of variables

%x_1 = ISP improvements, what percentage of max possible improvement
ISP_min = 0;
ISP_max = 1;

%x_2 = Food Percentage Grown on Mars, varargin for the input, in decimal
%percentage
Food_min = 0.25;
Food_max = 0.75;

%Crew Sizes
Crew_min = 16;
Crew_max = 18;
%{
x(3) = Propulsion Type 2
x(4) = Staging Location 3
x(5) = Transit Fuel Source 3
x(6) = Return Fuel Source 3
x(7) = Surface Crew Size 3
x(8) = Entry Type 2
x(9) = Site 12
x(10) = Surface Power Source 4
%}
%Consolidate variable limits
LB = [ISP_min,Food_min,1,1,1,1,Crew_min,1,1,1];
UB = [ISP_max,Food_max,2,3,3,3,Crew_max,2,12,4];
Bounds = [LB;UB];
intcon = [3 4 5 6 7 8 9 10]; %integer variables, the architectural options

%Options
options = gaoptimset(...
    'CreationFcn', @int_pop,...
    'MutationFcn', @int_mutation,...
    'CrossoverFcn',@int_crossoverarithmetic,...
    'TolFun', [1e-5],...
    'ParetoFraction', 0.50,...
    'Generations', 1000,...
    'PopulationSize',100,...
    'UseParallel', true,...
    'PlotFcn', @gaplotpareto,...
    'DistanceMeasureFcn', {@distancecrowding,'phenotype'},...
    'PopInitRange', Bounds);


tic
[x,fval,exitscores,output,population,scores] = gamultiobj(@Mars2040_GA_Multi_Wrapper,nvars,...
    [],[],[],[],LB,UB, ...@NoConstraints,
    options);

%results
Runtime_Mins = toc / 60
load gong.mat;
gong = audioplayer(y, Fs);
play(gong); 
Isp = x(1)
Food_On_Mars = x(2)
fval
output.message

Runtime_mins = toc/60
