function [file, increments] = simpleSlicing(file, increments)
%% Parameters
%Extract relevant paramters from excel file
data = stlread(file);
dataSize =size(data.faces);
n_elements = dataSize(1);
n_nodes = n_elements * 3;
ncon = data.faces;
X= data.vertices(:,1);
Y = data.vertices(:,2);
Z = data.vertices(:,3);


%% Element plotting
model = figure(1);  

for i = 1:n_elements
    n1 = ncon(i,1);
    n2 = ncon(i,2);
    n3 = ncon(i,3);
    x1 = X(n1);
    x2 = X(n2);
    x3 = X(n3);
    y1 = Y(n1);
    y2 = Y(n2);
    y3 = Y(n3);
    z1 = Z(n1);
    z2 = Z(n2);
    z3 = Z(n3);
    P =[x1;x2;x3];
    Q = [y1;y2;y3];
    R = [z1;z2;z3];

    xlabel('X-Axis')
    ylabel('Y-Axis')
    zlabel('Z-Axis')
    hold on;
    fill3(P,Q,R,'g')  
end
view(3);
saveas(model, 'model', 'bmp');


%% Slicing
% find the maximum height
zmax = 0;
zmin = Inf;
for i=1:n_nodes
    if Z(i)>=zmax
      zmax=Z(i);
    elseif Z(i)<=zmin
       zmin=Z(i);
    else
    end
end

% slicing parameters
INC = increments; % number of slices
NOSTEP = zmax/INC;
zs = zmin; % starting height

% iterate through number of steps
for i=1:NOSTEP-1
    zs=zs+INC; % increment height
    C=0; % counter
    
    for j = 1:n_elements % iterate through number of elements
        n1 = ncon(j,1);
        n2 = ncon(j,2);
        n3 = ncon(j,3);
        x1 = X(n1);
        x2 = X(n2);
        x3 = X(n3);
        y1 = Y(n1);
        y2 = Y(n2);
        y3 = Y(n3);
        z1 = Z(n1);
        z2 = Z(n2);
        z3 = Z(n3);
        
        if(z1 <= zs && zs <= z2) % if height order is z2-zs-z1
            C = C+1; % increase counter
            if (z1==z2) % if heights are the same (triangle is horizontal)
                XP(C) = x1; 
                YP(C) = y1;
                ZP(C) = zs;
            else % if not using similar triangles calculate
                XP(C) = x1+ ((z1-zs)/(z1-z2))*(x2-x1);
                YP(C) = y1+ ((z1-zs)/(z1-z2))*(y2-y1);
                ZP(C) = zs;
            end

        elseif(zs <= z1 && z2 <= zs) % if height oder is z1-zs-z2
            C = C+1; % increaes counter
            if (z1==z2)
                XP(C) = x1;
                YP(C) = y1;
                ZP(C) = zs;
            else
                XP(C) = x1+ ((z1-zs)/(z1-z2))*(x2-x1);
                YP(C) = y1+ ((z1-zs)/(z1-z2))*(y2-y1);
                ZP(C) = zs;
            end
        end
        
        % repeat above but check also for 2~3
        if(z2 <= zs && zs <= z3)
            C = C+1;
            if (z2==z3)
                XP(C) = x2;
                YP(C) = y2;
                ZP(C) = zs;
            else
                XP(C) = x2+ ((z2-zs)/(z2-z3))*(x3-x2);
                YP(C) = y2+ ((z2-zs)/(z2-z3))*(y3-y2);
                ZP(C) = zs;
            end

        elseif(z3 <= zs && zs <= z2)
            C = C+1;
            if (z2==z3)
                XP(C) = x2;
                YP(C) = y2;
                ZP(C) = zs;
            else
                XP(C) = x2+ ((z2-zs)/(z2-z3))*(x3-x2);
                YP(C) = y2+ ((z2-zs)/(z2-z3))*(y3-y2);
                ZP(C) = zs;
            end
        end

        % repeat above but check also for 3~1
        if(z3 <= zs && zs <= z1)
            C = C+1;
            if (z3==z1)
                XP(C) = x3;
                YP(C) = y3;
                ZP(C) = zs;
            else
                XP(C) = x1+ ((z3-zs)/(z3-z1))*(x1-x3);
                YP(C) = y1+ ((z3-zs)/(z3-z1))*(y1-y3);
                ZP(C) = zs;
            end
            
        elseif(zs <= z3 && z1 <= zs)
            C = C+1;
            if (z3==z1)
                XP(C) = x3;
                YP(C) = y3;
                ZP(C) = zs;
            else
                XP(C) = x1+ ((z3-zs)/(z3-z1))*(x1-x3);
                YP(C) = y1+ ((z3-zs)/(z3-z1))*(y1-y3);
                ZP(C) = zs;
            end
        end
    end
    
    % plot slicing
    slicing = figure(2)
    %set(slicing, 'Visible', 'off');
    plot3(XP,YP,ZP,'-r*', 'LineWidth', 1);
    hold on
    saveas(slicing, 'slicing', 'bmp');

    % plot structure
    structure = figure(3)
    %set(structure, 'Visible', 'off');
    fill3 (XP,YP,ZP, 'y')
    hold on
    saveas(structure, 'structure', 'bmp');
end

    
final = figure(4)
figure('Name', 'Final')
patch(data,'FaceColor',       [0.8 0.8 1.0], ...
         'EdgeColor',       'none',        ...
         'FaceLighting',    'gouraud',     ...
         'AmbientStrength', 0.15);
saveas(final, 'final', 'bmp');
% Add a camera light, and tone down the specular highlighting
camlight('headlight');
material('dull');

% Fix the axes scaling, and set a nice view angle
axis('image');
view([-135 35]);

saveas(final, 'final', 'bmp');
end

        