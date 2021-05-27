%% Represents a coordinate in 3d space
classdef Point
    
    properties
        x;
        y;
        z;
    end
 
    methods
        %% Constructor
         function r = Point(xVal, yVal, zVal)
            r.x = xVal;
            r.y = yVal;
            r.z = zVal;
         end
        
         function r = isEqual(this, point)
         
             if((this.x == point.x) && (this.y == point.y) && (this.z == point.z))
                r = true;
                return;
             else
                 r = false;
                 return;
             end
             
         end
         
         
    end
end