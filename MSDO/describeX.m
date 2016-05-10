PropOptions = {Propulsion.LH2, Propulsion.NTR}; %,Propulsion.CH4
StageOptions = {Location.LEO, Location.EML1, Location.EML2};  
TransFuelOptions = {[TransitFuel.EARTH_LH2,TransitFuel.EARTH_O2],[TransitFuel.EARTH_LH2,TransitFuel.LUNAR_O2],[TransitFuel.LUNAR_LH2,TransitFuel.LUNAR_O2]};
ReturnFuelOptions = {[ReturnFuel.EARTH_LH2, ReturnFuel.EARTH_O2],[ReturnFuel.EARTH_LH2,ReturnFuel.MARS_O2],[ReturnFuel.MARS_LH2,ReturnFuel.MARS_O2]};
EntryOptions = {ArrivalEntry.AEROCAPTURE, ArrivalEntry.PROPULSIVE}; 
SiteOptions = {Site.HOLDEN, Site.GALE, Site.MERIDIANI, Site.GUSEV, Site.ISIDIS, Site.ELYSIUM, Site.MAWRTH, Site.EBERSWALDE, Site.UTOPIA, Site.PLANUS_BOREUM, Site.HELLAS, Site.AMAZONIS};
SurfPowerOptions = {PowerSource.SOLAR,PowerSource.NUCLEAR,[PowerSource.NUCLEAR, PowerSource.SOLAR], [PowerSource.NUCLEAR, PowerSource.FUEL_CELL]};%, ...
CrewOptions = {SurfaceCrew.BIG_SURFACE, SurfaceCrew.MID_SURFACE, SurfaceCrew.MIN_SURFACE};
 
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
try
    CrewOptions{x(7)}
catch
    Crew = x(7)
end
EntryOptions{x(8)}% = Entry Type 2
SiteOptions{x(9)}% = Site 12
SurfPowerOptions{x(10)}% = Surface Power Source 4