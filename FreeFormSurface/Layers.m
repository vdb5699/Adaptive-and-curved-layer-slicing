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
            %zPlusOne(obj, obj.Px,obj.Py, obj.Pz, obj.thickness);
            LayerCoordinates(obj, obj.Px, obj.Py, obj.Pz, obj.thickness);
        end
    end
    %% Adding 1 to Z value (Easy Way Out)
    methods (Access = public)
        function Pz = zPlusOne(obj, Px, Py, Pz, thickness)
            if obj.type  == 1
                figure(10);
                surf(Px,Py,Pz);
                hold on;
                title('Surface with Layers');
                grid on;
                xlabel('X-Axis');
                ylabel('Y-Axis');
                zlabel('Z-Axis');
            else
                figure(11);
                plot3(Px,Py,Pz);
                hold on
                title('Cutter Paths with Layers');
                xlabel('X-Axis');
                ylabel('Y-Axis');
                zlabel('Z-Axis');
            end
            
         
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
            Pxtemp = Px;
            Pytemp = Py;
            Pztemp = Pz;
            if obj.type == 1
                figure(10);
                surf(Px,Py,Pz);
                title('Bezier Surface with layers');
                grid on;
                xlabel('X-Axis');
                ylabel('Y-Axis');
                zlabel('Z-Axis');
                hold on;
            else
                figure(11);
                plot3(Px,Py,Pz);
                
                title('Cutter Path with layers');
                xlabel('X-Axis');
                ylabel('Y-Axis');
                zlabel('Z-Axis');
                hold on;
            end
            for layers = 1:obj.numOfLayers
                Px1 = Pxtemp;
                Py1 = Pytemp;
                Pz1 = Pztemp;
                for row=1:height(Px)
                    for col=1:width(Px)
                        B = [Px(row,col) Py(row,col) Pz(row,col)]; %Point1
                        if col ~= 1 %previous P-coordinates
                            A = [Px(row,(col-1)) Py(row,(col-1)) Pz(row,(col-1))];   %Point2
                        end
                        if col ~= width(Px) %next P-coordinates
                            C = [Px(row,(col+1)) Py(row,(col+1)) Pz(row,(col+1))];   %Point3
                        end
                        
                        if col == 1
                            a1 = -C(1);
                           A = [a1 B(2) C(3)];
                           %A = B
                        end
                        
                        if col == width(Px)
                           c1 = (B(1)+(B(1)-A(1)));
                           C = [c1 B(2)  A(3)]; 
                           %C = B;
                        end
                         
                            V1 = B - A;
                            V2 = B - C;
                            V3 = cross(V1, V2);
%                             if V3(1) == 0 && V3(2) == 0 && V3(3) == 0
%                                V3 = [0 1 0];
%                             end
                            V1crossV3 = cross(V1, V3);
                            V3crossV2 = cross(V3,V2);
                            magnitude = vectorMag(obj,V1crossV3);                  %Calculating magnitude of V3
                            V13 = thickness * (V1crossV3/magnitude);   %Unit Vector

                            magnitude2 = vectorMag(obj,V3crossV2);           %Calculating magnitude of V3crossV2
                            V23 = thickness * (V3crossV2/magnitude2);   %Unit Vector

                            alpha = vectorAng(obj, V13,V23);
                            V5 = calcV5(obj,thickness,V13,V23,alpha);
                            
%                             if isnan(V5)
%                                 
%                                 V5 = [0 0 thickness];
%                             end

  
                        Pxtemp(row,col) = Px1(row,col) + V5(1);
                        Pytemp(row,col) = Py1(row,col) + V5(2);
                        Pztemp(row,col) = Pz1(row,col) + V5(3);
                    end
                end
            
                if obj.type == 1
                    figure(10);
                    surf(Pxtemp, Pytemp, Pztemp);
                else
                    figure(11);
                    plot3(Pxtemp, Pytemp, Pztemp);
                end
            end
        end
    end
    %% Calculate Magnitude of Vectors
    methods (Access = public)
        function mag = vectorMag(obj, vector)      %takes input vector as parameter
            sq = vector.*vector;
            dot = sum(sq);
            mag = sqrt(dot);        % magnitude
            return;
        end
    end
    %% Calculate Alpha Angle between 2 vectors
    methods (Access = public)
        function alphaAngle = vectorAng(obj, vector,vector2)      %takes input vector v and v2 as parameter
             num = dot(vector,vector2); %gets the angle between two vectors in rads
             magV = vectorMag(obj, vector);
             magV2 = vectorMag(obj, vector2);
             deno = dot(magV,magV2);
             frac = num/deno;
             alphaAngle = acos(frac);
             return
        end
        
        function V5 = calcV5(obj,thickness,vec1,vec2,angle)
            theta = angle/2;
            frac1 = thickness/(cos(theta));
            num = vec1+vec2;
            deno = vectorMag(obj,num);
            frac2 = num/deno;
            V5 = frac1*frac2;
            return
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