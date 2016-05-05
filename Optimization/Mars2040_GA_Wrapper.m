function [ Val ] =  Mars2040_GA_Wrapper ( x )
%This code takes the input variables from ga, and wraps in the parameters
%to correctly call the SingleTradeFunction
%% Input Order
%{
x(1) = Isp (0 to 1)
x(2) = food % grown on mars
x(3) = Propulsion Type 2
x(4) = Staging Location 3
x(5) = Transit Fuel Source 3
x(6) = Return Fuel Source 3
x(7) = Surface Crew Size 3
x(8) = Entry Type 2
x(9) = Site 12
x(10) = Surface Power Source 4
%}

%% Input Conversion

PropOptions = {Propulsion.LH2, Propulsion.NTR}; %,Propulsion.CH4
StageOptions = {Location.LEO, Location.EML1, Location.EML2};  
TransFuelOptions = {[TransitFuel.EARTH_LH2,TransitFuel.EARTH_O2],[TransitFuel.EARTH_LH2,TransitFuel.LUNAR_O2],[TransitFuel.LUNAR_LH2,TransitFuel.LUNAR_O2]};
ReturnFuelOptions = {[ReturnFuel.EARTH_LH2, ReturnFuel.EARTH_O2],[ReturnFuel.EARTH_LH2,ReturnFuel.MARS_O2],[ReturnFuel.MARS_LH2,ReturnFuel.MARS_O2]};
CrewOptions = {SurfaceCrew.BIG_SURFACE, SurfaceCrew.MID_SURFACE, SurfaceCrew.MIN_SURFACE};
EntryOptions = {ArrivalEntry.AEROCAPTURE, ArrivalEntry.PROPULSIVE}; 
SiteOptions = {Site.HOLDEN, Site.GALE, Site.MERIDIANI, Site.GUSEV, Site.ISIDIS, Site.ELYSIUM, Site.MAWRTH, Site.EBERSWALDE, Site.UTOPIA, Site.PLANUS_BOREUM, Site.HELLAS, Site.AMAZONIS};
SurfPowerOptions = {PowerSource.SOLAR,PowerSource.NUCLEAR,[PowerSource.NUCLEAR, PowerSource.SOLAR], [PowerSource.NUCLEAR, PowerSource.FUEL_CELL]};%, ...
        
%% Create the Architecture
%create Cur_Arch
Cur_Arch = MarsArchitecture.Enumerate( ...
    {PropOptions{x(3)}}, ...
    {SurfPowerOptions{x(10)}}, ...
    {SiteOptions{x(9)}}, ...
    {FoodSource.EARTH_ONLY},... changed Below
    {SurfaceCrew.BIG_SURFACE},...{CrewOptions{x(7)}}, ...
    {Crew.DRA_CREW},... changed Below
    {EntryOptions{x(8)}},... 
    {ArrivalDescent.AEROENTRY},... Fixed
    {TransFuelOptions{x(5)}},... 
    {StageOptions{x(4)}},... FIXED    
    {SurfaceShielding.REGOLITH}, ...FIXED 
    {ReturnFuelOptions{x(6)}},... 
    {ArrivalDescent.AEROENTRY}); %FIXED

%Correct the Variables
%Isp
switch x(3)
    case 1 %LH2
        new_Isp = 448 + x(1)*(480-448);
    case 2 %NTR
        new_Isp = 850 + x(1)*(1000-850);
end
Cur_Arch.PropulsionType.Isp = new_Isp;
        
%food supply
new_food_mars = x(2);
    Cur_Arch.FoodSupply = [FoodSource(Location.EARTH, 1-new_food_mars),...
        FoodSource(Location.MARS, new_food_mars)];
    
%Transit Crew
Cur_Arch.SurfaceCrew.Size = x(7);
Cur_Arch.TransitCrew.Size = ceil(Cur_Arch.SurfaceCrew.Size / 3);

%% Evaluate the Architecture
[ Val, ~ ] = SingleTradeFunction(Cur_Arch);

%function [ val ] = SingleTradeFunction (PropType, SurfPower, Site, 
%Food, SurfCrew, Input_ISP, varargin)

%Val = -Val;
%% Plot Results?
hold on
now = clock;
plot(-Val,(now(4)*12+now(5)+now(6)/60))

end