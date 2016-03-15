%% Architectures
load(MorphArches.mat); %Now have Morph as a variable
%need to figure out how to modify vars. Just i +/- 1 each time?  Search for
%other Arches with all same except var of note?
% alpha = Morph{i}; %Will be, once we figure out how to step through i

%could go this way, start with baseline, and alter vars independantly,
%straightforward, but a _lot_ of copy/paste.
% alpha = MarsArchitecture();
% alpha.WHATEVER = SOMETHING;

%% How to change propulsion numbers
% TempProp = Cur_Arch.PropulsionType;
% Cur_Arch.PropulsionType.Isp = 450; %seconds
% TempProp.FuelOxRatio = 6; %shouldn't change
% TempProp.IntertMassRatio = 0.17; %ratio (decimal percent)
% TempProp.StaticMass = 0; %kg
% Cur_Arch.PropulsionType = TempProp;

%% How to change Surface Crew size
% Cur_Arch.SurfaceCrew.Size = 32;

%% How to change Transit Crew size
% Cur_Arch.TransitCrew.Size = 4;

%% Set the ISRU efficiency
% ISRU_e = 0.15; %decimal percentage IMPROVEMENT in ISRU efficiency

%% Run the Simulation

[Results] = SingleTradeFunction(alpha, ISRU_e);