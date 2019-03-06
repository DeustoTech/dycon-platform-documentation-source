function [tspan,StateVector] = ode23(iode,varargin)
%ODE45 Summary of this function goes here
%   Detailed explanation goes here

tspan = iode.tspan;
InitialCondition = iode.InitialCondition;
U = iode.Control.Numeric;

Ufun = @(t) interp1(tspan,U,t)';
dynamics = @(t,Y) iode.Dynamic.Numeric(t,Y,Ufun(t));

[tspan,StateVector] = ode23(dynamics,tspan,InitialCondition);

iode.StateVector.Numeric = StateVector;

end
