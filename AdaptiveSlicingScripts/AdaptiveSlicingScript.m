function adaptive = adaptiveSlicing(file, increments, thicknessArray, angleArray, residueArray)
%% Parse file
data = stlread(file);
dataSize =size(data.faces);
n_elements = dataSize(1);
n_nodes = n_elements * 3;
ncon = data.faces;
X= data.vertices(:,1);
Y = data.vertices(:,2);
Z = data.vertices(:,3);

% Determine X/Y/Z mins
Xmin = Inf;
Ymin = Inf;
Zmin = Inf;
for index = 1:height(X)
    point1 = X(index);
    point2 = Y(index);
    point3 = Z(index); 
    
    if point1 < Xmin
        Xmin = point1;
    end
    if point2 < Ymin
        Ymin = point2;
    end
    if point3 < Zmin
        Zmin = point3;
    end
end

% Shift all coordinates into positive
if Xmin < 0
    X1(:,1) = X(:,1) + abs(Xmin);
elseif Xmin > 0
    X1(:,1) = X(:,1) - abs(Xmin);
else
    X1 = X;
end
if Ymin < 0
    Y1(:,1) = Y(:,1) + abs(Ymin);
elseif Ymin > 0
    Y1(:,1) = Y(:,1) - abs(Ymin);
else
    Y1 = Y;
end
if Zmin < 0
    Z1(:,1) = Z(:,1) + abs(Zmin);
elseif Zmin > 0
    Z1(:,1) = Z(:,1) - abs(Zmin);
else
    Z1 = Z;
end
     

%% Parse data into objects

%%1. Create point objects
pointArray = [];

for i = 1 : n_nodes
    newPoint = Point(X1(i),Y1(i),Z1(i));
    pointArray = [pointArray; newPoint];
end

%%2. Create the triangular elements based on the ncon matrix
triangleArray = [];

for i = 1 : n_elements
    
    p1Index = ncon(i,1);
    p2Index = ncon(i,2);
    p3Index = ncon(i,3);
  
    triangleArray = [triangleArray; TriangularElement(pointArray(p1Index), pointArray(p2Index), pointArray(p3Index))];
  
end

%% Plot triangles
figure(1)
view(3)
for n = 1: height(triangleArray)
    p1 = triangleArray(n).point1;
    p2 = triangleArray(n).point2;
    p3 = triangleArray(n).point3;
    patch([p1.x;p2.x;p3.x],[p1.y;p2.y;p3.y],[p1.z;p2.z;p3.z],'g');
    hold on
end
% Print STL model
saveas(figure(1), 'model2', 'bmp');

% Save all variables to model
model = Model(n_elements, n_nodes, pointArray, triangleArray);
% Slice layers
slicedModel = AdaptiveSlicing(model, increments, thicknessArray, angleArray, residueArray);
% save output to return model
adaptive = slicedModel;
% Plot layers
slicedModel.plotLayers(4);

% Print 3d model
final = figure(4);
patch(data,'FaceColor',       [0.8 0.8 1.0], ...
'EdgeColor',       'none',        ...
'FaceLighting',    'gouraud',     ...
'AmbientStrength', 0.15);

camlight('headlight');
material('dull');
axis('image');
view([-135 35]);
saveas(final, 'final2', 'bmp');
close all
end
