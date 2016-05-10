clear all
close all

% [prop, power, location, food, crew]=x(:);

%variable bounds
xb(1,1:2)=[0,6]; %prop
xb(2,1:2)=[0,1];
xb(3,1:2)=[0,4];
xb(4,1:2)=[0,4];
xb(5,1:2)=[0,2];

N=0;
varnum=size(xb,1);

for i=1:(xb(1,2)+1) %prop
    for j=1:(xb(2,2)+1) %power
        for k=(1:xb(3,2)+1) %location
            for l=(1:xb(4,2)+1) %food
               for m=(1:xb(5,2)+1) %crew
                   
                   N=N+1 %architecture count
                  
                   x(N,1:varnum+1)=[i-1,j-1,k-1,l-1,m-1,N]; %set design vector
                   
                    %Set design vector variable names 
                    if x(N,1)==0
                        PropType=Propulsion.LH2;
                        Input_Isp=445;
                    elseif x(N,1)==1
                        PropType=Propulsion.LH2;
                        Input_Isp=452;
                    elseif x(N,1)==2
                        PropType=Propulsion.LH2;
                        Input_Isp=465;   
                    elseif x(N,1)==3
                        PropType=Propulsion.LH2;
                        Input_Isp=480;
                    elseif x(N,1)==4
                        PropType=Propulsion.NTR;
                        Input_Isp=850;
                    elseif x(N,1)==5
                        PropType=Propulsion.NTR;
                        Input_Isp=950;
                    elseif x(N,1)==6
                        PropType=Propulsion.NTR;
                        Input_Isp=1000;
                    end

                    if x(N,2)==0
                        SurfPower=PowerSource.NUCLEAR;
                    elseif x(N,2)==1
                        SurfPower=PowerSource.SOLAR;
                    end

                    if x(N,3)==0
                        Loc=Site.HOLDEN;
                    elseif x(N,3)==1
                        Loc=Site.GALE;
                     elseif x(N,3)==2
                        Loc=Site.MERIDIANI;
                    elseif x(N,3)==3
                        Loc=Site.GUSEV;   
                      elseif x(N,3)==4
                        Loc=Site.EBERSWALDE;  
                     end

                    if x(N,4)==0
                        Food=FoodSource.EARTH_ONLY;
                    elseif x(N,4)==1
                        Food=FoodSource.EARTH_MARS_50_SPLIT;
                     elseif x(N,4)==2
                        Food=FoodSource.MARS_ONLY;
                    elseif x(N,4)==3
                        Food=FoodSource.EARTH_MARS_25_75;   
                      elseif x(N,4)==4
                        Food=FoodSource.EARTH_MARS_75_25;  
                     end

                    if x(N,5)==0
                       SurfCrew=SurfaceCrew.BIG_SURFACE; %24
                    elseif x(N,5)==1
                        SurfCrew=SurfaceCrew.MID_SURFACE; %18
                     elseif x(N,5)==2
                        SurfCrew=SurfaceCrew.MIN_SURFACE; %12
                    end
                  
                    %Evaluate design
                    [value, science, dev_cost, launch_cost] = fullfactSingleTradeFunction(PropType, SurfPower, Loc, Food, SurfCrew, Input_Isp);
                
                    %Record Evaluation
                    x(N,(varnum+2):(varnum+5))=[value, science, dev_cost, launch_cost]; %set design vector
                    
                    
               end
            end
        end
    end
end

x_sort_val = sortrows(x,varnum+2);
x_sort_val = flipud(x_sort_val);
x_sort_science =sortrows(x,varnum+3);
x_sort_dev_cost = sortrows(x,varnum+4);

plot(x(:, 1), x(:, varnum+2), 'x');
     


    

  



