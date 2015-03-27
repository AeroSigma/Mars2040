%% TrajectoryType class defines the type of trajectory used for space flight
% simple enumeration type to get track of type
classdef TrajectoryType < handle % derive handle to prevent object copying
    %% Private class variables
    properties (Access=private)
        %% Type of trajectory
        % Quick single character abbreviation for quick reference. Should
        % always be upper case letter.
        % Values can include:
        % H = hohmann
        % E = elliptical
        % S = SLS Launch Vehicle?
        % 
        type = ''; % don't specify default type letter for instantiation checking
    end
    
    %% Public dependent class members
    properties (Dependent)
        %% Defines the simple letter type for the trajectory.
        Type;
        %% Defines the simple name of the trajectory type.
        Name;
    end
    
    %% Private class methods (incl. constructor)
    methods (Access=private)
        %% private constructor so only base class can build objects
        function obj = TrajectoryType(typeChar)
            % validate our input is a single character
            if nargin > 0 && ischar(typeChar) && length(typeChar) == 1
                % convert type character to uppercase and check for valid
                % letter
                switch upper(typeChar)
                    % if there is a valid letter, set the object type
                    case 'H' % hohmann
                        obj.type = 'H';
                    case 'E' % elliptical
                        obj.type = 'E';
                    otherwise
                        % letter did not have a matching type, output error
                        error('Trajectory type not recognized.');
                end
            else
                % if there was not valid input, output error
                error('Trajectory type not found.');
            end
        end
    end
    
    %% Pulic class methods
    methods        
        %% Type getter
        function type = get.Type(obj)
            %% verify we have a valid trajectory type object to get the type
            if nargin > 0 && isa(obj, 'TrajectoryType') && length(obj.type) == 1
                type = obj.type;
            else
                % output error if object is not valid
                error('Invalid trajectory type object to get Type for.');
            end
        end
        %% Name getter
        function name = get.Name(obj)
            %% verify we have a valid trajectory type object to get the name
            if nargin > 0 && isa(obj, 'TrajectoryType') && length(obj.type) == 1
                % set name based the object type letter
                switch obj.type
                    case 'H' % hohmann
                        name = 'Hohmann';
                    case 'E' % elliptical
                        name = 'Elliptical';
                    otherwise % didn't match type (this shouldn't happen)
                        name = 'unknown';
                end
            else
                % output error if object is not valid
                error('Invalid trajectory type object to get Name for.');
            end
        end        
    end
    
    %% Enumerations of trajectory types
    enumeration
        %% Reference to Hohmann trajectory
        HOHMANN ('H')
        %% Reference to Elliptical trajectory
        ELLIPTICAL('E')
    end
end

