% J is provided by SingleTradeFunction
% [ Results.Value ] = SingleTradeFunction (PropType, SurfPower, Site, Food, SurfCrew, Input_ISP, varargin);

nvars = 10; %number of variables

%x_1 = ISP improvements, what percentage of max possible improvement
ISP_min = 0;
ISP_max = 1;

%x_2 = Food Percentage Grown on Mars, varargin for the input, in decimal
%percentage
Food_min = 0;
Food_max = 1;
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
LB = [ISP_min,Food_min,1,1,1,1,1,1,1,1];
UB = [ISP_max,Food_max,2,3,3,3,3,2,12,4];

intcon = [3 4 5 6 7 8 9 10]; %integer variables, the architectural options

%%Options
options = gaoptimset;
options.PopulationSize = 20;
options.CrossoverFraction = 0.85;
options.Generations = 400;
options.EliteCount = 2;
options.TolFun = [1e-6];
options.UseParallel = true;


tic
[x,fval,exitscores,output,population,scores] = ga(@Mars2040_GA_Wrapper,nvars,[],[],[],[],LB,UB, ...
    @NoConstraints,intcon, options);

%% results
Runtime_Mins = toc / 60
load gong.mat;
gong = audioplayer(y, Fs);
play(gong); 

PropOptions = {Propulsion.LH2, Propulsion.NTR}; %,Propulsion.CH4
StageOptions = {Location.LEO, Location.EML1, Location.EML2};  
TransFuelOptions = {[TransitFuel.EARTH_LH2,TransitFuel.EARTH_O2],[TransitFuel.EARTH_LH2,TransitFuel.LUNAR_O2],[TransitFuel.LUNAR_LH2,TransitFuel.LUNAR_O2]};
ReturnFuelOptions = {[ReturnFuel.EARTH_LH2, ReturnFuel.EARTH_O2],[ReturnFuel.EARTH_LH2,ReturnFuel.MARS_O2],[ReturnFuel.MARS_LH2,ReturnFuel.MARS_O2]};
CrewOptions = {SurfaceCrew.BIG_SURFACE, SurfaceCrew.MID_SURFACE, SurfaceCrew.MIN_SURFACE};
EntryOptions = {ArrivalEntry.AEROCAPTURE, ArrivalEntry.PROPULSIVE}; 
SiteOptions = {Site.HOLDEN, Site.GALE, Site.MERIDIANI, Site.GUSEV, Site.ISIDIS, Site.ELYSIUM, Site.MAWRTH, Site.EBERSWALDE, Site.UTOPIA, Site.PLANUS_BOREUM, Site.HELLAS, Site.AMAZONIS};
SurfPowerOptions = {PowerSource.SOLAR,PowerSource.NUCLEAR,[PowerSource.NUCLEAR, PowerSource.SOLAR], [PowerSource.NUCLEAR, PowerSource.FUEL_CELL]};%, ...
        
disp(['Isp = ',num2str(x(1))]);
disp(['Food_On_Mars = ',num2str(x(2))]);
PropOptions{x(3)}.type
StageOptions{x(4)}
disp('Transit Fuel:')
TransFuelOptions{x(5)}(1).Location
TransFuelOptions{x(5)}(1).Name
TransFuelOptions{x(5)}(2).Location
TransFuelOptions{x(5)}(2).Name
disp('Return Fuel:')
ReturnFuelOptions{x(6)}(1).Location 
ReturnFuelOptions{x(6)}(1).Name 
ReturnFuelOptions{x(6)}(2).Location 
ReturnFuelOptions{x(6)}(2).Name 
CrewOptions{x(7)}% = Surface Crew Size 3
EntryOptions{x(8)}% = Entry Type 2
SiteOptions{x(9)}% = Site 12
SurfPowerOptions{x(10)}% = Surface Power Source 4
fval
output

