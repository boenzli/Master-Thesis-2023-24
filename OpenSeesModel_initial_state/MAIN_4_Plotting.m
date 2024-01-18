%% Matlab script to plot results form previously run models
% Author: Aline Bönzli (except where explicity marked)
% Date latest version: 15.01.2024
% Project: Master Thesis, Parish House St. Lawrence church Petrinja, Croatia

clc
clear all
close all
analysisFolder = 'C:\Users\aline\OneDrive\Dokumente\EPFL\12_Master_Thesis\08_OpenSees_Model';
cd (analysisFolder)
load("modelParameters.mat")
%% Loop on different walls
% Specify the analyses you want to plot by marking X or Y for
% unidirectional acceleration, XY for NS acceleration in X direction and EW
% acceleration in Y direction, YX for EW acceleration in X direction and NS
% acceleration in Y direction.

EQdir = ["X" "Y" "XY" "YX"]; % Capital X or Y  to specify the direction, XY stands for NS-acceleration in X-direction and EW-acceleration in Y-direction and YX is the inverse.
EQfac = [0.5 1.0 1.5 2.0]; % Needs to correspond to one of the analysis that were performed
for a = 1:1:length(EQdir)
    for ii = 1:1:length(EQfac)
        close all
        ii_in=ii;
        try
            CurrentAnalysis = strcat("This is the analysis with ground acceleration in direction ",EQdir(a)," and factor ",num2str(EQfac(ii)))
            %------------------------------------------------------------------
            analysisFolder = 'C:\Users\aline\OneDrive\Dokumente\EPFL\12_Master_Thesis\08_OpenSees_Model';
            cd (analysisFolder)
            Results = strcat("C:\Users\aline\OneDrive\Dokumente\EPFL\12_Master_Thesis\08_OpenSees_Model\results_EQdir",EQdir(a),"_EQfac",num2str(EQfac(ii)));
            addpath(Results);
            
            % Import of workspace variables from the analyses
            workspace = strcat("ParishHouse_EQdir", EQdir(a), "_EQfac", num2str(EQfac(ii)),".mat");
            load(workspace);
            load("modelParameters.mat")
            
            ii=ii_in;
            %% Calculate max drifts

            % When activated, this code gives graphs showing the maximum
            % absolute drifts of all the piers or spandrels for a specific
            % wall.

            % plotDriftStats(analysis,wall_1_piers,"Wall 1 piers", "Pier",Results)
            % plotDriftStats(analysis,wall_2_piers,"Wall 2 piers", "Pier",Results)
            % plotDriftStats(analysis,wall_3_piers,"Wall 3 piers", "Pier",Results)
            % plotDriftStats(analysis,wall_4_piers,"Wall 4 piers", "Pier",Results)
            % plotDriftStats(analysis,wall_5_piers,"Wall 5 piers", "Pier",Results)
            % plotDriftStats(analysis,wall_6_piers,"Wall 6 piers", "Pier",Results)
            % plotDriftStats(analysis,wall_7_piers,"Wall 7 piers", "Pier",Results)
            % plotDriftStats(analysis,wall_8_piers,"Wall 8 piers", "Pier",Results)
            % plotDriftStats(analysis,wall_9_piers,"Wall 9 piers", "Pier",Results)
            % plotDriftStats(analysis,wall_10_piers,"Wall 10 piers", "Pier",Results)
            % 
            % plotDriftStats(analysis,wall_1_spandrels,"Wall 1 spandrels", "Spandrel",Results)
            % plotDriftStats(analysis,wall_2_spandrels,"Wall 2 spandrels", "Spandrel",Results)
            % plotDriftStats(analysis,wall_3_spandrels,"Wall 3 spandrels", "Spandrel",Results)
            % plotDriftStats(analysis,wall_4_spandrels,"Wall 4 spandrels", "Spandrel",Results)
            % plotDriftStats(analysis,wall_1_spandrels,"Wall 5 spandrels", "Spandrel",Results)
            % plotDriftStats(analysis,wall_2_spandrels,"Wall 6 spandrels", "Spandrel",Results)
            % plotDriftStats(analysis,wall_3_spandrels,"Wall 7 spandrels", "Spandrel",Results)
            % plotDriftStats(analysis,wall_4_spandrels,"Wall 8 spandrels", "Spandrel",Results)
            % plotDriftStats(analysis,wall_3_spandrels,"Wall 9 spandrels", "Spandrel",Results)
            % plotDriftStats(analysis,wall_4_spandrels,"Wall 10 spandrels", "Spandrel",Results)

            %% Plot analyses (3D)

            % The code for the 3D visualisation of the deformation during
            % the dynamic analysis has been written by Dr. Igor Tomic and
            % implemented in this script using the function "plotAnalysis"

            cd (analysisFolder)
            addpath('Tremuri_import_and_plot_functions');
            load(modelFile);
            eval(['model = ',modelFile(1:end-4),';']);
            load('inputFiles.mat');

            % % Plots model shape
            % DriftType='D'
            % DriftLimit=1
            % plotAnalysis(model, analysis(3),DriftType,DriftLimit)
            % title ("Modal shapes");
           
            % % Plots self weight deformed shape
            % DriftType='D'
            % DriftLimit=1
            % plotAnalysis(model, analysis(2),DriftType,DriftLimit)
            % title ("Self-weight - deformed shape");

            % % Plots flexural drift
            % DriftType='F'
            % DriftLimit=0.012
            % plotAnalysis(model, analysis(4),DriftType,DriftLimit)
            % title("Flexural drifts");
            % 
            % % Plots shear drift
            % DriftType='S'
            % DriftLimit=0.009
            % plotAnalysis(model, analysis(4),DriftType,DriftLimit)
            % title ("Shear drifts");

            %% Calculate the total mass of the building
            % This part can be used to verify the loads and masses of the
            % system.

            % M_tot=0;
            % for i=1:1:length(support_nodes)
            %     M_tot=M_tot+analysis(2).node(support_nodes(i)).Fz;
            % end
            % M_tot = M_tot/9.81;
            %
            % %Wall 1 masses
            % M_1=0;
            % for i=1:1:length(sn_W1)
            %     M_1=M_1+analysis(2).node(sn_W1(i)).Fz;
            % end
            % M_1 = M_1/9.81;
            %
            % %Wall 2 masses
            % M_2=0;
            % for i=1:1:length(sn_W2)
            %     M_2=M_2+analysis(2).node(sn_W2(i)).Fz;
            % end
            % M_2 = M_2/9.81;
            %
            % %Wall 3 masses
            % M_3=0;
            % for i=1:1:length(sn_W3)
            %     M_3=M_3+analysis(2).node(sn_W3(i)).Fz;
            % end
            % M_3 = M_3/9.81;
            %
            % %Wall 4 masses
            % M_4=0;
            % for i=1:1:length(sn_W4)
            %     M_4=M_4+analysis(2).node(sn_W4(i)).Fz;
            % end
            % M_4 = M_4/9.81;
            %
            % %Wall 5 masses
            % M_5=0;
            % for i=1:1:length(sn_W5)
            %     M_5=M_5+analysis(2).node(sn_W5(i)).Fz;
            % end
            % M_5 = M_5/9.81;
            %
            % %Wall 6 masses
            % M_6=0;
            % for i=1:1:length(sn_W6)
            %     M_6=M_6+analysis(2).node(sn_W6(i)).Fz;
            % end
            % M_6 = M_6/9.81;
            %
            % %Wall 7 masses
            % M_7=0;
            % for i=1:1:length(sn_W7)
            %     M_7=M_7+analysis(2).node(sn_W7(i)).Fz;
            % end
            % M_7 = M_7/9.81;
            %
            % %Wall 8 masses
            % M_8=0;
            % for i=1:1:length(sn_W8)
            %     M_8=M_8+analysis(2).node(sn_W8(i)).Fz;
            % end
            % M_8 = M_8/9.81;
            %
            % %Wall 9 masses
            % M_9= analysis(2).node(sn_W9).Fz;
            % M_9 = M_9/9.81;
            %
            % %Wall 10 masses
            % M_10=analysis(2).node(sn_W10).Fz;
            % M_10 = M_10/9.81;
            %% Mean roof displacement vs. base shear

            % Calculate the average roof displacement
            Max_rdx=[];
            Max_rdy=[];
            Rdx=[0];
            Rdy=[0];
            maxDispX=0;
            maxDispY=0;
            minDispX=0;
            minDispY=0;
            
            for i=1:1:length(roofnodes)
                Rdx=Rdx+analysis(4).node(roofnodes(i)).u;
                Rdy=Rdy+analysis(4).node(roofnodes(i)).v;
                if max(analysis(4).node(roofnodes(i)).u)>=maxDispX
                    maxDispX=max(analysis(4).node(roofnodes(i)).u);
                end
                if min(analysis(4).node(roofnodes(i)).u)<=minDispX
                    minDispX=min(analysis(4).node(roofnodes(i)).u);
                end
                if max(analysis(4).node(roofnodes(i)).v)>=maxDispY
                    maxDispY=max(analysis(4).node(roofnodes(i)).v);
                end
                if min(analysis(4).node(roofnodes(i)).v)<=minDispY
                    minDispY=min(analysis(4).node(roofnodes(i)).v);
                end
            end
            Rdx=1000*Rdx/length(roofnodes);
            Rdy=1000*Rdy/length(roofnodes);
            maxDispX=1000*maxDispX
            maxDispY=1000*maxDispY
            minDispX=1000*minDispX
            minDispY=1000*minDispY


            % Calculate the total base shear
            
            BaseShearX=0;
            BaseShearY=0;
            for i=1:1:length(basenodes)
                BaseShearX=BaseShearX+analysis(4).node(basenodes(i)).Fx;
                BaseShearY=BaseShearY+analysis(4).node(basenodes(i)).Fy;
            end
            BaseShearX=BaseShearX/-1000;
            BaseShearY=BaseShearY/-1000;
            maxBaseShearX=max(BaseShearX)
            maxBaseShearY=max(BaseShearY)
            minBaseShearX=min(BaseShearX)
            minBaseShearY=min(BaseShearY)



            % PLOT ROOF DISPLACEMENT - BASE SHEAR
            
            figure;
            plot (Rdx,BaseShearX);
            % title ("Average roof displacement to total base shear x-direction");
            xlabel("\delta_{mean,X}  [mm]");
            ylabel ("V_{d,tot,X} [kN]");
            fileName1 = strcat('BaseShearVSRoofDispX_',num2str(EQfac(ii)),EQdir(a),'.png'); % Specify the filename for saving the PNG file
            baseShearXPath = fullfile(Results, fileName1); % Combine the location and filename
            saveas(gcf, baseShearXPath, 'png'); % Save the figure as a PNG file


            figure;
            plot (Rdy,BaseShearY);
            % title ("Average roof displacement to total base shear y-direction");
            xlabel("\delta_{mean,Y}  [mm]");
            ylabel ("V_{d,tot,Y} [kN]");

            fileName2 = strcat('BaseShearVSRoofDispY_',num2str(EQfac(ii)),EQdir(a),'.png'); % Specify the filename for saving the PNG file
            baseShearYPath = fullfile(Results, fileName2); % Combine the location and filename
            saveas(gcf, baseShearYPath, 'png'); % Save the figure as a PNG file

            %% Max roof displacement vs. base shear

            % Calculate the maximum roof displacement
            Rdx_max=[0];
            Rdy_max=[0];
            u_ref = 0;
            v_ref = 0;

            for i=1:1:length(roofnodes)
                u = max(abs(analysis(4).node(roofnodes(i)).u));
                v = max(abs(analysis(4).node(roofnodes(i)).v));
                if EQdirection(iii)==1
                    if u > u_ref
                        u_ref = u;
                        Rdx_max = analysis(4).node(roofnodes(i)).u;
                        Rdy_max = analysis(4).node(roofnodes(i)).v;
                    end
                elseif EQdirection(iii)==2
                    if v > v_ref
                        v_ref = u;
                        Rdx_max = analysis(4).node(roofnodes(i)).u;
                        Rdy_max = analysis(4).node(roofnodes(i)).v;
                    end
                end
            end
            Rdx_max=1000*Rdx_max;
            Rdy_max=1000*Rdy_max;

            % PLOT MAX ROOF DISPLACEMENT - TOTALBASE SHEAR

            figure;
            plot (Rdx_max,BaseShearX);
            % title ("Maximum roof displacement to total base shear x-direction");
            xlabel("\delta_{max,X}  [mm]");
            ylabel ("V_{d,tot,X} [kN]");

            fileName1 = strcat('BaseShearVSMaxRoofDispX_',num2str(EQfac(ii)),EQdir(a),'.png'); % Specify the filename for saving the PNG file
            baseShearXPath = fullfile(Results, fileName1); % Combine the location and filename
            saveas(gcf, baseShearXPath, 'png'); % Save the figure as a PNG file


            figure;
            plot (Rdy_max,BaseShearY);
            % title ("Maximum roof displacement to total base shear y-direction");
            xlabel("\delta_{max,Y}  [mm]");
            ylabel ("V_{d,tot,Y} [kN]");

            fileName2 = strcat('BaseShearVSMaxRoofDispY_',num2str(EQfac(ii)),EQdir(a),'.png'); % Specify the filename for saving the PNG file
            baseShearYPath = fullfile(Results, fileName2); % Combine the location and filename
            saveas(gcf, baseShearYPath, 'png'); % Save the figure as a PNG file
        catch
        end
    end
end






