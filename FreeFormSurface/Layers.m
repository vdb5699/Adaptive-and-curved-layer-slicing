classdef Layers
   properties (Access = private)
       Bx;
       By;
       Bz;
       thickness;
       numOfLayers;
%        BxRows;
%        BxCols;
%        ByRows;
%        ByCols;
%        BzRows;
%        BzCols;
%A;
       %crossProdValue;
       
       
   end
   %% constructor
    methods(Access = public)
        function obj = Layers(Bx,By,Bz, thickness)
           obj.Bx = BezierSurface.Bx;
           obj.By = BezierSurface.By;
           obj.Bz = BezierSurface.Bz;
           obj.thickness = 0.2;     %Need to get user input here
           obj.numOfLayers = 20;
        end
    end
    %% Adding 1 to Z value (Easy Way Out)
     methods (Access = public)
       function obj = zPlusOne(Bx, By, Bz)
           [BzRows,BzCols] = size(Bz);
           oneMatrix = ones(BzRows, BzCols);
           obj.Bz = Bz + oneMatrix;
       end
     end           
    %% putting x,y,z values together in an array and calculating vectors
   methods (Access = public)
       function obj = LayerCoordinates(Bx, By, Bz)
           [BxRows,BxCols] = size(Bx);
           [ByRows,ByCols] = size(By);
           [BzRows,BzCols] = size(Bz);
           
           for i=1:BxRows
               for n=1:BxCols
                  
                   A = [Bx(i,n), By(i,n), Bz(i,n)];             %Point1
                   if(n+1) <= BxCols
                       B = [Bx(i,n+1), By(i,n+1), Bz(i,n+1)];   %Point2
                   end
                   if(n+2) <= BxCols
                       C = [Bx(i,n+2), By(i,n+2), Bz(i,n+2)];   %Point3
                   end
                   V1 = A - B;
                   V2 = C - B;
                   V3 = cross(V2, V1);
                   V1crossV3 = cross(V1, V3);
                   V3crossV2 = cross(V3,V2);

                   magnitude = vectorMag(V3);               %Calculating magnitude of V3
                   V13 = thickness * V1crossV3/magnitude;   %Unit Vector
                   magnitude = vectorMag(V3crossV2);        %Calculating magnitude of V3crossV2
                   V23 = thickness * V3crossV2/magnitude;   %Unit Vector
               end
           end
       end
   end
   %% Calculate Magnitude of Vectors
   methods (Access = public)
       function double = vectorMag(v)      %takes input vector as parameter
           vSquared = v.* v;      
           dotProd = sum(vSquared)      % sum of square
           mag = sqrt(dotProd)          % magnitude
       end
   end

%    methods (Access = public)
%            function obj = createArrays(Bx, By,Bz)
%                [BxRows,BxCols] = size(Bx);
%                [ByRows,ByCols] = size(By);
%                [BzRows,BzCols] = size(Bz);
%                %A = zeros(BxRows,3)
%                for i=1:BxRows
%                    for n=1:3
%                    A = table(Bx(i,n), By(i,n), Bz(i,n));
%                    end
%                end
%            end
%        end
  
end