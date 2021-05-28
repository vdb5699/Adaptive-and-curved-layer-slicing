classdef CutterPath
%% properties
   properties (Access = public)
       N {mustBeNumeric};
       U {mustBeNumeric};
       W {mustBeNumeric};
   end
   properties (Access = private)
        Bx {mustBeNumeric};
        By {mustBeNumeric};
        Bz {mustBeNumeric};
        res {mustBeNumeric};
        resc {mustBeNumeric};
        resr {mustBeNumeric};
   end 
 %% constructor (requires Bx, By, Bz from Bezier surface)
   methods (Access = public)
       function obj = CutterPath(Bxa,Bya,Bza,res,resc,resr)
           obj.Bx = Bxa;
           obj.By = Bya;
           obj.Bz = Bza;
           obj.res = res;
           obj.resc = resc;
           obj.resr = resr;
            
            if height(Bx) ~= height(By) || height(Bx) ~= height(Bz) || height(By) ~= height(Bz)
                %put erroe msg
            end
       end
   end
end