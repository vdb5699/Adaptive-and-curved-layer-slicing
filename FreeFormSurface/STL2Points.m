%% this class converts STL model into key points depending on user input
classdef STL2Points
    %% result variables
    properties (Access = public)
        Bx;
        By;
        Bz;
        
        points;
    end
    
    %% private variables
    properties (Access = private)
        model;
        cutX;
        cutY;

        xmin;
        xmax;
        ymin;
        ymax;
        
        minmaxArray;
        Tarray;
    end
    
    %% contructor
    methods (Access = public)
        
        function obj = STL2Points(model,cutX,cutY)
            obj.model = model;
            obj.cutX = cutX;
            obj.cutY = cutY;
            obj.Tarray = model.triangularElementArray;
            
            obj.minmaxArray = setMinMax(obj,obj.Tarray);
            obj.xmin = obj.minmaxArray(1);
            obj.xmax = obj.minmaxArray(2);
            obj.ymin = obj.minmaxArray(3);
            obj.ymax = obj.minmaxArray(4);
            
            obj.points = findPoints(obj,cutX,cutY,obj.minmaxArray);
            array1 = getZ(obj,obj.points);
            array = separate(obj,array1);
            num = width(array)/3;
            num = round(num);
            obj.Bx = array(:,1:num);
            obj.By = array(:,num+1:(2*num));
            obj.Bz = array(:,((2*num)+1:(3*num)));
        end
        
    end
    
    
    methods (Access = private)
        %% this function finds the maximum x and y, minimum x and y points
        function values = setMinMax(obj,Tarray)
            array = Tarray;
            Xmin = Inf;
            Xmax = -Inf;
            Ymin = Inf;
            Ymax = -Inf;
            for index = 1:height(array)
                point1 = array(index).point1;
                point2 = array(index).point2;
                point3 = array(index).point3;
                
                if point1.x < Xmin
                   Xmin = point1.x; 
                end
                if point2.x < Xmin
                    Xmin = point2.x;
                end
                if point3.x < Xmin
                    Xmin = point3.x; 
                end
                
                if point1.x > Xmax
                   Xmax = point1.x; 
                end
                if point2.x > Xmax
                    Xmax = point2.x;
                end
                if point3.x > Xmax
                    Xmax = point3.x; 
                end
                
                if point1.y < Ymin
                   Ymin = point1.y; 
                end
                if point2.y < Ymin
                   Ymin = point2.y; 
                end
                if point3.y < Ymin
                   Ymin = point3.y; 
                end
                
                if point1.y > Ymax
                   Ymax = point1.y; 
                end
                if point2.y > Ymax
                   Ymax = point2.y; 
                end
                if point3.y > Ymax
                   Ymax = point3.y; 
                end
            end
            values = [Xmin Xmax Ymin Ymax];
            return
        end
        
        %% calculates the points to investigate 
        function points = findPoints(obj, cutX, cutY, minmaxArray)
            lengthx = minmaxArray(2) - minmaxArray(1);
            lengthy = minmaxArray(4) - minmaxArray(3);
            xEach = lengthx/(cutX-1);
            yEach = lengthy/(cutY-1);
            arrayP = [];
            arrayRow = [];
            for row = 0:cutX-1
                for col = 0:cutY-1
                    x = (minmaxArray(1) + (xEach*col));
                    y = (minmaxArray(3) + (yEach*row));
                    p = Point(x,y,0);
                    arrayRow = [arrayRow p];
  
                end
                arrayP = [arrayP ; arrayRow];
                arrayRow = [];
            end
            points = arrayP;
            return
        end
        
        %% Separate x, y, z coordinates
        function array = separate(obj, arrayXYZ)
           for  row = 1:height(arrayXYZ)
               for col = 1:width(arrayXYZ)
                   cell = arrayXYZ(row,col);
                   array1(row,col) = cell.x;
                   array2(row,col) = cell.y;
                   array3(row,col) = cell.z;
               end
           end
           array = [array1 array2 array3];
           return
        end
        %% get Z coordinate for each point
        function array = getZ(obj, arrayXY)
            arraytemp = arrayXY;
            for row = 1:height(arrayXY)
                for col = 1:width(arrayXY)
                    tempA = [];
                    for index = 1:size(obj.Tarray)
                        triangle = obj.Tarray(index);
                        p1 = arrayXY(row,col);
                        if triangle.isXYPointIntersect(p1) == 1
                            
                            p = triangle.getPointIntersect(p1);
                            tempA = [tempA p];
                        end
                    end
                    if width(tempA) > 1
                       [~,hi] = sort([tempA.z]);
                       arraytemp(row,col) = tempA(hi(width(hi)));
                    elseif width(tempA) == 1
                       arraytemp(row,col) = tempA(1); 
                    end
                end
            end
            array = arraytemp;
            return
        end
    end
end    