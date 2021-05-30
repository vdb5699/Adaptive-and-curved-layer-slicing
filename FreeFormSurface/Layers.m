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
        type;
        
        
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
        function obj = Layers(surface, thickness, numOfLayers, type)
            points = surface.data;
            obj.Px = points.Px;
            obj.Py = points.Py;
            obj.Pz = points.Pz;
            obj.thickness = thickness;     %Need to get user input here
            obj.type = type;
            obj.numOfLayers = numOfLayers;
            zPlusOne(obj, obj.Px,obj.Py, obj.Pz, obj.thickness);
            %LayerCoordinates(obj, obj.Px, obj.Py, obj.Pz, obj.thickness);
        end
    end
    %% Adding 1 to Z value (Easy Way Out)
    methods (Access = public)
        function Pz = zPlusOne(obj, Px, Py, Pz, thickness)
            figure(10);
            surf(Px,Py,Pz);
            hold on;
            title('Surface with Layers');
            grid on;
            xlabel('X-Axis');
            ylabel('Y-Axis');
            zlabel('Z-Axis');
            
            figure(11);
            plot3(Px,Py,Pz);
            hold on
            title('Cutter Paths with Layers');
            xlabel('X-Axis');
            ylabel('Y-Axis');
            zlabel('Z-Axis');
            if obj.type == 1
                for row = 1:obj.numOfLayers
                    PzTemp = Pz + (thickness * row);
                    figure(10);
                    surf(Px,Py,PzTemp);
    %                 plot3(Px,Py,Pz);
                end
            else
                for row = 1:obj.numOfLayers
                    PzTemp = Pz + (thickness * row);
                    figure(11);
                    plot3(Px,Py,PzTemp);
                end
            end
        end
    end
    %% putting x,y,z values together in an array and calculating vectors
    methods (Access = public)
        function V5 = LayerCoordinates(obj, Px, Py, Pz, thickness)
            [PxRows,PxCols] = size(Px);
            [PyRows,PyCols] = size(Py);
            [PzRows,PzCols] = size(Pz);
            
            for layers = 1:obj.numOfLayers
                Px1 = [];
                Py1 = [];
                Pz1 = [];
                for i=1:PxRows
                    for n=1:PxCols
                        A = [Px(i,n) Py(i,n) Pz(i,n)];             %Point1
                        if(n+1) <= PxCols %next P-coordinates
                            B = [Px(i,n+1) Py(i,n+1) Pz(i,n+1)];   %Point2
%                         else
%                             B = [0 0 0];
                        end
                        if(n+2) <= PxCols%next P-coordinates
                            C = [Px(i,n+2) Py(i,n+2) Pz(i,n+2)];   %Point3
%                         else
%                             C = [0 0 0];
                        end 
                        V1 = A - B;
                        V2 = C - B;
                        V3 = cross(V2, V1);
                        V1crossV3 = cross(V1, V3);
                        V3crossV2 = cross(V3,V2);
                        magnitude = norm(V1crossV3);                  %Calculating magnitude of V3
                        V13 = obj.thickness * V1crossV3/magnitude;   %Unit Vector
                        magnitude2 = norm(V3crossV2);           %Calculating magnitude of V3crossV2
                        V23 = obj.thickness * V3crossV2/magnitude2;   %Unit Vector
                        alpha = vectorAng(obj, V13,V23);
                        V5 = (obj.thickness/cos(alpha/2))*((V13+V23)/norm(V13+V23));
                        Px1(i,n) = obj.Px(i,n) + V5(1);
                        Py1(i,n) = obj.Py(i,n) + V5(2);
                        Pz1(i,n) = obj.Pz(i,n) + V5(3);
                    end
                end
            
                if obj.type == 1
                    figure(10);
                    surf(Px1, Py1, Pz1);
                else
                    figure(11);
                    plot3(Px1, Py1, Pz1);
                end
            end
        end
    end
%     %% Calculate Magnitude of Vectors
%     methods (Access = public)
%         function mag = vectorMag(obj, v)      %takes input vector as parameter
%             dotProd = dot(v,v);          % dot product
%             mag = norm(dotProd);        % magnitude
%             return;
%         end
%     end
    %% Calculate Alpha Angle between 2 vectors
    methods (Access = public)
        function alphaAngle = vectorAng(obj, v,v2)      %takes input vector v and v2 as parameter
            alphaAngle = atan2(norm(cross(v,v2)), dot(v,v2));  %gets the angle between two vectors in rads
            %alphaAngle = rad2deg(radAngle);        %returns the angle in deg
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