function model = readTremuriInput(tremuri_input_file)

verbose = true;
tic
%% read input file
% open input, read and understand all lines
fid_tremuri_input = fopen(tremuri_input_file,'r');
line = fgetl(fid_tremuri_input);
nAnalysis = 0;

while 1  % Loop over all lines in input file (until \fine is reached)
    while isempty(strfind(line,'/'))
        if verbose; fprintf('%s\n', line); end
        line = fgetl(fid_tremuri_input);
    end
    if verbose; fprintf('%s\n', line); end
              
    %% read all walls orientation
    if not(isempty(strfind(line,'pareti'))) && isempty(strfind(line,'!'))
        line = fgetl(fid_tremuri_input);
        if verbose; fprintf('%s\n', line); end
        while isempty(strfind(line(1),'/'))
            
            if isempty(strfind(line,'!')) || isempty(find(isstrprop(line,'alphanum')==1))
                A=strread(line, '%s');
                wall(str2num(A{1})).x0    =  str2num(A{2});
                wall(str2num(A{1})).y0    =  str2num(A{3});
                wall(str2num(A{1})).angle =  str2num(A{4});
                if not(isempty(strfind(A{4},'°')))
                    angle_in_degrees = A{4}(1:end-1);
                    wall(str2num(A{1})).angle = deg2rad(str2num(angle_in_degrees));
                end
            end
            line = fgetl(fid_tremuri_input);
            if verbose; fprintf('%s\n', line); end
            while isempty(line) || isempty(find(isstrprop(line,'alphanum')==1))
                line = fgetl(fid_tremuri_input);
                if verbose; fprintf('%s\n', line); end
            end
        end
    end
    
    %% read materials
    if (not(isempty(strfind(line,'Materiali'))) || not(isempty(strfind(line,'materiali'))) )  && isempty(strfind(line,'!'))
        line = fgetl(fid_tremuri_input);
        if verbose; fprintf('%s\n', line); end
        while isempty(line) || isempty(find(isstrprop(line,'alphanum')==1))
            line = fgetl(fid_tremuri_input);
            if verbose; fprintf('%s\n', line); end
        end
        while isempty(strfind(line(1),'/'))
            if isempty(strfind(line,'!'))
                A=strread(line);
                material(A(1)).E    = A(2);
                material(A(1)).G    = A(3);
                
                if length(A)>3
                    material(A(1)).rho  = A(4);
                    if length(A)>4
                        material(A(1)).fc           = A(5);
                        if length(A)>=13
                            material(A(1)).tau0         = A(6);
                            material(A(1)).shear_model  = A(8);
                            material(A(1)).drift_S      = A(9);
                            material(A(1)).drift_F      = A(10);
                            material(A(1)).mu           = A(11);
                            material(A(1)).Gc           = A(12);
                            material(A(1)).beta         = A(13);
                        end
                    end
                end
                              
            end
            line = fgetl(fid_tremuri_input);
            if verbose; fprintf('%s\n', line); end
            while isempty(line) || isempty(find(isstrprop(line,'alphanum')==1))
                line = fgetl(fid_tremuri_input);
                if verbose; fprintf('%s\n', line); end
            end
        end
    end
    
    %% read all 2d nodes
    if not(isempty(strfind(line,'nodi2d'))) && isempty(strfind(line,'!'))
        line = fgetl(fid_tremuri_input);
        if verbose; fprintf('%s\n', line); end
        while isempty(line) || isempty(find(isstrprop(line,'alphanum')==1))
            line = fgetl(fid_tremuri_input);
            if verbose; fprintf('%s\n', line); end
        end
        while isempty(strfind(line(1),'/'))
            if isempty(strfind(line,'!')) || isempty(find(isstrprop(line,'alphanum')==1))
                A=strread(line, '%s');
                node2d(str2num(A{1})).wall    =  str2num(A{2});
                node2d(str2num(A{1})).x_loc   =  str2num(A{3});
                node2d(str2num(A{1})).z       =  str2num(A{4});
                node2d(str2num(A{1})).type    =  A{5}(1);
                
                if strcmp(A{5}, 'R')
                    node2d(str2num(A{1})).rho          =  str2num(A{6});
                    node2d(str2num(A{1})).thickness    =  str2num(A{7});
                    node2d(str2num(A{1})).offsetXloc   =  [-str2num(A{8}), str2num(A{9})];
                    node2d(str2num(A{1})).offsetZ      =  [str2num(A{10}), -str2num(A{11})];
                elseif contains(A{5}, 'P')
                    indexRead = 5;
                    while contains(A{indexRead}, 'P')   
                        numPolygon = str2num(A{indexRead}(2:end));
                        
                        node2d(str2num(A{1})).polygon(numPolygon).rho       = str2num(A{indexRead+1});
                        node2d(str2num(A{1})).polygon(numPolygon).thickness = str2num(A{indexRead+2});
                        
                        % assume the shape is a rectangle, which is always true for the Basel building
                        xVec = [str2num(A{indexRead+3}); str2num(A{indexRead+5}); str2num(A{indexRead+7}); str2num(A{indexRead+9}) ];
                        zVec = [str2num(A{indexRead+4}); str2num(A{indexRead+6}); str2num(A{indexRead+8}); str2num(A{indexRead+10}) ];
                        
                        node2d(str2num(A{1})).polygon(numPolygon).offsetXloc   =  [min(xVec), max(xVec)];
                        node2d(str2num(A{1})).polygon(numPolygon).offsetZ      =  [max(zVec), min(zVec)];                      
                                               
                        indexRead = min(indexRead + 11, length(A));
                       
                    end
                                      
                end
            end
            line = fgetl(fid_tremuri_input);
            if verbose; fprintf('%s\n', line); end
            while isempty(line) || isempty(find(isstrprop(line,'alphanum')==1))
                line = fgetl(fid_tremuri_input);
                if verbose; fprintf('%s\n', line); end
            end
        end
    end
    
    %% read all 3d nodes
    if not(isempty(strfind(line,'nodi3d'))) && isempty(strfind(line,'!'))
        line = fgetl(fid_tremuri_input);
        if verbose; fprintf('%s\n', line); end
        while isempty(strfind(line(1),'/'))
            if isempty(strfind(line,'!')) || isempty(find(isstrprop(line,'alphanum')==1))
                A=strread(line, '%s');
                node3d(str2num(A{1})).n_wall2    =  str2num(A{2});
                for k=1:str2num(A{2})
                    node3d(str2num(A{1})).wall(k) = str2num(A{2+k});
                end
                node3d(str2num(A{1})).z       =  str2num(A{3+k});
                node3d(str2num(A{1})).type    =  A{4+k}(1);
                
                if strcmp(node3d(str2num(A{1})).type, 'N')
                    off = 4+k;
                    indexRead = off+1;
                elseif strcmp(node3d(str2num(A{1})).type, 'R')
                    off = 10+k;
                    indexRead = off+1;
                    node3d(str2num(A{1})).rho1          =  str2num(A{5+k});
                    node3d(str2num(A{1})).thickness1    =  str2num(A{6+k});
                    node3d(str2num(A{1})).offsetXloc1   =  [-str2num(A{7+k}), str2num(A{8+k})];
                    node3d(str2num(A{1})).offsetZ1      =  [str2num(A{9+k}), -str2num(A{10+k})];
                elseif contains(node3d(str2num(A{1})).type, 'P')
                    indexRead = 6;
                    while contains(A{indexRead}, 'P') 
                        numPolygon = str2num(A{indexRead}(2:end));
                        
                        node3d(str2num(A{1})).polygon1(numPolygon).rho        = str2num(A{indexRead+1});
                        node3d(str2num(A{1})).polygon1(numPolygon).thickness  = str2num(A{indexRead+2});
                        
                        % assume the shape is a rectangle, which is always true for the Basel building
                        xVec = [str2num(A{indexRead+3}); str2num(A{indexRead+5}); str2num(A{indexRead+7}); str2num(A{indexRead+9}) ];
                        zVec = [str2num(A{indexRead+4}); str2num(A{indexRead+6}); str2num(A{indexRead+8}); str2num(A{indexRead+10}) ];
                        
                        node3d(str2num(A{1})).polygon1(numPolygon).offsetXloc   =  [min(xVec), max(xVec)];
                        node3d(str2num(A{1})).polygon1(numPolygon).offsetZ      =  [max(zVec), min(zVec)];
                        
                        indexRead = min(indexRead + 11, length(A));
                        if strcmp(A{indexRead}, '|')
                            indexRead=indexRead+1;
                            break
                        end                       
                    end  
                    off = indexRead-1;
                end
                    
                    
                if node3d(str2num(A{1})).n_wall2 >1
                    node3d(str2num(A{1})).type    =  [node3d(str2num(A{1})).type, A{1+off}(1)];
                    if strcmp(A{1+off}, 'R')
                        node3d(str2num(A{1})).rho2          =  str2num(A{2+off});
                        node3d(str2num(A{1})).thickness2    =  str2num(A{3+off});
                        node3d(str2num(A{1})).offsetXloc2   =  [-str2num(A{4+off}), str2num(A{5+off})];
                        node3d(str2num(A{1})).offsetZ2      =  [str2num(A{6+off}), -str2num(A{7+off})];
                    elseif contains(A{1+off}, 'P')
                        while contains(A{indexRead}, 'P')
                            numPolygon = str2num(A{indexRead}(2:end));
                            
                            node3d(str2num(A{1})).polygon2(numPolygon).rho        = str2num(A{indexRead+1});
                            node3d(str2num(A{1})).polygon2(numPolygon).thickness  = str2num(A{indexRead+2});
                            
                            % assume the shape is a rectangle, which is always true for the Basel building
                            xVec = [str2num(A{indexRead+3}); str2num(A{indexRead+5}); str2num(A{indexRead+7}); str2num(A{indexRead+9}) ];
                            zVec = [str2num(A{indexRead+4}); str2num(A{indexRead+6}); str2num(A{indexRead+8}); str2num(A{indexRead+10}) ];
                            
                            node3d(str2num(A{1})).polygon2(numPolygon).offsetXloc   =  [min(xVec), max(xVec)];
                            node3d(str2num(A{1})).polygon2(numPolygon).offsetZ      =  [max(zVec), min(zVec)];
                            
                            indexRead = min(indexRead + 11, length(A));
                            if strcmp(A{indexRead}, '|')
                                indexRead=indexRead+1;
                                break
                            end
                        end
                        
                    end
                end
                
                
            end
            line = fgetl(fid_tremuri_input);
            if verbose; fprintf('%s\n', line); end
            while isempty(line) || isempty(find(isstrprop(line,'alphanum')==1))
                line = fgetl(fid_tremuri_input);
                if verbose; fprintf('%s\n', line); end
            end
        end
    end
    
    %% read all floors
    if (not(isempty(strfind(line,'solaio'))) && isempty(strfind(line,'!'))) 
        line = fgetl(fid_tremuri_input);
        if verbose; fprintf('%s\n', line); end
        while isempty(strfind(line(1),'/'))
            if isempty(strfind(line,'!'))  || isempty(find(isstrprop(line,'alphanum')==1))
                A=strread(line, '%s');
                floor(str2num(A{1})).nodes      =  [str2num(A{2}), str2num(A{3}), str2num(A{4}), str2num(A{5})]; 
                floor(str2num(A{1})).thickness  =  str2num(A{6});
                floor(str2num(A{1})).E1         =  str2num(A{7});
                floor(str2num(A{1})).E2         =  str2num(A{8});
                floor(str2num(A{1})).Poisson    =  str2num(A{9});
                floor(str2num(A{1})).G          =  str2num(A{10});
                floor(str2num(A{1})).angle      =  str2num(A{11});
                if not(isempty(strfind(A{11},'°')))
                    angle_in_degrees = A{11}(1:end-1);
                    floor(str2num(A{1})).angle = deg2rad(str2num(angle_in_degrees));
                end
            end
            line = fgetl(fid_tremuri_input);
            if verbose; fprintf('%s\n', line); end
            while isempty(line) || isempty(find(isstrprop(line,'alphanum')==1))
                line = fgetl(fid_tremuri_input);
                if verbose; fprintf('%s\n', line); end
            end
        end
    end
    
    if (not(isempty(strfind(line,'floors 3N'))) && isempty(strfind(line,'!'))) 
        line = fgetl(fid_tremuri_input);
         if verbose; fprintf('%s\n', line); end
        while isempty(strfind(line(1),'/'))
            if isempty(strfind(line,'!'))  || isempty(find(isstrprop(line,'alphanum')==1))
                A=strread(line, '%s');
                floor(str2num(A{1})).nodes      =  [str2num(A{2}), str2num(A{3}), str2num(A{4})]; 
                floor(str2num(A{1})).thickness  =  str2num(A{5});
                floor(str2num(A{1})).E1         =  str2num(A{6});
                floor(str2num(A{1})).E2         =  str2num(A{7});
                floor(str2num(A{1})).Poisson    =  str2num(A{8});
                floor(str2num(A{1})).G          =  str2num(A{9});
                floor(str2num(A{1})).angle      =  str2num(A{10});
                if not(isempty(strfind(A{10},'°')))
                    angle_in_degrees = A{10}(1:end-1);
                    floor(str2num(A{1})).angle = deg2rad(str2num(angle_in_degrees));
                end
            end
            line = fgetl(fid_tremuri_input);
             if verbose; fprintf('%s\n', line); end
            while isempty(line)  || isempty(find(isstrprop(line,'alphanum')==1))
                line = fgetl(fid_tremuri_input);
                 if verbose; fprintf('%s\n', line); end
            end
        end
    end
       
    %% read all elements
    %if (not(isempty(strfind(line,'elementi'))) && isempty(strfind(line,'!')))   || (not(isempty(strfind(line,'elementoOPCM3274'))) && isempty(strfind(line,'!')))
    if (contains(line,'macroelementoCalibrato') && ~contains(line,'!'))  ||   (contains(line,'macroelemento') && ~contains(line,'!'))  ||   (contains(line,'elementi') && ~contains(line,'!'))  ||   (contains(line,'elementoOPCM3274') && ~contains(line,'!')) 
       line = fgetl(fid_tremuri_input);
       if verbose; fprintf('%s\n', line); end
        while isempty(strfind(line(1),'/'))
            if isempty(strfind(line,'!'))  || isempty(find(isstrprop(line,'alphanum')==1))
                A=strread(line);
                element(A(1)).wall      =  A(2);
                element(A(1)).nodeI     =  A(3);
                element(A(1)).nodeJ     =  A(4);
                element(A(1)).xBar      =  A(5);
                element(A(1)).zBar      =  A(6);
                element(A(1)).L         =  A(7);
                element(A(1)).H         =  A(8);
                element(A(1)).t         =  A(9);
                element(A(1)).mat       =  A(10);
                element(A(1)).type      =  A(11);
                if element(A(1)).type == 0
                   element(A(1)).angle = pi/2;
                elseif element(A(1)).type == 1
                    element(A(1)).angle = 0;
                elseif element(A(1)).type == 2
                    element(A(1)).angle = A(12);
                end
            end
            line = fgetl(fid_tremuri_input);
            if verbose; fprintf('%s\n', line); end
            while isempty(line)  || isempty(find(isstrprop(line,'alphanum')==1))
                line = fgetl(fid_tremuri_input);
                if verbose; fprintf('%s\n', line); end
            end
        end
    end
    
    %% read all elastic beams
    if (not(isempty(strfind(line,'traveElastica'))) && isempty(strfind(line,'!'))) 
        line = fgetl(fid_tremuri_input);
        if verbose; fprintf('%s\n', line); end
        while isempty(strfind(line(1),'/'))
            if isempty(strfind(line,'!')) || isempty(find(isstrprop(line,'alphanum')==1))
                A=strread(line);
                elasticBeam(A(1)).wall      =  A(2); 
                elasticBeam(A(1)).nodeI     =  A(3); 
                elasticBeam(A(1)).nodeJ     =  A(4); 
                elasticBeam(A(1)).mat       =  A(5);
                elasticBeam(A(1)).area      =  A(6);
                elasticBeam(A(1)).J         =  A(7);
                elasticBeam(A(1)).deformIn  =  A(8);
                elasticBeam(A(1)).type      =  A(9);
                elasticBeam(A(1)).offXloc_I =  A(10);
                elasticBeam(A(1)).offZ_I =     A(11);
                elasticBeam(A(1)).offXloc_J =  A(12);
                elasticBeam(A(1)).offZ_J =     A(13);
            end
            line = fgetl(fid_tremuri_input);
            if verbose; fprintf('%s\n', line); end
            while isempty(line) || isempty(find(isstrprop(line,'alphanum')==1))
                line = fgetl(fid_tremuri_input);
                if verbose; fprintf('%s\n', line); end
            end
        end
    end
    
    %% read all nonlinear beams
    if (not(isempty(strfind(line,'traveNonlineare'))) && isempty(strfind(line,'!'))) 
        line = fgetl(fid_tremuri_input);
        if verbose; fprintf('%s\n', line); end
        while isempty(strfind(line(1),'/'))
            if isempty(strfind(line,'!')) || isempty(find(isstrprop(line,'alphanum')==1))
                A=strread(line);
                nlBeam(A(1)).wall      =  A(2); 
                nlBeam(A(1)).nodeI     =  A(3); 
                nlBeam(A(1)).nodeJ     =  A(4); 
                nlBeam(A(1)).mat       =  A(5);
                nlBeam(A(1)).area      =  A(6);
                nlBeam(A(1)).J         =  A(7);

                nlBeam(A(1)).offXloc_I =  A(8);
                nlBeam(A(1)).offZ_I =     A(9);
                nlBeam(A(1)).offXloc_J =  A(10);
                nlBeam(A(1)).offZ_J =     A(11);
                
                nlBeam(A(1)).deformIn  =  A(12);
                nlBeam(A(1)).type      =  A(13);
                
                nlBeam(A(1)).Wpl       =  A(14);
            end
            line = fgetl(fid_tremuri_input);
            if verbose; fprintf('%s\n', line); end
            while isempty(line) || isempty(find(isstrprop(line,'alphanum')==1))
                line = fgetl(fid_tremuri_input);
                if verbose; fprintf('%s\n', line); end
            end
        end
    end
      
    %% read nodal masses
    if (not(isempty(strfind(line,'masse'))) && isempty(strfind(line,'!'))) 
        line = fgetl(fid_tremuri_input);
        if verbose; fprintf('%s\n', line); end
        k=0;
        while isempty(strfind(line(1),'/'))
            if isempty(strfind(line,'!')) || isempty(find(isstrprop(line,'alphanum')==1))
                k=k+1;
                A=strread(line);
                nodalMass(k).node      =  A(1); 
                nodalMass(k).mass      =  A(2); 
                if length(A)>2
                    nodalMass(k).ecc_x     =  A(3); 
                else
                    nodalMass(k).ecc_x     =  0;
                end
                if length(A)>3
                    nodalMass(k).ecc_z     =  A(4); 
                else
                    nodalMass(k).ecc_z     =  0;
                end
            end
            line = fgetl(fid_tremuri_input);
            if verbose; fprintf('%s\n', line); end
            while isempty(line) || isempty(find(isstrprop(line,'alphanum')==1))
                line = fgetl(fid_tremuri_input);
                if verbose; fprintf('%s\n', line); end
            end
        end
    end
    
    %% read distributed masses
    if (not(isempty(strfind(line,'massedistr'))) && isempty(strfind(line,'!'))) 
        line = fgetl(fid_tremuri_input);
        if verbose; fprintf('%s\n', line); end
        k=0;
        while isempty(strfind(line(1),'/'))  
            if isempty(strfind(line,'!')) || isempty(find(isstrprop(line,'alphanum')==1))
                k=k+1;
                A=strread(line);
                distrMass(k).node      =  A(1); 
                distrMass(k).V         =  A(2); 
                distrMass(k).M         =  A(3);
                distrMass(k).Vr        =  A(4);
                distrMass(k).Mr        =  A(5);
                distrMass(k).el        =  A(8);
            end
            line = fgetl(fid_tremuri_input);
            if verbose; fprintf('%s\n', line); end
            while isempty(line) || isempty(find(isstrprop(line,'alphanum')==1))
                line = fgetl(fid_tremuri_input);
                if verbose; fprintf('%s\n', line); end
            end
        end
    end
    
    %% read floor levels
    if (not(isempty(strfind(line,'Piani'))) && isempty(strfind(line,'!'))) 
          A=strread(line(7:end));
          for kFloor=1:length(A)-1
              floorLevel(kFloor).h = A(kFloor);
              floorLevel(kFloor).zAxis = [0;0;1]; 
          end
    end
    
    %% read distribution of the 2d nodes on 3d nodes
    if not(isempty(strfind(line,'ripartizione'))) && isempty(strfind(line,'!'))
        line = fgetl(fid_tremuri_input);
        if verbose; fprintf('%s\n', line); end
        while isempty(strfind(line(1),'/'))
            if isempty(strfind(line,'!'))  || isempty(find(isstrprop(line,'alphanum')==1))
                A=strread(line, '%s');
                n1 = str2num(A{2});
                n2 = str2num(A{3});
                node2d(str2num(A{1})).repartition  =  [n1;n2];
            end
            line = fgetl(fid_tremuri_input);
            if verbose; fprintf('%s\n', line); end
            while isempty(line)  || isempty(find(isstrprop(line,'alphanum')==1))
                line = fgetl(fid_tremuri_input);
                if verbose; fprintf('%s\n', line); end
            end
        end
    end
          
    %% read restraints
    if (not(isempty(strfind(line,'vincoli'))) && isempty(strfind(line,'!'))) 
        line = fgetl(fid_tremuri_input);
        if verbose; fprintf('%s\n', line); end
        k=0;
        while isempty(strfind(line(1),'/'))  
            if isempty(strfind(line,'!'))  || isempty(find(isstrprop(line,'alphanum')==1))
                k=k+1;
                A=strread(line, '%s');
                
                restraint(k).node      =  str2num(A{1}); 
                % case of 2dnode
                if exist('node2d', 'var')
                    if restraint(k).node<=length(node2d)
                        if not(isempty(node2d(restraint(k).node).wall))
                            if strcmp(A{2},'V') || strcmp(A{2},'1') || strcmp(A{2},'v')
                                restraint(k).x = 1;
                                restraint(k).y = 1;
                            else
                                restraint(k).x = 0;
                                restraint(k).y = 0;
                            end
                            if strcmp(A{3},'V') || strcmp(A{3},'1') || strcmp(A{3},'v')
                                restraint(k).z = 1;
                            else
                                restraint(k).z = 0;
                            end
                            if strcmp(A{4},'V') || strcmp(A{4},'1') || strcmp(A{4},'v')
                                restraint(k).rx = 1;
                                restraint(k).ry = 1;
                            else
                                restraint(k).rx = 0;
                                restraint(k).ry = 0;
                            end
                        end
                    end
                end
                    
                % case of 3dnode
                if restraint(k).node<=length(node3d)
                if not(isempty(node3d(restraint(k).node).z))
                    if strcmp(A{2},'V') || strcmp(A{2},'1') || strcmp(A{2},'v')
                        restraint(k).x = 1;
                    else
                        restraint(k).x = 0;
                    end
                    if strcmp(A{3},'V') || strcmp(A{3},'1') || strcmp(A{3},'v')
                        restraint(k).y = 1;
                    else
                        restraint(k).y = 0;
                    end
                    if strcmp(A{4},'V') || strcmp(A{4},'1') || strcmp(A{4},'v')
                        restraint(k).z = 1;
                    else
                        restraint(k).z = 0;
                    end
                    if strcmp(A{5},'V') || strcmp(A{5},'1') || strcmp(A{5},'v')
                        restraint(k).rx = 1;
                    else
                        restraint(k).rx = 0;
                    end
                    if strcmp(A{6},'V') || strcmp(A{6},'1') || strcmp(A{6},'v')
                        restraint(k).ry = 1;
                    else
                        restraint(k).ry = 0;
                    end
                end 
                end
            end
            line = fgetl(fid_tremuri_input);
            if verbose; fprintf('%s\n', line); end
            while isempty(line)  || isempty(find(isstrprop(line,'alphanum')==1))
                line = fgetl(fid_tremuri_input);
                if verbose; fprintf('%s\n', line); end
            end
        end
    end
    
    %% read analyses: pp
    if (not(isempty(strfind(line,'/pp'))) && isempty(strfind(line,'!'))) 
          A=strread(line(4:end));
          nAnalysis = nAnalysis+1;
                   
          analysis(nAnalysis).type    = 'SelfWeight';
          analysis(nAnalysis).nSteps  = A(1);
          analysis(nAnalysis).tol     = A(2);
          analysis(nAnalysis).maxStep = A(3);
          analysis(nAnalysis).accVec  = [A(4);A(5);A(6)];
    end
    
    %% read analyses: am
    if (not(isempty(strfind(line,'/am'))) && isempty(strfind(line,'!'))) 
          A=strread(line(4:end));
          nAnalysis = nAnalysis+1;
                   
          analysis(nAnalysis).type    = 'Modal';
          analysis(nAnalysis).nModes   = A(1);
    end
      
    
    %% read analyses: pomas, pomaz, po
    if (not(isempty(strfind(line,'/pomas'))) && isempty(strfind(line,'!')))
        A=strread(line(7:end),'%s');
        nAnalysis = nAnalysis+1;
        
        analysis(nAnalysis).type        = 'PushoverRectangular';
        analysis(nAnalysis).nSteps      = str2num(A{1});
        analysis(nAnalysis).tol         = str2num(A{2});
        analysis(nAnalysis).maxStep     = str2num(A{3});
        analysis(nAnalysis).controlNode = str2num(A{4});
        analysis(nAnalysis).DOF         = A{5};
        analysis(nAnalysis).maxDisp     = str2num(A{6});
        analysis(nAnalysis).forceDrop   = str2num(A{7});
    else
        % read analyses: pomaz
        if (not(isempty(strfind(line,'/pomaz'))) && isempty(strfind(line,'!')))
            A=strread(line(7:end),'%s');
            nAnalysis = nAnalysis+1;
            
            analysis(nAnalysis).type        = 'PushoverTriangular';
            analysis(nAnalysis).nSteps      = str2num(A{1});
            analysis(nAnalysis).tol         = str2num(A{2});
            analysis(nAnalysis).maxStep     = str2num(A{3});
            analysis(nAnalysis).controlNode = str2num(A{4});
            analysis(nAnalysis).DOF         = A{5};
            analysis(nAnalysis).maxDisp     = str2num(A{6});
            analysis(nAnalysis).forceDrop   = str2num(A{7});
        else
            % read analyses: po
            if (not(isempty(strfind(line,'/po'))) && isempty(strfind(line,'!')))
                A=strread(line(7:end),'%s');
                nAnalysis = nAnalysis+1;
                
                analysis(nAnalysis).type        = 'PushoverGeneric';
                analysis(nAnalysis).nSteps      = str2num(A{1});
                analysis(nAnalysis).tol         = str2num(A{2});
                analysis(nAnalysis).maxStep     = str2num(A{3});
                analysis(nAnalysis).controlNode = str2num(A{4});
                analysis(nAnalysis).DOF         = A{5};
                analysis(nAnalysis).maxDisp     = str2num(A{6});
                analysis(nAnalysis).forceDrop   = str2num(A{7});
                
                loadedNodes = [];
                
                line = fgetl(fid_tremuri_input);
                if verbose; fprintf('%s\n', line); end
                while isempty(strfind(line(1),'/'))
                    if isempty(strfind(line,'!'))  || isempty(find(isstrprop(line,'alphanum')==1))
                        A=strread(line, '%s');
                        if length(A)==6
                            loadedNodes = [loadedNodes; str2num(A{1}), str2num(A{2}), str2num(A{3}), str2num(A{4}), str2num(A{5}), str2num(A{6})];
                        else
                            loadedNodes = [loadedNodes; str2num(A{1}), str2num(A{2}), str2num(A{3}), str2num(A{4}), 0, 0];
                        end
                    end
                    line = fgetl(fid_tremuri_input);
                    if verbose; fprintf('%s\n', line); end
                    while isempty(line)  || isempty(find(isstrprop(line,'alphanum')==1))
                        line = fgetl(fid_tremuri_input);
                        if verbose; fprintf('%s\n', line); end
                    end
                end
                
                analysis(nAnalysis).loadedNodes = loadedNodes;  % structure: node, ratio
                
            end
        end
    end
    
    
    %% read analyses: ad
    if (not(isempty(strfind(line,'/ad'))) && isempty(strfind(line,'!'))) 
          A=strread(line(4:end));
          nAnalysis = nAnalysis+1;
                   
          analysis(nAnalysis).type     = 'Dynamic';
          analysis(nAnalysis).nSteps   = A(1);
          analysis(nAnalysis).tol      = A(2);
          analysis(nAnalysis).maxStep  = A(3);
          analysis(nAnalysis).dt       = A(4);
          analysis(nAnalysis).Rayleigh = [A(5), A(6)];
          analysis(nAnalysis).subd     = A(7);
          
          line = fgetl(fid_tremuri_input);
          if verbose; fprintf('%s\n', line); end
          while isempty(line)  || isempty(find(isstrprop(line,'alphanum')==1))
              line = fgetl(fid_tremuri_input);
              if verbose; fprintf('%s\n', line); end
          end
          
          A=strread(line, '%s');
          analysis(nAnalysis).DOF          = A{1};
          analysis(nAnalysis).groundMotion = A{2};
          if length(A)>2
              analysis(nAnalysis).PGA = A{3};
          else
              analysis(nAnalysis).PGA = -1;
          end
          
          [filepath,~,~] = fileparts(tremuri_input_file);
          analysis(nAnalysis).groundMotion = [filepath, '/', analysis(nAnalysis).groundMotion];
          
    end

    
    %% fine
    
    if not(isempty(strfind(line,'FINE'))) ||  not(isempty(strfind(line,'fine')))
        break;
    end

    if isempty(strfind(line,'pareti')) && isempty(strfind(line,'Materiali')) && isempty(strfind(line,'nodi2d')) && isempty(strfind(line,'nodi3d')) &&  ...
       isempty(strfind(line,'elemento')) && isempty(strfind(line,'traveelastica')) && isempty(strfind(line,'masse')) && isempty(strfind(line,'massedistr')) && ...
       isempty(strfind(line,'vincoli')) && isempty(strfind(line,'elementoOPCM3274')) 
   
        line = fgetl(fid_tremuri_input);
    end
    
   
    
    
end

%% postprocess
% assign 3d coordinates to all 2dnodes
if exist('node2d', 'var')
    for k=1:length(node2d)
        if isempty(node2d(k))
            node2d(k).wall = [];
            node2d(k).x_loc = [];
            node2d(k).x = [];
            node2d(k).y = [];
            node2d(k).z = [];
        end
    end
    
    
    for k=1:length(node2d)
        if not(isempty(node2d(k).wall))
            nWall =node2d(k).wall;
            theta = wall(nWall).angle;
            x0 = wall(nWall).x0;
            y0 = wall(nWall).y0;
            
            node2d(k).x = x0 + node2d(k).x_loc * cos(theta);
            node2d(k).y = y0 + node2d(k).x_loc * sin(theta);
            
            if strcmp(node2d(k).type, 'R')
                node2d(k).offsetX = node2d(k).x + node2d(k).offsetXloc * cos(theta);
                node2d(k).offsetY = node2d(k).y + node2d(k).offsetXloc * sin(theta);
            elseif strcmp(node2d(k).type, 'P')
                for kPolygon=1:length(node2d(k).polygon)
                    if ~isempty(node2d(k).polygon(kPolygon))
                        node2d(k).polygon(kPolygon).offsetX = node2d(k).x + node2d(k).polygon(kPolygon).offsetXloc * cos(theta);
                        node2d(k).polygon(kPolygon).offsetY = node2d(k).y + node2d(k).polygon(kPolygon).offsetXloc * sin(theta);
                    end
                end
                
            end
            
        end
    end
end

% assign 3d coordinates to all 3dnodes     
for k=1:length(node3d)
    if not(isempty(node3d(k).wall))
        nWall1 =node3d(k).wall(1);
        nWall2 =node3d(k).wall(2);
        theta1 = wall(nWall1).angle;
        theta2 = wall(nWall2).angle;
        x01 = wall(nWall1).x0;
        y01 = wall(nWall1).y0;
        x02 = wall(nWall2).x0;
        y02 = wall(nWall2).y0;
        
        A = [cos(theta1),  -cos(theta2);
             sin(theta1),  -sin(theta2)];
        b = [x02-x01;
             y02-y01];
        x = A\b;
        
        node3d(k).x = x01 + x(1) * cos(theta1);
        node3d(k).y = y01 + x(1) * sin(theta1); 
        
        if strcmp(node3d(k).type(1), 'R')
            node3d(k).offsetX1 = node3d(k).x + node3d(k).offsetXloc1 * cos(theta1);
            node3d(k).offsetY1 = node3d(k).y + node3d(k).offsetXloc1 * sin(theta1);
            
        elseif strcmp(node3d(k).type(1), 'P')
            for kPolygon=1:length(node3d(k).polygon1)
                if ~isempty(node3d(k).polygon1(kPolygon))
                    node3d(k).polygon1(kPolygon).offsetX = node3d(k).x + node3d(k).polygon1(kPolygon).offsetXloc * cos(theta1);
                    node3d(k).polygon1(kPolygon).offsetY = node3d(k).y + node3d(k).polygon1(kPolygon).offsetXloc * sin(theta1);
                end
            end
            
        end
        
        if strcmp(node3d(k).type(2), 'R')            
            node3d(k).offsetX2 = node3d(k).x + node3d(k).offsetXloc2 * cos(theta2);
            node3d(k).offsetY2 = node3d(k).y + node3d(k).offsetXloc2 * sin(theta2);
            
        elseif strcmp(node3d(k).type(2), 'P')
            for kPolygon=1:length(node3d(k).polygon2)
                if ~isempty(node3d(k).polygon2(kPolygon))
                    node3d(k).polygon2(kPolygon).offsetX = node3d(k).x + node3d(k).polygon2(kPolygon).offsetXloc * cos(theta2);
                    node3d(k).polygon2(kPolygon).offsetY = node3d(k).y + node3d(k).polygon2(kPolygon).offsetXloc * sin(theta2);
                end
            end
        end
        
        
    end
end

% assign offsets to all elements  
for k=1:length(element)
    if not(isempty(element(k).angle))
        theta =  element(k).angle;
        x0 = element(k).xBar;
        z0 = element(k).zBar;

        x_loc = x0 - element(k).H/2 * cos(theta);
        z_loc = z0 - element(k).H/2 * sin(theta);

        nWall = element(k).wall;
        theta = wall(nWall).angle;
        x0 = wall(nWall).x0;
        y0 = wall(nWall).y0;

        x_glob = x0 + x_loc * cos(theta);
        y_glob = y0 + x_loc * sin(theta);  
        element(k).nI=[x_glob; y_glob; z_loc];

        theta =  element(k).angle;
        x0 = element(k).xBar;
        z0 = element(k).zBar;
        x_loc = x0 + element(k).H/2 * cos(theta);
        z_loc = z0 + element(k).H/2 * sin(theta);

        nWall = element(k).wall;
        theta = wall(nWall).angle;
        x0 = wall(nWall).x0;
        y0 = wall(nWall).y0;

        x_glob = x0 + x_loc * cos(theta);
        y_glob = y0 + x_loc * sin(theta);  
        element(k).nJ=[x_glob; y_glob; z_loc];  
    end
end

if exist('wall', 'var');        model.wall  = wall;                     else model.wall  = [];          end;
if exist('node2d', 'var');      model.node2d  = node2d;                 else model.node2d  = [];        end;
if exist('node3d', 'var');      model.node3d  = node3d;                 else model.node3d  = [];        end;
if exist('element', 'var');     model.element = element;                else model.element = [];        end;
if exist('elasticBeam', 'var'); model.elasticBeam  = elasticBeam;       else model.elasticBeam  = [];   end;
if exist('nlBeam', 'var');      model.nlBeam  = nlBeam;            else model.nlBeam  = [];        end;
if exist('floor', 'var');       model.floor  = floor;                   else model.floor  = [];         end;
if exist('material', 'var');    model.material = material;              else model.material = [];       end;
if exist('nodalMass', 'var');   model.nodalMass = nodalMass;            else model.nodalMass = [];      end;
if exist('distrMass', 'var');   model.distrMass = distrMass;            else model.distrMass = [];      end;
if exist('restraint', 'var');   model.restraint = restraint;            else model.restraint = [];      end;
if exist('floorLevel', 'var');  model.floorLevel = floorLevel;          else model.floorLevel = [];     end;
if exist('analysis', 'var');    model.analysis = analysis;              else model.analysis = [];       end;

elapsedTime = toc;
fprintf('Read model file from %s (time %.1f s)\n', tremuri_input_file, elapsedTime);
fclose(fid_tremuri_input);

end

