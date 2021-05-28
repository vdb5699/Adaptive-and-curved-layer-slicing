classdef NMmat
    properties (Access = public)
        numCol;
        numRow;
        Nmatrix;
        Mmatrix;
        n;
        m;
    end
    
    methods (Access = public)
       function obj = NMmat(numCol, numRow)
           obj.numCol = numCol;
           obj.numRow = numRow;
           obj.n = numRow-1;
           obj.m = numCol-1;
           obj.Nmatrix = createMat(obj,obj.n);
           obj.Mmatrix = createMat(obj,obj.m);
       end
    end
    
    methods (Access = private)
  
        function N = createMat(obj,h)
           N = zeros(h+1);
           for row = 0:h
               for col = 0:h
                   if (col+row) <= h
                       N(row+1,col+1) = firstBit(obj,col,row,h)*secondBit(obj,row,col,h);
                   else
                       N(row+1,col+1) = 0;
                   end
               end
           end
            return;
        end
        
        function result = firstBit(obj,col,row,n)
            result = factorial(n)/(factorial(col)*factorial(row)*factorial(n-col-row));
            return;
        end
        
        function result = secondBit(obj,n,col,row)
                result = (-1)^(n-row-col);
            return;
        end
    end
end