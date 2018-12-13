classdef ControlProblem < handle
    % The problem control class is able to solve problems of optimization of a
    % function restricted to an ordinary differential equation. This scheme is 
    % used to solve optimal control problems in which the functional derivative 
    % is calculated. This class has methods that help us find optimal control, 
    % as well as the obtaining of the attached problem and the form of the derivative,
    % in its symbolic and numerical versions.
    properties (SetAccess = immutable)
        % type: "Functional"
        % default: "none"
        % description: "This property represent the cost of optimal control"
        Jfun        
        % type: "ode"
        % default: "none"
        % description: "This property represent ordinal differential equation"
        ode
    end
    %%
    properties (Dependent = true)
        % type: double
        % default: 1
        % description: Final Time 
        T
        dt
        UOptimal 
    end
    %%
    properties (Hidden)
        precision
        P
        adjoint
        dH_du
        %%
        Jhistory
        yhistory
        uhistory
        iter
        time
        dimension

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
        %       description: "This parameter represent is the interval to interpolate the control u and state y to obtain the functional $J$ and the gradient $\frac{dH}{du}$"
        %       class: double
        %       dimension: [1x1]
        %       default: iode.dt         
        

            p = inputParser;
            
            addRequired(p,'iode');
            addRequired(p,'JFunctional');
                    
            addOptional(p,'T',[])
            addOptional(p,'dt',[])
            
            parse(p,iode,Jfun,varargin{:})
            
            obj.ode          = copy(iode);
            obj.Jfun         = copy(Jfun);
            
           if isempty(obj.T) 
                if Jfun.T ~= iode.T
                    warning('The parameter T (final time), is different in Jfunction and ODE problem. We use ODE.T for all.')
                end
                Jfun.T = iode.T;
           else
               Jfun.T = obj.T;
               iode.T = obj.T;
           end
           if isempty(obj.dt) 
                if Jfun.dt ~= iode.dt
                    warning('The parameter dt (step time), is different in Jfunction and ODE problem. We use ODE.dt for all.')
                end
                Jfun.dt = iode.dt;
           else
               Jfun.dt = obj.dt;
               iode.dt = obj.dt;
           end
           
            GetAdjointProblem(obj);
            GetGradient(obj)
        end
        
        
        function Uopt = get.UOptimal(obj)
            if ~isempty(obj.uhistory)
                Uopt = obj.uhistory{end};
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

