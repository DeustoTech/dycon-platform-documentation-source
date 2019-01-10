classdef ControlProblem < handle & matlab.mixin.SetGet
% description: This class is able to solve optimization problems of a function restricted to an ordinary equation. This scheme is used to solve optimal control problems in which the functional derivative is calculated. <strong>ControlProblem</strong> class has methods that
%               help us find optimal control as well as obtaining the attached problem and it's derivative form, 
%               in both symbolic and numerical versions.
% visible: true

    properties 
        % type: "Functional"
        % default: "none"
        % description: "This property represent the cost of optimal control"
        Jfun        
        % type: ode
        % default: none
        % description: This property represented ordinary differential equation
        ode            
        
    end
    %%
    properties (Dependent = true)
        % type: double
        % default: 1
        % description: Final Time of simulation 
        T
        % type: double
        % default: iode.dt
        % description: Sampling in time of interpolation of calculate the functional value
        dt
        % type: double
        % default: none
        % description: It is the optimal control of problem. This property only can be set by GradientMethod.
        UOptimal 

     
    end
    %%
    properties 
        % type: double
        % default: none
        % description: Precision is a umber that is generated by solvers. This number incidcate the precision of solution obj.UOptimal
        precision 
        % type: double
        % default: none
        % description: Symbolic vector that represent the co-state of ode. $ \\textbf{P} = (p_1 ,p_2,... )$       
        P
        % type: struct
        % default: none
        % description: The adjoint propertir contain the numerical function that represents the adjoint problem this struct have a two properties. The first is dP_dt and the second is P0.
        adjoint
        % type: double
        % default: function_handle
        % description: The derivative of the Hamiltonian with respect to the control u         
        dH_du
        % type: double
        % default: none
        % description: It is an array that contains the different functional values during the execution of the optimization algorithm that has been used.
        Jhistory
        % type: cell
        % default: none
        % description: It is an cell that contains the different solutions of state, $Y$, during the execution of the optimization algorithm that has been used.        
        Yhistory
        % type: double
        % default: none
        % description: It is an array that contains the different control, $U$, values during the execution of the optimization algorithm that has been used.
        Uhistory
        % type: double
        % default: none
        % description: number of iterations that the algorithm has made
        iter
        % type: double
        % default: none
        % description: Time it took the optimization algorithm to execute.
        time
    end
    
     
    methods
        function obj = ControlProblem(iode,Jfun,varargin)
        % name: ControlProblem
        % description: 
        % autor: JOroya
        % MandatoryInputs:   
        %   iode: 
        %       name: Ordinary Differential Equation 
        %       description: Ordinary Differential Equation represent the constrain to minimization the functional 
        %       class: ode
        %       dimension: [1x1]
        %   Jfun: 
        %       name: functional
        %       description: Cost function to obtain the optimal control 
        %       class: Functional
        %       dimension: [1x1]        
        % OptionalInputs:
        %   T:
        %       name: Final Time 
        %       description: This parameter represent the final time of simulation.  
        %       class: double
        %       dimension: [1x1]
        %       default: iode.T 
        %   dt:
        %       name: Final Time 
        %       description: This parameter represent is the interval to interpolate the control, $u$, and state, $y$, to obtain the functional $J$ and the gradient $dH/du$
        %       class: double
        %       dimension: [1x1]
        %       default: iode.dt         
        % Outputs:
        %   obj:
        %       name: ControlProblem MATLAB
        %       description: ControlProblem MATLAB class
        %       class: ControlProblem
        %       dimension: [1x1]

            p = inputParser;
            
            addRequired(p,'iode');
            addRequired(p,'JFunctional');
                    
            
            parse(p,iode,Jfun,varargin{:})
            
            
            obj.ode          = copy(iode);
            obj.Jfun         = copy(Jfun);
            
            if Jfun.T ~= iode.T
                warning('The parameter T (final time), is different in Jfunction and ODE problem. We use ODE.T for all.')
            end
            Jfun.T = iode.T;

            if Jfun.dt ~= iode.dt
                warning('The parameter dt (step time), is different in Jfunction and ODE problem. We use ODE.dt for all.')
            end
            Jfun.dt = iode.dt;
 
           
            GetAdjointProblem(obj);
            GetGradient(obj)
        end
        
        
        function Uopt = get.UOptimal(obj)
            if ~isempty(obj.Uhistory)
                Uopt = obj.Uhistory{end};
            else
                Uopt = [];
            end
        end
        
        function T = get.T(obj)
            T = obj.ode.T;
        end
        function dt = get.dt(obj)
            dt = obj.ode.dt;
        end
        
    end
end

