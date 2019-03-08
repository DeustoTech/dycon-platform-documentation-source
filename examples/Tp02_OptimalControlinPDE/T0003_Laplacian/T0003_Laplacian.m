%% Parametros de discretizacion
N = 25;
xi = -1; xf = 1;
xline = linspace(xi,xf,N);
dx = xline(2) - xline(1);
%% Creamos el ODE 
A = FDLaplacian(N);
%%%%%%%%%%%%%%%%  
a = -0.5; b = 0.5;
B = construction_matrix_B(xline,a,b);
%%%%%%%%%%%%%%%%
FinalTime = 0.05;
dt = 0.001;
Y0 =sin(pi*xline)';

dynamics = pde('A',A,'B',B,'InitialCondition',Y0,'FinalTime',FinalTime,'dt',dt);
%% Creamos Problema de Control
Y = dynamics.StateVector.Symbolic;
U = dynamics.Control.Symbolic;

YT = 0.0*xline';
epsilon = dx^4;
symPsi  = dx*(1/(2*epsilon))*(YT - Y).'*(YT - Y);
symL    = 0.5*dx*(U.'*U);
%symL     dx* 1/2*sum(abs(U));


iCP1 = OptimalControl(dynamics,symPsi,symL);

%% Solve Gradient
tol = 1e-6;
%
GradientMethod(iCP1,'tol',tol,'Graphs',true,'TypeGraphs','PDE','DescentAlgorithm',@ConjugateGradientDescent,'MaxIter',8000)
%%
dynamics.label = 'Free';
iCP1.ode.label = 'with Control';
solve(dynamics)

plotT([iCP1.ode dynamics])

% animation([iCP1.ode,dynamics],'YLim',[-1 1],'xx',0.05)
% Several ways to run
% GradientMethod(iCP1)
% GradientMethod(iCP1,'DescentParameters',DescentParameters)
% GradientMethod(iCP1,'DescentParameters',DescentParameters,'graphs',true)

% iCP1.ode
%%
function [B] = construction_matrix_B(mesh,a,b)

N = length(mesh);
B = zeros(N,N);

control = (mesh>=a).*(mesh<=b);
B = diag(control);

end
