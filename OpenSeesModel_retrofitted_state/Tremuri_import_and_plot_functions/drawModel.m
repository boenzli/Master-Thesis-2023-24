function successOutput = drawModel( model, varargin )

p = inputParser;

addRequired(p,'model');
addOptional(p,'results',  [],     @isstruct);
addParameter(p,'style', 'wireframe',     @ischar);
addParameter(p,'fig', gcf,     @ishandle);

wallsToPlot = [];
for k=1:length(model.wall)
    if ~isempty(model.wall(k).zAxis)
        wallsToPlot = [wallsToPlot; k]; 
    end
end
addParameter(p,'walls', wallsToPlot,     @isnumeric);

addParameter(p,'colorPiers',     [1 1 1]*0.5);
addParameter(p,'colorSpandrels', [1 1 1]*0.5);
addParameter(p,'colorNodes',     [1 1 1]*0.5,     @isnumeric);
addParameter(p,'colorEdges',     [1 1 1]*0.5,     @isnumeric);
addParameter(p,'colorEdgesFloors',     [1 1 1]*0.5,     @isnumeric);
addParameter(p,'colorBeams',     [1 1 1]*0.5);
addParameter(p,'colorFloors',    [1 1 1]*0.7,     @isnumeric);
addParameter(p,'styleNodes', 'none',     @ischar);  % none, markers (with code)
addParameter(p,'sizeNodes', 8,     @isnumeric); 
addParameter(p,'styleBeams', 'wireframe',     @ischar);
addParameter(p,'styleElements', 'full',     @ischar);

addParameter(p,'mapDamage', 'none',     @ischar);
addParameter(p,'maxDamage', 1e6,     @isnumeric);

addParameter(p,'deformed', 0,     @isnumeric);
addParameter(p,'step', 0,     @isnumeric);
addParameter(p,'elements', 0,     @isnumeric);
addParameter(p,'floors', false,     @islogical);

addParameter(p,'sizeBeams',     0.3,     @isnumeric);

parse(p,model,varargin{:});

result     = p.Results.results;
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
colorEdgesFloors = p.Results.colorEdgesFloors ;
styleElements = p.Results.styleElements;

mapDamage = p.Results.mapDamage;
maxDamage = p.Results.maxDamage;


deformed    = p.Results.deformed;
stepToPlot  = p.Results.step;
elementList  = p.Results.elements;
floors       = p.Results.floors;
sizeBeams    = p.Results.sizeBeams;

if elementList == 0
    elementList = 1:length(model.element);
end



%%old code

%% draw
set(0, 'CurrentFigure', fig)
%axis equal
% 

%% plot all floors
if floors
    hold on
    XFloors4 = []; YFloors4 = []; ZFloors4 = [];
    XDir4 = []; YDir4 = []; ZDir4 = [];
    % XFloors3 = []; YFloors3 = []; ZFloors3 = [];
    
    for k=1:length(model.element)
        
        if ~isempty(model.element(k).type)
            if strcmp(model.element(k).type, 'FloorShell')
                if length(model.element(k).nodeVec) ==4
                    
                    if stepToPlot==0 % not deformed
                        xx = [ model.node( model.element(k).nodeVec(1) ).x;
                            model.node( model.element(k).nodeVec(2) ).x;
                            model.node( model.element(k).nodeVec(3) ).x;
                            model.node( model.element(k).nodeVec(4) ).x];
                        
                        yy = [ model.node( model.element(k).nodeVec(1) ).y;
                            model.node( model.element(k).nodeVec(2) ).y;
                            model.node( model.element(k).nodeVec(3) ).y;
                            model.node( model.element(k).nodeVec(4) ).y];
                        
                        zz = [ model.node( model.element(k).nodeVec(1) ).z;
                            model.node( model.element(k).nodeVec(2) ).z;
                            model.node( model.element(k).nodeVec(3) ).z;
                            model.node( model.element(k).nodeVec(4) ).z];
                        
                    else
                        %% deformed                        
                        xx = [ model.node( model.element(k).nodeVec(1) ).x + deformed*result.node(model.element(k).nodeVec(1)).u(stepToPlot);
                               model.node( model.element(k).nodeVec(2) ).x + deformed*result.node(model.element(k).nodeVec(2)).u(stepToPlot);
                               model.node( model.element(k).nodeVec(3) ).x + deformed*result.node(model.element(k).nodeVec(3)).u(stepToPlot);
                               model.node( model.element(k).nodeVec(4) ).x + deformed*result.node(model.element(k).nodeVec(4)).u(stepToPlot)];
                        
                        yy = [ model.node( model.element(k).nodeVec(1) ).y + deformed*result.node(model.element(k).nodeVec(1)).v(stepToPlot);
                               model.node( model.element(k).nodeVec(2) ).y + deformed*result.node(model.element(k).nodeVec(2)).v(stepToPlot);
                               model.node( model.element(k).nodeVec(3) ).y + deformed*result.node(model.element(k).nodeVec(3)).v(stepToPlot);
                               model.node( model.element(k).nodeVec(4) ).y + deformed*result.node(model.element(k).nodeVec(4)).v(stepToPlot)];
                        
                        zz = [ model.node( model.element(k).nodeVec(1) ).z + deformed*result.node(model.element(k).nodeVec(1)).w(stepToPlot);
                               model.node( model.element(k).nodeVec(2) ).z + deformed*result.node(model.element(k).nodeVec(2)).w(stepToPlot);
                               model.node( model.element(k).nodeVec(3) ).z + deformed*result.node(model.element(k).nodeVec(3)).w(stepToPlot);
                               model.node( model.element(k).nodeVec(4) ).z + deformed*result.node(model.element(k).nodeVec(4)).w(stepToPlot)];
                        
                    end
                    

                       
                    XFloors4 = [XFloors4, xx ];
                    YFloors4 = [YFloors4, yy ];
                    ZFloors4 = [ZFloors4, zz ];
                    
                    
                    if stepToPlot==0 % not deformed
                        center = [nanmean(xx); nanmean(yy); nanmean(zz)];
                        baseLength = model.element(k).b;
                        arrowLength = 1/4*baseLength;
                        arrowTip = 1/3 * arrowLength;
                        arrowWidth = 1/1.5 * arrowTip ;
                        xAxis = model.element(k).xAxis;
                        zAxis = model.floor(model.element(k).floor).zAxis;
                        yAxis = cross(zAxis, xAxis);
                        
                        xx = [center(1) - (arrowLength - arrowTip)*xAxis(1) - arrowWidth*yAxis(1);
                            center(1) - (arrowLength)*xAxis(1);
                            center(1) + (arrowLength)*xAxis(1);
                            center(1) + (arrowLength - arrowTip)*xAxis(1) + arrowWidth*yAxis(1);
                            NaN];
                        
                        yy = [center(2) - (arrowLength - arrowTip)*xAxis(2) - arrowWidth*yAxis(2);
                            center(2) - (arrowLength)*xAxis(2);
                            center(2) + (arrowLength)*xAxis(2);
                            center(2) + (arrowLength - arrowTip)*xAxis(2) + arrowWidth*yAxis(2);
                            NaN];
                        
                        zz = [center(3) - (arrowLength - arrowTip)*xAxis(3) - arrowWidth*yAxis(3);
                            center(3) - (arrowLength)*xAxis(3);
                            center(3) + (arrowLength)*xAxis(3);
                            center(3) + (arrowLength - arrowTip)*xAxis(3) + arrowWidth*yAxis(3);
                            NaN];
                        
                        XDir4 = [XDir4; xx ];
                        YDir4 = [YDir4; yy ];
                        ZDir4 = [ZDir4; zz ];
                    end
                    
                       
                end
            end
        end
    end
        
    if ischar(colorFloors)
        h = patch(XFloors4, YFloors4, ZFloors4, 'w', 'edgecolor', colorEdgesFloors, 'FaceAlpha', .4);
        set(h, 'FaceColor', colorFloors);
        hold on
    else
        patch(XFloors4, YFloors4, ZFloors4, colorFloors, 'edgecolor', colorEdgesFloors, 'FaceAlpha', .4);
        hold on
    end
    
%     if ischar(colorFloors)
%         h = patch(XFloors3, YFloors3, ZFloors3, 'w', 'edgecolor', colorEdges, 'FaceAlpha', .4);
%         set(h, 'FaceColor', colorFloors);
%     else
%         patch(XFloors3, YFloors3, ZFloors3, colorFloors, 'edgecolor', colorEdges, 'FaceAlpha', .4);
%     end

    plot3(XDir4, YDir4, ZDir4, 'color', colorEdges);
    
    
end


%% draw all nodes
if ~strcmp(styleNodes, 'none')
    X_vec = zeros(length(model.node), 1)*NaN;
    Y_vec = zeros(length(model.node), 1)*NaN;
    Z_vec = zeros(length(model.node), 1)*NaN;
    XNodes = []; YNodes = []; ZNodes = [];
    
    for k=1:length(model.node)
        if ~isempty(model.node(k).wall) && sum(model.node(k).wall == wallsToPlot)~=0
            % x and y coordinate
            if stepToPlot==0 % not deformed
                X_vec(k) = model.node(k).x;
                Y_vec(k) = model.node(k).y;
                Z_vec(k) = model.node(k).z;
                
            else
                %% deformed                
                X_vec(k) = model.node(k).x + deformed*result.node(k).u(stepToPlot);
                Y_vec(k) = model.node(k).y + deformed*result.node(k).v(stepToPlot);
                Z_vec(k) = model.node(k).z + deformed*result.node(k).w(stepToPlot);
              
            end
            
            for kPolygon = 1:length(model.node(k).polygon)
                
                if ~isempty(model.node(k).polygon(kPolygon).blCorner) 
                    if stepToPlot == 0
                        
                        nWall = model.node(k).wall;
                        nodeI = model.node(k).polygon(kPolygon).blCorner + model.wall(nWall).xAxis * model.node(k).polygon(kPolygon).xDim/2;
                        nodeJ = model.node(k).polygon(kPolygon).blCorner + model.wall(nWall).xAxis * model.node(k).polygon(kPolygon).xDim/2 + model.wall(nWall).yAxis * model.node(k).polygon(kPolygon).yDim;
                        v_or = model.wall(nWall).zAxis;
                    else
                        nWall = model.node(k).wall;
                        angles = [result.node(k).rotx(stepToPlot);
                            result.node(k).roty(stepToPlot);
                            result.node(k).rotz(stepToPlot)]*deformed;
                        
                        offsetRot =  rotate3D(model.node(k).polygon(kPolygon).blCorner - model.node(k).pos, angles);
                        xAxisRot = rotate3D(model.wall(nWall).xAxis, angles);
                        yAxisRot = rotate3D(model.wall(nWall).yAxis, angles);
                        zAxisRot = rotate3D(model.wall(nWall).zAxis, angles);
                        
                        nodeI = [X_vec(k); Y_vec(k); Z_vec(k)] + offsetRot + xAxisRot * model.node(k).polygon(kPolygon).xDim/2;
                        nodeJ = [X_vec(k); Y_vec(k); Z_vec(k)] + offsetRot + xAxisRot * model.node(k).polygon(kPolygon).xDim/2 + yAxisRot * model.node(k).polygon(kPolygon).yDim ;
                        
                        v_or = zAxisRot;
                    end
                    
                    
                    L = model.node(k).polygon(kPolygon).xDim;
                    t = model.node(k).polygon(kPolygon).t;
                    
                    if strcmp(styleElements, 'wireframe')
                        t =t*0;                       
                    end
                    
                    [xx yy zz] = addWallToPatch(nodeI, nodeJ, v_or, L, t, [0;0;0], [0;0;0], style);
                    XNodes = [XNodes, xx];
                    YNodes = [YNodes, yy];
                    ZNodes = [ZNodes, zz];
                    
                end
            end
        end
    end
    
    
    
    plot3(X_vec, Y_vec, Z_vec, styleNodes, 'MarkerFaceColor', colorNodes, 'MarkerEdgeColor', colorNodes, 'MarkerSize', sizeNodes);
    hold on
    
    if ischar(colorNodes)
        h = patch(XNodes, YNodes, ZNodes, 'w', 'edgecolor', colorEdges);
        set(h, 'FaceColor', colorNodes);
    else
        patch(XNodes, YNodes, ZNodes, colorNodes, 'edgecolor', colorEdges);
    end
else
    plot3(NaN, NaN, NaN);
    hold on
end

%% draw elements

XPiers = []; YPiers = []; ZPiers = []; CPiers = [];
XSpandrels = []; YSpandrels= []; ZSpandrels = []; CSpandrels = [];
for k_el=1:length(elementList)
    k = elementList(k_el);
    if not(isempty(model.element(k).nodeI))  && (strcmp(model.element(k).type, 'Macroelement3d') || strcmp(model.element(k).type, 'TriangularMacroelement'))
        if sum(model.element(k).wall == wallsToPlot)~=0
            nWall = model.element(k).wall;
            %theta = model.wall(nWall).angle;
            v_or = model.wall(nWall).zAxis;
            
            if stepToPlot==0 % not deformed
                nodeE = model.node(model.element(k).nodeE).pos;
                
                nodeI = nodeE - model.element(k).h/2 * model.element(k).xAxis;
                nodeJ = nodeE + model.element(k).h/2 * model.element(k).xAxis;
                
                nodeE1 = nodeE;
                nodeE2 = nodeE;
                
                zAxisRotI = v_or;
                zAxisRotJ = v_or;
                shift = 0;
                
            else
                nodeE = model.node(model.element(k).nodeE).pos;
                offsetI  = ( model.node(model.element(k).nodeE).pos - model.element(k).h/2 * model.element(k).xAxis) - model.node(model.element(k).nodeI).pos;
                offsetJ  = ( model.node(model.element(k).nodeE).pos + model.element(k).h/2 * model.element(k).xAxis) - model.node(model.element(k).nodeJ).pos;
                
                anglesI = [result.node(model.element(k).nodeI).rotx(stepToPlot);
                           result.node(model.element(k).nodeI).roty(stepToPlot);
                           result.node(model.element(k).nodeI).rotz(stepToPlot)]*deformed;
                       
                anglesJ = [result.node(model.element(k).nodeJ).rotx(stepToPlot);
                           result.node(model.element(k).nodeJ).roty(stepToPlot);
                           result.node(model.element(k).nodeJ).rotz(stepToPlot)]*deformed;
                    
                offsetRotI =  rotate3D(offsetI, anglesI);
                offsetRotJ =  rotate3D(offsetJ, anglesJ);
                
                
                xAxisRotI = rotate3D(model.element(k).xAxis, anglesI);
                zAxisRotI = rotate3D(model.wall(model.element(k).wall).zAxis, anglesI);
                yAxisRotI = cross(zAxisRotI, xAxisRotI);
                xAxisRotJ = rotate3D(model.element(k).xAxis, anglesJ);
                zAxisRotJ = rotate3D(model.wall(model.element(k).wall).zAxis, anglesJ);
                
                
                
                nodeI = model.node(model.element(k).nodeI).pos + offsetRotI + deformed * [result.node(model.element(k).nodeI).u(stepToPlot); 
                                                                                          result.node(model.element(k).nodeI).v(stepToPlot); 
                                                                                          result.node(model.element(k).nodeI).w(stepToPlot);];
                                                                                         
                nodeJ = model.node(model.element(k).nodeJ).pos + offsetRotJ + deformed * [result.node(model.element(k).nodeJ).u(stepToPlot); 
                                                                                          result.node(model.element(k).nodeJ).v(stepToPlot); 
                                                                                          result.node(model.element(k).nodeJ).w(stepToPlot);];
                
                nodeE1 = nodeE +  deformed * [result.node(model.element(k).nodeE).u(stepToPlot); 
                                              result.node(model.element(k).nodeE).v(stepToPlot); 
                                              result.node(model.element(k).nodeE).w(stepToPlot);];     
                nodeE2 = nodeE +  deformed * [result.node(model.element(k).nodeE).rotx(stepToPlot); 
                                              result.node(model.element(k).nodeE).roty(stepToPlot); 
                                              result.node(model.element(k).nodeE).rotz(stepToPlot);];  
                                          
                shift = (nodeE2-nodeE1)'*yAxisRotI;
                

            end
            
            t= model.element(k).t;
            if strcmp(styleElements, 'wireframe')
                t =t*0;
            end
            
            if strcmp(model.element(k).type, 'Macroelement3d')
                [xx1 yy1 zz1] = addWallToPatch(nodeI, nodeE1, zAxisRotI, model.element(k).b, t, [0;0;0], [0;shift/2;0], style);
                [xx2 yy2 zz2] = addWallToPatch(nodeE2, nodeJ, zAxisRotJ, model.element(k).b, t, [0;-shift/2;0], [0;0;0], style);
            else
                [xx1 yy1 zz1] = addIrregularWallToPatch(nodeI, nodeE1, zAxisRotI, model.element(k).b, t, [0;0;0], [0;0;0], style, 0.5, model.element(k).baseCut);
                [xx2 yy2 zz2] = addIrregularWallToPatch(nodeE2, nodeJ, zAxisRotJ, 0.5*model.element(k).b, t, [0;0;0], [0;0;0], style, 0.01, model.element(k).baseCut);
            end
            
            if abs([0,0,1]*model.element(k).xAxis) >0.9
                %if strcmp(style, 'wireframe'); colorEdges = colorPiers;  end
                %draw_wall( nodeI, nodeJ, v_or, model.element(k).L, model.element(k).t, ...
                %           [0;0;0], [0;0;0], style, colorEdges, colorPiers);
                XPiers = [XPiers, xx1, xx2];
                YPiers = [YPiers, yy1, yy2];
                ZPiers = [ZPiers, zz1, zz2];
                
                if strcmp(mapDamage, 'alpha')
                    CPiers = [CPiers, min(maxDamage,result.element(k).alpha(stepToPlot))*[1,1,1,1,1,1, 1,1,1,1,1,1]];
                elseif strcmp(mapDamage, 'driftF')
                    CPiers = [CPiers, min(maxDamage,max(abs(result.element(k).driftF(1:stepToPlot))))*[1,1,1,1,1,1, 1,1,1,1,1,1]];
                elseif strcmp(mapDamage, 'driftS')
                    CPiers = [CPiers, min(maxDamage,max(abs(result.element(k).driftS(1:stepToPlot))))*[1,1,1,1,1,1, 1,1,1,1,1,1]];
                else
                    CPiers = [CPiers, 1*[1,1,1,1,1,1, 1,1,1,1,1,1]];
                end
            else
                %if strcmp(style, 'wireframe'); colorEdges = colorSpandrels;  end
                %draw_wall( nodeI, nodeJ, v_or, model.element(k).L, model.element(k).t, ...
                %           [0;0;0], [0;0;0], style, colorEdges, colorSpandrels);
                XSpandrels = [XSpandrels, xx1, xx2];
                YSpandrels = [YSpandrels, yy1, yy2];
                ZSpandrels = [ZSpandrels, zz1, zz2];
                
                if strcmp(mapDamage, 'alpha')
                    CSpandrels = [CSpandrels, min(maxDamage,result.element(k).alpha(stepToPlot))*[1,1,1,1,1,1, 1,1,1,1,1,1]];
                elseif strcmp(mapDamage, 'driftF')
                    CSpandrels = [CSpandrels, min(maxDamage,max(abs(result.element(k).driftF(1:stepToPlot))))*[1,1,1,1,1,1, 1,1,1,1,1,1]];
                elseif strcmp(mapDamage, 'driftS')
                    CSpandrels = [CSpandrels, min(maxDamage,max(abs(result.element(k).driftS(1:stepToPlot))))*[1,1,1,1,1,1, 1,1,1,1,1,1]];
                else
                    CSpandrels = [CSpandrels, 1*[1,1,1,1,1,1, 1,1,1,1,1,1]];
                end
            end
        end
    end
end


size(CPiers)
size(XPiers)

if ischar(colorPiers)
    h = patch('XData',XPiers, 'YData',YPiers, 'ZData',ZPiers, 'CData',CPiers, 'edgecolor', colorEdges);
    if strcmp(mapDamage, 'none')
        set(h, 'FaceColor', colorPiers);
    else
        set(h, 'FaceColor', 'flat');
    end
else
   %patch(XPiers, YPiers, ZPiers, colorPiers, 'edgecolor', colorEdges);
   h = patch('XData',XPiers, 'YData',YPiers, 'ZData',ZPiers, 'CData',CPiers, 'edgecolor', colorEdges);
    if strcmp(mapDamage, 'none')
        set(h, 'FaceColor', colorPiers);
    else
        set(h, 'FaceColor', 'flat');
    end
end

if ischar(colorSpandrels)
    h = patch('XData',XSpandrels, 'YData',YSpandrels, 'ZData',ZSpandrels, 'CData',CSpandrels, 'edgecolor', colorEdges);
    if strcmp(mapDamage, 'none')
        set(h, 'FaceColor', colorSpandrels);
    else
        set(h, 'FaceColor', 'flat');
    end
        
else
   % patch(XSpandrels, YSpandrels, ZSpandrels, colorSpandrels, 'edgecolor', colorEdges);
    
    h = patch('XData',XSpandrels, 'YData',YSpandrels, 'ZData',ZSpandrels, 'CData',CSpandrels, 'edgecolor', colorEdges);
    if strcmp(mapDamage, 'none')
        set(h, 'FaceColor', colorSpandrels);
    else
        set(h, 'FaceColor', 'flat');
    end
end



%% draw rigid beams in undeformed configuration
XPiers = []; YPiers = []; ZPiers = [];
for k_el=1:length(elementList)
    k = elementList(k_el);
    if not(isempty(model.element(k).nodeI))  && (strcmp(model.element(k).type, 'ElasticBeam') || strcmp(model.element(k).type, 'NonlinearBeam'))
        if sum(model.element(k).wall == wallsToPlot)~=0
            nWall = model.element(k).wall;
            v_or = model.wall(nWall).zAxis;
            
            if stepToPlot==0 % not deformed
                
                if isempty(model.element(k).offsetI)
                    nodeI = model.node(model.element(k).nodeI).pos;
                else
                    nodeI = model.node(model.element(k).nodeI).pos + model.element(k).offsetI;
                end
                
                if isempty(model.element(k).offsetJ)
                    nodeJ = model.node(model.element(k).nodeJ).pos;
                else
                    nodeJ = model.node(model.element(k).nodeJ).pos + model.element(k).offsetJ;
                end
                
                zAxisRotI = v_or;
                zAxisRotJ = v_or;
                
                t= sizeBeams;
                if strcmp(styleElements, 'wireframe')
                    t =t*0;
                end

                [xx1 yy1 zz1] = addWallToPatch(nodeI, nodeJ, zAxisRotI, sizeBeams, t, [0;0;0], [0;0;0], style);

                XPiers = [XPiers, xx1];
                YPiers = [YPiers, yy1];
                ZPiers = [ZPiers, zz1];
            end
            
        end
    end
end

if ischar(colorBeams)
    h = patch(XPiers, YPiers, ZPiers, 'w', 'edgecolor', colorEdges);
    set(h, 'FaceColor', colorBeams);
else
   patch(XPiers, YPiers, ZPiers, colorBeams, 'edgecolor', colorEdges);
end

    
% %axis equal
% %axis off

successOutput = true;


end

