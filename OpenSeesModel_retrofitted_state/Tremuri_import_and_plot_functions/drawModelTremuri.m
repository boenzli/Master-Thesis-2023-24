function successOutput = drawModelTremuri( model, varargin )

p = inputParser;

addRequired(p,'model');
addOptional(p,'results',  [],     @isstruct);
addParameter(p,'style', 'wireframe',     @ischar);
addParameter(p,'fig', gcf,     @ishandle);

wallsToPlot = [];
for k=1:length(model.wall)
    if ~isempty(model.wall(k).x0)
        wallsToPlot = [wallsToPlot; k];
    end
end
addParameter(p,'walls', wallsToPlot,     @isnumeric);
addParameter(p,'colorPiers',     [1 1 1]*0.5);
addParameter(p,'colorSpandrels', [1 1 1]*0.5);
addParameter(p,'colorNodes',     [1 1 1]*0.5,     @isnumeric);
addParameter(p,'colorEdges',     [1 1 1]*0.5,     @isnumeric);
addParameter(p,'colorBeams',     [1 1 1]*0.5,     @isnumeric);
addParameter(p,'colorFloors',    [1 1 1]*0.7,     @isnumeric);
addParameter(p,'styleNodes', 'none',     @ischar);  % none, markers (with code)
addParameter(p,'sizeNodes', 8,     @isnumeric); 
addParameter(p,'styleBeams', 'wireframe',     @ischar);
addParameter(p,'deformed', 0,     @isnumeric);
addParameter(p,'step', 0,     @isnumeric);
addParameter(p,'elements', 0,     @isnumeric);
addParameter(p,'floors', false,     @islogical);

parse(p,model,varargin{:});

results     = p.Results.results;
style       = p.Results.style;
fig         = p.Results.fig;
wallsToPlot = p.Results.walls;
colorPiers  = p.Results.colorPiers;
colorSpandrels = p.Results.colorSpandrels;
colorNodes  = p.Results.colorNodes;
colorEdges  = p.Results.colorEdges;
colorBeams  = p.Results.colorBeams;
colorFloors = p.Results.colorFloors;
styleNodes  = p.Results.styleNodes;
sizeNodes   = p.Results.sizeNodes;
styleBeams  = p.Results.styleBeams;
deformed    = p.Results.deformed;
stepToPlot  = p.Results.step;
elementList  = p.Results.elements;
floors       = p.Results.floors;

if elementList == 0
    elementList = 1:length(model.element);
end



%%old code

%% draw
set(0, 'CurrentFigure', fig)
%axis equal

% plot all floors
if floors
    hold on
    XFloors4 = []; YFloors4 = []; ZFloors4 = [];
    XFloors3 = []; YFloors3 = []; ZFloors3 = [];
    
    for k=1:length(model.floor)
        if length(model.floor(k).nodes)==4
                 xx = [ model.node3d( model.floor(k).nodes(1) ).x;
                        model.node3d( model.floor(k).nodes(2) ).x;
                        model.node3d( model.floor(k).nodes(3) ).x;
                        model.node3d( model.floor(k).nodes(4) ).x];
                    
                 yy = [ model.node3d( model.floor(k).nodes(1) ).y;
                        model.node3d( model.floor(k).nodes(2) ).y;
                        model.node3d( model.floor(k).nodes(3) ).y;
                        model.node3d( model.floor(k).nodes(4) ).y];
                    
                 zz = [ model.node3d( model.floor(k).nodes(1) ).z;
                        model.node3d( model.floor(k).nodes(2) ).z;
                        model.node3d( model.floor(k).nodes(3) ).z;
                        model.node3d( model.floor(k).nodes(4) ).z];
                        
            XFloors4 = [XFloors4, xx ];
            YFloors4 = [YFloors4, yy ];
            ZFloors4 = [ZFloors4, zz ];
            
        else if length(model.floor(k).nodes)==3
                 xx = [ model.node3d( model.floor(k).nodes(1) ).x;
                        model.node3d( model.floor(k).nodes(2) ).x;
                        model.node3d( model.floor(k).nodes(3) ).x];
                    
                 yy = [ model.node3d( model.floor(k).nodes(1) ).y;
                        model.node3d( model.floor(k).nodes(2) ).y;
                        model.node3d( model.floor(k).nodes(3) ).y];
                    
                 zz = [ model.node3d( model.floor(k).nodes(1) ).z;
                        model.node3d( model.floor(k).nodes(2) ).z;
                        model.node3d( model.floor(k).nodes(3) ).z];
                        
            XFloors3 = [XFloors3, xx ];
            YFloors3 = [YFloors3, yy ];
            ZFloors3 = [ZFloors3, zz ];
            end
        end
    end
    
    if ischar(colorFloors)
        h = patch(XFloors4, YFloors4, ZFloors4, 'w', 'edgecolor', colorEdges, 'FaceAlpha', .4);
        set(h, 'FaceColor', colorFloors);
    else
        patch(XFloors4, YFloors4, ZFloors4, colorFloors, 'edgecolor', colorEdges, 'FaceAlpha', .4);
    end
    
    if ischar(colorFloors)
        h = patch(XFloors3, YFloors3, ZFloors3, 'w', 'edgecolor', colorEdges, 'FaceAlpha', .4);
        set(h, 'FaceColor', colorFloors);
    else
        patch(XFloors3, YFloors3, ZFloors3, colorFloors, 'edgecolor', colorEdges, 'FaceAlpha', .4);
    end
    
    
end




X_vec = zeros(length(model.node2d), 1)*NaN;
Y_vec = zeros(length(model.node2d), 1)*NaN;
Z_vec = zeros(length(model.node2d), 1)*NaN;

% draw all nodes
XNodes = []; YNodes = []; ZNodes = [];
for k=1:length(model.node2d)
    if ~isempty(model.node2d(k).wall) && sum(model.node2d(k).wall == wallsToPlot)~=0
        % x and y coordinate
        if stepToPlot==0 % not deformed
            X_vec(k) = model.node2d(k).x;
            Y_vec(k) = model.node2d(k).y;
            Z_vec(k) = model.node2d(k).z;
          
        else  % deformed
            % check if we have the true hor. displacement of the node
            dirVec = [cos(model.wall(model.node2d(k).wall).angle);
                sin(model.wall(model.node2d(k).wall).angle)];
            % out of plane displacement (from 3d nodes)
            dist1 =       [model.node2d(k).x - model.node3d(model.node2d(k).repartition(1)).x;
                model.node2d(k).y - model.node3d(model.node2d(k).repartition(1)).y;
                model.node2d(k).z - model.node3d(model.node2d(k).repartition(1)).z ];
            dist2 =       [model.node2d(k).x - model.node3d(model.node2d(k).repartition(2)).x;
                model.node2d(k).y - model.node3d(model.node2d(k).repartition(2)).y;
                model.node2d(k).z - model.node3d(model.node2d(k).repartition(2)).z ];
            if isempty(results.node3d(model.node2d(k).repartition(1)).ux)
                results.node3d(model.node2d(k).repartition(1)).ux(stepToPlot) = 0;
            end
            
            if isempty(results.node3d(model.node2d(k).repartition(1)).uy)
                results.node3d(model.node2d(k).repartition(1)).uy(stepToPlot) = 0;
            end
            
            if isempty(results.node3d(model.node2d(k).repartition(1)).uz)
                results.node3d(model.node2d(k).repartition(1)).uz(stepToPlot) = 0;
            end
            
            if isempty(results.node3d(model.node2d(k).repartition(2)).ux)
                results.node3d(model.node2d(k).repartition(2)).ux(stepToPlot) = 0;
            end
            
            if isempty(results.node3d(model.node2d(k).repartition(2)).uy)
                results.node3d(model.node2d(k).repartition(2)).uy(stepToPlot) = 0;
            end
            
            if isempty(results.node3d(model.node2d(k).repartition(2)).uz)
                results.node3d(model.node2d(k).repartition(2)).uz(stepToPlot) = 0;
            end
            
            
            d1 =          [results.node3d(model.node2d(k).repartition(1)).ux(stepToPlot);
                results.node3d(model.node2d(k).repartition(1)).uy(stepToPlot);
                results.node3d(model.node2d(k).repartition(1)).uz(stepToPlot)];
            d2 =          [results.node3d(model.node2d(k).repartition(2)).ux(stepToPlot);
                results.node3d(model.node2d(k).repartition(2)).uy(stepToPlot);
                results.node3d(model.node2d(k).repartition(2)).uz(stepToPlot)];
            
            if ~isempty(results.node2d(k).ux)
                
                d1(1:2) = d1(1:2) - dirVec'*d1(1:2) *dirVec;
                d2(1:2) = d2(1:2) - dirVec'*d2(1:2) *dirVec;
                d = d1 * norm(dist2) / ( norm(dist1)+norm(dist2) ) + d2 * norm(dist1) / ( norm(dist1)+norm(dist2) );
                
                X_vec(k) = model.node2d(k).x + deformed*(d(1) + dirVec(1)*results.node2d(k).ux(stepToPlot));
                Y_vec(k) = model.node2d(k).y + deformed*(d(2) + dirVec(2)*results.node2d(k).ux(stepToPlot));
                Z_vec(k) = model.node2d(k).z + deformed*d(3);
                
            else  % calculate it from the 3d nodes. if they are not recorded, 0
                d = d1 * norm(dist2) / ( norm(dist1)+norm(dist2) ) + d2 * norm(dist1) / ( norm(dist1)+norm(dist2) );
                X_vec(k) = model.node2d(k).x + deformed*d(1);
                Y_vec(k) = model.node2d(k).y + deformed*d(2);
                Z_vec(k) = model.node2d(k).z + deformed*d(3);
            end  
        end
        
        if model.node2d(k).type == 'R'
            nodeI = [nanmean(model.node2d(k).offsetX);
                     nanmean(model.node2d(k).offsetY);
                     Z_vec(k) + model.node2d(k).offsetZ(2)];
            nodeJ = [nanmean(model.node2d(k).offsetX);
                     nanmean(model.node2d(k).offsetY);
                     Z_vec(k) + model.node2d(k).offsetZ(1)];
            
            nWall = model.node2d(k).wall;
            theta = model.wall(nWall).angle;
            v_or = [-sin(theta); cos(theta); 0];
            
            L = abs(model.node2d(k).offsetXloc(2) -  model.node2d(k).offsetXloc(1));
            t = model.node2d(k).thickness;
            
            [xx yy zz] = addWallToPatch(nodeI, nodeJ, v_or, L, t, [0;0;0], [0;0;0], style);
            XNodes = [XNodes, xx];
            YNodes = [YNodes, yy];
            ZNodes = [ZNodes, zz];
        elseif model.node2d(k).type == 'P'           
            for kPolygon=1:length(model.node2d(k).polygon)
                if ~isempty(model.node2d(k).polygon(kPolygon).rho)
                    nodeI = [nanmean(model.node2d(k).polygon(kPolygon).offsetX);
                            nanmean(model.node2d(k).polygon(kPolygon).offsetY);
                            Z_vec(k) + model.node2d(k).polygon(kPolygon).offsetZ(2)];
                    nodeJ = [nanmean(model.node2d(k).polygon(kPolygon).offsetX);
                            nanmean(model.node2d(k).polygon(kPolygon).offsetY);
                            Z_vec(k) + model.node2d(k).polygon(kPolygon).offsetZ(1)];
                    
                    nWall = model.node2d(k).wall;
                    theta = model.wall(nWall).angle;
                    v_or = [-sin(theta); cos(theta); 0];
                    
                    L = abs(model.node2d(k).polygon(kPolygon).offsetXloc(2) -  model.node2d(k).polygon(kPolygon).offsetXloc(1));
                    t = model.node2d(k).polygon(kPolygon).thickness;
                    
                    [xx yy zz] = addWallToPatch(nodeI, nodeJ, v_or, L, t, [0;0;0], [0;0;0], style);
                    XNodes = [XNodes, xx];
                    YNodes = [YNodes, yy];
                    ZNodes = [ZNodes, zz];             
                end
                
            end
            
        end
    end
end


if ~strcmp(styleNodes, 'none')
    plot3(X_vec, Y_vec, Z_vec, styleNodes, 'MarkerFaceColor', colorNodes, 'MarkerEdgeColor', colorNodes, 'MarkerSize', sizeNodes);
    hold on
    
    if ischar(colorNodes)
        h = patch(XNodes, YNodes, ZNodes, 'w', 'edgecolor', colorEdges);
        set(h, 'FaceColor', colorNodes);
    else
        patch(XNodes, YNodes, ZNodes, colorNodes, 'edgecolor', colorEdges);
    end
    
    
end

XNodes = []; YNodes = []; ZNodes = [];
for k=1:length(model.node3d)
    if not(isempty(model.node3d(k).wall)) && (sum(model.node3d(k).wall(1) == wallsToPlot)~=0  || sum(model.node3d(k).wall(2) == wallsToPlot)~=0)
        if stepToPlot==0 % not deformed
            XX_vec(k) = model.node3d(k).x;
            YY_vec(k) = model.node3d(k).y;
            ZZ_vec(k) = model.node3d(k).z;
        else  % deformed
            
            % check if we have the true hor. displacement of the node
            if ~isempty(results.node3d(k).ux)
                XX_vec(k) = model.node3d(k).x + deformed* results.node3d(k).ux(stepToPlot);
            else  % calculate it from the 3d nodes. if they are not recorded, undeformed
                XX_vec(k) = model.node3d(k).x;
            end
            
            if ~isempty(results.node3d(k).uy)
                YY_vec(k) = model.node3d(k).y + deformed* results.node3d(k).uy(stepToPlot);
            else  % calculate it from the 3d nodes. if they are not recorded, undeformed
                YY_vec(k) = model.node3d(k).y;
            end
            
            if ~isempty(results.node3d(k).uz)
                ZZ_vec(k) = model.node3d(k).z + deformed* results.node3d(k).uz(stepToPlot);
            else  % calculate it from the 3d nodes. if they are not recorded, undeformed
                ZZ_vec(k) = model.node3d(k).z;
            end
        end
        
        if model.node3d(k).type(1) == 'R'
            nodeI = [nanmean(model.node3d(k).offsetX1);
                     nanmean(model.node3d(k).offsetY1);
                     ZZ_vec(k) + model.node3d(k).offsetZ1(2)];
            nodeJ = [nanmean(model.node3d(k).offsetX1);
                     nanmean(model.node3d(k).offsetY1);
                     ZZ_vec(k) + model.node3d(k).offsetZ1(1)];
            
            nWall = model.node3d(k).wall(1);
            theta = model.wall(nWall).angle;
            v_or = [-sin(theta); cos(theta); 0];
            
            L = abs(model.node3d(k).offsetXloc1(2) -  model.node3d(k).offsetXloc1(1));
            t = model.node3d(k).thickness1;
            
            [xx yy zz] = addWallToPatch(nodeI, nodeJ, v_or, L, t, [0;0;0], [0;0;0], style);
            XNodes = [XNodes, xx];
            YNodes = [YNodes, yy];
            ZNodes = [ZNodes, zz];
            
        elseif (model.node3d(k).type(1) == 'P')          
            for kPolygon=1:length(model.node3d(k).polygon1)
                if ~isempty(model.node3d(k).polygon1(kPolygon).rho)
                    nodeI = [nanmean(model.node3d(k).polygon1(kPolygon).offsetX);
                            nanmean(model.node3d(k).polygon1(kPolygon).offsetY);
                            ZZ_vec(k) + model.node3d(k).polygon1(kPolygon).offsetZ(2)];
                    nodeJ = [nanmean(model.node3d(k).polygon1(kPolygon).offsetX);
                            nanmean(model.node3d(k).polygon1(kPolygon).offsetY);
                            ZZ_vec(k) + model.node3d(k).polygon1(kPolygon).offsetZ(1)];
                    
                    nWall = model.node3d(k).wall(1);
                    theta = model.wall(nWall).angle;
                    v_or = [-sin(theta); cos(theta); 0];
                    
                    L = abs(model.node3d(k).polygon1(kPolygon).offsetXloc(2) -  model.node3d(k).polygon1(kPolygon).offsetXloc(1));
                    t = model.node3d(k).polygon1(kPolygon).thickness;
                    
                     [xx yy zz] = addWallToPatch(nodeI, nodeJ, v_or, L, t, [0;0;0], [0;0;0], style);
                     XNodes = [XNodes, xx];
                     YNodes = [YNodes, yy];
                     ZNodes = [ZNodes, zz];       
                     
                  
                end
                
            end          
            
        end
        
        
        
         if model.node3d(k).type(2) == 'R'     
            nodeI = [nanmean(model.node3d(k).offsetX2);
                nanmean(model.node3d(k).offsetY2);
                ZZ_vec(k) + model.node3d(k).offsetZ2(2)];
            nodeJ = [nanmean(model.node3d(k).offsetX2);
                nanmean(model.node3d(k).offsetY2);
                ZZ_vec(k) + model.node3d(k).offsetZ2(1)];
            
            nWall = model.node3d(k).wall(2);
            theta = model.wall(nWall).angle;
            v_or = [-sin(theta); cos(theta); 0];
            
            L = abs(model.node3d(k).offsetXloc2(2) -  model.node3d(k).offsetXloc2(1));
            t = model.node3d(k).thickness2;
            
            [xx yy zz] = addWallToPatch(nodeI, nodeJ, v_or, L, t, [0;0;0], [0;0;0], style);
            XNodes = [XNodes, xx];
            YNodes = [YNodes, yy];
            ZNodes = [ZNodes, zz];
            
         elseif model.node3d(k).type(2) == 'P'
             for kPolygon=1:length(model.node3d(k).polygon2)                
                 if ~isempty(model.node3d(k).polygon2(kPolygon).rho)
                     nodeI = [nanmean(model.node3d(k).polygon2(kPolygon).offsetX);
                              nanmean(model.node3d(k).polygon2(kPolygon).offsetY);
                              ZZ_vec(k) + model.node3d(k).polygon2(kPolygon).offsetZ(2)];
                     nodeJ = [nanmean(model.node3d(k).polygon2(kPolygon).offsetX);
                         nanmean(model.node3d(k).polygon2(kPolygon).offsetY);
                         ZZ_vec(k) + model.node3d(k).polygon2(kPolygon).offsetZ(1)];
                     
                     nWall = model.node3d(k).wall(2);
                     theta = model.wall(nWall).angle;
                     v_or = [-sin(theta); cos(theta); 0];
                     
                     L = abs(model.node3d(k).polygon2(kPolygon).offsetXloc(2) -  model.node3d(k).polygon2(kPolygon).offsetXloc(1));
                     t = model.node3d(k).polygon2(kPolygon).thickness;
                     
                     [xx yy zz] = addWallToPatch(nodeI, nodeJ, v_or, L, t, [0;0;0], [0;0;0], style);
                     XNodes = [XNodes, xx];
                     YNodes = [YNodes, yy];
                     ZNodes = [ZNodes, zz];
                 end
                 
             end
            
        end
        
       
        
    else
        XX_vec(k) = NaN;
        YY_vec(k) = NaN;
        ZZ_vec(k) = NaN;
    end
end

if ~strcmp(styleNodes, 'none')
    plot3(XX_vec, YY_vec, ZZ_vec, styleNodes, 'MarkerFaceColor', colorNodes, 'MarkerEdgeColor', colorNodes, 'MarkerSize', sizeNodes);
    hold on
        if ischar(colorNodes)
        h = patch(XNodes, YNodes, ZNodes, 'w', 'edgecolor', colorEdges);
        set(h, 'FaceColor', colorNodes);
    else
        patch(XNodes, YNodes, ZNodes, colorNodes, 'edgecolor', colorEdges);
    end
end

XPiers = []; YPiers = []; ZPiers = [];
XSpandrels = []; YSpandrels= []; ZSpandrels = [];
for k_el=1:length(elementList)
    k = elementList(k_el);
    if not(isempty(model.element(k).angle)) && sum(model.element(k).wall == wallsToPlot)~=0
        nWall = model.element(k).wall;
        theta = model.wall(nWall).angle;
        v_or = [-sin(theta); cos(theta); 0];
        
        if stepToPlot==0 % not deformed
            nodeI = model.element(k).nI;
            nodeJ = model.element(k).nJ;
        else
            if model.element(k).nodeI > length(model.node2d)
                model.node2d(model.element(k).nodeI).wall = [];
            end
            
            %if model.element(k).nodeI <= length(model.node3d)
             if isempty(model.node2d(model.element(k).nodeI).wall)
                nI  = [model.node3d(model.element(k).nodeI).x;
                    model.node3d(model.element(k).nodeI).y;
                    model.node3d(model.element(k).nodeI).z];
                nnI = [XX_vec(model.element(k).nodeI);
                    YY_vec(model.element(k).nodeI);
                    ZZ_vec(model.element(k).nodeI)];
                hi = model.element(k).nI - nI;
                v_or_i = v_or;
                
            else
                nI = [model.node2d(model.element(k).nodeI).x;
                    model.node2d(model.element(k).nodeI).y;
                    model.node2d(model.element(k).nodeI).z];
                nnI = [X_vec(model.element(k).nodeI);
                    Y_vec(model.element(k).nodeI);
                    Z_vec(model.element(k).nodeI)];
                hi = model.element(k).nI - nI;
                
                n1 = model.node2d(model.element(k).nodeI).repartition(1);
                n2 = model.node2d(model.element(k).nodeI).repartition(2);
                dx = XX_vec(n1) - XX_vec(n2);
                dy = YY_vec(n1) - YY_vec(n2);
                l = sqrt(dx^2+dy^2);
                dx = dx/l;
                dy = dy/l;
                v_or_i = [-dy; dx; 0];
             end
            
            if model.element(k).nodeJ > length(model.node2d)
                model.node2d(model.element(k).nodeJ).wall = [];
            end
            
            %if model.element(k).nodeI <= length(model.node3d)
             if isempty(model.node2d(model.element(k).nodeJ).wall)
                nJ = [model.node3d(model.element(k).nodeJ).x;
                    model.node3d(model.element(k).nodeJ).y;
                    model.node3d(model.element(k).nodeJ).z];
                nnJ = [XX_vec(model.element(k).nodeJ);
                    YY_vec(model.element(k).nodeJ);
                    ZZ_vec(model.element(k).nodeJ)];
                hj = model.element(k).nJ - nJ;
                v_or_j = v_or;
                
            else
                nJ = [model.node2d(model.element(k).nodeJ).x;
                    model.node2d(model.element(k).nodeJ).y;
                    model.node2d(model.element(k).nodeJ).z];
                nnJ = [X_vec(model.element(k).nodeJ);
                    Y_vec(model.element(k).nodeJ);
                    Z_vec(model.element(k).nodeJ)];
                hj = model.element(k).nJ - nJ;
                
                n1 = model.node2d(model.element(k).nodeJ).repartition(1);
                n2 = model.node2d(model.element(k).nodeJ).repartition(2);
                dx = XX_vec(n1) - XX_vec(n2);
                dy = YY_vec(n1) - YY_vec(n2);
                l = sqrt(dx^2+dy^2);
                dx = dx/l;
                dy = dy/l;
                v_or_j = [-dy; dx; 0];
            end
            
            if model.element(k).type == 0
                if v_or_i'*v_or_j>0
                    v_or = (v_or_i + v_or_j)/2;
                else
                    v_or = (-v_or_i + v_or_j)/2;
                end
            end
            
            h  = (nJ-nI);
            h = h/norm(h);
            
            hi_0 =  h * h'*hi;
            hi_90 = hi - hi_0;
            hj_0 =  h * h'*hj;
            hj_90 = hj - hj_0;
            
            hh  = (nnJ-nnI); hh = hh/norm(hh);
            
            nodeI =  nnI + norm(hi_0)*hh/norm(hh) + hi_90;
            nodeJ =  nnJ - norm(hj_0)*hh/norm(hh) + hj_90;
        end
        
        [xx yy zz] = addWallToPatch(nodeI, nodeJ, v_or, model.element(k).L, model.element(k).t, [0;0;0], [0;0;0], style);
        
        if model.element(k).type == 0
            %if strcmp(style, 'wireframe'); colorEdges = colorPiers;  end
            %draw_wall( nodeI, nodeJ, v_or, model.element(k).L, model.element(k).t, ...
            %           [0;0;0], [0;0;0], style, colorEdges, colorPiers);
            XPiers = [XPiers, xx];
            YPiers = [YPiers, yy];
            ZPiers = [ZPiers, zz];
        else
            %if strcmp(style, 'wireframe'); colorEdges = colorSpandrels;  end
            %draw_wall( nodeI, nodeJ, v_or, model.element(k).L, model.element(k).t, ...
            %           [0;0;0], [0;0;0], style, colorEdges, colorSpandrels);
            XSpandrels = [XSpandrels, xx];
            YSpandrels = [YSpandrels, yy];
            ZSpandrels = [ZSpandrels, zz];
        end
    end
end

if ischar(colorPiers)
    h = patch(XPiers, YPiers, ZPiers, 'w', 'edgecolor', colorEdges);
    set(h, 'FaceColor', colorPiers);
else
   patch(XPiers, YPiers, ZPiers, colorPiers, 'edgecolor', colorEdges);
end

if ischar(colorPiers)
    h = patch(XSpandrels, YSpandrels, ZSpandrels, 'w', 'edgecolor', colorEdges);
    set(h, 'FaceColor', colorSpandrels);
else
    patch(XSpandrels, YSpandrels, ZSpandrels, colorSpandrels, 'edgecolor', colorEdges);
end


%axis equal
%axis off

successOutput = true;


end

