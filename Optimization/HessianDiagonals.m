clear all
close all

%Calculate Hessian diagonals (second derivatives) for Mars2040 trade study.
%f''(x)=(f(x-dx)-2f(x)+f(x+dx))/dx^2 (central)
%f''(x)=(f(x+2dx)-2f(x+dx)+f(x))/dx^2 (forward)
% f''(x)=(f(x-2dx)-2f(x-dx)+f(x))/dx^2 (backward)

%DEFINITIONS FROM MARS2040_GA_WRAPPER.M
% x(1) = Isp
% x(2) = food % grown on mars
% x(3) = Propulsion Type
% x(4) = Staging Location
% x(5) = Transit Fuel Source
% x(6) = Return Fuel Source
% x(7) = Surface Crew Size
% x(8) = Entry Type
% x(9) = Site 
% x(10) = Surface Power Source

% PropOptions = {Propulsion.LH2, Propulsion.NTR}; %,Propulsion.CH4
% StageOptions = {Location.LEO, Location.EML1, Location.EML2};  
% TransFuelOptions = {[TransitFuel.EARTH_LH2,TransitFuel.EARTH_O2],[TransitFuel.EARTH_LH2,TransitFuel.LUNAR_O2],[TransitFuel.LUNAR_LH2,TransitFuel.LUNAR_O2]};
% ReturnFuelOptions = {[ReturnFuel.EARTH_LH2, ReturnFuel.EARTH_O2],[ReturnFuel.EARTH_LH2,ReturnFuel.MARS_O2],[ReturnFuel.MARS_LH2,ReturnFuel.MARS_O2]};
% CrewOptions = {SurfaceCrew.BIG_SURFACE, SurfaceCrew.MID_SURFACE, SurfaceCrew.MIN_SURFACE};
% EntryOptions = {ArrivalEntry.AEROCAPTURE, ArrivalEntry.PROPULSIVE}; 
% SiteOptions = {Site.HOLDEN, Site.GALE, Site.MERIDIANI, Site.GUSEV, Site.ISIDIS, Site.ELYSIUM, Site.MAWRTH, Site.EBERSWALDE, Site.UTOPIA, Site.PLANUS_BOREUM, Site.HELLAS, Site.AMAZONIS};
% SurfPowerOptions = {PowerSource.SOLAR,PowerSource.NUCLEAR,[PowerSource.NUCLEAR, PowerSource.SOLAR], [PowerSource.NUCLEAR, PowerSource.FUEL_CELL]};%, ...

% %Define maximum indices
% xbnd(1) = 7; %Isp and Propulsion Type
% xbnd(2) = 5; %food % grown on mars
% xbnd(3) = 0; %Propulsion Type - just leave zero for now
% xbnd(4) = 3; %Staging Location
% xbnd(5) = 3; %Transit Fuel Source
% xbnd(6) = 3; %Return Fuel Source
% xbnd(7) = 3; %Surface Crew Size
% xbnd(8) = 2; %Entry Type
% xbnd(9) = 12; %Site 
% xbnd(10) = 4; %Surface Power Source

% %Define optimium point xstar
% xstar(1) = 1; %Isp and Propulsion Type
% xstar(2) = 1; %food % grown on mars
% xstar(3) = 0; %Propulsion Type
% xstar(4) = 1; %Staging Location
% xstar(5) = 1; %Transit Fuel Source
% xstar(6) = 1; %Return Fuel Source
% xstar(7) = 1; %Surface Crew Size
% xstar(8) = 1; %Entry Type
% xstar(9) = 1; %Site 
% xstar(10) = 1; %Surface Power Source

%variable bounds
xb(1,1:2)=[0,6]; %propulsion (ISP and type)
xb(2,1:2)=[0,3]; %surface power
xb(3,1:2)=[0,11]; %location
xb(4,1:2)=[0,4]; %food
xb(5,1:2)=[0,2]; %crew
xb(6,1:2)=[0,2]; %Transit Fuel Source
xb(7,1:2)=[0,2]; %Return Fuel Source
xb(8,1:2)=[0,1]; %Entry Type
xb(9,1:2)=[0,2]; %Staging Location

%variable bounds
xstar(1)=0; %propulsion (ISP and type)
xstar(2)=2; %surface power
xstar(3)=0; %location
xstar(4)=0; %food
xstar(5)=0; %crew
xstar(6)=2; %Transit Fuel Source
xstar(7)=2; %Return Fuel Source
xstar(8)=0; %Entry Type
xstar(9)=0; %Staging Location

%Calculate f'' for each variable
for i=1:length(xstar)
    if xb(i,2)<=1 %if only two options, f''=0;
        myHess(i)=0;
    elseif xstar(i)-1 < xb(i,1) %f''(x)=(f(x+2dx)-2f(x+dx)+f(x))/dx^2 (forward)
        x=xstar;
        xpdx=xstar;
        xpdx(i)=xpdx(i)+1;
        xp2dx=xstar;
        xp2dx(i)=xp2dx(i)+2;
        dx=1;
        fx=constraintfun(x);
        fpdx=constraintfun(xpdx);
        fp2dx=constraintfun(xp2dx);
        myHess(i)=(fp2dx-2*fpdx+fx)/dx^2;
    elseif xstar(i)+1 > xb(i,2) % f''(x)=(f(x-2dx)-2f(x-dx)+f(x))/dx^2 (backward)
        x=xstar;
        xmdx=xstar;
        xmdx(i)=xmdx(i)-1;
        xm2dx=xstar;
        xm2dx(i)=xm2dx(i)-2;
        dx=1;
        fx=constraintfun(x);
        fmdx=constraintfun(xmdx);
        fm2dx=constraintfun(xm2dx);
        myHess(i)=(fm2dx-2*fmdx+fx)/dx^2;
    else %f''(x)=(f(x-dx)-2f(x)+f(x+dx))/dx^2 (central)
        x=xstar;
        xmdx=xstar;
        xmdx(i)=xmdx(i)-1;
        xpdx=xstar;
        xpdx(i)=xpdx(i)+1;
        dx=1;
        fx=constraintfun(x);
        fmdx=constraintfun(xmdx);
        fpdx=constraintfun(xpdx);
        myHess(i)=(fmdx-2*fx+fpdx)/dx^2;        
    end
    
end

 myHess=myHess*10^5
 
 
 condition=max(myHess)/min(myHess)
