function [ Dev_Cost_Module ] = Development_Cost(eng_type, eng_Isp, eng_mass, eng_static_mass)
%Calculate the transit engine development and production costs for each
%architecture. The code calculates costs and adds these into the SC_Class 
%definition

%PDV - April 2016

%---NASA Advanced Mission Cost Model Constants (from HSMAD)
alpha = 5.65e-4;
beta = 0.5941;
zi = 0.6604;
delta = 80.599;
epsilon = 3.8085e-55;
phi = -0.3553;
gamma = 1.5691;

%---1999 to 2016 inflation parameter (US Labor Statistics -
%http://www.bls.gov/data/inflation_calculator.htm)
inflation = 1.42;

%---setup costing 
kilo_to_lb = 2.2;

%---costing 
M = kilo_to_lb*(eng_mass + eng_static_mass);
Q = 1;
S = 2.39;
IOC = 2030;

if strcmp(eng_type, 'LH2')
    if eng_Isp == 448%445  %change back once full ISP implementation is together
        B = 6; D = -2.5;
    elseif eng_Isp == 452
        B = 6; D = -2;
    elseif eng_Isp == 465
        B = 2; D = -1;
    elseif eng_Isp == 480
        B = 1; D = 1;
    else
        'Unrecognized LH2 Isp Value'
    end

elseif strcmp(eng_type, 'NTR')
    if eng_Isp == 850
        B = 1; D = 0.5;
    elseif eng_Isp == 950
        B = 1; D = 1;
    elseif eng_Isp == 1000
        B = 1; D = 1.5;
    else
        'Unrecognized NTR Isp Value'
    end
end

Dev_Cost_Module = inflation*(alpha*Q^beta*M^zi*delta^S*epsilon^(1/(IOC-1900))*B^phi*gamma^D);     


end
