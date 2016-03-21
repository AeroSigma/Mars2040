%% Architectures
% a_transCrew = {Crew.DRA_CREW, Crew.DEFAULT_TRANSIT},...don't use, do below
% a_surfCrew = {SurfaceCrew.BIG_SURFACE, SurfaceCrew.MID_SURFACE, SurfaceCrew.MIN_SURFACE}, ... don't use this, use below?

%the cell arrays define the possibilities of alpha
%the values for a_vec define the current alpha
%the values for a_vec.XXXXXmax set the max choice

a_prop = {Propulsion.LH2, Propulsion.NTR}; 
a_vec.prop = 1;
a_vec.propmax = length(a_prop);

a_returnFuel = {[ReturnFuel.EARTH_LH2, ReturnFuel.EARTH_O2],[ReturnFuel.EARTH_LH2,ReturnFuel.MARS_O2],[ReturnFuel.MARS_LH2,ReturnFuel.MARS_O2], [ReturnFuel.ASCENT_LH2, ReturnFuel.ASCENT_O2]};
a_vec.returnFuel = 1;
a_vec.returnFuelmax = length(a_returnFuel);

a_surfPower = {PowerSource.NUCLEAR, PowerSource.SOLAR};
a_vec.surfPower = 1;
a_vec.surfPowermax = length(a_surfPower);

a_entry = {ArrivalEntry.AEROCAPTURE, ArrivalEntry.PROPULSIVE};
a_vec.entry = 1;
a_vec.entrymax = length(a_entry);

a_site = {Site.HOLDEN, Site.GALE, Site.MERIDIANI, Site.GUSEV, Site.ISIDIS, Site.ELYSIUM, Site.MAWRTH, Site.EBERSWALDE, Site.UTOPIA, Site.HELLAS, Site.AMAZONIS};
a_vec.site = 1;
a_vec.sitemax = length(a_site);

a_food = {FoodSource.EARTH_MARS_50_SPLIT,FoodSource.MARS_ONLY,FoodSource.EARTH_MARS_25_75, FoodSource.EARTH_MARS_75_25};
a_vec.food = 1;
a_vec.foodmax = length(a_food);

%this generates the current architecture based on the a_vec vector
Cur_Arch = MarsArchitecture.Enumerate( ...
    {Location.LEO}, ... 
    {SurfaceCrew.MID_SURFACE}, ...
    {SurfaceShielding.REGOLITH}, ...
    {Crew.DRA_CREW}, ...
    {[TransitFuel.EARTH_LH2,TransitFuel.LUNAR_O2]}, ...
    {ArrivalCargoEntry.AEROCAPTURE}, ...
    {a_prop{a_vec.prop}}, {a_returnFuel{a_vec.returnFuel}}, {a_surfPower{a_vec.surfPower}}, ...
    {a_entry{a_vec.entry}}, {a_site{a_vec.site}}, {a_food{a_vec.food}} ...
    );

%% How to change propulsion numbers
% Cur_Arch.Propulsion.Isp = 450;
% Cur_Arch.Propulsion.InertMassRatio = 0.15;
% Cur_Arch.Propulsion.StaticMass = 34000;
%% How to change Surface Crew size
% Cur_Arch.SurfaceCrew.Size = 32;

%% How to change Transit Crew size
% Cur_Arch.TransitCrew.Size = 4;

%% Set the ISRU efficiency
% ISRU_e = 0.15; %decimal percentage IMPROVEMENT in ISRU efficiency

%% Run the Simulation

% [Results] = SingleTradeFunction(Cur_Arch, ISRU_e);