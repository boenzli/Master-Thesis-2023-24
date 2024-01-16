function modelO = convertTremuriToOpenSees(modelT)

% translates a structure "modelTremuri" containing all the information that can be read from
% a Tremuri .txt input file, into a structure "modelOpensees", containing the necessary information
% to write an equivalent OpenSees model. 
% Gives as output a model structure that can be used to plot the model and
% to print an input file. As additional input variables are needed (for ex. the
% wall-to-wall connection model), this last step is done by a different script.

%% wall variable
% add just the local axis orientation as xAxis (xLoc), yAxis(zLoc), and zAxis (OOP vector)
%modelO.wall = modelT.wall;
for kWall=1:length(modelT.wall)
    if ~isempty(modelT.wall(kWall).x0)
        modelO.wall(kWall).origin = [modelT.wall(kWall).x0; modelT.wall(kWall).y0; 0];
        theta = modelT.wall(kWall).angle;
        modelO.wall(kWall).xAxis  = [cos(theta); sin(theta); 0];
        modelO.wall(kWall).yAxis  = [0; 0; 1];
        modelO.wall(kWall).zAxis  = cross(modelO.wall(kWall).xAxis, modelO.wall(kWall).yAxis);
    end
end

%% node variable
% add all 2d nodes as they are
for kNode=1:length(modelT.node2d)
    if ~isempty(modelT.node2d(kNode).wall)
        modelO.node(kNode).x = modelT.node2d(kNode).x;
        modelO.node(kNode).y = modelT.node2d(kNode).y;
        modelO.node(kNode).z = modelT.node2d(kNode).z;
        modelO.node(kNode).pos = [modelO.node(kNode).x; modelO.node(kNode).y; modelO.node(kNode).z];
        modelO.node(kNode).wall = modelT.node2d(kNode).wall;
        modelO.node(kNode).blCorner = [];
        modelO.node(kNode).xDim = [];
        modelO.node(kNode).yDim = [];
        modelO.node(kNode).area = [];
        modelO.node(kNode).t = [];
        modelO.node(kNode).rho = [];
        modelO.node(kNode).addedMass = [];
        modelO.node(kNode).repartition = modelT.node2d(kNode).repartition;
                   
        if strcmp(modelT.node2d(kNode).type, 'R')
            kWall = modelO.node(kNode).wall;
            modelO.node(kNode).polygon(1).xDim = abs(modelT.node2d(kNode).offsetXloc(2) - modelT.node2d(kNode).offsetXloc(1) );
            modelO.node(kNode).polygon(1).yDim = abs(modelT.node2d(kNode).offsetZ(2) - modelT.node2d(kNode).offsetZ(1) );
            modelO.node(kNode).polygon(1).area = modelO.node(kNode).polygon(1).xDim * modelO.node(kNode).polygon(1).yDim;
                                                               
                                                   
            modelO.node(kNode).polygon(1).blCorner =  [NaN;
                                                       NaN;
                                                       modelO.node(kNode).z+ min(modelT.node2d(kNode).offsetZ)];
                                                   
           if modelO.wall(kWall).xAxis(1)>=0
               modelO.node(kNode).polygon(1).blCorner(1) =  min(modelT.node2d(kNode).offsetX);
           else
               modelO.node(kNode).polygon(1).blCorner(1) =  max(modelT.node2d(kNode).offsetX);
           end
           
           if modelO.wall(kWall).xAxis(2)>=0
               modelO.node(kNode).polygon(1).blCorner(2) =  min(modelT.node2d(kNode).offsetY);
           else
               modelO.node(kNode).polygon(1).blCorner(2) =  max(modelT.node2d(kNode).offsetY);
           end
                                                   
                                                   
            
            modelO.node(kNode).polygon(1).t   = modelT.node2d(kNode).thickness;
            modelO.node(kNode).polygon(1).rho = modelT.node2d(kNode).rho;
            
        elseif strcmp(modelT.node2d(kNode).type, 'P')
            for kPolygon = 1:length(modelT.node2d(kNode).polygon)
                
                if ~isempty(modelT.node2d(kNode).polygon(kPolygon).rho)
                    
                    modelO.node(kNode).polygon(kPolygon).xDim = abs(modelT.node2d(kNode).polygon(kPolygon).offsetXloc(2) ...
                                                                  - modelT.node2d(kNode).polygon(kPolygon).offsetXloc(1) );
                    modelO.node(kNode).polygon(kPolygon).yDim = abs(modelT.node2d(kNode).polygon(kPolygon).offsetZ(2) ...
                                                                  - modelT.node2d(kNode).polygon(kPolygon).offsetZ(1) );
                    modelO.node(kNode).polygon(kPolygon).area = modelO.node(kNode).polygon(kPolygon).xDim * modelO.node(kNode).polygon(kPolygon).yDim;
                    
                    modelO.node(kNode).polygon(kPolygon).blCorner =  [min(modelT.node2d(kNode).polygon(kPolygon).offsetX);
                                                                      min(modelT.node2d(kNode).polygon(kPolygon).offsetY);
                                                                      modelO.node(kNode).z+ min(modelT.node2d(kNode).polygon(kPolygon).offsetZ)];
                    
                    modelO.node(kNode).polygon(kPolygon).t = modelT.node2d(kNode).polygon(kPolygon).thickness;
                    modelO.node(kNode).polygon(kPolygon).rho = modelT.node2d(kNode).polygon(kPolygon).rho;
                end
            end         
        end
    end     
end

% add all 3d nodes as two overlapped nodes that can potentially split
newNodetag = max([length(modelT.node2d),length(modelT.node3d)] );
w2wTag = 0;
doubled3dNodes = [];

for kNode=1:length(modelT.node3d)
    if ~isempty(modelT.node3d(kNode).wall)
        % make first copy of the node, same tag
        modelO.node(kNode).x = modelT.node3d(kNode).x;
        modelO.node(kNode).y = modelT.node3d(kNode).y;
        modelO.node(kNode).z = modelT.node3d(kNode).z;
        modelO.node(kNode).pos = [modelO.node(kNode).x; modelO.node(kNode).y; modelO.node(kNode).z];
        modelO.node(kNode).wall = modelT.node3d(kNode).wall(1);
        modelO.node(kNode).blCorner = [];
        modelO.node(kNode).addedMass = [];
        modelO.node(kNode).repartition = [];
        
        modelO.node(kNode).polygon(1).blCorner = [];
        modelO.node(kNode).polygon(1).xDim = [];
        modelO.node(kNode).polygon(1).xDim = [];
        modelO.node(kNode).polygon(1).area = [];
        modelO.node(kNode).polygon(1).t = [];
        modelO.node(kNode).polygon(1).rho = [];
        
        modelO.node(kNode).polygon(2).blCorner = [];
        modelO.node(kNode).polygon(2).xDim = [];
        modelO.node(kNode).polygon(2).xDim = [];
        modelO.node(kNode).polygon(2).area = [];
        modelO.node(kNode).polygon(2).t = [];
        modelO.node(kNode).polygon(2).rho = [];
                   
        if strcmp(modelT.node3d(kNode).type(1), 'R')
            kWall = modelO.node(kNode).wall;
            modelO.node(kNode).polygon(1).xDim = abs(modelT.node3d(kNode).offsetXloc1(2) - modelT.node3d(kNode).offsetXloc1(1) );
            modelO.node(kNode).polygon(1).yDim = abs(modelT.node3d(kNode).offsetZ1(2) - modelT.node3d(kNode).offsetZ1(1) );
            modelO.node(kNode).polygon(1).area = modelO.node(kNode).polygon(1).xDim * modelO.node(kNode).polygon(1).yDim;
            
            modelO.node(kNode).polygon(1).blCorner =  [NaN;
                                                       NaN;
                                                       modelO.node(kNode).z+ min(modelT.node3d(kNode).offsetZ1)];
                                                   
           if modelO.wall(kWall).xAxis(1)>=0
               modelO.node(kNode).polygon(1).blCorner(1) =  min(modelT.node3d(kNode).offsetX1);
           else
               modelO.node(kNode).polygon(1).blCorner(1) =  max(modelT.node3d(kNode).offsetX1);
           end
           
           if modelO.wall(kWall).xAxis(2)>=0
               modelO.node(kNode).polygon(1).blCorner(2) =  min(modelT.node3d(kNode).offsetY1);
           else
               modelO.node(kNode).polygon(1).blCorner(2) =  max(modelT.node3d(kNode).offsetY1);
           end

            modelO.node(kNode).polygon(1).t   = modelT.node3d(kNode).thickness1;
            modelO.node(kNode).polygon(1).rho = modelT.node3d(kNode).rho1;
            
        elseif strcmp(modelT.node3d(kNode).type(1), 'P')
            for kPolygon = 1:length(modelT.node3d(kNode).polygon1)
                
                if ~isempty(modelT.node3d(kNode).polygon1(kPolygon).rho)
                    
                    modelO.node(kNode).polygon(kPolygon).xDim = abs(modelT.node3d(kNode).polygon1(kPolygon).offsetXloc(2) ...
                                                                  - modelT.node3d(kNode).polygon1(kPolygon).offsetXloc(1) );
                    modelO.node(kNode).polygon(kPolygon).yDim = abs(modelT.node3d(kNode).polygon1(kPolygon).offsetZ(2) ...
                                                                  - modelT.node3d(kNode).polygon1(kPolygon).offsetZ(1) );
                    modelO.node(kNode).polygon(kPolygon).area = modelO.node(kNode).polygon(kPolygon).xDim * modelO.node(kNode).polygon(kPolygon).yDim;
                    
                    modelO.node(kNode).polygon(kPolygon).blCorner =  [min(modelT.node3d(kNode).polygon1(kPolygon).offsetX);
                                                                      min(modelT.node3d(kNode).polygon1(kPolygon).offsetY);
                                                                      modelO.node(kNode).z+ min(modelT.node3d(kNode).polygon1(kPolygon).offsetZ)];
                    
                    modelO.node(kNode).polygon(kPolygon).t = modelT.node3d(kNode).polygon1(kPolygon).thickness;
                    modelO.node(kNode).polygon(kPolygon).rho = modelT.node3d(kNode).polygon1(kPolygon).rho;
                end
            end         
        end
        
        % make copy of the node on the second wall and keep track of the connection 
        newNodetag = newNodetag+1;
        w2wTag = w2wTag +1;
        modelO.constraint.wallToWall(w2wTag).master = kNode; 
        modelO.constraint.wallToWall(w2wTag).slave  = newNodetag;
        modelO.constraint.wallToWall(w2wTag).dofs = [1,2];
        
        doubled3dNodes = [doubled3dNodes; kNode, newNodetag];
        
        
        modelO.node(newNodetag).x = modelT.node3d(kNode).x;
        modelO.node(newNodetag).y = modelT.node3d(kNode).y;
        modelO.node(newNodetag).z = modelT.node3d(kNode).z;
        modelO.node(newNodetag).pos = [modelO.node(newNodetag).x; modelO.node(newNodetag).y; modelO.node(newNodetag).z];
        modelO.node(newNodetag).wall = modelT.node3d(kNode).wall(2);
                   
        if strcmp(modelT.node3d(kNode).type(2), 'R')
            modelO.node(newNodetag).polygon(1).xDim = abs(modelT.node3d(kNode).offsetXloc2(2) - modelT.node3d(kNode).offsetXloc2(1) );
            modelO.node(newNodetag).polygon(1).yDim = abs(modelT.node3d(kNode).offsetZ2(2) - modelT.node3d(kNode).offsetZ2(1) );
            modelO.node(newNodetag).polygon(1).area = modelO.node(newNodetag).polygon(1).xDim * modelO.node(newNodetag).polygon(1).yDim;
                         
            kWall = modelO.node(newNodetag).wall;
            modelO.node(newNodetag).polygon(1).blCorner =  [NaN;
                                                            NaN;
                                                            modelO.node(newNodetag).z+ min(modelT.node3d(kNode).offsetZ2)];
                                                   
           if modelO.wall(kWall).xAxis(1)>=0
               modelO.node(newNodetag).polygon(1).blCorner(1) =  min(modelT.node3d(kNode).offsetX2);
           else
               modelO.node(newNodetag).polygon(1).blCorner(1) =  max(modelT.node3d(kNode).offsetX2);
           end
           
           if modelO.wall(kWall).xAxis(2)>=0
               modelO.node(newNodetag).polygon(1).blCorner(2) =  min(modelT.node3d(kNode).offsetY2);
           else
               modelO.node(newNodetag).polygon(1).blCorner(2) =  max(modelT.node3d(kNode).offsetY2);
           end
                                                        
            
            modelO.node(newNodetag).polygon(1).t   = modelT.node3d(kNode).thickness2;
            modelO.node(newNodetag).polygon(1).rho = modelT.node3d(kNode).rho2;
            
        elseif strcmp(modelT.node3d(kNode).type(2), 'P')
            for kPolygon = 1:length(modelT.node3d(kNode).polygon2)
                
                if ~isempty(modelT.node3d(kNode).polygon2(kPolygon).rho)
                    
                    modelO.node(newNodetag).polygon(kPolygon).xDim = abs(modelT.node3d(kNode).polygon2(kPolygon).offsetXloc(2) ...
                                                                       - modelT.node3d(kNode).polygon2(kPolygon).offsetXloc(1) );
                    modelO.node(newNodetag).polygon(kPolygon).yDim = abs(modelT.node3d(kNode).polygon2(kPolygon).offsetZ(2) ...
                                                                       - modelT.node3d(kNode).polygon2(kPolygon).offsetZ(1) );
                    modelO.node(newNodetag).polygon(kPolygon).area = modelO.node(newNodetag).polygon(kPolygon).xDim * modelO.node(newNodetag).polygon(kPolygon).yDim;
                    
                    modelO.node(newNodetag).polygon(kPolygon).blCorner =  [min(modelT.node3d(kNode).polygon2(kPolygon).offsetX);
                                                                           min(modelT.node3d(kNode).polygon2(kPolygon).offsetY);
                                                                           modelO.node(newNodetag).z+ min(modelT.node3d(kNode).polygon2(kPolygon).offsetZ)];
                    
                    modelO.node(newNodetag).polygon(kPolygon).t   = modelT.node3d(kNode).polygon2(kPolygon).thickness;
                    modelO.node(newNodetag).polygon(kPolygon).rho = modelT.node3d(kNode).polygon2(kPolygon).rho;
                end
            end         
        end
   
    end     
end

%% element variable - macroelements
for kEl=1:length(modelT.element)
    if ~isempty(modelT.element(kEl).wall)
       modelO.element(kEl).wall  = modelT.element(kEl).wall;
       % check if node I was split
       nI = modelT.element(kEl).nodeI;
       if ~isempty(find(doubled3dNodes==nI))
           if modelO.element(kEl).wall==modelT.node3d(nI).wall(2)
               nI = doubled3dNodes( find(doubled3dNodes==nI,1), 2 );
           end 
       end
       modelO.element(kEl).nodeI = nI;
       
       % check if node J was split
       nJ = modelT.element(kEl).nodeJ;
       if ~isempty(find(doubled3dNodes==nJ))
           if modelO.element(kEl).wall==modelT.node3d(nJ).wall(2)
               nJ = doubled3dNodes( find(doubled3dNodes==nJ,1), 2 );
           end 
       end
       modelO.element(kEl).nodeJ = nJ;
       
       % create element node
        newNodetag = newNodetag+1; 
        posVec = modelO.wall(modelT.element(kEl).wall).origin + modelO.wall(modelT.element(kEl).wall).xAxis * modelT.element(kEl).xBar;
        modelO.node(newNodetag).x = posVec(1);
        modelO.node(newNodetag).y = posVec(2);
        modelO.node(newNodetag).z = modelT.element(kEl).zBar;
        modelO.node(newNodetag).pos = [modelO.node(newNodetag).x; modelO.node(newNodetag).y; modelO.node(newNodetag).z];
        modelO.node(newNodetag).wall = modelT.element(kEl).wall;
        
        modelO.element(kEl).nodeE = newNodetag;
                   
        modelO.element(kEl).nodeVec = [modelO.element(kEl).nodeI; modelO.element(kEl).nodeJ; modelO.element(kEl).nodeE];
        
        angles = modelT.element(kEl).angle *modelO.wall(modelT.element(kEl).wall).zAxis;
        axisVec = rotate3D(modelO.wall(modelT.element(kEl).wall).xAxis, angles);
             
        modelO.element(kEl).xAxis = axisVec;
        modelO.element(kEl).h = modelT.element(kEl).H;
        modelO.element(kEl).b = modelT.element(kEl).L;
        modelO.element(kEl).t = modelT.element(kEl).t;
        
        modelO.element(kEl).type =  'Macroelement3d';
        modelO.element(kEl).area =  [];
        modelO.element(kEl).floor = [];
        modelO.element(kEl).mat = modelT.element(kEl).mat;

    end
end

%% element variable - elastic beams
% add tags
newkEl = length(modelO.element);
for kEl=1:length(modelT.elasticBeam)
    if ~isempty(modelT.elasticBeam(kEl).wall)
       newkEl= newkEl +1;
       modelO.element(newkEl).wall  = modelT.elasticBeam(kEl).wall;
       
       % check if node I was split
       nI = modelT.elasticBeam(kEl).nodeI;
       if ~isempty(find(doubled3dNodes==nI))
           if modelO.element(newkEl).wall==modelT.node3d(nI).wall(2)
               nI = doubled3dNodes( find(doubled3dNodes==nI,1), 2 );
           end 
       end
       modelO.element(newkEl).nodeI = nI;
       
       % check if node J was split
       nJ = modelT.elasticBeam(kEl).nodeJ;
       if ~isempty(find(doubled3dNodes==nJ))
           if modelO.element(newkEl).wall==modelT.node3d(nJ).wall(2)
               nJ = doubled3dNodes( find(doubled3dNodes==nJ,1), 2 );
           end 
       end
       modelO.element(newkEl).nodeJ = nJ;
       
       modelO.element(newkEl).mat   = modelT.elasticBeam(kEl).mat;
       modelO.element(newkEl).area  = modelT.elasticBeam(kEl).area;
       modelO.element(newkEl).J     = modelT.elasticBeam(kEl).J;  
       modelO.element(newkEl).propVec = [modelT.elasticBeam(kEl).deformIn; modelT.elasticBeam(kEl).type; ...
                                         modelT.elasticBeam(kEl).offXloc_I; modelT.elasticBeam(kEl).offZ_I; ...
                                         modelT.elasticBeam(kEl).offXloc_J; modelT.elasticBeam(kEl).offZ_J]; 
       
       modelO.element(newkEl).type =  'ElasticBeam';
       
       % calculate offset
       kWall = modelT.elasticBeam(kEl).wall;
       xAxis = modelO.wall(kWall).xAxis;
       yAxis = modelO.wall(kWall).yAxis;
       zAxis = modelO.wall(kWall).zAxis;
       
       modelO.element(newkEl).offsetI = xAxis* modelT.elasticBeam(kEl).offXloc_I + yAxis* modelT.elasticBeam(kEl).offZ_I ;
       modelO.element(newkEl).offsetJ = xAxis* modelT.elasticBeam(kEl).offXloc_J + yAxis* modelT.elasticBeam(kEl).offZ_J ;
       
    end
end

%% element variable - nonlinear beams
% add tags
newkEl = length(modelO.element);
for kEl=1:length(modelT.nlBeam)
    if ~isempty(modelT.nlBeam(kEl).wall)
       newkEl= newkEl +1;
       modelO.element(newkEl).wall  = modelT.nlBeam(kEl).wall;
       
       % check if node I was split
       nI = modelT.nlBeam(kEl).nodeI;
       if ~isempty(find(doubled3dNodes==nI))
           if modelO.element(newkEl).wall==modelT.node3d(nI).wall(2)
               nI = doubled3dNodes( find(doubled3dNodes==nI,1), 2 );
           end 
       end
       modelO.element(newkEl).nodeI = nI;
       
       % check if node J was split
       nJ = modelT.nlBeam(kEl).nodeJ;
       if ~isempty(find(doubled3dNodes==nJ))
           if modelO.element(newkEl).wall==modelT.node3d(nJ).wall(2)
               nJ = doubled3dNodes( find(doubled3dNodes==nJ,1), 2 );
           end 
       end
       modelO.element(newkEl).nodeJ = nJ;
       
       modelO.element(newkEl).mat   = modelT.nlBeam(kEl).mat;
       modelO.element(newkEl).area  = modelT.nlBeam(kEl).area;
       modelO.element(newkEl).J     = modelT.nlBeam(kEl).J;  
       modelO.element(newkEl).Wpl   = modelT.nlBeam(kEl).Wpl; 
       modelO.element(newkEl).propVec = [modelT.elasticBeam(kEl).deformIn; modelT.elasticBeam(kEl).type; ...
                                         modelT.elasticBeam(kEl).offXloc_I; modelT.elasticBeam(kEl).offZ_I; ...
                                         modelT.elasticBeam(kEl).offXloc_J; modelT.elasticBeam(kEl).offZ_J]; 
       
       modelO.element(newkEl).type =  'NonlinearBeam';
       
       % calculate offset
       kWall = modelT.nlBeam(kEl).wall;
       xAxis = modelO.wall(kWall).xAxis;
       yAxis = modelO.wall(kWall).yAxis;
       zAxis = modelO.wall(kWall).zAxis;
       
       modelO.element(newkEl).offsetI = xAxis* modelT.nlBeam(kEl).offXloc_I + yAxis* modelT.nlBeam(kEl).offZ_I ;
       modelO.element(newkEl).offsetJ = xAxis* modelT.nlBeam(kEl).offXloc_J + yAxis* modelT.nlBeam(kEl).offZ_J ;
       
       
       
    end
end

%% floor variable
modelO.floor = modelT.floorLevel;

newkNode = length(modelO.node);
f2wTag = 0;
for kFloor=1:length(modelT.floor)
    if ~isempty(modelT.floor(kFloor).nodes)
        % create nodes to connect it to the structure with possible sliding
        for kNode=1:length(modelT.floor(kFloor).nodes)
            newkNode = newkNode+1;
            % write explicitly because we don't want to import also the masses
            oldNode = modelT.floor(kFloor).nodes(kNode);
            modelO.node(newkNode).x = modelO.node(oldNode).x;
            modelO.node(newkNode).y = modelO.node(oldNode).y;
            modelO.node(newkNode).z = modelO.node(oldNode).z;
            modelO.node(newkNode).pos = [modelO.node(newkNode).x; modelO.node(newkNode).y; modelO.node(newkNode).z];
            modelO.node(newkNode).wall = modelO.node(oldNode).wall;
            
            % remember the constraint
            f2wTag = f2wTag +1;
            modelO.constraint.floorToWall(f2wTag).master = oldNode; 
            modelO.constraint.floorToWall(f2wTag).slave  = newkNode;
            modelO.constraint.floorToWall(f2wTag).dofs = [1,2,3,4,5,6];        
        end
        
        % create floor shell
        newkEl= newkEl +1;
        modelO.element(newkEl).t        = modelT.floor(kFloor).thickness;
        modelO.element(newkEl).nodeI = newkNode-3;
        modelO.element(newkEl).nodeJ = newkNode-2;
        modelO.element(newkEl).nodeK = newkNode-1;
        modelO.element(newkEl).nodeL = newkNode;
        modelO.element(newkEl).nodeVec  = [modelO.element(newkEl).nodeI; modelO.element(newkEl).nodeJ; modelO.element(newkEl).nodeK; modelO.element(newkEl).nodeL];
        
        % calculate area (useful for applying loads)
        area = 0;
        vecAB = modelO.node(modelO.element(newkEl).nodeJ).pos - modelO.node(modelO.element(newkEl).nodeI).pos;
        vecAC = modelO.node(modelO.element(newkEl).nodeL).pos - modelO.node(modelO.element(newkEl).nodeI).pos;
        area = area + 1/2*norm(cross(vecAB, vecAC));
        
        vecAB = modelO.node(modelO.element(newkEl).nodeJ).pos - modelO.node(modelO.element(newkEl).nodeK).pos;
        vecAC = modelO.node(modelO.element(newkEl).nodeL).pos - modelO.node(modelO.element(newkEl).nodeK).pos;
        area = area + 1/2*norm(cross(vecAB, vecAC));
        
        modelO.element(newkEl).area = area;
        modelO.element(newkEl).properties = [modelT.floor(kFloor).E1; modelT.floor(kFloor).E2; modelT.floor(kFloor).Poisson;modelT.floor(kFloor).G];
        modelO.element(newkEl).type =  'FloorShell';
        
        % assign floor number
        heightVec = [modelO.node(modelO.element(newkEl).nodeI).z; ...
                     modelO.node(modelO.element(newkEl).nodeJ).z; ...
                     modelO.node(modelO.element(newkEl).nodeK).z; ...
                     modelO.node(modelO.element(newkEl).nodeL).z];
        avgHeight = nanmean(heightVec);
        tol = 0.05;
        for kk=1:length(modelO.floor)
            if avgHeight-modelO.floor(kk).h<tol
                modelO.element(newkEl).floor = kk;
                break
            end
        end
        
        % assign principal direction
        vecIJ = modelO.node(modelO.element(newkEl).nodeJ).pos - modelO.node(modelO.element(newkEl).nodeI).pos;
        vecLK = modelO.node(modelO.element(newkEl).nodeK).pos - modelO.node(modelO.element(newkEl).nodeL).pos;
        modelO.element(newkEl).b = norm(vecIJ+vecLK)/2;
        modelO.element(newkEl).xAxis = (vecIJ+vecLK)/norm(vecIJ+vecLK);
        
    
    end
    
end

%% material variable
modelO.material = modelT.material;
for kMat=1:length(modelO.material)
    if ~isempty(modelO.material(kMat).Gc)
        modelO.material(kMat).muR = modelO.material(kMat).mu * 0.5;
    end
end

%% nodal mass variable
for kMass = 1:length(modelT.nodalMass)
    kNode = modelT.nodalMass(kMass).node;
    kWall = modelO.node(kNode).wall;
    modelO.node(kNode).addedMass = modelT.nodalMass(kMass).mass;
    modelO.node(kNode).addedMassEcc = modelT.nodalMass(kMass).ecc_x * modelO.wall(kWall).xAxis + ...
                                      modelT.nodalMass(kMass).ecc_z * modelO.wall(kWall).yAxis; 
end

%% restraints variable
newFix = 0;
for kFix = 1:length(modelT.restraint)
    kNode = modelT.restraint(kFix).node;
    newFix = newFix+1;
    
    modelO.constraint.fix(newFix).node = kNode;
    modelO.constraint.fix(newFix).dof = [1,2,3,4,5,6];  % restrain always everything
    
    % check if node was doubled (if 3d node)
    if ~isempty(find(doubled3dNodes(:,1)==kNode))
        newNode = doubled3dNodes(find(doubled3dNodes(:,1)==kNode,1),2);
        newFix = newFix+1;
        modelO.constraint.fix(newFix).node = newNode;
        modelO.constraint.fix(newFix).dof = [1,2,3,4,5,6];  % restrain always everything
        
    end
end

modelO.doubledNodes.doubled3dNodes = doubled3dNodes ;

%% analysis variable
modelO.analysis = modelT.analysis;
% calculate true scale factor of the accelerogram
for kAn = 1:length(modelO.analysis)
    if strcmp(modelO.analysis(kAn).type, 'Dynamic')
        % read accelerogram
%         delimiter = ' ';
%         formatSpec = '%f%[^\n\r]';
%         fileID = fopen(modelO.analysis(kAn).groundMotion, 'r');
%         dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
%         fclose(fileID);    
        dataArray=importdata("montenegro.txt")
        accVec = dataArray(:, 1);        
        clearvars filename delimiter formatSpec fileID dataArray ans;
        
        % process
        if modelO.analysis(kAn).PGA<0
            modelO.analysis(kAn).PGA = max(abs(accVec));
            modelO.analysis(kAn).scaleFactor = -1.0;
            modelO.analysis(kAn).scaledGroundMotion = -accVec;
        else
            modelO.analysis(kAn).scaleFactor = -modelO.analysis(kAn).PGA/max(abs(accVec));
            modelO.analysis(kAn).scaledGroundMotion = accVec * modelO.analysis(kAn).scaleFactor;
        end

    end
end






end

