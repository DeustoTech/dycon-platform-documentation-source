function [tspan,StateVector] = ode23(iode,varargin)
%ODE45 Summary of this function goes here
%   Detailed explanation goes here

tspan = iode.tspan;
InitialCondition = iode.InitialCondition;
U = iode.Control.Numeric;

if isempty(varargin)
  iode.SolverParameters = {odeset('Mass',iode.MassMatrix)};
else
  iode.SolverParameters{:} = varargin{:};
  iode.SolverParameters{:}.Mass = iode.MassMatrix;
end

Ufun = @(t) interp1(tspan,U,t)';
params = {iode.Params.value};

dynamics = @(t,Y) iode.DynamicEquation.Num(t,Y,Ufun(t),params);

[tspan,StateVector] = ode23(dynamics,tspan,InitialCondition);

iode.StateVector.Numeric = StateVector;

end

