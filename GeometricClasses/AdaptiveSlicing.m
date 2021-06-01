classdef AdaptiveSlicing
    
    properties
        slicedLayers %%An array of adaptively sliced layers
        thicknessArray%%An array holding the thickness ranges for the layers
        angleArray%%An array holding the corresponding angle ranges for the layers
        residueArray %% An array holding residue height ranges for layers
        increments%%Ascaling factor for the layers
    end
    
    methods
        
        function r = getLayerPoints(obj,index) 
            
             layer = obj.slicedLayers(index);   
             topPoints = layer.topLayerPoints;
             bottomPoints = layer.bottomLayerPoints;   
             %%Get the top an bottom points of the layer 
             outputArray = [];
             for i = 1: length(topPoints)
                 rowPoints = [topPoints(i).x, topPoints(i).y, topPoints(i).z, bottomPoints(i).x, bottomPoints(i).y, bottomPoints(i).z] ;
                 outputArray = [outputArray;rowPoints];
             end    
             
                r = outputArray;
        end
        
        function r = AdaptiveSlicing(model, increments, thicknessArray, angleArray, residueArray)
            r.slicedLayers = r.SliceModel(model, increments, thicknessArray, angleArray, residueArray);
            r.thicknessArray = thicknessArray;
            r.angleArray = angleArray;
            r.residueArray = residueArray;
            r.increments = increments;
        end
        
        function r = getRecommendedSliceThickness(obj,triangleArray, currentHeight, thicknessIndex, thicknessArray, angleArray, residueArray)
            
            %% 1. Determine maximum thickness based on the residual height of the intersected triangles
            %% Find the triangles intersected by the current height
            intersectedTri = [];
            for i = 1 : height(triangleArray)
                currentTriangle = triangleArray(i);
                if(currentTriangle.isIntersected(currentHeight))
                    if(currentHeight == 0)
                        p1 = currentTriangle.point1;
                        p2 = currentTriangle.point2;
                        p3 = currentTriangle.point3;
                        if(p1.z == 0 && p2.z == 0 && p3.z == 0)
                        else
                            intersectedTri = [intersectedTri; currentTriangle];
                        end
                    else
                        intersectedTri = [intersectedTri; currentTriangle];
                    end
                end
            end
            
            minimumHeight = Inf;
            %%Find the vertex with the minimum z value
            for (i = 1:height(intersectedTri))
                
                currentTri = intersectedTri(i);
                p1 = currentTri.point1;
                p2 = currentTri.point2;
                p3 = currentTri.point3;
                localMax = p1.z;
                if(localMax < p2.z)
                    localMax = p2.z;
                end
                if(localMax < p3.z)
                    localMax = p3.z;
                end
                
                if(localMax < minimumHeight)
                    minimumHeight = localMax;
                end
            end
            
            %%Calculate the minimum residual and get the maximum thickness in mm
            minimumResidual = minimumHeight-currentHeight;
            residualThickness = HelperMethods.GetResidualLayerThickness(minimumResidual, thicknessArray, residueArray);
            
            %%2. Determine the maximum thickness based on the minimum angle of the intersected elements
            
            for count = thicknessIndex:width(thicknessArray)
                
                %%Find all triangles intersected by the current slice height
                checkHeight = currentHeight + thicknessArray(count);
                
                intersectedTri = [];
                for i = 1 : height(triangleArray)
                    currentTriangle = triangleArray(i);
                    if(currentTriangle.isIntersected(checkHeight))
                        intersectedTri = [intersectedTri; currentTriangle];
                    end
                end
                
                %%Check the angles of each intersected triangle and adjust the slice thickness
                minThickness = 100;
                for j = 1 : height(intersectedTri)
                    
                    currentTriangle = intersectedTri(j);
                    %%Check the recommended thickness
                    rec = HelperMethods.GetRecommendedThickness(currentTriangle.angle, thicknessArray, angleArray);
                    %%set the minimum thickness
                    if(minThickness > rec)
                        minThickness = rec;
                    end
                end
                
                %%Determine if the angle slice thickness should change
                if(minThickness == thicknessArray(count))
                    break;
                end
            end
            
            %%Set slice thickness
            adaptThickness = minThickness;
            
            %%3. Set the slice thickness to the minimum from the two checks
            if(residualThickness < adaptThickness)
                r = residualThickness;
            else
                r = adaptThickness;
            end
        end
        
        function r = getLayer(obj, triangleArray, currentHeight, currentSliceThickness, zMax)
            
            sliceHeight = currentHeight + currentSliceThickness;
            
            if(sliceHeight ~= zMax)
                %% Find the triangles intersected by the current height
                intersectedTri = [];
                for i = 1 : height(triangleArray)
                    currentTriangle = triangleArray(i);
                    if(currentTriangle.isIntersected(sliceHeight))
                        intersectedTri = [intersectedTri; currentTriangle];
                    end
                end
            else
                 %% Find the triangles intersected by the current height
                intersectedTri = [];
                for i = 1 : height(triangleArray)
                    currentTriangle = triangleArray(i);
                    if(currentTriangle.isIntersected(sliceHeight))
                        intersectedTri = [intersectedTri; currentTriangle];
                    end
                end
            end
            C=0;
            UP = [];
            for k = 1 : height(intersectedTri)
                
                currentTri = intersectedTri(k);
                intersection1 = HelperMethods.FindPlaneIntersect(currentTri.point1, currentTri.point2, sliceHeight, k);
                intersection2 = HelperMethods.FindPlaneIntersect(currentTri.point1, currentTri.point3, sliceHeight, k);
                intersection3 = HelperMethods.FindPlaneIntersect(currentTri.point2, currentTri.point3, sliceHeight, k);
                
                %%Only add if point is not on the list
                
                if(intersection1.x ~= -1)
                    C = C+1;
                    UP = [UP; intersection1];
                end
                if(intersection2.x ~= -1)
                    C = C+1;
                    UP = [UP; intersection2];
                end
                if(intersection3.x ~= -1)
                    C = C+1;
                    UP = [UP; intersection3];
                end
            end
            
            %%Create the layer object
            upperPoints = UP;
            r = PrintLayer(upperPoints, currentSliceThickness);
           
         
        end
        
        function plotLayers(obj,figureNumber) 
            figure(2)
            view(3)
            for(i = 1: height(obj.slicedLayers))
                toPlot = obj.slicedLayers(i);
                hold on
                toPlot.plot3Layer();
            end
            saveas (figure(2), 'slicing2', 'bmp');
            
            figure(3)
            view(3)
            for(i = 1: height(obj.slicedLayers))
                toPlot = obj.slicedLayers(i);
                hold on
                toPlot.fill3Layer();
            end
            saveas (figure(3), 'structure2', 'bmp');
            
        end
        
        function r = SliceModel(obj, model, increments, thicknessArray, angleArray, residueArray)
            
            %%Initialise variables
            currentHeight = 0;
            zMax = 0;
            printLayers = [];
            newModel = model;
            pointArray = newModel.nodeArray;
            thicknessIndex = 4;
            thicknessArr = cell2mat(thicknessArray);
            angleArr = angleArray;
            residueArr = residueArray;
            
            triangleArray = newModel.triangularElementArray;
            for i=1:model.nodesNumber
                if pointArray(i).z >= zMax
                    zMax=pointArray(i).z;
                end
            end
            
            %%Create layers
            while (currentHeight < zMax)
                %%Get the adaptive slice thickness
                currentSliceThickness = obj.getRecommendedSliceThickness(triangleArray, currentHeight, thicknessIndex, thicknessArr, angleArr, residueArr);
                %%Get the layer from the slice
                newLayer = obj.getLayer(triangleArray, currentHeight, currentSliceThickness, zMax);
                %%Update all values
                if(newLayer.topLayerPoints(1).id ~= -1)
                    printLayers = [printLayers; newLayer];
                end
                currentHeight = round((currentHeight + currentSliceThickness* increments)*100)/100;
                if(currentSliceThickness == 1)
                    thicknessIndex = 1;
                elseif(currentSliceThickness == 0.5)
                    thicknessIndex = 2;
                elseif(currentSliceThickness == 0.2)
                    thicknessIndex = 3;
                elseif(currentSliceThickness == 0.1)
                    thicknessIndex = 4;
                end
            end
            %%return the layers array
            r = printLayers;
        end
end
end