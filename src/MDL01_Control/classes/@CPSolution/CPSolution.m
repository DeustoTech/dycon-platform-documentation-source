classdef CPSolution < handle
    %CPSOLUTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % type: double
        % default: none
        % description: Precision is a umber that is generated by solvers. This number incidcate the precision of solution obj.UOptimal
        precision 
        % type: double
        % default: none
        % description: number of iterations that the algorithm has made
        iter
        % type: double
        % default: none
        % description: Time it took the optimization algorithm to execute.
        time
        % type: cell
        % default: none
        % description: It is an cell that contains the different solutions of state, $Y$, during the execution of the optimization algorithm that has been used.        
        Yhistory
        % type: double
        % default: none
        % description: It is an cell that contains the different control, $U$, values during the execution of the optimization algorithm that has been used.
        Uhistory
        % type: double
        % default: none
        % description: number of iterations that the algorithm has made
        Jhistory
        Phistory
        dJhistory
        fhistory
        dfhistory
        Ehistory
        timeline
        du

    end
    properties (Dependent)
        % type: double
        % default: none
        % description: number of iterations that the algorithm has made
        UOptimal
        JOptimal
    end
    methods

        function UOptimal = get.UOptimal(obj)
            if ~isempty(obj.Uhistory{end})
                UOptimal = obj.Uhistory{end};
            else
                UOptimal = [];
            end
        end
        function JOptimal = get.JOptimal(obj)
            JOptimal = obj.Jhistory(end);
        end
    end
end

