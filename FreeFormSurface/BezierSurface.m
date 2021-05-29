classdef BezierSurface
    properties(Access = public)
       Bx {mustBeNumeric};
       By {mustBeNumeric};
       Bz {mustBeNumeric};
       
       res {mustBeNumeric};
       
       data;
    end
    %% constructor
    methods(Access = public)
        function obj = BezierSurface(Bx,By,Bz,res)
           obj.Bx = Bx;
           obj.By = By;
           obj.Bz = Bz;
           obj.res = res;
            
           obj.data = calculatePoints(obj);
        end
    end
    %% calculate Px,Py,Pz
   methods (Access = private)
       function data = calculatePoints(obj)
            data = Points(obj.res,obj.res,1,obj.Bx,obj.By,obj.Bz);
            return;
       end
   end
end