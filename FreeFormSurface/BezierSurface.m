classdef BezierSurface
    properties(Access = public)
       Bx {mustBeNumeric};
       By {mustBeNumeric};
       Bz {mustBeNumeric};
       
       res {mustBeNumeric};
       Px;
       Py;
       Pz;
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
           obj.Px = obj.data.Px;
           obj.Py = obj.data.Py;
           obj.Pz = obj.data.Pz;
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