classdef Surface
   
    properties (Access = public)
       Px;
       Py;
       Pz;
    end
    
    methods (Access = public)
        
        function obj = Surface(Px,Py,Pz)
           obj.Px = Px;
           obj.Py = Py;
           obj.Pz = Pz;      
        end
    end
end