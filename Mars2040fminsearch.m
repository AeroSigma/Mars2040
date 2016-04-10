clear all
close all

x0=[0,0,0,0,0];
[x, fval]=fminsearch(@constraintfun, x0)