classdef SPWM < matlab.System & matlab.system.mixin.Propagates
    % Implements Sinusoidal PWM

    % Public, tunable properties
    properties
        
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)

    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

        function [Dabc] = stepImpl(obj, Vdq, theta_elec, Vdc)
            % Output is Vah, Vbh, Vch (the Low side outputs are generated 
            % by hardware)
            
            % Inverse Park Transform
            Vabc = inverseParkTransform(Vdq, theta_elec);
            Va = Vabc(1);
            Vb = Vabc(2);
            Vc = Vabc(3);
            
            % Convert to duty cycle
            offset = Vdc/2;
            
            Vah = sat( (Va+offset)/Vdc, 0, 1);
            Vbh = sat( (Vb+offset)/Vdc, 0, 1);
            Vch = sat( (Vc+offset)/Vdc, 0, 1);
            
            Dabc = [Vah; Vbh; Vch];
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
    
        %% Output sizing
        function [sz1] = getOutputSizeImpl(obj)            
            sz1 = [3,1];
        end
        
        function [fz1] = isOutputFixedSizeImpl(~)
          fz1 = true;
        end
        
        function [dt1] = getOutputDataTypeImpl(obj)
            dt1 = 'double';
        end
    
        function [cp1] = isOutputComplexImpl(obj)
            cp1 = false;
        end
    end
end
