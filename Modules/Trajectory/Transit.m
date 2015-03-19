function [ IMLEO ] = Transit( Cur_Arch, Descent_SC, Trans_SC, MissionType )
%TRANSIT Solving for the Mass to Orbit based on the staging points and fuel
%sources, this is for the outgoing leg
%   Cur_Arch is the Architecture object for the current architecture,
%   Descent_SC in the spacecraft that descends to Mars Surface based on EDL
%   module, Trans_SC is the partially complete spacecraft from the Return
%   leg module, and Mission Type defines whether this is a human or cargo
%   mission.

%% ------Inputs and ititializations------
%Initialize the propulsion class from the current architecture
switch char(Cur_Arch.PropulsionType)
    case 'LH2'
        Cur_Prop = Propulsion.LH2;
    case 'NTR'
        Cur_Prop = Propulsion.NTR;
    case 'SEP'
        Cur_Prop = Propulsion.SEP;
    case 'CH4'
        Cur_Prop = Propulsion.CH4;
    otherwise
        disp('Bad Architecture')
end

%Initialize the spacecrafts
switch MissionType
    case 'Human'
        switch Cur_Arch.TransitTrajectory
            case 'Hohmann'
                Arrival_SC = Trans_SC; %Copy transit vehicle from earlier
                 %add descent vehicle and trans vehicle together
                Arrival_SC.Payload_Mass = (Descent_SC.Origin_Mass - Descent_SC.Hab_Mass) + Arrival_SC.Payload_Mass;
                Arrival_SC.Hab_Mass = Descent_SC.Hab_Mass + Arrival_SC.Hab_Mass;
                Arrival_SC.Hab_Vol = Descent_SC.Hab_Vol + Arrival_SC.Hab_Vol;
                
                Departure_Stage = SC_Class(Arrival_SC.Origin_Mass,0,'Departure Stage to Trans-Mars Injection');
            case 'Elliptic' %should be same as Hohmann
                Arrival_SC = SC_Class(Descent_SC.Origin_Mass,0,'Arrival Vehicle without Depart Stage');
                Departure_Stage = SC_Class(Arrival_SC.Origin_Mass,0,'Departure Vehicle');
            case 'Cycler_1L1'
                Taxi = SC_Class;
            case 'Cycler_2L3'
            otherwise
                disp('Human Mission, Transit Trajectory error')
        end
    case 'Cargo'
        switch Cur_Arch.TransitTrajectory
            case 'Hohmann'
                Arrival_SC = SC_Class(Descent_SC.Origin_Mass,0,'Arrival Vehicle without Depart Stage');
                Departure_Stage = SC_Class(Arrival_SC.Origin_Mass,0,'Departure Vehicle');
            case 'Spiral'
            otherwise 
                disp('Cargo Mission, Cargo Trajectory error')
        end
    otherwise
        disp('Mission Type error') 
end
            
%Initialize the Strings

Stage_Point = char(Cur_Arch.Staging); %co   nvert architecture 'location' type to string

%% Get the spacecraft at departure based on the selected transit orbit

switch Cur_Arch.TransitTrajectory
    case 'Hohmann'
        switch Cur_Arch.OrbitCapture
            case 'PropulsiveCapture'
                %arrival stage
                dV = Hohm_Chart('TMI','LMO'); %lookup final (arrival) stage in the dV in the Hohmann chart
                Arrival_SC = Propellant_Mass(Cur_Prop, Arrival_SC, dV); %Calc the S/C
               
                %departure stage
                dV = Hohm_Chart(Stage_Point,'TMI'); %lookup dV to get from stage point to Trans Mars Injection
                Departure_Stage.Payload_Mass = Arrival_SC.Origin_Mass; %update departure stage payload
                Departure_Stage = Propellant_Mass(Cur_Prop,Departure_Stage, dV); %Determine Departure Stage Fuel and Engine masses
            case 'Aerocapture'
                %should be capture code that outputs SC_Inst with mass to mars approach
                dV = Hohm_Chart(Stage_Point,'TMI');%lookup dV to mars approach
                Dep_Mass = Propellant_Mass(Cur_Prop, SC_Inst, dV); %Calc SC_Inst properties to get to aerocapture point (Mars Approach)
        end
    case 'Cycler_1L1'
        Approach_Vinf = 9.75; % McConaghy, Longuski & Byrnes
        Departure_Vinf = 6.54;% McConaghy, Longuski & Byrnes
        disp('Not Yet')
    case 'Cycler_2L3'
        Approach_Vinf = 3.05; % McConaghy, Longuski & Byrnes
        Departure_Vinf = 5.65; % McConaghy, Longuski & Byrnes
        disp('Not Yet')
    case 'Elliptical'
        disp('Not Yet')
end


%% Fuel Depot Section
%Use the departure fuel needs and S/C mass to calc getting fuel to the S/C from the appropriate source
switch Cur_Arch.TransitFuel
    case 'Earth'
        Stage_From_Earth = SC_Class(Departure_Stage.Origin_Mass,0,'S/C to get departure craft to staging point');
        Stage_From_Earth = Propellant_Mass(Cur_Prop, Stage_From_Earth, Hohm_Chart('LEO',Stage_Point)); %Get Departure Mass (already fueled up) to Staging Point
        IMLEO = Stage_From_Earth.Origin_Mass;
    case 'Lunar_O2'
        %Get the Fuel to the staging point
        Fuel_Mass = Departure_Stage.Fuel_Mass; %this much fuel
        Fuel_Transport = SC_Class(Fuel_Mass,0,'Fuel Transport Vehicle, Moon to stage');
        Fuel_Transport = Propellant_Mass(Cur_Prop, Fuel_Transport, Hohm_Chart('Moon',Stage_Point)); %Plus this propellant from moon to stage
        Ox_to_Moon = Fuel_Transport.Ox_Mass; %Need this Ox shipped from IMLEO as Propellant for fuel transport
        Ox_Transport = SC_Class(Ox_to_Moon,0,'Ox Transport Vehicle, Leo to Moon');
        Ox_Transport = Propellant_Mass(Cur_Prop, Ox_Transport, Hohm_Chart('LEO','Moon')); %IMLEO of Ox to moon plus dV to get there
        
        %Get the Oxidizer and S/C to the staging point
        Unfueled_Mass = Departure_Stage.Origin_Mass - Departure_Stage.Fuel_Mass; %this much S/C with oxidizer to combine with the fuel from the moon
        Stage_From_Earth = SC_Class(Unfueled_Mass,0,'complete S/C without Fuel, LEO to staging point');
        Stage_From_Earth = Propellant_Mass(Cur_Prop, Stage_From_Earth, Hohm_Chart('LEO',Stage_Point)); %IMLEO of S/C with Ox but no Fuel, plus dV to get to staging
        
        %Sum IMLEO to get everything to staging point
        IMLEO = Ox_Transport.Origin_Mass + Stage_From_Earth.Origin_Mass; %Ox_Moon_IMLEO pushes fuel from moon to staging, Stage_From_Earth is the S/C without fuel at the staging point
    case 'Lunar_Fuel'
        disp('Not yet')
    case 'Lunar_all'
        disp('Not yet')
end
end