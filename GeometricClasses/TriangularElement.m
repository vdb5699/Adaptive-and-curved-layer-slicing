
classdef TriangularElement
    
    properties
        point1
        point2
        point3
        angle
    end
    methods
        function r = TriangularElement(p1, p2, p3)
            r.point1 = p1;
            r.point2 = p2;
            r.point3 = p3;
            r.angle = TriangularElement.getTriangularElementAngle(p1,p2,p3);
            
        end
    end
    methods
       
        function r = isIntersected(obj, zp) 
            
            z1 = round(obj.point1.z*10000)/10000;
            z2 = round(obj.point2.z*10000)/10000;
            z3 = round(obj.point3.z*10000)/10000;
            
            
            if (z1 < zp && z2 < zp && z3 < zp)
                r = false;
                return;
            elseif(z1 > zp && z2 > zp && z3 > zp)
                r = false;
                return;
            end
        
            r = true;
            return;
        end
    end    
    
    
    
    methods(Static)
        function r = getTriangularElementAngle(p1,p2,p3)
            
            %%1. Calculate vectors between two points
            v1 = [(p2.x-p1.x); (p2.y-p1.y); (p2.z - p1.z)];
            v2 = [(p1.x-p3.x); (p1.y-p3.y); (p1.z - p3.z)];
            
            %%2. Calculate the cross product of the two vectors
            normalV = cross(v1,v2);
            %%3. Calculate the dot product with a vector on the x-y plane
            vh = [normalV(1);normalV(2);0];
            dotV = dot(vh,normalV);
            
            %%4. Calculate the magnitude of both vectors
            magVh = sqrt((vh(1)^2)+(vh(2)^2)+(vh(3)^2));
            magVnormal = sqrt((normalV(1)^2)+(normalV(2)^2)+(normalV(3)^2));
            
            %%5. Return the angle between the normal and horizontal vector
            
            r = round(-(acosd((dotV)/(magVh * magVnormal))-90));
        end
    end
end
