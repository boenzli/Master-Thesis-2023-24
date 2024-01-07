function [ X, Y, Z ] = addWallToPatch( nodeI, nodeJ, v_or, L, t, off_i, off_j, style )

% draws a wall defined by 2 nodes, an orientation vector equivalent to the
% one of opensees (geomTransf) parallel to the z axis (thickness) of the
% section. Two offsets can be specified. nodeI and nodeJ are the vector
% column of the 3 coordinates of I and J;

% change this
% shift_i = off_i;
% shift_j = off_j;
% 
% off_i = 0*off_i;
% off_j = 0*off_j;



if strcmp(style,'1D') || strcmp(style,'2D')
    X = zeros(1,4)*NaN;
    Y = zeros(1,4)*NaN;
    Z = zeros(1,4)*NaN;
else
    X = zeros(6,4)*NaN;
    Y = zeros(6,4)*NaN;
    Z = zeros(6,4)*NaN;
end

H_wall = norm(nodeJ-nodeI);
x_loc = (nodeJ-nodeI) / norm(nodeJ-nodeI);

% check if the orientation vector is right (it can't be parallel to the axis of the wall
if norm(v_or-(v_or'*x_loc)*x_loc)==0
    warning('Orientation vector parallel to the axis. The orientation vector is assumed parallel to the global Z (or global Y if this does not work');  
    v_or = [0;0;1];
    if norm(v_or-(v_or'*x_loc)*x_loc)==0
        v_or = [0;1;0];
    end
end
    
v_or_x = (v_or' * x_loc) * x_loc;
v_or_z = v_or - v_or_x;
z_loc = v_or_z / norm(v_or_z);
y_loc = cross(z_loc, x_loc);

if strcmp(style,'2D')
    t = 0;
end

if strcmp(style,'1D')
    t = 0;
    L = L*0.01;
end



    %% full shape view 3D
    % base
    verticesI_loc = [off_i(1),        off_i(1),       off_i(1),       off_i(1);
                     off_i(2)-L/2,    off_i(2)-L/2,   off_i(2)+L/2,   off_i(2)+L/2;
                     off_i(3)-t/2,    off_i(3)+t/2,   off_i(3)+t/2,   off_i(3)-t/2];
    for kCol=1:4
       verticesI(:,kCol) = verticesI_loc(1,kCol)*x_loc + verticesI_loc(2,kCol)*y_loc + verticesI_loc(3,kCol)*z_loc; 
    end
    
    if ~strcmp(style,'2D') && ~strcmp(style,'1D')
        % add base I
        X(1, :) = nodeI(1)+verticesI(1,:);
        Y(1, :) = nodeI(2)+verticesI(2,:);
        Z(1, :) = nodeI(3)+verticesI(3,:);
    end
    

    verticesJ_loc = [H_wall+off_j(1), H_wall+off_j(1), H_wall+off_j(1), H_wall+off_j(1);
                     off_j(2)-L/2,    off_j(2)-L/2,    off_j(2)+L/2,    off_j(2)+L/2;
                     off_j(3)-t/2,    off_j(3)+t/2,    off_j(3)+t/2,    off_j(3)-t/2];

    for kCol=1:4
       verticesJ(:,kCol) = verticesJ_loc(1,kCol)*x_loc + verticesJ_loc(2,kCol)*y_loc + verticesJ_loc(3,kCol)*z_loc; 
    end
    
    if ~strcmp(style,'2D') && ~strcmp(style,'1D')
        % add base J
        X(2, :) = nodeI(1)+verticesJ(1,:);
        Y(2, :) = nodeI(2)+verticesJ(2,:);
        Z(2, :) = nodeI(3)+verticesJ(3,:);
        
        % add other edges
        corners = [1,2];
        X(3, :) = nodeI(1)+[verticesI(1,corners(1)), verticesI(1,corners(2)), verticesJ(1,corners(2)), verticesJ(1,corners(1))];
        Y(3, :) = nodeI(2)+[verticesI(2,corners(1)), verticesI(2,corners(2)), verticesJ(2,corners(2)), verticesJ(2,corners(1))];
        Z(3, :) = nodeI(3)+[verticesI(3,corners(1)), verticesI(3,corners(2)), verticesJ(3,corners(2)), verticesJ(3,corners(1))];
        
        corners = [2,3];
        X(4, :) = nodeI(1)+[verticesI(1,corners(1)), verticesI(1,corners(2)), verticesJ(1,corners(2)), verticesJ(1,corners(1))];
        Y(4, :) = nodeI(2)+[verticesI(2,corners(1)), verticesI(2,corners(2)), verticesJ(2,corners(2)), verticesJ(2,corners(1))];
        Z(4, :) = nodeI(3)+[verticesI(3,corners(1)), verticesI(3,corners(2)), verticesJ(3,corners(2)), verticesJ(3,corners(1))];
        
        corners = [3,4];
        X(5, :) = nodeI(1)+[verticesI(1,corners(1)), verticesI(1,corners(2)), verticesJ(1,corners(2)), verticesJ(1,corners(1))];
        Y(5, :) = nodeI(2)+[verticesI(2,corners(1)), verticesI(2,corners(2)), verticesJ(2,corners(2)), verticesJ(2,corners(1))];
        Z(5, :) = nodeI(3)+[verticesI(3,corners(1)), verticesI(3,corners(2)), verticesJ(3,corners(2)), verticesJ(3,corners(1))];
        
        corners = [4,1];
        X(6, :) = nodeI(1)+[verticesI(1,corners(1)), verticesI(1,corners(2)), verticesJ(1,corners(2)), verticesJ(1,corners(1))];
        Y(6, :) = nodeI(2)+[verticesI(2,corners(1)), verticesI(2,corners(2)), verticesJ(2,corners(2)), verticesJ(2,corners(1))];
        Z(6, :) = nodeI(3)+[verticesI(3,corners(1)), verticesI(3,corners(2)), verticesJ(3,corners(2)), verticesJ(3,corners(1))];
        
    else
        corners = [4,1];
        X(1, :) = nodeI(1)+[verticesI(1,corners(1)), verticesI(1,corners(2)), verticesJ(1,corners(2)), verticesJ(1,corners(1))];
        Y(1, :) = nodeI(2)+[verticesI(2,corners(1)), verticesI(2,corners(2)), verticesJ(2,corners(2)), verticesJ(2,corners(1))];
        Z(1, :) = nodeI(3)+[verticesI(3,corners(1)), verticesI(3,corners(2)), verticesJ(3,corners(2)), verticesJ(3,corners(1))];
    end
    
    X = X';
    Y = Y';
    Z = Z';


end


