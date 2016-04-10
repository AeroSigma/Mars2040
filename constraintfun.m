function objective=constraintfun(x)

% [prop, power, location, food, crew]=x(:);

%variable bounds
xb(1,1:2)=[0,6]; %prop
xb(2,1:2)=[0,1];
xb(3,1:2)=[0,4];
xb(4,1:2)=[0,4];
xb(5,1:2)=[0,2];


i=length(x);
penalty=zeros(i);
xround=zeros(i);

for i=1:i
    if (x(i)< xb(i,1)) || (x(i) > xb(i,2))
        penalty(i)=100;
    end
    xround(i)=round(x(i));
    
    if i==1
        if xround(i)==0
            PropType=Propulsion.LH2;
            Input_Isp=445;
       
        elseif xround(i)==1
            PropType=Propulsion.LH2;
            Input_Isp=452;
        elseif xround(i)==2
            PropType=Propulsion.LH2;
            Input_Isp=465;   
        elseif xround(i)==3
            PropType=Propulsion.LH2;
            Input_Isp=480;
        elseif xround(i)==4
            PropType=Propulsion.NTR;
            Input_Isp=850;
        elseif xround(i)==5
            PropType=Propulsion.NTR;
            Input_Isp=950;
        elseif xround(i)==6
            PropType=Propulsion.NTR;
            Input_Isp=1000;
        end
    elseif i==2
        if xround(i)==0
            SurfPower=PowerSource.NUCLEAR;
        elseif xround(i)==1
            SurfPower=PowerSource.SOLAR;
        end
    elseif i==3
         if xround(i)==0
            Site=Site.HOLDEN;
        elseif xround(i)==1
            Site=Site.GALE;
         elseif xround(i)==2
            Site=Site.MERIDIANI;
        elseif xround(i)==3
            Site=Site.GUSEV;   
          elseif xround(i)==4
            Site=Site.EBERSWALDE;  
         end
    elseif i==4
        if xround(i)==0
            Food=FoodSource.EARTH_ONLY;
        elseif xround(i)==1
            Food=FoodSource.EARTH_MARS_50_SPLIT;
         elseif xround(i)==2
            Food=FoodSource.MARS_ONLY;
        elseif xround(i)==3
            Food=FoodSource.EARTH_MARS_25_75;   
          elseif xround(i)==4
            Food=FoodSource.EARTH_MARS_75_25;  
         end
    elseif i==5
        if xround(i)==0
           Crew=SurfaceCrew.BIG_SURFACE; %24
        elseif xround(i)==1
            Crew=SurfaceCrew.MID_SURFACE; %18
         elseif xround(i)==2
            Crew=SurfaceCrew.MIN_SURFACE; %12
        end
    end

objective=SingleTradeFunction(PropType, SurfPower, Site, Food, SurfCrew, Input_ISP);

        
        

end


