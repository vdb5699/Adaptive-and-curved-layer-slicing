classdef CutterPath
%% properties
   properties (Access = public)      
       Bx {mustBeNumeric};
       By {mustBeNumeric};
       Bz {mustBeNumeric};
       
       resc {mustBeNumeric};
       resr {mustBeNumeric};
       
       data;
   end
   
 %% constructor (requires Bx, By, Bz for Bezier surface)
   methods (Access = public)
       function obj = CutterPath(Bx,By,Bz,resc,resr)
           obj.Bx = Bx;
           obj.By = By;
           obj.Bz = Bz;
           obj.resc = resc;
           obj.resr = resr;
            
           if height(Bx) ~= height(By) || height(Bx) ~= height(Bz) || height(By) ~= height(Bz)
              %put erroe msg
           end 
           obj.data = calculatePoints(obj);
       end
   end
   %% calculate Px,Py,Pz
   methods (Access = private)
       function data = calculatePoints(obj)
            data = Points(obj.resc,obj.resr,2,obj.Bx,obj.By,obj.Bz);
            return;
       end
   end
end