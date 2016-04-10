clear all
close all

options = optimset('Display', 'simplex');
x0=[5,2,2,2,2];
[x, fval]=fminsearchMod(@constraintfun, x0,options);
x = round(x)
fval