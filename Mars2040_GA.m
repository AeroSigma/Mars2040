% J is provided by SingleTradeFunction
% [ Results.Value ] = SingleTradeFunction (Cur_Arch, ISRU_e, Input_ISP, foodperc)

%x_1 = food

%subject to:
xmin = -5;
xmax = 5;
LB = [xmin,xmin,xmin];
UB = [xmax,xmax,xmax];

nvars = 3; %number of variables

%%Options
options = gaoptimset;
options.PopulationSize = 50;
options.CrossoverFraction = 0.70;
options.Generations = [];
options.EliteCount = 1;
options.TolFun = [1e-9];


tic
[x,fval,exitscores,output,population,scores] = ga(@SimpleTradeFunction,nvars,[],[],[],[],LB,UB, ...
    @gee,options);
toc
x
fval
output