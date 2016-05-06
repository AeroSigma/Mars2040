function objective=constraintfun(x)

% [prop, power, location, food, crew]=x(:);

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

i=length(x);
penalty=zeros(1,i);
xround=zeros(1,i);

for i=1:length(x)
    if (x(i)< xb(i,1))
        penalty(i)=100;
        x(i) = xb(i,1);
    end
    if (x(i) > xb(i,2))
        penalty(i)=100;
        x(i) = xb(i,2);
    end
    xround(i)=round(x(i));
    
    if i==1
        if xround(i)==0
            PropType=1;%Propulsion.LH2;
            Input_Isp=0; %445s
        elseif xround(i)==1
            PropType=1;%Propulsion.LH2;
            Input_Isp=0.2; %452s
        elseif xround(i)==2
            PropType=1;%Propulsion.LH2;
            Input_Isp=20/35; %465s   
        elseif xround(i)==3
            PropType=1;%Propulsion.LH2;
            Input_Isp=1; %480s
        elseif xround(i)==4
            PropType=2;%Propulsion.NTR;
            Input_Isp=0; %850s
        elseif xround(i)==5
            PropType=2;%Propulsion.NTR;
            Input_Isp=2/3; %950s
        elseif xround(i)==6
            PropType=2;%Propulsion.NTR;
            Input_Isp=1; %1000s
        end
    elseif i==2
        if xround(i)==0
            SurfPower=2;%PowerSource.NUCLEAR;
        elseif xround(i)==1
            SurfPower=1;%PowerSource.SOLAR;
        elseif xround(i)==2
            SurfPower=3;%[PowerSource.NUCLEAR, PowerSource.SOLAR];
        elseif xround(i)==3
            SurfPower=4;%[PowerSource.NUCLEAR, PowerSource.FUEL_CELL];
        end
    elseif i==3   %indicies reordered to avoid local minimums
         if xround(i)==1
            Loc=1; %Site.HOLDEN;
         elseif xround(i)==3
            Loc=2; %Site.GALE;
         elseif xround(i)==7
            Loc=3; %Site.MERIDIANI;
         elseif xround(i)==0
            Loc=4; %Site.GUSEV;   
         elseif xround(i)==2
            Loc=8; %Site.EBERSWALDE;  
         elseif xround(i)==11
            Loc=5; %ISIDIS
         elseif xround(i)==9
            Loc=6; %ELYSIUM
         elseif xround(i)==4
            Loc=7; %MAWRTH
         elseif xround(i)==5
            Loc=9; %UTOPIA
         elseif xround(i)==8
            Loc=10; %PLANUS_BOREUM
         elseif xround(i)==6
            Loc=11; %HELLAS
         elseif xround(i)==10
            Loc=12; %AMAZONIS
         end
    elseif i==4  %indicies reordered to avoid local minimums
        if xround(i)==0
            Food=0; %FoodSource.EARTH_ONLY;
        elseif xround(i)==2
            Food=0.5; %FoodSource.EARTH_MARS_50_SPLIT;
        elseif xround(i)==4
            Food=1; %FoodSource.MARS_ONLY;
        elseif xround(i)==3
            Food=0.75; %FoodSource.EARTH_MARS_25_75;   
        elseif xround(i)==1
            Food=0.25; %FoodSource.EARTH_MARS_75_25;  
        end
    elseif i==5
        if xround(i)==0
           SurfCrew=1; %SurfaceCrew.BIG_SURFACE; %24
        elseif xround(i)==1
           SurfCrew=2; %SurfaceCrew.MID_SURFACE; %18
        elseif xround(i)==2
           SurfCrew=3; %SurfaceCrew.MIN_SURFACE; %12
        end
    elseif i==6
        if xround(i)==0
           TransFuel=1; %[TransitFuel.EARTH_LH2,TransitFuel.EARTH_O2];
        elseif xround(i)==1
           TransFuel=2; %[TransitFuel.EARTH_LH2,TransitFuel.LUNAR_O2];
        elseif xround(i)==2
           TransFuel=3; %[TransitFuel.LUNAR_LH2,TransitFuel.LUNAR_O2];
        end
    elseif i==7
        if xround(i)==0
           ReturnFuel=1; %[ReturnFuel.EARTH_LH2, ReturnFuel.EARTH_O2];
        elseif xround(i)==1
           ReturnFuel=2; %[ReturnFuel.EARTH_LH2,ReturnFuel.MARS_O2];
        elseif xround(i)==2
           ReturnFuel=3; %[ReturnFuel.MARS_LH2,ReturnFuel.MARS_O2];
        end
    elseif i==8
        if xround(i)==0
           EntryType=1; %ArrivalEntry.AEROCAPTURE;
        elseif xround(i)==1
           EntryType=2; %ArrivalEntry.PROPULSIVE;
        end
    elseif i==9
        if xround(i)==0
           Staging=1; %Location.LEO;
        elseif xround(i)==1
           Staging=2; %Location.EML1;
        elseif xround(i)==2
           Staging=3; %Location.EML2;
        end
    end
end

value=Mars2040_GA_Wrapper([Input_Isp, Food, PropType, Staging, TransFuel, ReturnFuel, SurfCrew, EntryType, Loc, SurfPower]);


objective=-value+sum(penalty);

        

end


