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
            
%             for(i = 1:height(obj.topLayerPoints)-1)
%                 patch(XPA((4*i)-3:(4*i)),YPA((4*i)-3:(4*i)),ZPA((4*i)-3:(4*i)), 'r')
%                 hold on
%             end
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
            LPA = PrintLayer.removeDuplicatePoints(LPA);
            %%Add the first point to the array
            orderedArray(1) = LPA(1);
            LPA(1) = [];
            
            while(width(LPA) > 0)
                
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
                        if(currentPoint.isEqual(orderedArray(width(orderedArray))))
                            %%Add the current point to the list
                            orderedArray(width(orderedArray)+1) = currentPoint;
                            LPA(i) = [];
                            break;
                        end
                    end
                end
            end
            r = orderedArray;
        end
        
        
        
        function r = removeDuplicatePoints(pointArray)
            
            PA = pointArray;
            %%Sort the points by ID
            [~,ind] = sort([PA.id]);
            sortedPoints = PA(ind); 

            
            %%Check each ID for double points and remove if necessary
            toRemove = [];
            for(i = 1:width(sortedPoints)/2)
                if(sortedPoints((2*i)-1).isEqual(sortedPoints(2*i)))
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
    end
end
