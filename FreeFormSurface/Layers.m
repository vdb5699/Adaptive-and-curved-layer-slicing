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
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
=======
>>>>>>> b10c407930c0fdcec9df837515cc2807c07439c8
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
<<<<<<< HEAD
>>>>>>> 42ba4e0f14dbfdd5e1f12e0a7aeead3dfef664f1
=======
>>>>>>> b10c407930c0fdcec9df837515cc2807c07439c8
            
         
            if obj.type == 1
                for row = 1:obj.numOfLayers
                    PzTemp = Pz + (thickness * row);
                    figure(10);
                    surf(Px,Py,PzTemp);
                end
                for n=1:PxCols
                    if mod(n,2)  == 1       %if Column is odd
                        for i=1:PxRows%Increment Rows
                            Pstart = [Px(i,n) Py(i,n) Pz(i,n)];
                            if i==PxRows
                                Pmax = [Px(i,n) Py(i,n) Pz(i,n)];
                            end
                            if i==1
                                Pmin = [Px(i,n) Py(i,n) Pz(i,n)];
                            end
                        end
                    else
                        for q=PxRows:-1:1  %Else decrement Rows
                        %for q=1:PxRows  %Else decrement Rows
                            Pstart = [Px(q,n) Py(q,n) Pz(q,n)];
                            if q==1
                                Pmin2 = [Px(q,n) Py(q,n) Pz(q,n)];
                            end
                            if q==PxRows
                                Pmax2 = [Px(q,n) Py(q,n) Pz(q,n)];
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
<<<<<<< HEAD
<<<<<<< HEAD
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
=======
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
                         
                        if col ~= 1 && col ~= width(Px)
                            V1 = B - A;
                            V2 = B - C;
                            V3 = cross(V2, V1);
=======
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
>>>>>>> b10c407930c0fdcec9df837515cc2807c07439c8
                            V1crossV3 = cross(V1, V3);
                            V3crossV2 = cross(V3,V2);
                            magnitude = vectorMag(obj,V1crossV3);                  %Calculating magnitude of V3
                            V13 = thickness * (V1crossV3/magnitude);   %Unit Vector
<<<<<<< HEAD
                            magnitude2 = vectorMag(obj,V3crossV2);           %Calculating magnitude of V3crossV2
                            V23 = thickness * (V3crossV2/magnitude2);   %Unit Vector
                            alpha = vectorAng(obj, V13,V23);
                            V5 = calcV5(obj,thickness,V13,V23,alpha);
                        elseif col == 1
                            V3 = B - C;
                            magnitude = vectorMag(obj,V3);
                            V13 = thickness * (V3/magnitude);
                            alpha = acos(V13/magnitude);
                            V5 = (thickness/cos(alpha/2))*(V13/magnitude);
                        else
                            V3 = B - A;
                            magnitude = vectorMag(obj,V3);
                            V13 = thickness * (V3/magnitude);
                            alpha = acos(V13/magnitude);
                            V5 = (thickness/cos(alpha/2))*(V13/magnitude);
                        end
                        Pxtemp(row,col) = Px1(row,col) + V5(1);
                        Pytemp(row,col) = Py1(row,col) + V5(2);
                        Pztemp(row,col) = Pz1(row,col) + V5(3);
>>>>>>> 42ba4e0f14dbfdd5e1f12e0a7aeead3dfef664f1
=======

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
>>>>>>> b10c407930c0fdcec9df837515cc2807c07439c8
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
<<<<<<< HEAD
<<<<<<< HEAD
    %     %% Calculate Magnitude of Vectors
    %     methods (Access = public)
    %         function mag = vectorMag(obj, v)      %takes input vector as parameter
    %             dotProd = dot(v,v);          % dot product
    %             mag = norm(dotProd);        % magnitude
    %             return;
    %         end
    %     end
=======
    %% Calculate Magnitude of Vectors
    methods (Access = public)
        function mag = vectorMag(obj, vector)      %takes input vector as parameter
            sq = vector.*vector;
            dot = sum(sq);
            mag = sqrt(dot);        % magnitude
            return;
        end
    end
>>>>>>> 42ba4e0f14dbfdd5e1f12e0a7aeead3dfef664f1
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
=======
    %% Calculate Magnitude of Vectors
    methods (Access = public)
        function mag = vectorMag(obj, vector)      %takes input vector as parameter
            sq = vector.*vector;
            dot = sum(sq);
            mag = sqrt(dot);        % magnitude
            return;
>>>>>>> b10c407930c0fdcec9df837515cc2807c07439c8
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
end