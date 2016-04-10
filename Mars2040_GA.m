% J is provided by SingleTradeFunction
% [ Results.Value ] = SingleTradeFunction (PropType, SurfPower, Site, Food, SurfCrew, Input_ISP, varargin);

%x_1 = ISP improvements, Input_ISP for the input
ISP_min = 448;
ISP_max = 480;

%x_2 = Food Percentage Grown on Mars, varargin for the input, in decimal
%percentage
Food_min = 0.25;
Food_max = 0.75;

%Consolidate variable limits
LB = [ISP_min,Food_min];
UB = [ISP_max,Food_max];

nvars = 2; %number of variables

%%Options
options = gaoptimset;
options.PopulationSize = 30;
options.CrossoverFraction = 0.75;
options.Generations = [40];
options.EliteCount = 1;
options.TolFun = [1e-6];


tic
[x,fval,exitscores,output,population,scores] = ga(@Mars2040_GA_Wrapper,nvars,[],[],[],[],LB,UB, ...
    @NoConstraints,options);
Runtime_Mins = toc / 60
x
fval
output