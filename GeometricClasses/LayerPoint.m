
classdef LayerPoint < Point
    
    properties 
        id
    end

    methods
        
        function r = LayerPoint(x,y,z,id)
    
            r = r@Point(x,y,z);
            r.id = id;
        end
        
          function r = isEqual(this, point)
            r = isEqual@Point(this, point);
          end
    end
end