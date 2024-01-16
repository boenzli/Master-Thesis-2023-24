function result = readAnalysis(model, path, varargin)

p = inputParser;

addRequired(p,'model');
addRequired(p,'path');
addParameter(p,'Displacements', 0, @isnumeric)
addParameter(p,'Forces', 0, @isnumeric)
addParameter(p,'Modal', 0, @isnumeric)
addParameter(p,'ElementOutputs', 0, @isnumeric)
addParameter(p,'DampingForces', 0, @isnumeric)


parse(p,model,path,varargin{:});

displFlag  = p.Results.Displacements;
forcesFlag = p.Results.Forces;
modalFlag = p.Results.Modal;
elementFlag = p.Results.ElementOutputs;
dampingFlag = p.Results.DampingForces;

if ~displFlag && ~forcesFlag && ~elementFlag && ~modalFlag
    displFlag=1;
    forcesFlag=1;
    elementFlag=1;
end

if modalFlag
    displFlag=1;
    forcesFlag=0;
    elementFlag=0;
    
    formatSpec = '';
    startFrom = 1;
else
    formatSpec = '%f';
    startFrom = 2;
end


for kNode=1:length(model.node)
    if ~isempty(model.node(kNode).x)
        formatSpec = [formatSpec, '%f%f%f%f%f%f'];
    end
end
formatSpec = [formatSpec, '%[^\n\r]'];

delimiter = ' ';

if displFlag
    if ~modalFlag
        filename = [path, 'allDispl.out'];
    else
        filename = path;
    end
    fileID = fopen(filename,'r');
    
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string',  'ReturnOnError', false);
    fclose(fileID);
    
    result.time = dataArray{:, 1};
    
    readNode = 0;
    for kNode=1:length(model.node)
        if ~isempty(model.node(kNode).x)
            readNode = readNode +1;
            
            result.node(kNode).u = dataArray{:, startFrom+0+(readNode-1)*6};
            result.node(kNode).v = dataArray{:, startFrom+1+(readNode-1)*6};
            result.node(kNode).w = dataArray{:, startFrom+2+(readNode-1)*6};
            result.node(kNode).rotx = dataArray{:, startFrom+3+(readNode-1)*6};
            result.node(kNode).roty = dataArray{:, startFrom+4+(readNode-1)*6};
            result.node(kNode).rotz = dataArray{:, startFrom+5+(readNode-1)*6};
        end
    end
    
end


if forcesFlag   
    filename = [path, 'allForce.out'];
    fileID = fopen(filename,'r');
    
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string',  'ReturnOnError', false);
    fclose(fileID);
    
    result.time = dataArray{:, 1};
    
    readNode = 0;
    for kNode=1:length(model.node)
        if ~isempty(model.node(kNode).x)
            readNode = readNode +1;
            
            result.node(kNode).Fx = dataArray{:, startFrom+0+(readNode-1)*6};
            result.node(kNode).Fy = dataArray{:, startFrom+1+(readNode-1)*6};
            result.node(kNode).Fz = dataArray{:, startFrom+2+(readNode-1)*6};
            result.node(kNode).Mx = dataArray{:, startFrom+3+(readNode-1)*6};
            result.node(kNode).My = dataArray{:, startFrom+4+(readNode-1)*6};
            result.node(kNode).Mz = dataArray{:, startFrom+5+(readNode-1)*6};
        end
    end   
    
    
    if dampingFlag
        filename = [path, 'allDampingForce.out'];
        fileID = fopen(filename,'r');
        
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string',  'ReturnOnError', false);
        fclose(fileID);
                
        readNode = 0;
        for kNode=1:length(model.node)
            if ~isempty(model.node(kNode).x)
                readNode = readNode +1;
                
                result.node(kNode).Fx_damping = dataArray{:, startFrom+0+(readNode-1)*6};
                result.node(kNode).Fy_damping = dataArray{:, startFrom+1+(readNode-1)*6};
                result.node(kNode).Fz_damping = dataArray{:, startFrom+2+(readNode-1)*6};
                result.node(kNode).Mx_damping = dataArray{:, startFrom+3+(readNode-1)*6};
                result.node(kNode).My_damping = dataArray{:, startFrom+4+(readNode-1)*6};
                result.node(kNode).Mz_damping = dataArray{:, startFrom+5+(readNode-1)*6};
            end
        end
    end
    
    
    
end


if elementFlag
    startFrom = 2;
    % read all element outputs
    % alpha values
    formatSpec = '%f';
    readElement = [];
    for kEl=1:length(model.element)
        if strcmp(model.element(kEl).type, 'Macroelement3d') || strcmp(model.element(kEl).type, 'TriangularMacroelement') 
            formatSpec = [formatSpec, '%f'];
            readElement = [readElement; kEl];
        end
    end
    formatSpec = [formatSpec, '%[^\n\r]']; 
    delimiter = ' ';
    
    filename = [path, 'allElementShearDamage.out'];
    fileID = fopen(filename,'r');
    
    if fileID>=0
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string',  'ReturnOnError', false);
        fclose(fileID);
        
        for k=1:length(readElement)
            kEl = readElement(k);
            
            result.element(kEl).alpha = dataArray{:, startFrom+0+(k-1)*1};
        end
    else
        for k=1:length(readElement)
            kEl = readElement(k);
            
            result.element(kEl).alpha = NaN;
        end
    end
    
    
    % element drifts
    formatSpec = '%f';
    for kEl=1:length(model.element)
        if strcmp(model.element(kEl).type, 'Macroelement3d') || strcmp(model.element(kEl).type, 'TriangularMacroelement') 
            formatSpec = [formatSpec, '%f%f'];
        end
    end
    formatSpec = [formatSpec, '%[^\n\r]']; 
    delimiter = ' ';
    
    filename = [path, 'allElementDrift.out'];
    fileID = fopen(filename,'r');
    
    if fileID>=0
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string',  'ReturnOnError', false);
        fclose(fileID);
        
        for k=1:length(readElement)
            kEl = readElement(k);
            
            result.element(kEl).driftS = dataArray{:, startFrom+0+(k-1)*2};
            result.element(kEl).driftF = dataArray{:, startFrom+1+(k-1)*2};
        end
    else
        for k=1:length(readElement)
            kEl = readElement(k);
            
            result.element(kEl).driftS = NaN;
            result.element(kEl).driftF = NaN;
        end
    end
    
    
    % element basic forces
    formatSpec = '%f';
    for kEl=1:length(model.element)
        if strcmp(model.element(kEl).type, 'Macroelement3d') || strcmp(model.element(kEl).type, 'TriangularMacroelement') 
            formatSpec = [formatSpec, '%f%f%f%f%f%f%f%f%f%f%f%f'];
        end
    end
    formatSpec = [formatSpec, '%[^\n\r]']; 
    delimiter = ' ';
    
    filename = [path, 'allElementForce.out'];
    fileID = fopen(filename,'r');
    
    if fileID>=0
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string',  'ReturnOnError', false);
        fclose(fileID);
        
        for k=1:length(readElement)
            kEl = readElement(k);
            
            result.element(kEl).N1  = dataArray{:, startFrom+0+(k-1)*12};
            result.element(kEl).Mz1 = dataArray{:, startFrom+1+(k-1)*12};
            result.element(kEl).My1 = dataArray{:, startFrom+2+(k-1)*12};
            result.element(kEl).T   = dataArray{:, startFrom+3+(k-1)*12};
            result.element(kEl).N2  = dataArray{:, startFrom+4+(k-1)*12};
            result.element(kEl).Mz2 = dataArray{:, startFrom+5+(k-1)*12};
            result.element(kEl).My2 = dataArray{:, startFrom+6+(k-1)*12};
            result.element(kEl).N3  = dataArray{:, startFrom+7+(k-1)*12};
            result.element(kEl).Mz3 = dataArray{:, startFrom+8+(k-1)*12};
            result.element(kEl).My3 = dataArray{:, startFrom+9+(k-1)*12};
            result.element(kEl).Vy  = dataArray{:, startFrom+10+(k-1)*12};
            result.element(kEl).Vz  = dataArray{:, startFrom+11+(k-1)*12};   
        end
    else
        for k=1:length(readElement)
            kEl = readElement(k);
            
            result.element(kEl).N1  = NaN;
            result.element(kEl).Mz1 = NaN;
            result.element(kEl).My1 = NaN;
            result.element(kEl).T   = NaN;
            result.element(kEl).N2  = NaN;
            result.element(kEl).Mz2 = NaN;
            result.element(kEl).My2 = NaN;
            result.element(kEl).N3  = NaN;
            result.element(kEl).Mz3 = NaN;
            result.element(kEl).My3 = NaN;
            result.element(kEl).Vy  = NaN;
            result.element(kEl).Vz  = NaN; 
        end
    end
    

   
end






end

