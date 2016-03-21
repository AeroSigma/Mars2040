%% Propulsion class defining characteristics of a specific propulsion type
classdef Propulsion   
    %% the shorthand name of the propulsion type
    properties (GetAccess = public)
       
        % this should be a 3 character representation of the type, such as
        % 'LH2' for liquid hydrogen chemical rockets or 'NTR' for NTR
        type;
    end
    
    %% characteristic properties of propulsion type
    properties (SetAccess = public, GetAccess = public)
        % specific impulse of the propulsion type (or typical average)
        Isp
        
        % fuel to oxidizer ration, that characterizes the amount of oxider required per part of fuel
        % dimensionless since this is a part ratio
        FuelOxRatio
        
        % ratio describing the amount of mass required for engine and fuel storage as compared to propellant mass
        InertMassRatio
        
        % any fixed amount of mass required for engines, fuel, fuel storage, or anything else specific to propulsion
        StaticMass
    end
    
    %% Private Properties for internal number storage
    properties (Access = private)
        IspINT
        FuelOxRatioINT
        InertMassRatioINT
        StaticMassINT
    end

    methods
        %% Propulsion constructor
        function obj = Propulsion(typeName)
            % verify we have correct type input
            if nargin > 0 && ischar(typeName)
                % lookup type for provided propulsion, set type to 3
                % character value
                switch upper(typeName)
                    case 'LH2'
                        obj.type = 'LH2';
                        obj.IspINT = 448;
                        obj.FuelOxRatioINT = 6;
                        obj.InertMassRatioINT = 0.17;
                        obj.StaticMassINT = 0;
                    case 'NTR'
                        obj.type = 'NTR';
                        obj.IspINT = 850;
                        obj.FuelOxRatioINT = 0;
                        obj.InertMassRatioINT = 0.1;
                        obj.StaticMassINT = 34500;
                    case 'SEP'
                        obj.type = 'SEP';
                        obj.IspINT = 3000;
                        obj.FuelOxRatioINT = 1;
                        obj.InertMassRatioINT = 0.18;
                        obj.StaticMassINT = 0;
                    case 'CH4'
                        obj.type = 'CH4';
                        obj.IspINT = 280;
                        obj.FuelOxRatioINT = 2.93;
                        obj.InertMassRatioINT = 0.2;
                        obj.StaticMassINT = 0;
                end %switch
            end %if good inputs
        end %constructor
        
        %% Propulsion class display method overload
        function disp(obj)
           % verify we have correct inputs to get Isp
           if nargin > 0 && isa(obj,'Propulsion')
               disp(['           type : ' obj.type]);
               disp(['            Isp : ' num2str(obj.Isp)]);
               disp(['           F/Ox : ' num2str(obj.FuelOxRatio)]);
               disp(['InertMass Ratio : ' num2str(obj.InertMassRatio)]);
               disp(['     StaticMass : ' num2str(obj.StaticMass)]);
           else 
               warning('Unable to display object because it was not a Propulsion object.');
               disp('unknown');
           end
        end
        %% Getters
        % Isp getter
        function ispout = get.Isp(obj)
            % verify we have correct inputs to get Isp
            if nargin > 0 && isa(obj,'Propulsion')
%                 % lookup isp using the type and column names from
%                 % propulsion properties table
%                 isp = Propulsion.propulsionProps{obj.type,Propulsion.ispColName};
                ispout = obj.IspINT;
            end
        end
        % Fuel-Oxidizer ratio getter
        function fuelOxRatio = get.FuelOxRatio(obj)
            % verify we have correct inputs to get fuel-oxidizer ratio
            if nargin > 0 && isa(obj,'Propulsion') && ischar(obj.type)
%                 % lookup fuel-oxidizer ratio using the type and column
%                 % names from propulsion properties table
%                 fuelOxRatio = Propulsion.propulsionProps{obj.type,Propulsion.fuelOxidizerColName};
                fuelOxRatio = obj.FuelOxRatioINT;
            end
        end
        % Inert Mass ratio getter
        function inertMass = get.InertMassRatio(obj)
            % verify we have correct inputs to get inert mass ratio
            if nargin > 0 && isa(obj,'Propulsion') && ischar(obj.type)
%                 % lookup inert mass ratio using the type and column names
%                 % from propulsion properties table
%                 inertMass = Propulsion.propulsionProps{obj.type,Propulsion.inertMassColName};
                inertMass = obj.InertMassRatioINT;
            end
        end
        % Static Mass getter
        function mass = get.StaticMass(obj)
            % verify we have correct inputs to get static mass
            if nargin > 0 && isa(obj,'Propulsion') && ischar(obj.type)
%                 % lookup static mass using the type and column names from
%                 % propulsion properties table
%                 mass = Propulsion.propulsionProps{obj.type,Propulsion.staticMassColName};
                mass = obj.StaticMassINT;
            end
        end
        %% Setters
        % ISP Setter
        function obj = set.Isp(obj,val)
           if nargin > 0 && isa(obj,'Propulsion')% && isa(val,'Double')
               obj.IspINT = val;
           end
        end
        % Fox Setter
        function obj = set.FuelOxRatio(obj,val)
           if nargin > 0 && isa(obj,'Propulsion')
               obj.FuelOxRatioINT = val;
           end
        end
        % Static Mass Setter
        function obj = set.StaticMass(obj,val)
           if nargin > 0 && isa(obj,'Propulsion')
               obj.StaticMassINT = val;
           end
        end
        % InertMass Setter
        function obj = set.InertMassRatio(obj,val)
           if nargin > 0 && isa(obj,'Propulsion')
               obj.InertMassRatioINT = val;
           end
        end
        
        
        %% equality definition
        function equalityOUT = eq(obj1,obj2)
            if nargin == 2 && isa(obj1,'Propulsion') && isa(obj2,'Propulsion')
                %compare the string values of type
                equalityOUT = strcmp(obj1.type,obj2.type);
            end %good arguments
        end%equality comparison
        
    end%methods
    

    %% enumerated values for common propulsion types
    properties (Constant)
        LH2 = Propulsion('LH2');
        NTR = Propulsion('NTR');
        SEP = Propulsion('SEP');
        CH4 = Propulsion('CH4');

    end %enumeration
end%classdef