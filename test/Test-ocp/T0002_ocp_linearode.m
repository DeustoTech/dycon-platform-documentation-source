clear all;close all
import casadi.*
%
A = [-2 1;
      1 -2];

B = [1 0;
     0 1];
%
tspan = linspace(0,2,10);
idyn = linearode(A,B,tspan);
idyn.InitialCondition = [1;2];

Control0  = ZerosControl(idyn);
FreeState = solve(idyn,Control0);

ts = idyn.ts;
Xs = idyn.State.sym;
Us = idyn.Control.sym;
%
epsilon = 1e4;
PathCost  = Function('L'  ,{ts,Xs,Us},{ Us'*Us           });
FinalCost = Function('Psi',{Xs}      ,{ epsilon*(Xs'*Xs) });

iocp = ocp(idyn,PathCost,FinalCost);


ControlGuess = ZerosControl(idyn);
[OptControl ,OptState] = ClassicalGradient(iocp,ControlGuess);

%%
figure
subplot(1,2,1);
plot(tspan,OptState');
title('Optimal State')
ylim([-1 2])
subplot(1,2,2);
plot(tspan,FreeState')
title('Free')
ylim([-1 2])