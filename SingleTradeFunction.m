function [ Val ] = SingleTradeFunction (Cur_Arch)
%varargin {1} = food percentage on mars, in decimal percentage.
       
%% Begin Main Run
    i = Cur_Arch.Index;
    Results = Results_Class(i); %with the Arch_Num of i
    %% Logistics Setup %%
    
    %% --- Duration Module --- %%
    %{
    Inputs:
        Cur_Arch
            Trajectory in TrajectoryType
    Outputs:
        Trajectory Object
            Stay Duration in Days
            Outgoing Duration in Days
            Return Duration in Days
            Contingency Duration in Days
    %}
    %Trajectory_obj = Duration(Cur_Arch);
    
    %% --- Transit Hab Module --- %%
    %{
    Inputs:
        Cur_Arch
            Crew_Number in #
        Trajectory Object
            Stay Duration in Days
            Outgoing Duration in Days
            Return Duration in Days
            Contingency Duration in Days
        Overall Spacecraft Object
            empty
    Outputs:
        Overall Spacecraft Object
            Transit Hab
                Dry Mass
                Power
                Volume
    %}
    Results.HumanSpacecraft = Transit_Habitat(Cur_Arch, Results.HumanSpacecraft, Results);
    
    %% --- Earth Entry Module --- %%
    %{
    Inputs: 
        Cur_Arch
            Transit Crew Size in #
            Payload Mass and Volume (0 for now)
        Overall Spacecraft Object
    Outputs:
        Overall Spacecraft Object
            Earth Entry
                Habitable Mass
                Habitable Vol
                Bus Volume
                Bus Mass
    %}
    
    Earth_Entry = SC_Class('Earth Entry Module'); %initialize the Earth Entry Module
    Earth_Entry.Hab_Mass = Cur_Arch.TransitCrew.Size * 1570; %kg, based on (Apollo CM Mass - heat sheild mass) / astronaut
    Earth_Entry.Hab_Vol = Cur_Arch.TransitCrew.Size * 2.067; %based on Apollo hab vol / astronaut
    Earth_Entry.Payload_Vol = 0; %As yet undefined, and not a trade
    Earth_Entry.Payload_Mass = 0; %As yet undefined, and not a trade
    Earth_Entry.volume_calc; %populate the total volume
    Earth_Entry.Bus_Mass = Earth_Entry.Volume * 81.73; %size of HeatSheild, kg, based on Apollo, per total module volume
    Earth_Entry.drymass_calc; %populate the overall mass numbers
    Results.HumanSpacecraft.Add_Craft = Earth_Entry; %Add entry module to the S/C
    
    %% --- Return Transit Module --- %%
    %{
    Inputs:
        Cur_Arch
            Trajectory Class
        Spacecraft
            -Transit Habitat
            -Earth Entry
            Mass      
    Outputs:
        Spacecraft
            Return Engine Stage
        Results Object
            Mars ISRU requirements
    %}
    
    [Results.HumanSpacecraft, Results] = Return_Trans (Cur_Arch, Results.HumanSpacecraft, Results);
    
    %% --- Ascent Module --- %%
    %{
    Inputs:
        Cur_Arch
            Propulsion Type
        HumanSpacecraft
            EarthEntry Module
        Results
            Mars Fuel ISRU
            Mars Oxidizer ISRU
    
    Outputs:
        AscentSpacecraft
        HumanSpacecraft without reuseable Ascent/Descent Craft
        Results with updated ISRU fuel
    %}
    
    [Results.AscentSpacecraft, Results.HumanSpacecraft, Results] = Ascent (Cur_Arch, Results.HumanSpacecraft, Results);
       
    %% --- Surf Structure --- %%
    %{
    Inputs:
        Cur_Arch
    Outputs:
        Results
            Surface Mass
            Surface Volume
            Surface Power
    %}
    [Results, Food_Time, ECLSS_ISRU] = Surface_Habitat(Cur_Arch, Results);
    
    %% --- ECLSS Module --- %%
    %{
    Inputs:
        Cur_Arch
            Crew Number
        Results
            Surface_Habitat.Volume
    Outputs:
        Results
            ECLSS.Mass, Volume & Power
            ISRURequirements object
    %}
    %[Food_Time, ECLSS_ISRU, Results] = ECLSS (Cur_Arch, Results);
    %%%THIS HAS BEEN INCORPORATED INTO Surface_Habitat MODULE, is called on
    %%%line 121

  %% --- Site Selection Module --- %%
    %{
    Inputs:
        Cur_Arch
            SiteSelection
    Outputs:
        Site_Sci_Value
    %}
  
    [Site_Sci_Value, Site_Elevation, Site_Water_Percent, Site_Lat] = Site_Selection(Cur_Arch);
    
    %% --- Mars ISRU --- %%
    %{
    Inputs:
        Cur_Arch
        ISRURequirements object
        Results
            Fuel & Oxidizer_Output
    Outputs:
        Results
            ISRU.Mass, Volume & Power
    %}
    Results = ISRU(Cur_Arch, ECLSS_ISRU, Site_Water_Percent, Results);
  
    %% --- Surface Power Module --- %%
    %{
    Inputs:
        Cur_Arch
            Surface_Power
        Results
            ECLSS, Surface_Habitat & ISRU.Power
    Outputs:
        Results
            Surface_PowerPlant.Mass & Volume
    %}
    Results = MarsPower (Cur_Arch, Results, Site_Lat);
    %Results = Surface_Power (Cur_Arch, Results);
    %% --- ISFR and Sparing Module --- %%
    %{
    Inputs:
        Results
            Surface_Habitat, ECLSS, Mars_ISRU, PowerPlant.Mass
    Outputs:
        Results
            Surface_Habitat, ECLSS, Mars_ISRU, PowerPlant.Spares
    %}
    SparesRatio = 0.05; %percentage of Mass per Year, Leath and Green, 1993
    %Years per Synodic Cycle = 2.1d37, be able to convert to % mass per
    %resupply
    Synod = 2.137;
    
    Results.Surface_Habitat.Spares = Results.Surface_Habitat.Mass * SparesRatio * Synod;
    Results.ECLSS.Spares = Results.ECLSS.Mass * SparesRatio * Synod;
    Results.Mars_ISRU.Spares = Results.Mars_ISRU.Mass * SparesRatio * Synod;
    Results.PowerPlant.Spares = Results.PowerPlant.Mass * SparesRatio * Synod;
    
    %% --- Astronaut Time Module --- %%
    %{
    Inputs:
        Cur_Arch
            SurfaceCrew.Size
        Results
            Spares
    Outputs:
        Astronaut_Sci_Time
    %}
    [Results] = Astronaut_Time(Cur_Arch, Results, Food_Time);
    
    %% --- Descent --- %%
    %{
    Inputs:
        Cur_Arch
            TransitCrew.Size
        Results
            Spares
            Consumables
            Replacements
        Ascent_Vehicle
            Entry and Ascent Module
    Outputs:
        Descent_Craft
            MEAA Module
            Cargo Descenders
    %}
    
    [Results.AscentSpacecraft, Results.HumanSpacecraft, Results.CargoSpacecraft, Results.Num_CargoSpacecraft] = Descent(Cur_Arch, Results.AscentSpacecraft, Results.HumanSpacecraft, Results, Site_Elevation);
    %% --- Outgoing Transit --- %%
    %{
    Inputs:
        HumanSpacecraft
        CargoSpacecraft
        Cur_Arch
            HumanTrajectory
            CargoTrajectory
    Outputs:
        HumanSpacecraft
        CargoSpacecraft
    %}
    [Results.HumanSpacecraft] = NewTransit(Cur_Arch, Results.HumanSpacecraft, 'Human', Results);
    [Results.CargoSpacecraft] = NewTransit(Cur_Arch, Results.CargoSpacecraft, 'Cargo', Results);
    %% --- Lunar ISRU --- %%
    %{
    Inputs:
        Cur_Arch
            TransitFuel
        HumanSpacecraft
            Fuel_Mass
            Ox_Mass
        Results.CargoSpacecraft
            Fuel_Mass
            Ox_Mass
        Results
    Outputs:
        Results
        FerrySpacecraft
    %}
    if ~or(isequal(Cur_Arch.TransitFuel, [TransitFuel.EARTH_LH2, TransitFuel.EARTH_O2]),...
        isequal(Cur_Arch.TransitFuel, [TransitFuel.EARTH_O2, TransitFuel.EARTH_LH2])) % Only go through this if there is Lunar ISRU involved
        [Results.FerrySpacecraft, Results.HumanSpacecraft, Results.CargoSpacecraft, Results] = Lunar_ISRU (Cur_Arch, Results.HumanSpacecraft, Results.CargoSpacecraft, Results);
    end
    %% --- Staging Module --- %%
    HumanStageing = SC_Class('Staging Engines'); %should Initialize
    HumanStageing = Propellant_Mass(Cur_Arch.PropulsionType,HumanStageing,Hohm_Chart('LEO',Cur_Arch.Staging.Code),Results.HumanSpacecraft.Mass);
    if HumanStageing.Prop_Mass > 0 %if staging is LEO, skip the add
        Results.HumanSpacecraft.Add_Craft = HumanStageing;
    end
    
    CargoStageing = SC_Class('Staging Engines');
    CargoStageing = Propellant_Mass(Cur_Arch.PropulsionType,CargoStageing,Hohm_Chart('LEO',Cur_Arch.Staging.Code),nansum([Results.CargoSpacecraft.Mass, ...
        Results.FerrySpacecraft.Prop_Mass, ...%Needs to bring the non-Lunar ISRU prop mass to staging point for the Ferry
        Results.Lunar_ISRU.Spares])); %Needs to bring the Lunar Spares as well.
    if CargoStageing.Prop_Mass > 0 %if staging is LEO, skip the add
    Results.CargoSpacecraft.Add_Craft = CargoStageing;
    end
    
    Results.IMLEO = nansum([Results.HumanSpacecraft.Mass, (Results.CargoSpacecraft.Mass*Results.Num_CargoSpacecraft), Results.FerrySpacecraft.Prop_Mass, Results.Lunar_ISRU.Spares]);
%     disp(Results.IMLEO)

    %% --- Science Module --- %%
    %{
    Inputs:
        Results
            Astronaut_Sci_Time
            Site_Sci_Value
    Output:
        Results
            Science
    %}
    Results.Science = Site_Sci_Value * (Results.Science_Time * (10/65466));
    
    %% --- Costing Module --- %%
    %{
    Inputs:
        Cur_Arch
            Propulsion type
            Propulsion Isp
        Results
            Transfer Engine Mass
            Transfer Engine Static Mass
            IMLEO
    Output:
        Results
            Dev_Cost
            Launch_Cost
    %}
    Results.Dev_Cost = Development_Cost(Cur_Arch.PropulsionType.type, Cur_Arch.PropulsionType.Isp, Results.HumanSpacecraft.SC{5}.Eng_Mass, Results.HumanSpacecraft.SC{5}.Static_Mass);
    Results.Launch_Cost = Launch_Cost(Results.IMLEO); %$M
    
        %% --- Value Module --- %%
    %{
    Inputs:
        Results
            Science
            Dev_Cost
            Launch_Cost
    Output:
        Results
            Value
    %}
    Results.Value = Value(Results.Science, Results.Dev_Cost, Results.Launch_Cost); %ScienceUtility/$M
    plot(i,Results.Value,'x')
    hold on
 
    %% End Main Run
    
    Val = Results.Value;

end

