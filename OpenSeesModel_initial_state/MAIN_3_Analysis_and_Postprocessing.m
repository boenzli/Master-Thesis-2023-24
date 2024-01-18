%% Matlab script to run the OpenSees analysis and store the results
% Author: Aline Bönzli (except where explicity marked)
% Date latest version: 15.01.2024
% Project: Master Thesis, Parish House St. Lawrence church Petrinja, Croatia

clc
clear all
close all

%% Adapt and intorduce the analysis data

% Material properties
E = 1.5e9;            % Youngs modulus [Pa]
Gs = 0.5e9;           % Shear modulus [Pa]
fc = 3.2e6;           % Compressive strength [Pa]
mus = 0.65;           % Initial friction coefficient [-]
coh = 1.8e5;          % Cohesion [Pa]
rho = 1800;           % Material density [kg/m^3]

%   Post peak
Gc = 3.0;             % Parameter defining the pre-peak deformability in shear
dropDrift = 0.0065;   % Drift at 20% force capacity loss [-]
muR = mus;            % Residual friction coefficient [-]
driftF = 0.0086*1.15; % Drift at loss of lateral force capacity, flexural failure [-]
driftS = 0.0058*1.15; % Drift at loss of lateral force capacity, shear failure [-]
betaTremuri = 0.8;    % Factor for the post peak behaviour of walls without OOP [-]

% Rayleigh damping parameters ("damping" frunction written by Dr. Igor Tomic)
dampingpercentage=0.05;
[alpha,beta_matlab]= damping(0.1144,0.0919,dampingpercentage);

% Factor of the dynamic analysis
EQfactor = [0.5 1.0 1.5 2.0];

% Direction of analysis
% 1 = X-direction and 2 = Y-direction, for bi-directional analysis choose 1
% and adapte the "Parish_house_3_3_Dynamic_template.tcl" file
EQdirection = [1 2];
for ii=1:1:length(EQfactor)
    for iii=1:1:length(EQdirection)

        %% options
        %%%% change this to the folder where you have Opensees.exe and Macroelement3d.ddl
        analysisFolder = 'C:\Users\aline\OneDrive\Dokumente\EPFL\12_Master_Thesis\08_OpenSees_Model';
        cd (analysisFolder)

        % file containing all information of the model (must contain the model in a variable
        % with the same name)
        projectName = 'Parish_house_3';

        % file containing all information of the model (must contain the model in a variable
        % with the same name)
        modelFile = 'modelOpensees.mat';


        %% load files
        addpath('Tremuri_import_and_plot_functions');
        load(modelFile);
        eval(['model = ',modelFile(1:end-4),';']);
        load('inputFiles.mat');

        %% Define where the results should be stored
        XY=["X" "Y"];
        % For bi-directional analysis choose the corresponding link
        % (adapted to your computer) and also change the input file called
        % "Parish_house_3_3_Dynamic_template.tcl"
        Results = strcat("C:\Users\aline\OneDrive\Dokumente\EPFL\12_Master_Thesis\08_OpenSees_Model\results_EQdir",XY(EQdirection(iii)),"_EQfac",num2str(EQfactor(ii)));
        % Results = strcat("C:\Users\aline\OneDrive\Dokumente\EPFL\12_Master_Thesis\08_OpenSees_Model\results_EQdirXY_EQfac",num2str(EQfactor(ii)));
        % Results = strcat("C:\Users\aline\OneDrive\Dokumente\EPFL\12_Master_Thesis\08_OpenSees_Model\results_EQdirYX_EQfac",num2str(EQfactor(ii)));
        
        % Check if the results folder exists already
        if ~exist(Results, 'dir')
            % If the folder does not exist, create it
            mkdir(Results);
        end
        %% Update analysis parameters
        currentDir=pwd;
        cd inputFiles

        fidi=fopen('Parish_house_3_model_template.tcl','r');
        fido=fopen('Parish_house_3_model.tcl','wt');

        while ~feof(fidi)
            l=fgetl(fidi);   % read line

            if strfind(l,'set Eelement')
                % modify line here
                l=strcat("set Eelement ", num2str(E)) ;
            end

            if strfind(l,'set Gs')
                % modify line here
                l=strcat("set Gs  ", num2str(Gs));
            end

            if strfind(l,'set fc')
                % modify line here
                l=strcat("set fc  ", num2str(fc));
            end

            if strfind(l,'set mus')
                % modify line here
                l=strcat("set mus  ", num2str(mus));
            end

            if strfind(l,'set coh')
                % modify line here
                l=strcat("set coh  ", num2str(coh));
            end

            if strfind(l,'set Gc')
                % modify line here
                l=strcat("set Gc  ", num2str(Gc));
            end

            if strfind(l,'set dropDrift')
                % modify line here
                l=strcat("set dropDrift  ", num2str(dropDrift));
            end

            if strfind(l,'set muR')
                % modify line here
                l=strcat("set muR  ", num2str(muR));
            end

            if strfind(l,'set rho')
                % modify line here
                l=strcat("set rho  ", num2str(rho));
            end

            if strfind(l,'set driftF')
                % modify line here
                l=strcat("set driftF  ", num2str(driftF));
            end

            if strfind(l,'set driftS')
                % modify line here
                l=strcat("set driftS  ", num2str(driftS));
            end

            if strfind(l,'set betaTremuri')
                % modify line here
                l=strcat("set betaTremuri  ", num2str(betaTremuri));
            end

            fprintf(fido,'%s \n',l)  % 'fgetl returns \n so it's embedded
        end
        fidi=fclose(fidi);
        fido=fclose(fido);

    
        fidi=fopen('Parish_house_3_3_Dynamic_template.tcl','r');
        fido=fopen('Parish_house_3_3_Dynamic.tcl','wt');

        while ~feof(fidi)
            l=fgetl(fidi);   % read line

            if strfind(l,'set alpha')
                % modify line here
                l=strcat("set alpha ", num2str(alpha)) ;
            end

            if strfind(l,'set beta_matlab')
                % modify line here
                l=strcat("set beta_matlab  ", num2str(beta_matlab));
            end

            if strfind(l,'set factor')
                % modify line here
                l=strcat("set factor ", num2str(EQfactor(ii))) ;
            end

            if strfind(l,'set direction')
                % modify line here
                l=strcat("set direction ", num2str(EQdirection(iii))) ;
            end

            fprintf(fido,'%s \n',l)  % 'fgetl returns \n so it's embedded
        end

        fidi=fclose(fidi);
        fido=fclose(fido);
        cd (currentDir);
        %% Run analysis
        currentDir = pwd;
        copyfile(inputFiles(end).filename, analysisFolder);
        [~,nameBatch,extBatch] = fileparts(inputFiles(end).filename);

        cd(analysisFolder);
        tic;
        commandLine = ['!Opensees.exe ', nameBatch, extBatch];
        eval(commandLine);
        elapsedTime = toc;
        cd(currentDir);

        fprintf('Total analysis time: %.2f s\n', elapsedTime);

        %% Read analysis
        
        for kAnalysis=2:length(inputFiles)-1

            if ~isempty(inputFiles(kAnalysis).filename)
                if ~contains(inputFiles(kAnalysis).filename, '_Modal.tcl')
                    try
                        result = readAnalysis(model, inputFiles(kAnalysis).outputFiles(1).filename(1:end-12));
                        result.periods = [];
                        result.frequencies = [];
                        analysis(kAnalysis).time = result.time;
                        analysis(kAnalysis).node = result.node;
                        analysis(kAnalysis).element = result.element;
                        analysis(kAnalysis).periods = result.periods;
                        analysis(kAnalysis).frequencies = result.frequencies;
                    catch
                    end
                else
                    nModes = length(inputFiles(kAnalysis).outputFiles)-1;
                    for kMode = 1:nModes
                        result = readAnalysis(model, inputFiles(kAnalysis).outputFiles(kMode).filename, 'Modal', 1);
                        analysis(kAnalysis).time(kMode) = kMode;
                        for kNode = 1:length(result.node)
                            if ~isempty(result.node(kNode).u)
                                analysis(kAnalysis).node(kNode).u(kMode,1) = result.node(kNode).u(1);
                                analysis(kAnalysis).node(kNode).v(kMode,1) = result.node(kNode).v(1);
                                analysis(kAnalysis).node(kNode).w(kMode,1) = result.node(kNode).w(1);
                                analysis(kAnalysis).node(kNode).rotx(kMode,1) = result.node(kNode).rotx(1);
                                analysis(kAnalysis).node(kNode).roty(kMode,1) = result.node(kNode).roty(1);
                                analysis(kAnalysis).node(kNode).rotz(kMode,1) = result.node(kNode).rotz(1);

                            end
                        end
                    end
                    % read periods
                    formatString = '%f%f%[^\n\r]';

                    filename = inputFiles(kAnalysis).outputFiles(end).filename;
                    fileID = fopen(filename,'r');

                    dataArray = textscan(fileID, formatString, 'Delimiter', ' ', 'MultipleDelimsAsOne', true, 'TextType', 'string',  'ReturnOnError', false);
                    fclose(fileID);

                    analysis(kAnalysis).periods     = dataArray{:, 1};
                    analysis(kAnalysis).frequencies = dataArray{:, 2};

                end
            end

        end



        %% Save results
        % % Plots flexural drift
        % DriftType='F';
        % DriftLimit=0.012;
        % plotAnalysis(model, analysis(4),DriftType,DriftLimit);
        % title("Flexural drifts");
        
        cd(Results);

        % For bi-directional analysis choose the corresponding link
        % (adapted to your computer) and also change the input file called
        % "Parish_house_3_3_Dynamic_template.tcl"
        % fname=sprintf(strcat("ParishHouse_EQdirXY_EQfac", num2str(EQfactor(ii)),".mat"));
        % fname=sprintf(strcat("ParishHouse_EQdirYX_EQfac", num2str(EQfactor(ii)),".mat"));
        fname=sprintf(strcat("ParishHouse_EQdir", XY(EQdirection(iii)), "_EQfac", num2str(EQfactor(ii)),".mat"));
        
        save(fname,'-v7.3');

        cd ("C:\Users\aline\OneDrive\Dokumente\EPFL\12_Master_Thesis\08_OpenSees_Model")


    end
end





