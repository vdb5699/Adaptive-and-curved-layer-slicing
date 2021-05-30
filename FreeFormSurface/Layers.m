classdef Layers
    properties (Access = public)
        Bx;
        By;
        Bz;
        thickness;
        numOfLayers;
        Px;
        Py;
        Pz;
        
        
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
        function obj = Layers(surface, thickness, numOfLayers)
            points = surface.data;
            obj.Px = points.Px;
            obj.Py = points.Py;
            obj.Pz = points.Pz;
            obj.thickness = thickness;     %Need to get user input here
            obj.numOfLayers = numOfLayers;
            zPlusOne(obj, obj.Px,obj.Py, obj.Pz, obj.thickness);
        end
    end
    %% Adding 1 to Z value (Easy Way Out)
    methods (Access = public)
        function Pz = zPlusOne(obj, Px, Py, Pz, thickness)
            figure(10);
            surf(Px,Py,Pz);
            hold on;
            title('Bezier Surface');
            grid on;
            xlabel('X-Axis');
            ylabel('Y-Axis');
            zlabel('Z-Axis');
            for row = 1:obj.numOfLayers
                PzTemp = Pz + (thickness * row);
                surf(Px,Py,PzTemp);
                
                
                %                 [PzRows,PzCols] = size(Pz);
                %                 oneMatrix = ones(PzRows, PzCols);
                %                 Pz = Pz + oneMatrix + thickness;
                %T = table(Bx, By, Bz);
            end
        end
    end
    %% putting x,y,z values together in an array and calculating vectors
    methods (Access = public)
        function V5 = LayerCoordinates(obj, Px, Py, Pz, thickness)
            [BxRows,BxCols] = size(Bx);
            [ByRows,ByCols] = size(By);
            [BzRows,BzCols] = size(Bz);
            
            for i=1:BxRows
                for n=1:BxCols
                    
                    A = [Px(i,n), Py(i,n), Pz(i,n)];             %Point1
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
                    V13 = obj.thickness * V1crossV3/magnitude;   %Unit Vector
                    magnitude = vectorMag(V3crossV2);        %Calculating magnitude of V3crossV2
                    V23 = obj.thickness * V3crossV2/magnitude;   %Unit Vector
                    alpha = alphaAngle(V13,V23);
                    V5 = (obj.thickness/cos(alpha/2))*((V13+V23)/norm(V13+V23));
                end
            end
        end
    end
    %% Calculate Magnitude of Vectors
    methods (Access = public)
        function mag = vectorMag(v)      %takes input vector as parameter
            dotProd = dot(v,v);          % dot product
            mag = norm(dotProd);        % magnitude
        end
    end
    %% Calculate Alpha Angle between 2 vectors
    methods (Access = public)
        function alphaAngle = vectorAng(v,v2)      %takes input vector v and v2 as parameter
            radAngle = atan2(norm(cross(v,v2)), dot(v,v2));  %gets the angle between two vectors in rads
            alphaAngle = rad2deg(radAngle);        %returns the angle in deg
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