
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
        
        function r = isXYPointIntersect(obj, intersectPoint)
            
            %%Get XY Points of the triangle
            p1 = [obj.point1.x,obj.point1.y]; 
            p2 = [obj.point2.x,obj.point2.y];
            p3 = [obj.point3.x,obj.point3.y];
            
            %%Get XY Points of the intersect point
            pI = [intersectPoint.x,intersectPoint.y];
            
            %%check if the int point = any of the point in triangle
            if pI(1) == p1(1) && pI(2) == p1(2)
               r = 1;
               return
            elseif pI(1) == p2(1) && pI(2) == p2(2)
                r = 1;
               return
            elseif pI(1) == p3(1) && pI(2) == p3(2)
                r = 1;
               return
            end
            
            %%Create vectors between from the point to the vertices
            v1 = [p1(1) - pI(1); p1(2) - pI(2)];
            v2 = [p2(1) - pI(1); p2(2) - pI(2)];
            v3 = [p3(1) - pI(1); p3(2) - pI(2)];
            
            %%Calculate the angle between each vector
            magV1 = sqrt(v1(1)^2 + v1(2)^2);
            magV2 = sqrt(v2(1)^2 + v2(2)^2);
            magV3 = sqrt(v3(1)^2 + v3(2)^2);
            dotV12 = dot(v1,v2);
            dotV23 = dot(v2,v3);
            dotV31 = dot(v3,v1);
            
            %%add up the angles
            angle12 = round(acosd(dotV12/(magV1 * magV2)));
            angle23 = round(acosd(dotV23/(magV2 * magV3)));
            angle31 = round(acosd(dotV31/(magV3 * magV1)));
            
            if((angle12 + angle23 + angle31) == 360)
                r = 1;
                return;
            else
                r = 0;
                return;
            end
        end
        
        function r = getPointIntersect(obj, intersectPoint)
        
            %%Calculate a normal vector to the plane
            %%Get XY Points of the triangle
            p1x = obj.point1.x; 
            p1y = obj.point1.y;
            p1z = obj.point1.z; 
            p2x = obj.point2.x; 
            p2y = obj.point2.y; 
            p2z = obj.point2.z; 
            p3x = obj.point3.x; 
            p3y = obj.point3.y; 
            p3z = obj.point3.z; 
            
            px = intersectPoint.x;
            py = intersectPoint.y;
            pz = intersectPoint.z;             
            
            %%Find vectors on plane 
            v12 = [p1x - p2x, p1y - p2y, p1z - p2z];
            v13 = [p1x - p3x, p1y - p3y, p1z - p3z];
            
            %%Find cross product of the vectors
            crossV = cross(v12, v13);
            
            N1 = crossV(1);
            N2 = crossV(2);
            N3 = crossV(3);
            
            %%Calculate t  
            t = ((N1*(p1x - px))+(N2*(p1y - py))+(N3*(p1z - pz)))/N3
            x = px; 
            y = py;
            z = pz + t;
            r = Point(x,y,z);
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
            if isnan(r)
                r = 1;
            end
            
        end
        
       
    end
end
