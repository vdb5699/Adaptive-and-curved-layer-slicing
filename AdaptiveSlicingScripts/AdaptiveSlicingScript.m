%% Parse file
n_elements = xlsread('SimpleShape.xlsx',1,'A2');
n_nodes = xlsread('SimpleShape.xlsx',1,'B2');
ncon = xlsread('SimpleShape.xlsx',1,'C2:E25');
X = xlsread('SimpleShape.xlsx',1,'F2:F18');
Y = xlsread('SimpleShape.xlsx',1,'G2:G18');
Z = xlsread('SimpleShape.xlsx',1,'H2:H18');

%% Parse data into objects

%%1. Create point objects
pointArray = [];

for i = 1 : n_nodes
    newPoint = Point(X(i),Y(i),Z(i));
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
for n = 1: n_elements
    p1 = triangleArray(n).point1;
    p2 = triangleArray(n).point2;
    p3 = triangleArray(n).point3;
    patch([p1.x;p2.x;p3.x],[p1.y;p2.y;p3.y],[p1.z;p2.z;p3.z],'g');
    hold on
end

model = Model(n_elements, n_nodes, pointArray, triangleArray);

slicedModel = AdaptiveSlicing(model);
slicedModel.plotLayers(2);

%% Parse file
n_elements = xlsread('extendedShape.xlsx',1,'A2');
n_nodes = xlsread('extendedShape.xlsx',1,'B2');
ncon = xlsread('extendedShape.xlsx',1,'C2:E33');
X = xlsread('extendedShape.xlsx',1,'F2:F25');
Y = xlsread('extendedShape.xlsx',1,'G2:G25');
Z = xlsread('extendedShape.xlsx',1,'H2:H25');

%% Parse data into objects

%%1. Create point objects
pointArray = [];

for i = 1 : n_nodes
    newPoint = Point(X(i),Y(i),Z(i));
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
figure(3)
view(3)
for n = 1: n_elements
    p1 = triangleArray(n).point1;
    p2 = triangleArray(n).point2;
    p3 = triangleArray(n).point3;
    patch([p1.x;p2.x;p3.x],[p1.y;p2.y;p3.y],[p1.z;p2.z;p3.z],'g');
    hold on
end

model = Model(n_elements, n_nodes, pointArray, triangleArray);

slicedModel = AdaptiveSlicing(model);
slicedModel.plotLayers(4);
