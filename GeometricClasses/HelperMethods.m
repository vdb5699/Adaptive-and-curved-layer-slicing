%%Class supplies some helper static methods for some geometric calculations 
classdef HelperMethods
    methods(Static)
        
        %% A method for finding the point in which a Z plane specified by zp 
        %% intersects a line connecting two Point objects, p1 and p2.  
        function r = FindPlaneIntersect(p1, p2, zp, triangleIndex)
            
            %% Check if the points are within range
            if(p1.z > zp && p2.z > zp)
                r = LayerPoint(-1,-1,-1,triangleIndex);
                return;
            elseif(p1.z < zp && p2.z < zp)
                r = LayerPoint(-1,-1,-1,triangleIndex);
                return;
            end
            
            %%If the points are vertical then return either
            if(p1.x == p2.x && p1.y == p2.y)
                r = LayerPoint(p1.x, p1.y, zp,triangleIndex);
                return;
                %%If the points are horizontal then return a negative point
            elseif(p1.z == p2.z)
                r = LayerPoint(-1,-1,-1,triangleIndex);
                return;
                %%Calculate the X slope
                %%Find upper point
            end
            
            if(p1.z > p2.z)
                upperPoint = p1;
                lowerPoint = p2;
            else
                upperPoint = p2;
                lowerPoint = p1;
            end
            
            %%If a positive slope
            if(upperPoint.x > lowerPoint.x)
                xp = ((zp - lowerPoint.z)/(upperPoint.z - lowerPoint.z))*(upperPoint.x - lowerPoint.x) + lowerPoint.x;
                %%If a negative slope
            else
                xp = ((lowerPoint.z - zp)/(upperPoint.z - lowerPoint.z))*(lowerPoint.x - upperPoint.x) + lowerPoint.x;
            end
            
            %%Calculate the Y slope
            %%If a positive slope
            if(upperPoint.y > lowerPoint.y)
                yp = ((zp - lowerPoint.z)/(upperPoint.z - lowerPoint.z))*(upperPoint.y - lowerPoint.y) + lowerPoint.y;
                %%If a negative slope
            else
                yp = ((lowerPoint.z - zp)/(upperPoint.z - lowerPoint.z))*(lowerPoint.y - upperPoint.y) + lowerPoint.y;
            end
            
            r = LayerPoint(xp, yp, zp, triangleIndex);
            return;
            
            
        end
        
        function r = GetRecommendedThickness(elementAngle, thicknessArray, angleArray)
            angleArray = cell2mat(angleArray);
            if(elementAngle >=angleArray(1) && elementAngle < angleArray(2))
                r = thicknessArray(2);
                return; 
            elseif(elementAngle >=angleArray(2) && elementAngle < angleArray(3))    
                r = thicknessArray(3);
                return;
            elseif(elementAngle >=angleArray(3) && elementAngle < angleArray(4))
                r = thicknessArray(4);
                return;
            elseif(elementAngle >=angleArray(4) && elementAngle <= angleArray(5))    
                r = thicknessArray(5);
                return;
            else
                r = -1;
                return;
            end
        end
        
        function r = GetResidualLayerThickness(minimumResidual, thicknessArray, residueArray)
            residueArray = cell2mat(residueArray);
            if(minimumResidual >= residueArray(1) && minimumResidual < residueArray(2))
                r = thicknessArray(2); 
                return; 
            elseif(minimumResidual >= residueArray(2) && minimumResidual < residueArray(3))    
                r = thicknessArray(3); 
                return;
            elseif(minimumResidual >= residueArray(3) && minimumResidual < residueArray(4))
                r = thicknessArray(4);
                return;
            elseif(minimumResidual >= residueArray(4) && minimumResidual <= residueArray(5))    
                r = thicknessArray(5);
                return;
            else
                r = -1;
                return;
             end
        end
        
    end
end