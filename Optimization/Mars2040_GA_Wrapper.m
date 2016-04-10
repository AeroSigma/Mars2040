function [ Val ] =  Mars2040_GA_Wrapper ( x )
%This code takes the input variables from ga, and wraps in the parameters
%to correctly call the SingleTradeFunction

[ Val ] = SingleTradeFunction (Propulsion.LH2, PowerSource.NUCLEAR, Site.GUSEV, ...
    FoodSource.EARTH_MARS_50_SPLIT, SurfaceCrew.MID_SURFACE, x(1), x(2));
%function [ val ] = SingleTradeFunction (PropType, SurfPower, Site, 
%Food, SurfCrew, Input_ISP, varargin)

end