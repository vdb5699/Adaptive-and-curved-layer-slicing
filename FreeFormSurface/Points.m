classdef Points
   properties (Access = private)
       pointsD;
       pointsC;
       nOfCP
       mat;
       
       Umat;
       Wmat;
       
       n;
       m;
       type;
       
       Bx;
       By;
       Bz;
   end
   
   properties(Access = public)
       Px;
       Py;
       Pz;
       NMm;
   end
    
   methods (Access = public)
       function obj = Points(pointsRes,nOfCP,type,Bx,By,Bz)
          obj.type = type;
          obj.n = height(Bx);
          obj.m = size(Bx,2);
          obj.Bx = Bx;
          obj.By = By;
          obj.Bz = Bz;
          obj.NMm = NMmat(size(Bx,2),height(Bx));
          obj.Px = zeros(height(Bx),size(Bx,2));
          obj.Py = zeros(height(Bx),size(Bx,2));
          obj.Pz = zeros(height(Bx),size(Bx,2));
          if type == 1
              obj.pointsD = pointsRes;
              obj.pointsC = 0;
              obj.nOfCP = 0;
              createCoordinate(obj,obj.pointsD,obj.pointsD);
          else
              obj.pointsD = 0;
              obj.pointsC = pointsRes;
              obj.nOfCP = nOfCP;
              createCoordinate(obj,obj.pointsC,obj.nOfCP);
          end
       end
   end
   
   methods (Access = private)
       function createCoordinate(obj,p,p2)
           
            for i = 0: p
                for j = 0 : p2
                     for z = obj.n:-1:1
                         obj.Umat(obj.n-z+1) = (i/p)^(z-1);
                     end
                     for z = obj.m:-1:1
                         obj.Wmat(obj.m-z+1,1) = (j/p2)^(z-1);
                     end
                     obj.Px(i+1,j+1) = obj.Umat*obj.NMm.Nmatrix*obj.Bx*obj.NMm.Mmatrix'*obj.Wmat;
                     obj.Py(i+1,j+1) = obj.Umat*obj.NMm.Nmatrix*obj.By*obj.NMm.Mmatrix'*obj.Wmat;
                     obj.Pz(i+1,j+1) = obj.Umat*obj.NMm.Nmatrix*obj.Bz*obj.NMm.Mmatrix'*obj.Wmat;
                end
            end
            
            if obj.type == 1
                figure(1);

                surf(obj.Px,obj.Py,obj.Pz);
           
                title('Bezier Surface');
                grid on;
                xlabel('X-Axis');
                ylabel('Y-Axis');
                zlabel('Z-Axis');
            else
                figure (2);
                
                figure(2);
                plot3(obj.Px,obj.Py,obj.Pz);
                hold on
                title('CNC Cutter Paths');
                xlabel('X-Axis');
                ylabel('Y-Axis');
                zlabel('Z-Axis');
            end
                
       end
   end       
end