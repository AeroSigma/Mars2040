function [ spacecraft, Results ] = NewTransit( Cur_Arch, spacecraft, type, Results)
%NEWTRANSIT Summary of this function goes here
%   Detailed explanation goes here

%swap trajectory based on type
switch type
    case 'Human'
        Cur_Trajectory = Cur_Arch.CrewTrajectory;
    case 'Cargo'
        Cur_Trajectory = Cur_Arch.CargoTrajectory;
end

%% Mars Capture
Cap_Stage = SC_Class('Mars Capture');
switch Cur_Arch.OrbitCapture
% switch Cur_Arch.MarsCapture %Define Capture Stage craft     
    case ArrivalEntry.AEROCAPTURE   %Based on AeroCapture AeroShell Mass
        Capture_Time = 30; %days based on DRA 5.0?
        Cap_Stage.Bus_Mass = 66100; % Based on DRA 5.0, including payload fairing & adapter
    case ArrivalEntry.PROPULSIVE %Based on Propulsive Capture Engines
        Capture_Time = 0; %Don't need to wait in circularization
        Cap_Stage = Propellant_Mass(Cur_Arch.PropulsionType, Cap_Stage, Hohm_Chart('TMI','LMO'), spacecraft.Mass);
end
spacecraft.Add_Craft = Cap_Stage;


%% Transit Engines
%set Earth staging location
switch Cur_Arch.Staging
    case Location.LEO
        stage = 'LEO';
    case Location.EML1
        stage = 'EML1';
    case Location.EML2
        stage = 'EML2';
end
switch Cur_Trajectory.Type
    case TrajectoryType.HOHMANN.Type
        Rotation_Period = 540; %days based on DRA 5.0 Exec Summary
        Trans_Eng = SC_Class('Transit Engines');
        Trans_Eng = Propellant_Mass(Cur_Arch.PropulsionType,Trans_Eng,Hohm_Chart(stage,'TMI'),spacecraft.Mass);
        spacecraft.Add_Craft = Trans_Eng;
    case TrajectoryType.ELLIPTICAL.Type
        disp('too bad')
end

%% Update to Astronaut_Sci_Time
if type == 'Human'
    Results.Science_Time = Results.Science_Time * Rotation_Period ... now it's in CM-days/Rotation Period
        - Capture_Time * Cur_Arch.TransitCrew.Size; %and subtract the CMs stuck in capture
end

end

