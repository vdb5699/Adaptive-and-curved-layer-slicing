

classdef Model

    properties
    
        elementsNumber;
        nodesNumber;
        nodeArray;
        triangularElementArray;
    
    end

    methods
        
        function r = Model(elementNumber, nodeNumber, nodeArray, triangularElementArray)
        
            r.elementsNumber = elementNumber;
            r.nodesNumber = nodeNumber;
            r.nodeArray = nodeArray;
            r.triangularElementArray = triangularElementArray;
        end
    end
end