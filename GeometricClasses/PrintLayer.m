%% Class that represents a 3d layer of a model
%% It contains points for the top and bottom surface and the layer height.
classdef PrintLayer

    properties 
    
        topLayerPoints %% An Array of point object representing the 
        %%intersection points of the layer's top surface with the model
        
        bottomLayerPoints %% An Array of point object representing the 
        %%intersection points of the layer's bottom surface with the model
        
        layerWidth %%The width of the layer. The distance between the top and bottom points 
   
    end
    
    methods
        function r = PrintLayer(topArray, layerW)
            TA = topArray;
            if(height(TA) > 0)
                r.topLayerPoints = PrintLayer.sortLayerVertices(TA)';
                lowerPoints = [];
                for(n = 1 : height(r.topLayerPoints))
                    lowerPoints = [lowerPoints; LayerPoint(r.topLayerPoints(n).x, r.topLayerPoints(n).y,r.topLayerPoints(n).z - layerW, r.topLayerPoints(n).id)];
                end
                r.bottomLayerPoints = lowerPoints;
            else
                r.topLayerPoints = [LayerPoint(-1,-1,-1,-1)];
                r.bottomLayerPoints = r.topLayerPoints;
            end
            r.layerWidth = layerW;
        end
  
        function r = fill3Layer(obj)
            %%Top layer
            for i = 1 : height(obj.topLayerPoints)
                XPU(i) =obj.topLayerPoints(i,1).x;
                YPU(i) =obj.topLayerPoints(i,1).y;
                ZPU(i) = obj.topLayerPoints(i,1).z;
            end
            %%Bottom layer
            for i = 1 : height(obj.bottomLayerPoints)
                XPB(i) = obj.bottomLayerPoints(i,1).x;
                YPB(i) = obj.bottomLayerPoints(i,1).y;
                ZPB(i) = obj.bottomLayerPoints(i,1).z;
            end
            %%Alternating
            C = 0;
            for i = 1 : height(obj.topLayerPoints)-1
                C = C+1;
                XPA(C) = obj.topLayerPoints(i,1).x;
                YPA(C) = obj.topLayerPoints(i,1).y;
                ZPA(C) = obj.topLayerPoints(i,1).z;
                C = C+1;
                XPA(C) = obj.bottomLayerPoints(i,1).x;
                YPA(C) = obj.bottomLayerPoints(i,1).y;
                ZPA(C) = obj.bottomLayerPoints(i,1).z;
                C = C+1;
                XPA(C) = obj.bottomLayerPoints(i+1,1).x;
                YPA(C) = obj.bottomLayerPoints(i+1,1).y;
                ZPA(C) = obj.bottomLayerPoints(i+1,1).z;
                C = C+1;
                XPA(C) = obj.topLayerPoints(i+1,1).x;
                YPA(C) = obj.topLayerPoints(i+1,1).y;
                ZPA(C) = obj.topLayerPoints(i+1,1).z;
            end
            
            fill3(XPB,YPB,ZPB, 'y')
            hold on
            fill3(XPU,YPU,ZPU, 'y')
            hold on
        end
        
        function r = plot3Layer(obj)
            %%Top layer
            for i = 1 : height(obj.topLayerPoints)
                XPU(i) =obj.topLayerPoints(i,1).x;
                YPU(i) =obj.topLayerPoints(i,1).y;
                ZPU(i) = obj.topLayerPoints(i,1).z;
            end
            %%Bottom layer
            for i = 1 : height(obj.bottomLayerPoints)
                XPB(i) = obj.bottomLayerPoints(i,1).x;
                YPB(i) = obj.bottomLayerPoints(i,1).y;
                ZPB(i) = obj.bottomLayerPoints(i,1).z;
            end
            %%Alternating
            C = 0;
            for i = 1 : height(obj.topLayerPoints)-1
                C = C+1;
                XPA(C) = obj.topLayerPoints(i,1).x;
                YPA(C) = obj.topLayerPoints(i,1).y;
                ZPA(C) = obj.topLayerPoints(i,1).z;
                C = C+1;
                XPA(C) = obj.bottomLayerPoints(i,1).x;
                YPA(C) = obj.bottomLayerPoints(i,1).y;
                ZPA(C) = obj.bottomLayerPoints(i,1).z;
                C = C+1;
                XPA(C) = obj.bottomLayerPoints(i+1,1).x;
                YPA(C) = obj.bottomLayerPoints(i+1,1).y;
                ZPA(C) = obj.bottomLayerPoints(i+1,1).z;
                C = C+1;
                XPA(C) = obj.topLayerPoints(i+1,1).x;
                YPA(C) = obj.topLayerPoints(i+1,1).y;
                ZPA(C) = obj.topLayerPoints(i+1,1).z;
            end
            figure(2);
            plot3(XPU,YPU,ZPU,'-r*', 'LineWidth', 0.2);
            hold on;

        end
    end
    methods(Static)
        function r = sortLayerVertices(layerPointArray)
            
            LPA = layerPointArray';
            LPA = PrintLayer.removeTriplePoints(LPA);
            LPA = PrintLayer.removeDuplicatePoints(LPA);
            LPA = PrintLayer.removeAdjacentPoints(LPA);
            %%Add the first point to the array
            orderedArray(1) = LPA(1);
            LPA(1) = [];
            
            while(width(LPA) > 0 )
                
                %%Find the matching index
                for(i = 1 : width(LPA))
                    currentPoint = LPA(i);
                    if(currentPoint.id == orderedArray(width(orderedArray)).id)
                        %%Add the current point to the ordered array
                        orderedArray(width(orderedArray)+1) = currentPoint;
                        LPA(i) = [];
                        break;
                    end
                end
                
                if(width(LPA) > 0)
                    %%Find the matching points
                    for i = 1: width(LPA)
                        %%Collect all identical points
                        currentPoint = LPA(i);
                        p1x = round(currentPoint.x *10000)/10000;
                        p1y = round(currentPoint.y *10000)/10000;
                        p1z = round(currentPoint.z *10000)/10000;
                        p2x = round(orderedArray(width(orderedArray)).x *10000)/10000;
                        p2y = round(orderedArray(width(orderedArray)).y *10000)/10000;
                        p2z = round(orderedArray(width(orderedArray)).z *10000)/10000;
                        point1 = Point(p1x,p1y,p1z);
                        point2 = Point(p2x,p2y,p2z);
                        if(point1.isEqual(point2))
                            %%Add the current point to the list
                            orderedArray(width(orderedArray)+1) = currentPoint;
                            LPA(i) = [];
                            break;
                        end
                    end
                end
                if(orderedArray(1).isEqual(orderedArray(width(orderedArray))))
                    break;
                end
            end
            r = orderedArray;
        end
        
        function r = removeTriplePoints(pointArray)
            
            PA = pointArray;
            %%Sort the points by ID
            [~,ind] = sort([PA.id]);
            sortedPoints = PA(ind); 

            
            %%Check each ID for triple points and remove if necessary
            toRemove = [];
            for(i = 1:width(sortedPoints)-2)
                 if(sortedPoints(i).id == sortedPoints(i+1).id && sortedPoints(i+1).id == sortedPoints(i+2).id)
                   %%Find duplicate points
                   point1 = sortedPoints(i);
                   point2 = sortedPoints(i+1);
                   point3 = sortedPoints(i+2);
                   if(point1.isEqual(point2) && ~point1.isEqual(point3))
                        toRemove = [toRemove; i];
                   elseif(point1.isEqual(point3) && ~point1.isEqual(point2))
                        toRemove = [toRemove; i];
                   elseif(point2.isEqual(point3) && ~point2.isEqual(point1))
                        toRemove = [toRemove; i+1];
                   end
                end
            end

            %%Check if all points will be removed
            if(height(toRemove) == width(sortedPoints))
                r = sortedPoints(1);
                return;
            end
            if(height(toRemove) ~= 0 && width(toRemove) ~= 0)
                removed1 = sortedPoints(toRemove(1)); 
                removed2 = sortedPoints(toRemove(2));
                %%Remove points and return 
                sortedPoints(toRemove) = [];
                match1 = [];
                match2 = [];
                %%Find the duplicate point
                for i = 1:width(sortedPoints)
                    if(removed1.isEqual(sortedPoints(i)))
                        match1 = [match1; sortedPoints(i)];
                    end
                    if(removed2.isEqual(sortedPoints(i)))
                        match2 = [match2; sortedPoints(i)];
                    end
                end
                
                for i = 1:height(match1)
                    searchId = match1(i).id;
                    for(j = 1:height(match2))
                        if(searchId == match2(j).id)
                            break;
                        end
                    end
                end
                
                %%Loop through and remove specified ID
                for(i = 1:width(sortedPoints))
                    if(searchId == sortedPoints(i).id)
                        sortedPoints(i+1) = [];
                        sortedPoints(i) = [];
                        break;
                    end
                end
                
            else
                sortedPoints(toRemove) = [];
            end
            r = sortedPoints;
            return;
        end
        
        function r = removeDuplicatePoints(pointArray)
            
            PA = pointArray;
            %%Sort the points by ID
            [~,ind] = sort([PA.id]);
            sortedPoints = PA(ind); 

            
            %%Check each ID for double points and remove if necessary
            toRemove = [];
            for(i = 1:width(sortedPoints)/2)
                p1x = round(sortedPoints((2*i)-1).x *10000)/10000;
                p1y = round(sortedPoints((2*i)-1).y *10000)/10000;
                p1z = round(sortedPoints((2*i)-1).z *10000)/10000;
                p2x = round(sortedPoints((2*i)).x *10000)/10000;
                p2y = round(sortedPoints((2*i)).y *10000)/10000;
                p2z = round(sortedPoints((2*i)).z *10000)/10000;
                point1 = Point(p1x,p1y,p1z);
                point2 = Point(p2x,p2y,p2z);
                 if(point1.isEqual(point2))
                    toRemove = [toRemove;(2*i)-1;(2*i)];
                end
            end

            %%Check if all points will be removed
            if(height(toRemove) == width(sortedPoints))
                r = sortedPoints(1);
                return;
            end
            %%Remove points and return 
            sortedPoints(toRemove) = [];
            
            r = sortedPoints;
            return;
        end
        
        function r = removeAdjacentPoints(pointArray)
            
            PA = pointArray;
            %%Sort the points by ID
            [~,ind] = sort([PA.id]);
            sortedArray = PA(ind); 
            matchArray = [];
            %%Create a matrix of the points by id
            for i = 1:width(sortedArray)/2
                matchRow = [sortedArray((2*i)-1),sortedArray(2*i)];
                matchArray = [matchArray;matchRow];
            end
            
            %%Iterate throught the matched array and see if there is any
            %%duplicate points
            toRemove = [];
            for j = 1:height(matchArray)-1
                currentMatch = matchArray(j, 1:2);
               for k = j+1:height(matchArray)
                   currentCheck = matchArray(k, 1:2);
                   if(currentMatch(1).isEqual(currentCheck(1)) && currentMatch(2).isEqual(currentCheck(2)))
                       toRemove = [toRemove; j];
                   elseif(currentMatch(2).isEqual(currentCheck(1)) && currentMatch(1).isEqual(currentCheck(2)))
                       toRemove = [toRemove; j];
                   end  
               end 
            end
            
            %%Remove necessary values
            %%Check if all points will be removed
            if(height(toRemove) == width(sortedArray))
                r = sortedArray(1);
                return;
            end
                matchArray(toRemove,:) = [];
           %%Turn the remaining points into a row vector
          for(i = 1:height(matchArray))
            returnArray((2*i)-1) = matchArray(i,1);
            returnArray(2*i) = matchArray(i,2);
          end
          
          r = returnArray;
          return;
        end
    end
end
