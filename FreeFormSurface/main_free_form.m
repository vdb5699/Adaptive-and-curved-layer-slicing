classdef main_free_form
    
    
    methods(Access = public)
        function obj = main_free_form()
           main(obj); 
        end
    end
    methods(Access = private)
       
        function main(obj)
            clear;
            
%             Bx = [0 15 30 45 60; 0 15 30 45 60; 0 15 30 45 60; 0 15 30 45 60; 0 15 30 45 60];
%             By = [0 0 0 0 0; 15 15 15 15 15; 30 30 30 30 30; 45 45 45 45 45; 60 60 60 60 60];
%             Bz = [0 25 50 25 0; 25 65 400 65 25; 50 200 750 200 50; 25 65 400 65 25; 0 25 50 25 0];
%             Bx = [0 0 2 2;0 0 2 2];
%             By = [0 0 0 0;2 2 2 2];
%             Bz = [0 2 2 0;0 2 2 0];

            Bx = [0 2.5 5; 0 2.5 5; 0 2.5 5; 0 2.5 5; 0 2.5 5];
            By = [0 0 0 ; 1.25 1.25 1.25; 2.5 2.5 2.5; 3.75 3.75 3.75; 5 5 5];
            Bz = [0 0 0; 0 5 0; 0 10 0; 0 5 0; 0 0 0];
            thickness = 0.2;
            numOfLayers = 5;
            
            mat = NMmat(4,2);
            N = mat.Nmatrix;
            M = mat.Mmatrix;
            
            res = 30;
            resc = 30;
            resr = 30;
            
            a = Points(res,res,1,Bx,By,Bz);
            b = Points(resc,resr,2,Bx,By,Bz);
             
            figure(3);
            mesh(Bx,By,Bz);
            bezier = BezierSurface(Bx, By, Bz, res);
            points = bezier.data;
            
            newLayers = Layers(bezier, thickness, numOfLayers);
        end
    end
    
end