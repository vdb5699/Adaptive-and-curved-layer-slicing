classdef newNewlayers2
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
        surfaces;
        
        
    end
    %% constructor
    methods(Access = public)
        function obj = newNewlayers2(surface, thickness, numOfLayers, type)
            points = surface.data;
            obj.Px = points.Px;
            obj.Py = points.Py;
            obj.Pz = points.Pz;
            obj.thickness = thickness;     %Need to get user input here
            obj.type = type;
            obj.numOfLayers = numOfLayers;
            %zPlusOne(obj, obj.Px,obj.Py, obj.Pz, obj.thickness);
            obj.surfaces = LayerCoordinates(obj, obj.Px, obj.Py, obj.Pz, obj.thickness);
        end
    end
    %% Adding 1 to Z value (Easy Way Out)
    methods (Access = public)
        function Pz = zPlusOne(obj, Px, Py, Pz, thickness)
            [PxRows,PxCols] = size(Px);
            [PyRows,PyCols] = size(Py);
            [PzRows,PzCols] = size(Pz);
            
            figure(10);
            surf(Px,Py,Pz);
            hold on;
            title('Curved Layers');
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
                end
                
            else
                for row = 0:obj.numOfLayers-1
                    PzTemp = Pz + (thickness * row);
                    
                    for n=1:PxCols
                        if mod(n,2)  == 1       %if Column is odd
                            for i=1:PxRows%Increment Rows
                                Pstart = [Px(i,n) Py(i,n) PzTemp(i,n)];
                                if i==PxRows
                                    Pmax = [Px(i,n) Py(i,n) PzTemp(i,n)];
                                end
                                if i==1
                                    Pmin = [Px(i,n) Py(i,n) PzTemp(i,n)];
                                end
                            end
                        else
                            for q=PxRows:-1:1  %Else decrement Rows
                                Pstart = [Px(q,n) Py(q,n) PzTemp(q,n)];
                                if q==1
                                    Pmin2 = [Px(q,n) Py(q,n) PzTemp(q,n)];
                                end
                                if q==PxRows
                                    Pmax2 = [Px(q,n) Py(q,n) PzTemp(q,n)];
                                end
                            end
                        end
                        if n >= 2
                            figure(11);
                            if mod(n,2)  == 0       %if Column is even
                                %plot3([Pmax(1) Pmax2(1)], [Pmax(2) Pmax2(2)], [Pmax(3) Pmax2(3)]);
                                plot3([Pmax(1) Pmax2(1)], [Pmax(2) Pmax2(2)], [Pmax(3) Pmax2(3)]);
                                hold on;
                            else
                                plot3([Pmin(1) Pmin2(1)], [Pmin(2) Pmin2(2)], [Pmin(3) Pmin2(3)]);
                                hold on;
                            end
                        end
                    end
                    figure(11);
                    plot3(Px,Py,PzTemp);
                end
            end
        end
    end
    %% putting x,y,z values together in an array and calculating vectors
    methods (Access = public)
        function surs = LayerCoordinates(obj, Px, Py, Pz, thickness)
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
            surs(1) = Surface(Px,Py,Pz);
            for layers = 1:obj.numOfLayers
                Px1 = Pxtemp;
                Py1 = Pytemp;
                Pz1 = Pztemp;
                
            %%Set the corners individualy
            %row 1 col 1 
            B = [Px(1,1) Py(1,1) Pz(1,1)]; %Point1
            A = [Px(1,1)-(Px(2,2) - Px(1,1)), Py(1,1)-(Py(2,2) - Py(1,1)), 0];   %Point2
            C = [Px(2,2) Py(2,2) Pz(2,2)];   %Point3
           
            V1 = [(A(1)-B(1)) (A(2)-B(2)) (A(3)-B(3))];
            V2 = [(C(1)-B(1)) (C(2)-B(2)) (C(3)-B(3))];
            V3 = cross(V1, V2);
          
            V1crossV3 = cross(V1, V3);
            V3crossV2 = cross(V3,V2);
            magnitude = vectorMag(obj,V1crossV3);                  %Calculating magnitude of V3
            V13 = thickness * (V1crossV3/magnitude);   %Unit Vector
            
            magnitude2 = vectorMag(obj,V3crossV2);           %Calculating magnitude of V3crossV2
            V23 = thickness * (V3crossV2/magnitude2);   %Unit Vector
            
            alpha = vectorAng(obj, V13,V23);
            V5 = calcV5(obj,thickness,V13,V23,alpha);
            
            Pxtemp(1,1) = Px1(1,1) - V5(1);
            Pytemp(1,1) = Py1(1,1) - V5(2);
            Pztemp(1,1) = Pz1(1,1) - V5(3);
            
            %row 1 col max
            w = width(Px);
            B = [Px(1,w) Py(1,w) Pz(1,w)]; %Point1
            A = [Px(1,w)-(Px(2,w-1) - Px(1,w)), Py(1,w)-(Py(2,w-1) - Py(1,w)), 0];   %Point2
            C = [Px(2,w-1) Py(2,w-1) Pz(2,w-1)];   %Point3
           
            V1 = [(A(1)-B(1)) (A(2)-B(2)) (A(3)-B(3))];
            V2 = [(C(1)-B(1)) (C(2)-B(2)) (C(3)-B(3))];
            V3 = cross(V1, V2);
          
            V1crossV3 = cross(V1, V3);
            V3crossV2 = cross(V3,V2);
            magnitude = vectorMag(obj,V1crossV3);                  %Calculating magnitude of V3
            V13 = thickness * (V1crossV3/magnitude);   %Unit Vector
            
            magnitude2 = vectorMag(obj,V3crossV2);           %Calculating magnitude of V3crossV2
            V23 = thickness * (V3crossV2/magnitude2);   %Unit Vector
            
            alpha = vectorAng(obj, V13,V23);
            V5 = calcV5(obj,thickness,V13,V23,alpha);
            
            Pxtemp(1,w) = Px1(1,w) - V5(1);
            Pytemp(1,w) = Py1(1,w) - V5(2);
            Pztemp(1,w) = Pz1(1,w) - V5(3);
            
           %row max col 1 
            h = height(Px);
            B = [Px(h,1) Py(h,1) Pz(h,1)]; %Point1
            A = [Px(h,1)-(Px(h-1,2) - Px(h,1)), Py(h,1)-(Py(h-1,2) - Py(h,1)), 0];   %Point2
            C = [Px(h-1,2) Py(h-1,2) Pz(h-1,2)];   %Point3
           
            V1 = [(A(1)-B(1)) (A(2)-B(2)) (A(3)-B(3))];
            V2 = [(C(1)-B(1)) (C(2)-B(2)) (C(3)-B(3))];
            V3 = cross(V1, V2);
          
            V1crossV3 = cross(V1, V3);
            V3crossV2 = cross(V3,V2);
            magnitude = vectorMag(obj,V1crossV3);                  %Calculating magnitude of V3
            V13 = thickness * (V1crossV3/magnitude);   %Unit Vector
            
            magnitude2 = vectorMag(obj,V3crossV2);           %Calculating magnitude of V3crossV2
            V23 = thickness * (V3crossV2/magnitude2);   %Unit Vector
            
            alpha = vectorAng(obj, V13,V23);
            V5 = calcV5(obj,thickness,V13,V23,alpha);
            
            Pxtemp(h,1) = Px1(h,1) - V5(1);
            Pytemp(h,1) = Py1(h,1) - V5(2);
            Pztemp(h,1) = Pz1(h,1) - V5(3);
            
            %row max col max 
            h = height(Px);
            w = width(Px);
            B = [Px(h,w) Py(h,w) Pz(h,w)]; %Point1
            A = [Px(h,w)-(Px(h-1,w-1) - Px(h,w)), Py(h,w)-(Py(h-1,w-1) - Py(h,w)), 0];   %Point2
            C = [Px(h-1,w-1) Py(h-1,w-1) Pz(h-1,w-1)];   %Point3
           
            V1 = [(A(1)-B(1)) (A(2)-B(2)) (A(3)-B(3))];
            V2 = [(C(1)-B(1)) (C(2)-B(2)) (C(3)-B(3))];
            V3 = cross(V1, V2);
          
            V1crossV3 = cross(V1, V3);
            V3crossV2 = cross(V3,V2);
            magnitude = vectorMag(obj,V1crossV3);                  %Calculating magnitude of V3
            V13 = thickness * (V1crossV3/magnitude);   %Unit Vector
            
            magnitude2 = vectorMag(obj,V3crossV2);           %Calculating magnitude of V3crossV2
            V23 = thickness * (V3crossV2/magnitude2);   %Unit Vector
            
            alpha = vectorAng(obj, V13,V23);
            V5 = calcV5(obj,thickness,V13,V23,alpha);
            
            Pxtemp(h,w) = Px1(h,w) - V5(1);
            Pytemp(h,w) = Py1(h,w) - V5(2);
            Pztemp(h,w) = Pz1(h,w) - V5(3);
            
            %%Iterate through rows and columns 
            %%Row 1
            for col = 2:width(Px)-1
                
                B = [Px(1,col) Py(1,col) Pz(1,col)]; %Point1
                A = [Px(1,col), Py(1,col)-(Py(2,col) - Py(1,col)), 0];   %Point2
                C = [Px(2,col) Py(2,col) Pz(2,col)];   %Point3
                
                V1 = [(A(1)-B(1)) (A(2)-B(2)) (A(3)-B(3))];
                V2 = [(C(1)-B(1)) (C(2)-B(2)) (C(3)-B(3))];
                V3 = cross(V1, V2);
                
                V1crossV3 = cross(V1, V3);
                V3crossV2 = cross(V3,V2);
                magnitude = vectorMag(obj,V1crossV3);                  %Calculating magnitude of V3
                V13 = thickness * (V1crossV3/magnitude);   %Unit Vector
                
                magnitude2 = vectorMag(obj,V3crossV2);           %Calculating magnitude of V3crossV2
                V23 = thickness * (V3crossV2/magnitude2);   %Unit Vector
                
                alpha = vectorAng(obj, V13,V23);
                V5 = calcV5(obj,thickness,V13,V23,alpha);
                
                Pxtemp(1,col) = Px1(1,col) - V5(1);
                Pytemp(1,col) = Py1(1,col) - V5(2);
                Pztemp(1,col) = Pz1(1,col) - V5(3);  
            end
            
              %%Row max
            for col = 2:width(Px)-1
                h = height(Px);
                B = [Px(h,col) Py(h,col) Pz(h,col)]; %Point1
                A = [Px(h,col), Py(h,col)-(Py(h-1,col) - Py(h,col)), 0];   %Point2
                C = [Px(h-1,col) Py(h-1,col) Pz(h-1,col)];   %Point3
                
                V1 = [(A(1)-B(1)) (A(2)-B(2)) (A(3)-B(3))];
                V2 = [(C(1)-B(1)) (C(2)-B(2)) (C(3)-B(3))];
                V3 = cross(V1, V2);
                
                V1crossV3 = cross(V1, V3);
                V3crossV2 = cross(V3,V2);
                magnitude = vectorMag(obj,V1crossV3);                  %Calculating magnitude of V3
                V13 = thickness * (V1crossV3/magnitude);   %Unit Vector
                
                magnitude2 = vectorMag(obj,V3crossV2);           %Calculating magnitude of V3crossV2
                V23 = thickness * (V3crossV2/magnitude2);   %Unit Vector
                
                alpha = vectorAng(obj, V13,V23);
                V5 = calcV5(obj,thickness,V13,V23,alpha);
                
                Pxtemp(h,col) = Px1(h,col) - V5(1);
                Pytemp(h,col) = Py1(h,col) - V5(2);
                Pztemp(h,col) = Pz1(h,col) - V5(3);
                
            end
            
            %%Col 1
            for row = 2:height(Px)-1
                
                B = [Px(row,1) Py(row, 1) Pz(row,1)]; %Point1
                A = [Px(row,1)-(Px(row,2) - Px(row,1)), Py(row,1),0];   %Point2
                C = [Px(row,2) Py(row,2) Pz(row,2)];   %Point3
                
                V1 = [(A(1)-B(1)) (A(2)-B(2)) (A(3)-B(3))];
                V2 = [(C(1)-B(1)) (C(2)-B(2)) (C(3)-B(3))];
                V3 = cross(V1, V2);
                
                V1crossV3 = cross(V1, V3);
                V3crossV2 = cross(V3,V2);
                magnitude = vectorMag(obj,V1crossV3);                  %Calculating magnitude of V3
                V13 = thickness * (V1crossV3/magnitude);   %Unit Vector
                
                magnitude2 = vectorMag(obj,V3crossV2);           %Calculating magnitude of V3crossV2
                V23 = thickness * (V3crossV2/magnitude2);   %Unit Vector
                
                alpha = vectorAng(obj, V13,V23);
                V5 = calcV5(obj,thickness,V13,V23,alpha);
                
                Pxtemp(row,1) = Px1(row,1) - V5(1);
                Pytemp(row,1) = Py1(row,1) - V5(2);
                Pztemp(row,1) = Pz1(row,1) - V5(3);  
            end
            
            %%col max
            for row = 2:height(Px)-1
                w = width(Px);
                B = [Px(row,w) Py(row,w) Pz(row,w)]; %Point1
                A = [Px(row,w)-(Px(row,w-1) - Px(row,w)), Py(row,w) 0];   %Point2
                C = [Px(row,w-1) Py(row,w-1) Pz(row,w-1)];   %Point3
                
                V1 = [(A(1)-B(1)) (A(2)-B(2)) (A(3)-B(3))];
                V2 = [(C(1)-B(1)) (C(2)-B(2)) (C(3)-B(3))];
                V3 = cross(V1, V2);
                
                V1crossV3 = cross(V1, V3);
                V3crossV2 = cross(V3,V2);
                magnitude = vectorMag(obj,V1crossV3);                  %Calculating magnitude of V3
                V13 = thickness * (V1crossV3/magnitude);   %Unit Vector
                
                magnitude2 = vectorMag(obj,V3crossV2);           %Calculating magnitude of V3crossV2
                V23 = thickness * (V3crossV2/magnitude2);   %Unit Vector
                
                alpha = vectorAng(obj, V13,V23);
                V5 = calcV5(obj,thickness,V13,V23,alpha);
                
                Pxtemp(row,w) = Px1(row,w) - V5(1);
                Pytemp(row,w) = Py1(row,w) - V5(2);
                Pztemp(row,w) = Pz1(row,w) - V5(3);
            end

                for row=2:height(Px)-1
                    for col=2:width(Px)-1
                        B = [Px(row,col) Py(row,col) Pz(row,col)]; %Point1
                        A = [Px(row,(col-1)) Py(row,(col-1)) Pz(row,(col-1))];   %Point2
                        C = [Px(row,(col+1)) Py(row,(col+1)) Pz(row,(col+1))];   %Point3
                      
                        
                        if col == 1
                            a1 = -C(1);
                            A = [a1 B(2) C(3)];
                        end
                        
                        if col == width(Px)
                            c1 = (B(1)+(B(1)-A(1)));
                            C = [c1 B(2)  A(3)];
                        end
                        
                        V1 = [(A(1)-B(1)) (A(2)-B(2)) (A(3)-B(3))];
                        V2 = [(C(1)-B(1)) (C(2)-B(2)) (C(3)-B(3))];
                        V3 = cross(V1, V2);
                        if V3(1) == 0 && V3(2) == 0 && V3(3) == 0
                            V3 = [0 1 0];
                        end
                        V1crossV3 = cross(V1, V3);
                        V3crossV2 = cross(V3,V2);
                        magnitude = vectorMag(obj,V1crossV3);                  %Calculating magnitude of V3
                        V13 = thickness * (V1crossV3/magnitude);   %Unit Vector
                        
                        magnitude2 = vectorMag(obj,V3crossV2);           %Calculating magnitude of V3crossV2
                        V23 = thickness * (V3crossV2/magnitude2);   %Unit Vector
                        
                        alpha = vectorAng(obj, V13,V23);
                        V5 = calcV5(obj,thickness,V13,V23,alpha);
                        
                        if(Pz1(row,col) > (Pz1(row,col) + V5(3)))
                            
                            Pxtemp(row,col) = Px1(row,col) - V5(1);
                            Pytemp(row,col) = Py1(row,col) - V5(2);
                            Pztemp(row,col) = Pz1(row,col) - V5(3);
                            
                        else
                            
                            Pxtemp(row,col) = Px1(row,col) + V5(1);
                            Pytemp(row,col) = Py1(row,col) + V5(2);
                            Pztemp(row,col) = Pz1(row,col) + V5(3);
                            
                        end
                    end
                end
                
                if obj.type == 1
                    figure(10);
                    surf(Pxtemp, Pytemp, Pztemp);
                else
                    for row = 0:obj.numOfLayers-1
                        
                        
                        for n=1:width(Px)
                            if mod(n,2)  == 1       %if Column is odd
                                for i=1:height(Px)%Increment Rows
                                    Pstart = [Pxtemp(i,n) Pytemp(i,n) Pztemp(i,n)];
                                    if i==height(Px)
                                        Pmax = [Pxtemp(i,n) Pytemp(i,n) Pztemp(i,n)];
                                    end
                                    if i==1
                                        Pmin = [Pxtemp(i,n) Pytemp(i,n) Pztemp(i,n)];
                                    end
                                end
                            else
                                for q=height(Px):-1:1  %Else decrement Rows
                                    Pstart = [Pxtemp(q,n) Pytemp(q,n) Pztemp(q,n)];
                                    if q==1
                                        Pmin2 = [Pxtemp(q,n) Pytemp(q,n) Pztemp(q,n)];
                                    end
                                    if q==height(Px)
                                        Pmax2 = [Pxtemp(q,n) Pytemp(q,n) Pztemp(q,n)];
                                    end
                                end
                            end
                            if n >= 2
                                figure(11);
                                if mod(n,2)  == 0       %if Column is even
                                    %plot3([Pmax(1) Pmax2(1)], [Pmax(2) Pmax2(2)], [Pmax(3) Pmax2(3)]);
                                    plot3([Pmax(1) Pmax2(1)], [Pmax(2) Pmax2(2)], [Pmax(3) Pmax2(3)]);
                                    hold on;
                                else
                                    plot3([Pmin(1) Pmin2(1)], [Pmin(2) Pmin2(2)], [Pmin(3) Pmin2(3)]);
                                    hold on;
                                end
                            end
                        end
                    end
                    figure(11);
                    plot3(Pxtemp, Pytemp, Pztemp);
                   
                end
                surs(layers+1) = Surface(Pxtemp,Pytemp,Pztemp);
            end
            return
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
        
        function r = returninfo(obj)
            surface = [];
            
            for i = 1 : width(obj.surfaces)
                b = [obj.surfaces(i).Px; obj.surfaces(i).Py; obj.surfaces(i).Pz];
                surface = [surface b];
                b = [];
            end
            r = surface;
            return;
        end
    end
    
end