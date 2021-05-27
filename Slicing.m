%% Parameters
%Extract relevant paramters from excel file
% test =size(fv.faces)
% n_element = test(1);
% n_nodes = n_element * 2;
% ncon = fv.faces;
% X= fv.vertices(:,1);
% Y = fv.vertices(:,2);
% Z = fv.vertices(:,3);

%% Element plotting
for i = 1:n_element
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

    figure(1)
    fill3(P,Q,R,'g')    
    xlabel('X-Axis')
    ylabel('Y-Axis')
    zlabel('Z-Axis')

    hold on;
end

%% Slicing
% find the maximum height
zmax = 0;
for i=1:n_nodes
    if Z(i)>=zmax
      zmax=Z(i);
    else
    end
end

% slicing parameters
INC = 5; % number of slices
NOSTEP = zmax/INC;
zs = 0; % starting height

% iterate through number of steps
for i=1:NOSTEP-1
    zs=zs+INC; % increment height
    C=0; % counter
    for j = 1:n_element % iterate through number of elements
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
    figure(2)
    plot3(XP,YP,ZP,'-r*', 'LineWidth', 2);
    hold on

    % plot structure
    figure(3)
    fill3 (XP,YP,ZP, 'r')
    hold on
    
end


        