function resume(idynamics)
% description: Constructor the ecuacion diferencial
% autor: JOroya
% MandatoryInputs:   
%   DynamicEquation: 
%       description: simbolic expresion
%       class: Symbolic
%       dimension: [1x1]
%   VectorState: 
%       description: simbolic expresion
%       class: Symbolic
%       dimension: [1x1]
%   Control: 
%       description: simbolic expresion
%       class: Symbolic
%       dimension: [1x1]
% OptionalInputs:
%   InitialControl:
%       name: Initial Control 
%       description: matrix 
%       class: double
%       dimension: [length(iCP.tspan)]
%       default:   empty   
tab = '     ';


condition = 'Y(0) = ';


display([newline, ...
         tab,'Dynamics:',newline,newline, ...
         tab,tab,'Y''(t,Y,U) = ',char(idynamics.DynamicEquation.Num), ...
         newline,newline, ...
         tab,tab,'t in [0,',num2str(idynamics.FinalTime),']  with condition: ',condition,char(join(string(idynamics.InitialCondition),' ')),newline])
         
end

