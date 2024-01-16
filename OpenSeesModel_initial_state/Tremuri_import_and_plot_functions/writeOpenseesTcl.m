function filesToRun = writeOpenseesTcl(model, varargin )

% writes all the tcl files needed for running an Opensees analysis of a
% model previously loaded
% model file and analyses are kept separated

p = inputParser;

addRequired(p,'model');
addParameter(p,'inputPath',   pwd,   @ischar);  % MUST exist before
addParameter(p,'outputPath',  pwd,   @ischar);  % MUST exist before
addParameter(p,'accelerogramPath',  pwd,   @ischar);  % MUST exist before. Goes from inputPath to the accelegram folder where the applied ground motion is written
addParameter(p,'projectName',  'autoTcl',   @ischar);
addParameter(p,'wallToWallConnection', '1 2 3',   @ischar);     % locked DOFs in the wall to wall connection, ex. '1 2 3'
addParameter(p,'floorToWallConnection', '1 2 3 4 5',   @ischar);     % locked DOFs in the floor to wall connection, ex. '1 2 3'
addParameter(p,'wallToWallStrength',   [],   @isnumeric);   % structure [wall1, wall2, strength (N), GfI]
addParameter(p,'dropDrift',   0.004,   @isnumeric);   % standard dropDrift for standard implementation, if not present as a material field
addParameter(p,'massDistribution',  'Standard',   @ischar); % mass distribution. options 'Tremuri', 'Consistent', 'Standard', 'Lumped'
addParameter(p,'macroelementType',  'Tremuri',   @ischar);  % options 'Tremuri', 'Standard'
addParameter(p,'sectionType',       'Standard',  @ischar);  % options 'Tremuri', 'Fiber'
addParameter(p,'ignoreDrift',       0,  @isnumeric);  
addParameter(p,'flexureShells',     0,  @isnumeric);  
addParameter(p,'dampingRatio',     -1,  @isnumeric);  
addParameter(p,'pushoverPattern',   'Standard',  @ischar);  
addParameter(p,'freeVibrationTime',   0,  @isnumeric);  

parse(p,model,varargin{:});

path     = p.Results.inputPath;
pathOut  = p.Results.outputPath;
pathAcc  = p.Results.accelerogramPath;
projectName     = p.Results.projectName;
wallToWallConnection     = p.Results.wallToWallConnection;
floorToWallConnection    = p.Results.floorToWallConnection;
wallToWallStrength     = p.Results.wallToWallStrength;
massDistribution     = p.Results.massDistribution;
macroelementType     = p.Results.macroelementType;
sectionType          = p.Results.sectionType;
dropDrift          = p.Results.dropDrift;
ignoreDrift = p.Results.ignoreDrift;
flexureShells = p.Results.flexureShells;
csi = p.Results.dampingRatio;
pushoverPattern = p.Results.pushoverPattern;
freeVibrationTime = p.Results.freeVibrationTime;

nFiles = 0;

% remove backslash
path(find(path=='\')) = '/';
pathOut(find(pathOut=='\')) = '/';

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% model file
nFiles = nFiles+1;
outputFile = [path, '/', projectName, '_model.tcl'];

fid = fopen(outputFile, 'w');

% initial stuff and materials
fprintf(fid, 'wipe\n\n');
fprintf(fid, 'setMaxOpenFiles 2048;	        		# Max number of recorders\n');
fprintf(fid, 'set Ubig 1.e10; 			   	 		# a really large number\n');
fprintf(fid, 'set Usmall [expr 1.0/$Ubig]; 			# a really small number\n');
fprintf(fid, 'set g    %9.2f; \n', 9.81);
fprintf(fid, 'set pi   %9.7f; \n\n', pi);

fprintf(fid, '# Create ModelBuilder (with three-dimensions (-ndm) and 6 DOF/node (-ndf))\n');
fprintf(fid, 'model basic -ndm 3 -ndf 6\n\n');

%% nodes
fprintf(fid, '#NODES ------------------------------------------------------------ \n');
fprintf(fid, '# Definition of the geometry\n# Create nodes\n#       tag     X         Y         Z  \n');
node2dVec = [0;0;0];
for k = 1:length(model.node)
    if ~isempty(model.node(k).x)
        fprintf(fid, 'node %6.0i %9.3f %9.3f %9.3f \n', k, model.node(k).x, model.node(k).y, model.node(k).z);
        
        if ~isempty(model.node(k).repartition)
            node2dVec = [node2dVec, [k; model.node(k).repartition]];
        end     
    end
end
fprintf(fid, '#END NODES ------------------------------------------------------------ \n');
fprintf(fid, 'puts "Nodes defined." \n\n\n');

for k=1:length(model.wall)
    if ~isempty(model.wall(k).xAxis)
        fprintf(fid, 'geomTransf PDelta %6.0i %6.3f %6.3f %6.3f\n', k, model.wall(k).zAxis(1), model.wall(k).zAxis(2), model.wall(k).zAxis(3));
    end
end

%% macroelements
fprintf(fid, '\n#MACROELEMENTS --------------------------------------------------------- \n');
maxMacroelement = 0;
if strcmp(macroelementType, 'Tremuri')
    fprintf(fid, '#element Macroelement3d $eTag $nI $nJ $nE $aX $aY $aZ $oopX $oopY $oopZ -tremuri   $h $L $t $E $G $fc $mu $c $Gc $beta $driftF $driftS\n');
else
    fprintf(fid, '#element Macroelement3d $eTag $nI $nJ $nE $aX $aY $aZ $oopX $oopY $oopZ  -pier     $h $L $t $E $G $fc $mu $c $Gc $dropDrift $muR $driftF $driftS \n');
end
for k = 1:length(model.element)
    if ~isempty(model.element(k).nodeI) &&  strcmp(model.element(k).type, 'Macroelement3d')
        if maxMacroelement<k
            maxMacroelement = k;
        end
        
        if strcmp(macroelementType, 'Tremuri')
            % tremuri implementation
            if (abs(model.element(k).xAxis'*[0;0;1])>0.9)
                formatString = 'element Macroelement3d    %6.0i  %6.0i   %6.0i   %6.0i   %6.3f %6.3f %6.3f   %6.3f %6.3f %6.3f  -tremuri  %6.3f %6.3f %6.3f %6.3e %6.3e %6.3e %6.3f %6.3e %6.3f %6.3f %7.5f %7.5f  ';  
            else
                formatString = 'element Macroelement3d    %6.0i  %6.0i   %6.0i   %6.0i   %6.3f %6.3f %6.3f   %6.3f %6.3f %6.3f  -tremuri  %6.3f %6.3f %6.3f %6.3e %6.3e %6.3e %6.3f %6.3e %6.3f %6.3f %7.5f %7.5f  ';  

            end
            if strcmp(massDistribution, 'Standard')
                formatString = [formatString, ' -density %8.1f '];
            else if strcmp(massDistribution, 'Consistent')
                   formatString = [formatString, ' -density %8.1f -cmass ']; 
                end
            end
            formatString = [formatString, '\n']; 
            
            kMat = model.element(k).mat;
            
            if ignoreDrift
                model.material(kMat).drift_F = -1;
                model.material(kMat).drift_S = -1;
            end
            
            if strcmp(massDistribution, 'Standard') || strcmp(massDistribution, 'Consistent')
                fprintf(fid, formatString, ...
                    k, model.element(k).nodeI, model.element(k).nodeJ, model.element(k).nodeE, ...
                    model.element(k).xAxis(1), model.element(k).xAxis(2), model.element(k).xAxis(3), ...
                    model.wall(model.element(k).wall).zAxis(1), model.wall(model.element(k).wall).zAxis(2), model.wall(model.element(k).wall).zAxis(3), ...
                    model.element(k).h, model.element(k).b, model.element(k).t, ...
                    model.material(kMat).E, model.material(kMat).G, model.material(kMat).fc, model.material(kMat).mu, model.material(kMat).tau0, ...
                    model.material(kMat).Gc, model.material(kMat).beta, model.material(kMat).drift_F, model.material(kMat).drift_S, model.material(kMat).rho);
            else
                fprintf(fid, formatString, ...
                    k, model.element(k).nodeI, model.element(k).nodeJ, model.element(k).nodeE, ...
                    model.element(k).xAxis(1), model.element(k).xAxis(2), model.element(k).xAxis(3), ...
                    model.wall(model.element(k).wall).zAxis(1), model.wall(model.element(k).wall).zAxis(2), model.wall(model.element(k).wall).zAxis(3), ...
                    model.element(k).h, model.element(k).b, model.element(k).t, ...
                    model.material(kMat).E, model.material(kMat).G, model.material(kMat).fc, model.material(kMat).mu, model.material(kMat).tau0, ...
                    model.material(kMat).Gc, model.material(kMat).beta, model.material(kMat).drift_F, model.material(kMat).drift_S);
            end
            
        else
            % standard implementation
            if model.element(k).xAxis(3)<0.1*norm(model.element(k).xAxis)  % spandrel element
                 formatString = 'element Macroelement3d    %6.0i  %6.0i   %6.0i   %6.0i   %6.3f %6.3f %6.3f   %6.3f %6.3f %6.3f  -spandrel %6.3f %6.3f %6.3f %6.3e %6.3e %6.3e %6.3f %6.3e %6.3f %6.3f %6.3f %7.5f %7.5f  -pDelta ';             
            else  
                 formatString = 'element Macroelement3d    %6.0i  %6.0i   %6.0i   %6.0i   %6.3f %6.3f %6.3f   %6.3f %6.3f %6.3f  -pier     %6.3f %6.3f %6.3f %6.3e %6.3e %6.3e %6.3f %6.3e %6.3f %6.3f %6.3f %7.5f %7.5f  -pDelta '; 
            end

            if strcmp(massDistribution, 'Standard')
                formatString = [formatString, ' -density %8.1f '];
            else if strcmp(massDistribution, 'Consistent')
                   formatString = [formatString, ' -density %8.1f -cmass ']; 
                end
            end
            formatString = [formatString, '\n']; 
            
            kMat = model.element(k).mat;
            
            if ~isfield(model.material(kMat),'dropDrift')
                model.material(kMat).dropDrift = dropDrift;
            end
            
            if ignoreDrift
                model.material(kMat).drift_F = -1;
                model.material(kMat).drift_S = -1;
            end
                               
            if strcmp(massDistribution, 'Standard') || strcmp(massDistribution, 'Consistent')
                fprintf(fid, formatString, ...
                    k, model.element(k).nodeI, model.element(k).nodeJ, model.element(k).nodeE, ...
                    model.element(k).xAxis(1), model.element(k).xAxis(2), model.element(k).xAxis(3), ...
                    model.wall(model.element(k).wall).zAxis(1), model.wall(model.element(k).wall).zAxis(2), model.wall(model.element(k).wall).zAxis(3), ...
                    model.element(k).h, model.element(k).b, model.element(k).t, ...
                    model.material(kMat).E, model.material(kMat).G, model.material(kMat).fc, model.material(kMat).mu, model.material(kMat).tau0, ...
                    model.material(kMat).Gc, model.material(kMat).dropDrift, model.material(kMat).muR, model.material(kMat).drift_F, model.material(kMat).drift_S, model.material(kMat).rho);
            else
                fprintf(fid, formatString, ...
                    k, model.element(k).nodeI, model.element(k).nodeJ, model.element(k).nodeE, ...
                    model.element(k).xAxis(1), model.element(k).xAxis(2), model.element(k).xAxis(3), ...
                    model.wall(model.element(k).wall).zAxis(1), model.wall(model.element(k).wall).zAxis(2), model.wall(model.element(k).wall).zAxis(3), ...
                    model.element(k).h, model.element(k).b, model.element(k).t, ...
                    model.material(kMat).E, model.material(kMat).G, model.material(kMat).fc, model.material(kMat).mu, model.material(kMat).tau0, ...
                    model.material(kMat).Gc, model.material(kMat).dropDrift, model.material(kMat).muR, model.material(kMat).drift_F, model.material(kMat).drift_S, model.material(kMat).rho);
            end
        end
                       
    end
end




for k = 1:length(model.element)
    if ~isempty(model.element(k).nodeI) &&  strcmp(model.element(k).type, 'TriangularMacroelement')
        if maxMacroelement<k
            maxMacroelement = k;
        end
        
        if strcmp(macroelementType, 'Tremuri')
            % tremuri implementation
            formatString = 'element Macroelement3d    %6.0i  %6.0i   %6.0i   %6.0i   %6.3f %6.3f %6.3f   %6.3f %6.3f %6.3f  -gable  %6.3f %6.3f %6.3f %6.3e %6.3e %6.3e %6.3f %6.3e %6.3f %6.3f %6.3f %7.5f %7.5f  ';  

            if strcmp(massDistribution, 'Standard')
                formatString = [formatString, ' -density %8.1f '];
            else if strcmp(massDistribution, 'Consistent')
                   formatString = [formatString, ' -density %8.1f -cmass ']; 
                end
            end
            formatString = [formatString, '\n']; 
            
            kMat = model.element(k).mat;
            
            if ignoreDrift
                model.material(kMat).drift_F = -1;
                model.material(kMat).drift_S = -1;
            end
            
            if strcmp(massDistribution, 'Standard') || strcmp(massDistribution, 'Consistent')
                fprintf(fid, formatString, ...                
                    k, model.element(k).nodeI, model.element(k).nodeJ, model.element(k).nodeE, ...
                    model.element(k).xAxis(1), model.element(k).xAxis(2), model.element(k).xAxis(3), ...
                    model.wall(model.element(k).wall).zAxis(1), model.wall(model.element(k).wall).zAxis(2), model.wall(model.element(k).wall).zAxis(3), ...
                    model.element(k).h, model.element(k).b, model.element(k).t, ...
                    model.material(kMat).E, model.material(kMat).G, model.material(kMat).fc, model.material(kMat).mu, model.material(kMat).tau0, ...
                    model.material(kMat).Gc, 1.0, model.material(kMat).mu, model.material(kMat).drift_F, model.material(kMat).drift_S, model.material(kMat).rho);
                
            else
                fprintf(fid, formatString, ...
                    k, model.element(k).nodeI, model.element(k).nodeJ, model.element(k).nodeE, ...
                    model.element(k).xAxis(1), model.element(k).xAxis(2), model.element(k).xAxis(3), ...
                    model.wall(model.element(k).wall).zAxis(1), model.wall(model.element(k).wall).zAxis(2), model.wall(model.element(k).wall).zAxis(3), ...
                    model.element(k).h, model.element(k).b, model.element(k).t, ...
                    model.material(kMat).E, model.material(kMat).G, model.material(kMat).fc, model.material(kMat).mu, model.material(kMat).tau0, ...
                    model.material(kMat).Gc, 1.0, model.material(kMat).mu, model.material(kMat).drift_F, model.material(kMat).drift_S);
            end
            
        else
            % standard implementation
            formatString = 'element Macroelement3d    %6.0i  %6.0i   %6.0i   %6.0i   %6.3f %6.3f %6.3f   %6.3f %6.3f %6.3f  -gable  %6.3f %6.3f %6.3f %6.3e %6.3e %6.3e %6.3f %6.3e %6.3f %6.3f %6.3f %7.5f %7.5f  '; 
            if strcmp(massDistribution, 'Standard')
                formatString = [formatString, ' -density %8.1f '];
            else if strcmp(massDistribution, 'Consistent')
                   formatString = [formatString, ' -density %8.1f -cmass ']; 
                end
            end
            formatString = [formatString, '\n']; 
            
            kMat = model.element(k).mat;
            
            if ~isfield(model.material(kMat),'dropDrift')
                model.material(kMat).dropDrift = dropDrift;
            end
            
            if ignoreDrift
                model.material(kMat).drift_F = -1;
                model.material(kMat).drift_S = -1;
            end
                               
            if strcmp(massDistribution, 'Standard') || strcmp(massDistribution, 'Consistent')
                fprintf(fid, formatString, ...                
                    k, model.element(k).nodeI, model.element(k).nodeJ, model.element(k).nodeE, ...
                    model.element(k).xAxis(1), model.element(k).xAxis(2), model.element(k).xAxis(3), ...
                    model.wall(model.element(k).wall).zAxis(1), model.wall(model.element(k).wall).zAxis(2), model.wall(model.element(k).wall).zAxis(3), ...
                    model.element(k).h, model.element(k).b, model.element(k).t, ...
                    model.material(kMat).E, model.material(kMat).G, model.material(kMat).fc, model.material(kMat).mu, model.material(kMat).tau0, ...
                    model.material(kMat).Gc, 1.0, model.material(kMat).mu, model.material(kMat).drift_F, model.material(kMat).drift_S, model.material(kMat).rho);
                
            else
                fprintf(fid, formatString, ...
                    k, model.element(k).nodeI, model.element(k).nodeJ, model.element(k).nodeE, ...
                    model.element(k).xAxis(1), model.element(k).xAxis(2), model.element(k).xAxis(3), ...
                    model.wall(model.element(k).wall).zAxis(1), model.wall(model.element(k).wall).zAxis(2), model.wall(model.element(k).wall).zAxis(3), ...
                    model.element(k).h, model.element(k).b, model.element(k).t, ...
                    model.material(kMat).E, model.material(kMat).G, model.material(kMat).fc, model.material(kMat).mu, model.material(kMat).tau0, ...
                    model.material(kMat).Gc, 1.0, model.material(kMat).mu, model.material(kMat).drift_F, model.material(kMat).drift_S);
            end
        end
                       
    end
end

fprintf(fid, '#END Macrolements------------------------------------------------------------ \n\n');

%% shells
fprintf(fid, '\n#SHELLS  --------------------------------------------------------- \n\n');
fprintf(fid, '#element ShellMITC4 $eleTag $iNode $jNode $kNode $lNode $secTag \n');
for kEl = 1:length(model.element)
    if ~isempty(model.element(kEl).floor) && strcmp(model.element(kEl).type, 'FloorShell')

        if flexureShells
            ni = model.element(kEl).properties(1)/(2*model.element(kEl).properties(4))-1;
            if ni>0.5 || isinf(ni) || isnan(ni) || ni<0
                warning('WARINING: invalid Poisson''s ratio calculated for shell. A value of ni=0.2 is assumed. %i\n', kEl);
                ni = 0.2;
            end
            fprintf(fid, 'section ElasticMembranePlateSection  %g %9.1fe+06 %9.3f %9.3f \n',kEl, model.element(kEl).properties(1)*1e-6, ni, model.element(kEl).t);
        else
            fprintf(fid, 'section OrthotropicMembraneSection   %g   %9.1fe+06  %9.1fe+06  %9.3f  %9.1fe+06  %9.3f  %9.1f  \n', ...
                kEl, model.element(kEl).properties(1)*1e-6, model.element(kEl).properties(2)*1e-6, model.element(kEl).properties(3), model.element(kEl).properties(4)*1e-6, model.element(kEl).t, 0.0);
        end
        
        fprintf(fid, 'element ShellMITC4    %6.0i  %6.0i   %6.0i   %6.0i  %6.0i  %6.0i \n', ...
                kEl, model.element(kEl).nodeI, model.element(kEl).nodeJ, model.element(kEl).nodeK, model.element(kEl).nodeL, kEl);
  
    end
end
fprintf(fid, '#END Shells ------------------------------------------------------------ \n\n');

%% fixed nodes
fprintf(fid, '#CONSTRAINTS --------------------------------------------------------- \n');
fixedNodes = [];
for k = 1:length(model.constraint.fix)
    if ~isempty(model.constraint.fix(k).node)
        dofs = 6;
        fix = zeros(dofs,1);
        for dof=1:dofs
            if ~isempty(find(model.constraint.fix(k).dof == dof))
                fix(dof) =1;
            end
        end   
        fprintf(fid, 'fix  %6.0i  %3.0i %3.0i %3.0i %3.0i %3.0i %3.0i \n', model.constraint.fix(k).node, fix);
        fixedNodes = [fixedNodes; model.constraint.fix(k).node];
               
    end
end
fprintf(fid, '#END Constraints------------------------------------------------------------ \n\n');

%% wall to wall - floor to wall connections
fprintf(fid, '#WALL TO WALL CONNECTIONS --------------------------------------------------------- \n');
for k=1:length(model.constraint.wallToWall)
    constrainedNode = 0;
    for kConstrained = 1:length(model.constraint.fix)
        if model.constraint.fix(kConstrained).node == model.constraint.wallToWall(k).master || model.constraint.fix(kConstrained).node == model.constraint.wallToWall(k).slave
            constrainedNode = 1;
            break;
        end
    end
        
    % check if a nonrigid link must be set up
    foundConnection = 0;
    index = 0;
    for kConnection = 1:size(wallToWallStrength, 1)
        if wallToWallStrength(kConnection,1)==model.node(model.constraint.wallToWall(k).master).wall && wallToWallStrength(kConnection,2)==model.node(model.constraint.wallToWall(k).slave).wall
            foundConnection = 1;
            index = kConnection;
            break
        end
        
        if wallToWallStrength(kConnection,2)==model.node(model.constraint.wallToWall(k).master).wall && wallToWallStrength(kConnection,1)==model.node(model.constraint.wallToWall(k).slave).wall
            foundConnection = 1;
            index = kConnection;
            break;
        end        
    end
    
    if foundConnection && constrainedNode~=1
        warning('WARNING: no implementation yet provided for nonlinear wall to wall connection. Rigid connection between nodes %i and %i is assumed.', ...
            model.constraint.wallToWall(k).master, model.constraint.wallToWall(k).slave); 
    end

    if constrainedNode~=1
        fprintf(fid, 'equalDOF %6.0i %6.0i  %s \n', model.constraint.wallToWall(k).master, model.constraint.wallToWall(k).slave, wallToWallConnection);
    end
end

fprintf(fid, '\n\n#FLOOR TO WALL CONNECTIONS --------------------------------------------------------- \n');
if isfield(model.constraint, 'floorToWall')
    for k=1:length(model.constraint.floorToWall)
        fprintf(fid, 'equalDOF %6.0i %6.0i  %s\n', model.constraint.floorToWall(k).master, model.constraint.floorToWall(k).slave, floorToWallConnection);
    end
end

fprintf(fid, '#END Connections ------------------------------------------------------ \n\n');

%% rigid beams
fprintf(fid, '#RIGID LINKS ---------------------------------------------------------- \n');
kEl = length(model.element);
if isfield(model.constraint, 'rigidBeam')
    for k = 1:length(model.constraint.rigidBeam)
        if ~isempty(model.constraint.rigidBeam(k).master)
            %fprintf(fid, 'rigidLink beam %6.0i %6.0i \n', model.constraint.rigidBeam(k).master, model.constraint.rigidBeam(k).slave);
            kEl = kEl+1;
            fprintf(fid, 'element elasticBeamColumn %6.0i %6.0i %6.0i 10.0 30e9 10e9 5 5 5 %6.0i\n', kEl,  model.constraint.rigidBeam(k).master, model.constraint.rigidBeam(k).slave, model.node(model.constraint.rigidBeam(k).master).wall);
        end
    end
end
fprintf(fid, '# ----------------\n');
kTransf = length(model.wall);
for k=1:length(model.element)
    if strcmp(model.element(k).type, 'ElasticBeam')
        kWall = model.element(k).wall;
        kTransf = kTransf+1;
        fprintf(fid, 'geomTransf Linear %6.0i %6.3f %6.3f %6.3f -jntOffset %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f  \n', kTransf, model.wall(kWall).zAxis, model.element(k).offsetI, model.element(k).offsetJ );
        
        kEl = kEl+1;
        %fprintf(fid, 'element elasticBeamColumn %6.0i %6.0i %6.0i 10.0 30e9 10e9 5 5 5 %6.0i\n', kEl, model.element(k).nodeI, model.element(k).nodeJ, kTransf);
        
        if model.material(model.element(k).mat).G==0
            model.material(model.element(k).mat).G = 0.3*model.material(model.element(k).mat).E;
        end
        
        fprintf(fid, 'element elasticBeamColumn %6.0i %6.0i %6.0i %6.3e %6.3e %6.3e %6.3e %6.3e %6.3e  %6.0i\n', kEl, model.element(k).nodeI, model.element(k).nodeJ, ...
                                         model.element(k).area, model.material(model.element(k).mat).E, model.material(model.element(k).mat).G, ...
                                         model.element(k).J, model.element(k).J, model.element(k).J,  kTransf);
                                     
        %fprintf(fid, 'rigidLink beam %6.0i %6.0i \n', model.element(k).nodeI, model.element(k).nodeJ);
    end
end
fprintf(fid, '#END Elastic beams---------------------------------------------------- \n\n');

%% nonlinear beams
fprintf(fid, '#NONLINEAR BEAMS ---------------------------------------------------------- \n');
for k=1:length(model.element)
    if strcmp(model.element(k).type, 'NonlinearBeam')
        kWall = model.element(k).wall;
        kTransf = kTransf+1;
        fprintf(fid, 'geomTransf PDelta %6.0i %6.3f %6.3f %6.3f -jntOffset %6.3f %6.3f %6.3f %6.3f %6.3f %6.3f  \n', kTransf, model.wall(kWall).zAxis, model.element(k).offsetI, -model.element(k).offsetJ );
        
        kEl = kEl+1;
        fprintf(fid, 'element elasticBeamColumn %6.0i %6.0i %6.0i %6.3e %6.3e %6.3e %6.3e %6.3e %6.3e  %6.0i\n', kEl, model.element(k).nodeI, model.element(k).nodeJ, ...
                                         model.element(k).area, model.material(model.element(k).mat).E, model.material(model.element(k).mat).G, ...
                                         model.element(k).J, model.element(k).J, model.element(k).J,  kTransf);
        %fprintf(fid, 'rigidLink beam %6.0i %6.0i \n', model.element(k).nodeI, model.element(k).nodeJ);
    end
end
fprintf(fid, '#END Nonlinear beams---------------------------------------------------- \n\n');

%% additional masses
% mass distribution. options 'Tremuri', 'Lumped', 'Consistent', 'Standard'
for k = 1:length(model.node)
    model.node(k).mass         = [0,0,0, 0,0,0];
    model.node(k).massTremuri  = [0,0,0, 0,0,0];
    
    model.node(k).load_x = [0,0,0, 0,0,0];
    model.node(k).load_y = [0,0,0, 0,0,0];
    model.node(k).load_z = [0,0,0, 0,0,0];
end
    
for k = 1:length(model.node)
    if ~isempty(model.node(k).polygon)
        
        kWall = model.node(k).wall;
        xAxis = model.wall(kWall).xAxis;
        yAxis = model.wall(kWall).yAxis;
        
        for kPolygon=1:length(model.node(k).polygon)
            if ~isempty(model.node(k).polygon(kPolygon).area)
                m = model.node(k).polygon(kPolygon).area * model.node(k).polygon(kPolygon).t * model.node(k).polygon(kPolygon).rho;
                baricenter = model.node(k).polygon(kPolygon).blCorner + xAxis*model.node(k).polygon(kPolygon).xDim/2  + yAxis*model.node(k).polygon(kPolygon).yDim/2;
                r =    baricenter - model.node(k).pos;
                
                % true mass
                model.node(k).mass =  model.node(k).mass + [1,1,1, r(2)^2+r(3)^2, r(1)^2+r(3)^2, r(1)^2+r(2)^2]* m; 
                
                % forces for vertical analysis and pushover
                F = m*[1;0;0];
                moment = cross(r,F);     
                
                model.node(k).load_x =  model.node(k).load_x + [F', moment'];
                
                F = m*[0;1;0];
                moment = cross(r,F);
                model.node(k).load_y =  model.node(k).load_y + [F', moment'];
                                
                F = m*[0;0;1];
                moment = cross(r,F);
                model.node(k).load_z =  model.node(k).load_z + [F', moment'];
                
                % tremuri mass distribution
                xAxis = model.wall(model.node(k).wall).xAxis;
                yAxis = model.wall(model.node(k).wall).yAxis;
                zAxis = model.wall(model.node(k).wall).zAxis;
                
                if isempty(find(node2dVec(1,:)==k))
                    model.node(k).massTremuri = model.node(k).massTremuri + [1,1,1, 0,0,0]*m;
                else
                    index = find(node2dVec(1,:)==k,1);
                    dist1 = norm(model.node(k).pos - model.node(node2dVec(2,index)).pos);
                    dist2 = norm(model.node(k).pos - model.node(node2dVec(3,index)).pos);
                    distTot = dist1+dist2;
                    
                    model.node(k).massTremuri = model.node(k).massTremuri + [abs(xAxis')+ abs(yAxis'), 0,0,0]*m;
                    
                    model.node(node2dVec(2,index)).massTremuri = model.node(node2dVec(2,index)).massTremuri + [abs(zAxis'), 0,0,0]*m* dist2/distTot;
                    model.node(node2dVec(3,index)).massTremuri = model.node(node2dVec(3,index)).massTremuri + [abs(zAxis'), 0,0,0]*m* dist1/distTot;      
                end              
            end
        end 
    end
    
    % add added mass if any
    if ~isempty(model.node(k).addedMass)
        m = model.node(k).addedMass;
        r = model.node(k).addedMassEcc;
        
        model.node(k).mass =  model.node(k).mass + [1,1,1, r(2)^2+r(3)^2, r(1)^2+r(3)^2, r(1)^2+r(2)^2]* m;

        % forces for vertical analysis and pushover
        F = m*[1;0;0];
        moment = cross(r,F);
        model.node(k).load_x =  model.node(k).load_x + [F', moment'];
        
        F = m*[0;1;0];
        moment = cross(r,F);
        model.node(k).load_y =  model.node(k).load_y + [F', moment'];
        
        F = m*[0;0;1];
        moment = cross(r,F);
        model.node(k).load_z =  model.node(k).load_z + [F', moment'];
        
        
        % tremuri mass distribution
        xAxis = model.wall(model.node(k).wall).xAxis;
        yAxis = model.wall(model.node(k).wall).yAxis;
        zAxis = model.wall(model.node(k).wall).zAxis;
        
        if isempty(find(node2dVec(1,:)==k))
            model.node(k).massTremuri =  model.node(k).massTremuri + [1,1,1, r(2)^2+r(3)^2, r(1)^2+r(3)^2, r(1)^2+r(2)^2]* m;
        else
            index = find(node2dVec(1,:)==k,1);
            dist1 = norm(model.node(k).pos - model.node(node2dVec(2,index)).pos);
            dist2 = norm(model.node(k).pos - model.node(node2dVec(3,index)).pos);
            distTot = dist1+dist2;
            
            model.node(k).massTremuri = model.node(k).massTremuri + [abs(xAxis')+ abs(yAxis'), 0,0,0]*m;
            
            model.node(node2dVec(2,index)).massTremuri = model.node(node2dVec(2,index)).massTremuri + [abs(zAxis'), 0,0,0]*m* dist2/distTot;
            model.node(node2dVec(3,index)).massTremuri = model.node(node2dVec(3,index)).massTremuri + [abs(zAxis'), 0,0,0]*m* dist1/distTot;
            
        end
    end
end

%add element masses to Tremuri mass and pushover loads
for kEl=1:length(model.element)
    if strcmp(model.element(kEl).type, 'Macroelement3d')
        elementMass = model.element(kEl).b * model.element(kEl).t * model.element(kEl).h *model.material(model.element(kEl).mat).rho;
        

        
        elementWall = model.element(kEl).wall;
        xAxis = model.wall(elementWall).xAxis;
        yAxis = model.wall(elementWall).yAxis;
        zAxis = model.wall(elementWall).zAxis;
        
        if strcmp(massDistribution, 'Lumped') || strcmp(massDistribution, 'Tremuri') || strcmp(massDistribution, 'Standard')
            k = kEl;
            
            totWeight = [1;0;0] *elementMass;
            offsetI = model.node(model.element(k).nodeE).pos - model.element(k).h*0.5*model.element(k).xAxis -  model.node(model.element(k).nodeI).pos;
            offsetJ = model.node(model.element(k).nodeE).pos + model.element(k).h*0.5*model.element(k).xAxis -  model.node(model.element(k).nodeJ).pos;
            momentI = cross(offsetI, totWeight/2);
            momentJ = cross(offsetJ, totWeight/2);
            
            model.node(model.element(k).nodeI).load_x =  model.node(model.element(k).nodeI).load_x + [totWeight'/2, momentI'];
            model.node(model.element(k).nodeJ).load_x =  model.node(model.element(k).nodeJ).load_x + [totWeight'/2, momentJ'];
            
            
            totWeight = [0;1;0] *elementMass;
            momentI = cross(offsetI, totWeight/2);
            momentJ = cross(offsetJ, totWeight/2);
            
            model.node(model.element(k).nodeI).load_y =  model.node(model.element(k).nodeI).load_y + [totWeight'/2, momentI'];
            model.node(model.element(k).nodeJ).load_y =  model.node(model.element(k).nodeJ).load_y + [totWeight'/2, momentJ'];
            
            if ~strcmp(massDistribution, 'Standard')        
                totWeight = [0;0;1] *elementMass;
                momentI = cross(offsetI, totWeight/2);
                momentJ = cross(offsetJ, totWeight/2);
                
                model.node(model.element(k).nodeI).load_z =  model.node(model.element(k).nodeI).load_z + [totWeight'/2, momentI'];
                model.node(model.element(k).nodeJ).load_z =  model.node(model.element(k).nodeJ).load_z + [totWeight'/2, momentJ'];
            end
            
            if strcmp(massDistribution, 'Lumped')        
                model.node(model.element(k).nodeI).mass =  model.node(model.element(k).nodeI).mass + [1,1,1, 0,0,0]* elementMass/2;
                model.node(model.element(k).nodeJ).mass =  model.node(model.element(k).nodeJ).mass + [1,1,1, 0,0,0]* elementMass/2;
            end
            
        end
                
        if isempty(find(node2dVec(1,:)==model.element(kEl).nodeI))
            model.node(model.element(kEl).nodeI).massTremuri = model.node(model.element(kEl).nodeI).massTremuri + [1,1,1, 0,0,0]*elementMass  /2;
        else
            index = find(node2dVec(1,:)==model.element(kEl).nodeI,1);
            dist1 = norm(model.node(model.element(kEl).nodeI).pos - model.node(node2dVec(2,index)).pos);
            dist2 = norm(model.node(model.element(kEl).nodeI).pos - model.node(node2dVec(3,index)).pos);
            distTot = dist1+dist2;
            
            model.node(model.element(kEl).nodeI).massTremuri = model.node(model.element(kEl).nodeI).massTremuri + [abs(xAxis')+ abs(yAxis'), 0,0,0]*elementMass  /2;
            
            model.node(node2dVec(2,index)).massTremuri = model.node(node2dVec(2,index)).massTremuri + [abs(zAxis'), 0,0,0]*elementMass  /2 * dist2/distTot;
            model.node(node2dVec(3,index)).massTremuri = model.node(node2dVec(3,index)).massTremuri + [abs(zAxis'), 0,0,0]*elementMass  /2 * dist1/distTot;
            
        end
        
        if isempty(find(node2dVec(1,:)==model.element(kEl).nodeJ))
            model.node(model.element(kEl).nodeJ).massTremuri = model.node(model.element(kEl).nodeJ).massTremuri + [1,1,1, 0,0,0]*elementMass  /2;
        else
            index = find(node2dVec(1,:)==model.element(kEl).nodeJ,1);
            dist1 = norm(model.node(model.element(kEl).nodeJ).pos - model.node(node2dVec(2,index)).pos);
            dist2 = norm(model.node(model.element(kEl).nodeJ).pos - model.node(node2dVec(3,index)).pos);
            distTot = dist1+dist2;
            
            model.node(model.element(kEl).nodeJ).massTremuri = model.node(model.element(kEl).nodeJ).massTremuri + [abs(xAxis')+ abs(yAxis'), 0,0,0]*elementMass  /2;
            
            model.node(node2dVec(2,index)).massTremuri = model.node(node2dVec(2,index)).massTremuri + [abs(zAxis'), 0,0,0]*elementMass  /2 * dist2/distTot;
            model.node(node2dVec(3,index)).massTremuri = model.node(node2dVec(3,index)).massTremuri + [abs(zAxis'), 0,0,0]*elementMass  /2 * dist1/distTot;
            
        end

    end
end


for kEl=1:length(model.element)
    if strcmp(model.element(kEl).type, 'TriangularMacroelement')
        elementMass = 1/2*model.element(kEl).b * model.element(kEl).t * model.element(kEl).h *model.material(model.element(kEl).mat).rho;

        elementWall = model.element(kEl).wall;
        xAxis = model.wall(elementWall).xAxis;
        yAxis = model.wall(elementWall).yAxis;
        zAxis = model.wall(elementWall).zAxis;
        
        if strcmp(massDistribution, 'Lumped') || strcmp(massDistribution, 'Tremuri') || strcmp(massDistribution, 'Standard')
            k = kEl;
            
            totWeight = [1;0;0] *elementMass;
            offsetI = model.node(model.element(k).nodeE).pos - model.element(k).h*0.5*model.element(k).xAxis -  model.node(model.element(k).nodeI).pos;
            offsetJ = model.node(model.element(k).nodeE).pos + model.element(k).h*0.5*model.element(k).xAxis -  model.node(model.element(k).nodeJ).pos;
            momentI = cross(offsetI, totWeight/2);
            momentJ = cross(offsetJ, totWeight/2);
            
            model.node(model.element(k).nodeI).load_x =  model.node(model.element(k).nodeI).load_x + [totWeight'/2, momentI'];
            model.node(model.element(k).nodeJ).load_x =  model.node(model.element(k).nodeJ).load_x + [totWeight'/2, momentJ'];
            
            
            totWeight = [0;1;0] *elementMass;
            momentI = cross(offsetI, totWeight/2);
            momentJ = cross(offsetJ, totWeight/2);
            
            model.node(model.element(k).nodeI).load_y =  model.node(model.element(k).nodeI).load_y + [totWeight'/2, momentI'];
            model.node(model.element(k).nodeJ).load_y =  model.node(model.element(k).nodeJ).load_y + [totWeight'/2, momentJ'];
            
            if ~strcmp(massDistribution, 'Standard')        
                totWeight = [0;0;1] *elementMass;
                momentI = cross(offsetI, totWeight/2);
                momentJ = cross(offsetJ, totWeight/2);
                
                model.node(model.element(k).nodeI).load_z =  model.node(model.element(k).nodeI).load_z + [totWeight'*0, momentI'];
                model.node(model.element(k).nodeJ).load_z =  model.node(model.element(k).nodeJ).load_z + [totWeight', momentJ'];
            end
            
            if strcmp(massDistribution, 'Lumped')        
                model.node(model.element(k).nodeI).mass =  model.node(model.element(k).nodeI).mass + [1,1,1, 0,0,0]* elementMass/2;
                model.node(model.element(k).nodeJ).mass =  model.node(model.element(k).nodeJ).mass + [1,1,1, 0,0,0]* elementMass/2;
            end
            
        end
                
        if isempty(find(node2dVec(1,:)==model.element(kEl).nodeI))
            model.node(model.element(kEl).nodeI).massTremuri = model.node(model.element(kEl).nodeI).massTremuri + [1,1,1, 0,0,0]*elementMass  /2;
        else
            index = find(node2dVec(1,:)==model.element(kEl).nodeI,1);
            dist1 = norm(model.node(model.element(kEl).nodeI).pos - model.node(node2dVec(2,index)).pos);
            dist2 = norm(model.node(model.element(kEl).nodeI).pos - model.node(node2dVec(3,index)).pos);
            distTot = dist1+dist2;
            
            model.node(model.element(kEl).nodeI).massTremuri = model.node(model.element(kEl).nodeI).massTremuri + [abs(xAxis')+ abs(yAxis'), 0,0,0]*elementMass  /2;
            
            model.node(node2dVec(2,index)).massTremuri = model.node(node2dVec(2,index)).massTremuri + [abs(zAxis'), 0,0,0]*elementMass  /2 * dist2/distTot;
            model.node(node2dVec(3,index)).massTremuri = model.node(node2dVec(3,index)).massTremuri + [abs(zAxis'), 0,0,0]*elementMass  /2 * dist1/distTot;
            
        end
        
        if isempty(find(node2dVec(1,:)==model.element(kEl).nodeJ))
            model.node(model.element(kEl).nodeJ).massTremuri = model.node(model.element(kEl).nodeJ).massTremuri + [1,1,1, 0,0,0]*elementMass  /2;
        else
            index = find(node2dVec(1,:)==model.element(kEl).nodeJ,1);
            dist1 = norm(model.node(model.element(kEl).nodeJ).pos - model.node(node2dVec(2,index)).pos);
            dist2 = norm(model.node(model.element(kEl).nodeJ).pos - model.node(node2dVec(3,index)).pos);
            distTot = dist1+dist2;
            
            model.node(model.element(kEl).nodeJ).massTremuri = model.node(model.element(kEl).nodeJ).massTremuri + [abs(xAxis')+ abs(yAxis'), 0,0,0]*elementMass  /2;
            
            model.node(node2dVec(2,index)).massTremuri = model.node(node2dVec(2,index)).massTremuri + [abs(zAxis'), 0,0,0]*elementMass  /2 * dist2/distTot;
            model.node(node2dVec(3,index)).massTremuri = model.node(node2dVec(3,index)).massTremuri + [abs(zAxis'), 0,0,0]*elementMass  /2 * dist1/distTot;
            
        end

    end
end





% 
% compute total model mass (and eccentricity?) 
totMass    = [0,0,0];
barycenter = [0,0,0]';
for k = 1:length(model.node)    
    if ~isempty(model.node(k).x)
        totMass = totMass + model.node(k).massTremuri(1:3);
        barycenter = barycenter + [model.node(k).x *model.node(k).massTremuri(3);
                                   model.node(k).y *model.node(k).massTremuri(3);
                                   model.node(k).z *model.node(k).massTremuri(3)];
    end
end

barycenter = barycenter ./ totMass;

fprintf('Total mass, x: %.1f\n', totMass(1));
fprintf('Total mass, y: %.1f\n', totMass(2));
fprintf('Total mass, z: %.1f\n\n', totMass(3));

fprintf('Centroid x: %.3f\n', barycenter(1));
fprintf('Centroid y: %.3f\n', barycenter(2));
fprintf('Centroid z: %.3f\n\n', barycenter(3));

%% write masses
fprintf(fid, '#NODAL MASSES ------------------------------------------------------------ \n');
fprintf(fid, '#       tag         X         Y         Z        RX        RY        RZ \n');
for k = 1:length(model.node)
    formatString = 'mass %6.0i %9.1f %9.1f %9.1f %9.1f %9.1f %9.1f \n';
    if strcmp(massDistribution, 'Tremuri')
        if norm(model.node(k).massTremuri) > 0  && ~isempty(model.node(k).x)
            fprintf(fid, 'mass %6.0i %9.1f %9.1f %9.1f %9.1f %9.1f %9.1f \n',k, ...
                model.node(k).massTremuri(1), model.node(k).massTremuri(2), model.node(k).massTremuri(3), ...
                model.node(k).massTremuri(4), model.node(k).massTremuri(5), model.node(k).massTremuri(6));
        end
    else
        if norm(model.node(k).mass) > 0  && ~isempty(model.node(k).x)
            fprintf(fid, 'mass %6.0i %9.1f %9.1f %9.1f %9.1f %9.1f %9.1f \n',k, ...
                model.node(k).mass(1), model.node(k).mass(2), model.node(k).mass(3), ...
                model.node(k).mass(4), model.node(k).mass(5), model.node(k).mass(6));
        end
        
    end
end
fprintf(fid, '#END MASSES ------------------------------------------------------------ \n');

%% close model file
fprintf(fid, 'puts "Model defined." \n\n\n');
fclose(fid);
filesToRun(nFiles).filename = outputFile;



%% analysis files
for kAnalysis = 1:length(model.analysis)
    nFiles = nFiles+1;
    outputFile = [path, '/', projectName, '_',num2str(kAnalysis),'_', model.analysis(kAnalysis).type,'.tcl'];
    
    fid = fopen(outputFile, 'w');
    
 
    if strcmp(model.analysis(kAnalysis).type, 'Modal')
        %% modal analysis
        
        outDir = [pathOut, '/', model.analysis(kAnalysis).type, num2str(kAnalysis)];
        if ~exist(outDir, 'dir')
              mkdir(outDir);
        end

        fprintf(fid, '# -------------------------------------------- \n');  
        fprintf(fid, '# Modal Analysis ----------------------------- \n');  
        fprintf(fid, '# -------------------------------------------- \n\n');   
        
        
        fprintf(fid, 'set numModes %i; \n\n', model.analysis(kAnalysis).nModes);
        
        if kAnalysis<2 || 1==1
            fprintf(fid, 'system BandGeneral \n');
            fprintf(fid, 'numberer RCM \n');
            fprintf(fid, 'constraints Transformation \n\n');
        end
        
        fprintf(fid, '# set recorders for modal analysis \n');      
%         fprintf(fid, 'for { set k 1 } { $k <= $numModes } { incr k } { \n');
%         fprintf(fid, '    recorder Node -file [format "mode%%i.out" $k] -nodeRange 1 %i -dof 1 2 3 4 5 6 "eigen $k" \n', length(model.node));
%         fprintf(fid, '}  \n\n');
        
        for kMode=1:model.analysis(kAnalysis).nModes
            fprintf(fid, 'recorder Node -file "%s" -nodeRange 1 %i -dof 1 2 3 4 5 6 "eigen %i" \n',  [outDir, '/', projectName, '_mode',num2str(kMode),'.out'], length(model.node), kMode);
        end
        fprintf(fid, '\n\n');

        fprintf(fid, '# eigenvalues analysis \n');
        fprintf(fid, 'set lambda [eigen  $numModes]; \n\n');
        
        fprintf(fid, 'set omega {} \n');
        fprintf(fid, 'set f {} \n');
        fprintf(fid, 'set T {} \n\n');
        
        fprintf(fid, 'foreach lam $lambda { \n');
        fprintf(fid, '  lappend omega [expr sqrt($lam)] \n');
        fprintf(fid, '  lappend f [expr sqrt($lam)/(2.*$pi)] \n');
        fprintf(fid, '  lappend T [expr (2.*$pi)/sqrt($lam)] \n');
        fprintf(fid, '} \n');
        
        fprintf(fid, '# write output \n');
        fprintf(fid, 'set period "%s" \n', [outDir, '/', projectName, '_periods.out']);
        fprintf(fid, 'set Periods [open $period "w"] \n');
        fprintf(fid, 'set ind 0; \n');
        fprintf(fid, 'foreach tt $T {  \n');
        fprintf(fid, '   set toPlot    [lindex $f  $ind]		 \n');
        fprintf(fid, '   puts $Periods " $tt $toPlot" \n');
        fprintf(fid, '   set ind [expr $ind+1];	 \n');
        fprintf(fid, '	 puts [expr $tt]  \n');
        fprintf(fid, '}  \n');
        fprintf(fid, 'close $Periods  \n\n');
        
        fprintf(fid, 'record \n\n');
        
        fprintf(fid, 'puts "Eigenvalues analysis completed." \n');
        fprintf(fid, 'remove recorders; \n\n');
        
        fclose(fid);
        filesToRun(nFiles).filename = outputFile;
        
        for kFile=1:model.analysis(kAnalysis).nModes
            filesToRun(nFiles).outputFiles(kFile).filename = [outDir, '/', projectName, '_mode',num2str(kFile),'.out']; 
        end
        %kFile = kFile+1; filesToRun(nFiles).outputFiles(kFile).filename = [outDir, '/', projectName, '_periods.out']';
         kFile = kFile+1; filesToRun(nFiles).outputFiles(kFile).filename = strcat(outDir, '/', projectName, '_periods.out');
    else
        if strcmp(model.analysis(kAnalysis).type, 'SelfWeight')
            %% vertical load analysis
            outDir = pathOut;            
            accVec = model.analysis(kAnalysis).accVec;
            
            fprintf(fid, '# -------------------------------------------- \n');
            fprintf(fid, '# Self Weight analysis------------------------ \n');
            fprintf(fid, '# -------------------------------------------- \n\n');
            
            fprintf(fid, '# set recorders \n');
            fprintf(fid, 'recorder Node -file "%s"  -time -nodeRange 1 %i -dof 1 2 3 4 5 6 disp\n',        [outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allDispl.out'], length(model.node));
            fprintf(fid, 'recorder Node -file "%s"  -time -nodeRange 1 %i -dof 1 2 3 4 5 6 reaction \n\n', [outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allForce.out'], length(model.node));
            
            fprintf(fid, 'recorder Element -file "%s"  -time -eleRange 1 %i localForce \n', [outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allElementForce.out'], maxMacroelement);
            fprintf(fid, 'recorder Element -file "%s"  -time -eleRange 1 %i drift \n', [outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allElementDrift.out'], maxMacroelement);
            fprintf(fid, 'recorder Element -file "%s"  -time -eleRange 1 %i shear state \n\n', [outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allElementShearDamage.out'], maxMacroelement);
                    
            
            fprintf(fid, '# Define constant axial load\n');
            fprintf(fid, '#NODAL LOADS------------------------------------------------------------ \n');
            fprintf(fid, 'pattern Plain %i "Linear" {\n', kAnalysis);
            
            totalLoad = [0,0,0,0,0,0];
            
            for k=1:length(model.node)
                if ~isempty(model.node(k).x)
                    if norm(model.node(k).load_z)>0
                        nodeLoad = accVec(1)*model.node(k).load_x + accVec(2)*model.node(k).load_y + accVec(3)*model.node(k).load_z;
                        totalLoad = totalLoad + nodeLoad;
                        fprintf(fid, '    load %6.0i %9.3fe3 %9.3fe3 %9.3fe3 %9.3fe3 %9.3fe3 %9.3fe3 \n',k, nodeLoad * 1e-3);
                    end
                end
            end
            
            for kEl=1:length(model.element)
                if strcmp(model.element(kEl).type, 'Macroelement3d')        
                    if strcmp(massDistribution, 'Standard') || strcmp(massDistribution, 'Consistent')
                        fprintf(fid, '    eleLoad -ele %i -type -selfWeight %6.3f %6.3f %6.3f \n', kEl, accVec);
                    end  
                end
            end
            fprintf(fid, '}\n');
            fprintf(fid, '#END LOADS ------------------------------------------------------------ \n\n');
            
            fprintf(fid, '#TOTAL NODAL LOADS (excluding element loads) : %.3fe+3  %.3fe+3  %.3fe+3, %.3fe+3 %.3fe+3 %.3fe+3\n\n', totalLoad*1e-3);
            
            
            fprintf(fid, '# Define analysis parameters\n');
            fprintf(fid, 'wipeAnalysis\n');
            fprintf(fid, 'system BandGeneral;  \n');
            fprintf(fid, 'numberer RCM \n');
            fprintf(fid, 'constraints Transformation \n\n');

	        fprintf(fid, 'integrator LoadControl 1 %i \n', model.analysis(kAnalysis).nSteps);
	        fprintf(fid, 'test NormUnbalance %.2e %i 1\n\n', model.analysis(kAnalysis).tol, model.analysis(kAnalysis).maxStep);
	        fprintf(fid, 'algorithm Newton\n');
	        fprintf(fid, 'analysis Static\n');
       
            fprintf(fid, 'analyze 1 \n\n');
                                              
            fprintf(fid, '#set self weight as constant load and reset the time to 0\n');
            fprintf(fid, 'loadConst -time 0.0 \n\n');
            
            fprintf(fid, 'puts "Self Weight analysis completed." \n');
            fprintf(fid, 'remove recorders; \n\n');   
            
            fclose(fid);
            filesToRun(nFiles).filename = outputFile;
        
            
            filesToRun(nFiles).outputFiles(1).filename = strcat(outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allDispl.out');
            filesToRun(nFiles).outputFiles(2).filename = strcat(outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allForce.out');
        else
            
            if strcmp(model.analysis(kAnalysis).type, 'PushoverRectangular')
                %% rectangular pushover analysis
                outDir = pathOut;
                direction = model.analysis(kAnalysis).DOF;
                
                fprintf(fid, '# -------------------------------------------- \n');
                fprintf(fid, '# Pushover, rectangular force pattern -------- \n');
                fprintf(fid, '# -------------------------------------------- \n\n');
                
                fprintf(fid, '# set recorders \n');
                fprintf(fid, 'recorder Node -file "%s"  -time -nodeRange 1 %i -dof 1 2 3 4 5 6 disp\n',        [outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allDispl.out'], length(model.node));
                fprintf(fid, 'recorder Node -file "%s"  -time -nodeRange 1 %i -dof 1 2 3 4 5 6 reaction \n\n', [outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allForce.out'], length(model.node));
                
                fprintf(fid, 'recorder Element -file "%s"  -time -eleRange 1 %i localForce \n', [outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allElementForce.out'], maxMacroelement);
                fprintf(fid, 'recorder Element -file "%s"  -time -eleRange 1 %i drift \n', [outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allElementDrift.out'], maxMacroelement);
                fprintf(fid, 'recorder Element -file "%s"  -time -eleRange 1 %i shear state \n\n', [outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allElementShearDamage.out'], maxMacroelement);
                
                
                fprintf(fid, '# Define lateral force pattern \n');
                fprintf(fid, '#NODAL LOADS------------------------------------------------------------ \n');
                fprintf(fid, 'pattern Plain %i "Linear" {\n', kAnalysis);
                
                for k=1:length(model.node)
                    if ~isempty(model.node(k).x)
                       % if not(strcmp(massDistribution, 'Tremuri') && ~isempty(find(fixedNodes==k)))
                       
                       if strcmp(pushoverPattern, 'Tremuri')
                       
                           if isempty(find(fixedNodes==k))
                               if direction=='ux'
                                   if model.node(k).massTremuri(1)>0.1
                                       fprintf(fid, '    load %6.0i %9.3fe3 %9.3fe3 %9.3fe3 %9.3fe3 %9.3fe3 %9.3fe3 \n',k, [1,0,0, 0,0,0]*model.node(k).massTremuri(1) *9.81 * 1e-3);
                                   end
                               else
                                   if model.node(k).massTremuri(2)>0.1
                                       fprintf(fid, '    load %6.0i %9.3fe3 %9.3fe3 %9.3fe3 %9.3fe3 %9.3fe3 %9.3fe3 \n',k, [0,1,0, 0,0,0]*model.node(k).massTremuri(2) *9.81 * 1e-3);
                                   end
                               end
                           end
                       else
                           if isempty(find(fixedNodes==k))
                               if direction=='ux'
                                   if norm(model.node(k).load_x)>0
                                       fprintf(fid, '    load %6.0i %9.3fe3 %9.3fe3 %9.3fe3 %9.3fe3 %9.3fe3 %9.3fe3 \n',k, model.node(k).load_x *9.81 * 1e-3);
                                   end
                               else
                                   if norm(model.node(k).load_y)>0
                                       fprintf(fid, '    load %6.0i %9.3fe3 %9.3fe3 %9.3fe3 %9.3fe3 %9.3fe3 %9.3fe3 \n',k, model.node(k).load_y *9.81 * 1e-3);
                                   end
                               end
                           end
                       end
                           
                    end
                end
                
                for kEl=1:length(model.element)
                    if strcmp(model.element(kEl).type, 'Macroelement3d')
                        if strcmp(massDistribution, 'Consistent')
                            if direction=='ux'
                                fprintf(fid, '    eleLoad -ele %i -type -selfWeight %6.3f %6.3f %6.3f \n', kEl, [9.81 0 0]);
                            else
                                fprintf(fid, '    eleLoad -ele %i -type -selfWeight %6.3f %6.3f %6.3f \n', kEl, [0 9.81 0]);
                            end
                        end
                    end
                end
                    
                fprintf(fid, '}\n');
                fprintf(fid, '#END LOADS ------------------------------------------------------------ \n\n');
                fprintf(fid, '#Note: The sum of horizontal forces is equal to the weight of the building.\n');
                fprintf(fid, '#The time variable of the analysis is therefore directly the base shear ratio H/W \n\n\n');
                
                fprintf(fid, '# Define analysis parameters\n');
                fprintf(fid, 'set controlled_node   %i\n', model.analysis(kAnalysis).controlNode);
                if  model.analysis(kAnalysis).DOF=='ux'
                    fprintf(fid, 'set controlled_dof    1\n\n');
                else
                    fprintf(fid, 'set controlled_dof    2\n\n');
                end
                
                fprintf(fid, 'set incr %f\n', model.analysis(kAnalysis).maxDisp / model.analysis(kAnalysis).nSteps);                
                fprintf(fid, 'set maxDispl  %f\n\n', model.analysis(kAnalysis).maxDisp);                
                fprintf(fid, 'set substepIfNotConverged  1.\n\n');
                
                fprintf(fid, 'set currentDisp [nodeDisp $controlled_node $controlled_dof]\n\n');
                fprintf(fid, 'set nSteps [expr int(abs(($maxDispl-$currentDisp)/$incr))]\n\n');

                fprintf(fid, 'constraints Plain\n');
                fprintf(fid, 'numberer RCM \n');
                fprintf(fid, 'system BandGeneral; \n');
                %fprintf(fid, 'system SparseGEN; \n');
                fprintf(fid, 'analysis Static\n\n');

                fprintf(fid, 'record;\n\n');

                fprintf(fid, '#wipeAnalysis\n');
                fprintf(fid, 'while {$nSteps>=1} {\n');
                fprintf(fid, '    set nSteps [expr int(abs(($maxDispl-$currentDisp)/$incr))]\n');
                fprintf(fid, '    if ($nSteps<1) {\n');
                fprintf(fid, '       break;\n');
                fprintf(fid, '    }\n');
                fprintf(fid, '    test NormUnbalance %.2e %i %i\n', model.analysis(kAnalysis).tol*totMass(1)*9.81,35,2);
                fprintf(fid, '    algorithm Newton \n');
                fprintf(fid, '    integrator    DisplacementControl     $controlled_node      $controlled_dof     $incr\n');
                fprintf(fid, '    set ok [analyze $nSteps]\n\n');
	
                fprintf(fid, '    if ($ok!=0) {\n');
                fprintf(fid, '        test NormUnbalance %.2e %i %i\n', model.analysis(kAnalysis).tol*totMass(1)*9.81, model.analysis(kAnalysis).maxStep, 5);
                fprintf(fid, '        algorithm Newton -initial\n');
                fprintf(fid, '        integrator    DisplacementControl     $controlled_node      $controlled_dof     [expr $incr/$substepIfNotConverged] \n');
                fprintf(fid, '        set ok [analyze [expr int($substepIfNotConverged)]]\n');
                fprintf(fid, '    }\n');
                fprintf(fid, '    set currentDisp [nodeDisp $controlled_node $controlled_dof]\n');
                fprintf(fid, '    puts [format "Continues from displacement %%.2f mm" [expr $currentDisp*1000.]]; \n\n');

                fprintf(fid, '}\n\n');

                fprintf(fid, 'remove loadPattern 3\n\n');

                fprintf(fid, 'puts "Rectangular pushover direction ux completed." \n\n');
                fprintf(fid, 'remove recorders; \n\n');
                
                fclose(fid);
                filesToRun(nFiles).filename = outputFile;
                
                
                filesToRun(nFiles).outputFiles(1).filename = strcat(outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allDispl.out');
                filesToRun(nFiles).outputFiles(2).filename = strcat(outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allForce.out');
            else
                if strcmp(model.analysis(kAnalysis).type, 'Dynamic')
                    %% dynamic analysis
                    outDir = pathOut;
                    direction = model.analysis(kAnalysis).DOF;
                    if pathAcc(end)~='/' ||  pathAcc(end)~='\'
                        pathAcc = [pathAcc, '/'];
                    end
                    pathAcc = strrep(pathAcc, '\', '/');
                    
                    groundMotionFullPath = [pathAcc, model.analysis(kAnalysis).groundMotion];
                    
                    
%                     % write ground motion
%                     if ~exist([path,'/groundMotion'], 'dir')
%                         mkdir([path,'/groundMotion']);
%                     end
%                     groundMotionFullPath = [path,'/groundMotion/dynamicInput_analysis',num2str(kAnalysis),'.txt']
%                     fid_TH = fopen(groundMotionFullPath, 'w');
%                     for kTime = 1:length(model.analysis(kAnalysis).scaledGroundMotion)
%                         fprintf(fid_TH, '%f\n',model.analysis(kAnalysis).scaledGroundMotion(kTime));
%                     end
%                     fclose(fid_TH);
                    
                                        
                    fprintf(fid, '# -------------------------------------------------------------------------------------------- \n');
                    fprintf(fid, '# Dynamic analysis, direction %s \n', direction);
                    fprintf(fid, '# Ground motion: %s  \n', groundMotionFullPath);
                    fprintf(fid, '# Duration: %.2f s\n', length(model.analysis(kAnalysis).scaledGroundMotion)*model.analysis(kAnalysis).dt);
                    fprintf(fid, '# Scale factor: %.4f  \n', model.analysis(kAnalysis).scaleFactor);
                    fprintf(fid, '# PGA: %.3f g  \n', model.analysis(kAnalysis).PGA/9.81);
                    fprintf(fid, '# -------------------------------------------------------------------------------------------- \n\n');
                    
                    fprintf(fid, '# set recorders \n');
                    fprintf(fid, 'recorder Node -file "%s"  -time -nodeRange 1 %i -dof 1 2 3 4 5 6 disp\n',        [outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allDispl.out'], length(model.node));
                    fprintf(fid, 'recorder Node -file "%s"  -time -nodeRange 1 %i -dof 1 2 3 4 5 6 reaction \n\n', [outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allForce.out'], length(model.node));
                    
                    fprintf(fid, 'recorder Element -file "%s"  -time -eleRange 1 %i localForce \n', [outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allElementForce.out'], maxMacroelement);
                    fprintf(fid, 'recorder Element -file "%s"  -time -eleRange 1 %i drift \n', [outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allElementDrift.out'], maxMacroelement);
                    fprintf(fid, 'recorder Element -file "%s"  -time -eleRange 1 %i shear state \n\n', [outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allElementShearDamage.out'], maxMacroelement);

                    
                    fprintf(fid, '# Define dynamic excitation\n');
                    fprintf(fid, '# ----------------------------------------------\n');
                    fprintf(fid, 'set dt_GM  %f;\n', model.analysis(kAnalysis).dt);
                    fprintf(fid, 'set currentTime -%f\n', model.analysis(kAnalysis).dt); 
                    fprintf(fid, 'set currentTime 0.0;\n');  
                    fprintf(fid, 'loadConst -time $currentTime\n\n');  
                    
                    fprintf(fid, 'set groundMotionPath "%s"; \n',    groundMotionFullPath); 
                    if  model.analysis(kAnalysis).DOF=='ux'
                        fprintf(fid, 'set direction    1 \n\n');
                    else
                        fprintf(fid, 'set direction    2 \n\n');
                    end
                    fprintf(fid, 'timeSeries Path %i  -dt $dt_GM  -filePath $groundMotionPath  -factor %f\n', kAnalysis, model.analysis(kAnalysis).scaleFactor);                    
                    fprintf(fid, '#                           $patternTag $dir -accel $tsTag <-vel0 $vel0> <-fact $cFactor>\n');
                    fprintf(fid, 'pattern UniformExcitation   %i    $direction   -accel %i \n\n\n', kAnalysis, kAnalysis);
                    
                    fprintf(fid, '# Define damping model\n'); 
                    fprintf(fid, '# ----------------------------------------------\n');
                    fprintf(fid, 'set betaKinitial    1.0;\n');
                    fprintf(fid, 'set betaKcurrent    0.0;\n');
                    fprintf(fid, 'set betaKcommitted  0.0;\n\n');
                    if csi<0
                        fprintf(fid, '# User defined. Alpha (mass proportional) %f, beta (initial stiffness proprotional) %f\n', model.analysis(kAnalysis).Rayleigh);
                        fprintf(fid, 'rayleigh     %f      [expr $betaKcurrent* %f]     [expr $betaKinitial* %f]    [expr $betaKcommitted* %f];\n\n\n',model.analysis(kAnalysis).Rayleigh(1), ...
                                model.analysis(kAnalysis).Rayleigh(2), model.analysis(kAnalysis).Rayleigh(2), model.analysis(kAnalysis).Rayleigh(2)); 
                    else
                        fprintf(fid, '# Rayleigh damping, %f%% on the first two frequencies\n', csi*100);
                        fprintf(fid, 'set csi  %f;\n', csi);
                        fprintf(fid, 'set pi  %f;\n', pi);
                        fprintf(fid, 'set f1 [expr [lindex $f 0] ];\n');
                        fprintf(fid, 'set f2 [expr [lindex $f 1] ];\n\n');
                        
                        fprintf(fid, 'set beta   [expr 2.0*$csi / (2.*$pi*$f1 + 2.*$pi*$f2)] ;\n');
                        fprintf(fid, 'set alpha  [expr $beta*(2.*$pi*$f1)*(2.*$pi*$f2)] ;\n\n');
                       
                        fprintf(fid, 'puts [format "Rayleigh damping coeffcients, alpha %%f, beta %%f" $alpha $beta]; \n\n')
                        fprintf(fid, 'rayleigh     $alpha    [expr $betaKinitial*$beta]     [expr $betaKcurrent*$beta]    [expr $betaKcommitted*$beta];\n\n\n');
                    end
                    
                    fprintf(fid, '# Create the analysis\n');
                    fprintf(fid, '# ----------------------------------------------\n');
                    fprintf(fid, '#wipeAnalysis\n');
                    fprintf(fid, 'constraints Transformation\n');
                    fprintf(fid, 'numberer RCM \n');
                    fprintf(fid, 'system SparseGEN; \n');
                    fprintf(fid, 'integrator Newmark 0.5 0.25 \n');
                    fprintf(fid, 'analysis Transient\n\n');
                    
                    fprintf(fid, 'set maxTime  %f\n', model.analysis(kAnalysis).nSteps*model.analysis(kAnalysis).dt);
                    fprintf(fid, 'set subd %f;\n', model.analysis(kAnalysis).subd);
                    fprintf(fid, 'set incr %f;\n', model.analysis(kAnalysis).dt/model.analysis(kAnalysis).subd);
                    fprintf(fid, 'set substepIfNotConverged  1.\n\n');
                    
                    fprintf(fid, 'while {$currentTime<$maxTime} {\n');
                    fprintf(fid, '    set nSteps [expr int(abs($maxTime-$currentTime)/$incr)]\n');
                    fprintf(fid, '    if ($nSteps<1) {\n');
                    fprintf(fid, '       break;\n');
                    fprintf(fid, '    }\n');
                    fprintf(fid, '    test NormUnbalance %.2e %i %i\n', model.analysis(kAnalysis).tol*totMass(1)*9.81,35,2);
                    fprintf(fid, '    algorithm Newton \n\n');
                    
                    fprintf(fid, '    set ok  [analyze $nSteps  $incr]\n\n');
                    
                    fprintf(fid, '    if ($ok!=0) {\n');
                    fprintf(fid, '        test NormUnbalance %.2e %i %i\n', model.analysis(kAnalysis).tol*totMass(1)*9.81, model.analysis(kAnalysis).maxStep, 5);
                    fprintf(fid, '        algorithm Newton -initial\n');
                    fprintf(fid, '        set ok  [analyze [expr int($substepIfNotConverged)]  [expr $incr/$substepIfNotConverged]]\n\n');
                    fprintf(fid, '    }\n');
                    fprintf(fid, '    set currentTime [getTime]\n');
                    fprintf(fid, '    puts [format "Continues from time %%.3f s" $currentTime]; \n\n');
                    
                    fprintf(fid, '}\n\n');
                    
                    fprintf(fid, 'after 5000\n\n');
                    
                    
                    fprintf(fid, 'remove loadPattern %i\n\n', kAnalysis);
                    
                    if freeVibrationTime>0
                        fprintf(fid, 'puts "Adding %.3f s of free vibrations..."\n\n', freeVibrationTime);
                        fprintf(fid, 'pattern UniformExcitation   %i    $direction   -accel %i -fact 0.0 \n', kAnalysis, kAnalysis);
                        
                        fprintf(fid, 'set maxTime  %f\n', model.analysis(kAnalysis).nSteps*model.analysis(kAnalysis).dt + freeVibrationTime);
                        fprintf(fid, 'system SparseGEN; \n');
                        
                        fprintf(fid, 'while {$currentTime<$maxTime} {\n');
                        fprintf(fid, '    set nSteps [expr int(abs($maxTime-$currentTime)/$incr)]\n');
                        fprintf(fid, '    if ($nSteps<1) {\n');
                        fprintf(fid, '       break;\n');
                        fprintf(fid, '    }\n');
                        fprintf(fid, '    test NormUnbalance %.2e %i %i\n', model.analysis(kAnalysis).tol*totMass(1)*9.81,35,2);
                        fprintf(fid, '    algorithm Newton \n\n');
                        
                        fprintf(fid, '    set ok  [analyze $nSteps  $incr]\n\n');
                        
                        fprintf(fid, '    if ($ok!=0) {\n');
                        fprintf(fid, '        test NormUnbalance %.2e %i %i\n', model.analysis(kAnalysis).tol*totMass(1)*9.81, model.analysis(kAnalysis).maxStep, 5);
                        fprintf(fid, '        algorithm Newton -initial\n');
                        fprintf(fid, '        set ok  [analyze [expr int($substepIfNotConverged)]  [expr $incr/$substepIfNotConverged]]\n\n');
                        fprintf(fid, '    }\n');
                        fprintf(fid, '    set currentTime [getTime]\n');
                        fprintf(fid, '    puts [format "Continues from time %%.3f s" $currentTime]; \n\n');
                        
                        fprintf(fid, '}\n\n');
                        
                        fprintf(fid, 'after 5000\n\n');
   
                    end
                    

                    fprintf(fid, 'puts "Dynamic analysis completed. (%s, scale factor %f, PGA %f, direction %s) " \n\n', model.analysis(kAnalysis).groundMotion, ...
                             model.analysis(kAnalysis).scaleFactor, model.analysis(kAnalysis).PGA, direction);
                    fprintf(fid, 'remove recorders; \n\n');
                    
                    fprintf(fid, 'after 5000\n\n');
                    
                    
                    fclose(fid);
                    filesToRun(nFiles).filename = outputFile;
                    
                    
                    filesToRun(nFiles).outputFiles(1).filename = strcat(outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allDispl.out');
                    filesToRun(nFiles).outputFiles(2).filename = strcat(outDir, '/analysis', num2str(kAnalysis),'_', model.analysis(kAnalysis).type ,'_allForce.out');
                end
                
                
            end
        end
        
    end
    
    
end

%% write batch to run
    nFiles = nFiles+1;
    outputFile = [path, '/', projectName, '_batch.tcl'];
    
    fid = fopen(outputFile, 'w');
    
    for kFile=1:length(filesToRun) 
        if ~isempty(filesToRun(kFile).filename)          
            if kFile==1
                fprintf(fid, '#load Model \n');
            else
                fprintf(fid, '#execute analysis: %s \n', model.analysis(kFile-1).type);
            end
            fprintf(fid, 'source %s;\n\n', filesToRun(kFile).filename);
        end
    end
    
    
    fprintf(fid, 'puts "---------------------------------------------------------------" \n');
    fprintf(fid, 'puts "All analyses completed-----------------------------------------" \n');
    fprintf(fid, 'puts "---------------------------------------------------------------" \n');
    
    fprintf(fid, 'wipe \n');
    fprintf(fid, 'exit \n');
       
    fclose(fid);
    filesToRun(nFiles).filename = outputFile;

    
    fclose all;
end

