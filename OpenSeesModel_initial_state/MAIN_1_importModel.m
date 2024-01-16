%% Matlab script to import the Tremuri model parameters and visualize the model
% Author: Dr. Igor Tomic
% Date latest version: 2023
% Project: Master Thesis, Parish House St. Lawrence church Petrinja, Croatia
% clc
clear all
close all

% creates the 3d model of the Basel building starting from the Tremuri model
addpath('C:\Users\aline\OneDrive\Dokumente\EPFL\12_Master_Thesis\08_OpenSees_Model\Tremuri_import_and_plot_functions');

modelTremuri = readTremuriInput('parish_house_3.txt');
modelOpensees = convertTremuriToOpenSees(modelTremuri);
%%
figure; hold on;
drawModelTremuri(modelTremuri, 'ColorPiers', [0.8 0 0], 'ColorSpandrels', [0 0 0.8], 'styleNodes', 'sk')
axis equal
axis off
view( -30,   40);

figure; hold on;
drawModel(modelOpensees, 'ColorPiers', [0.8 0 0], 'ColorSpandrels', [0 0 0.8], 'styleNodes', 'sk', 'floors', true, 'ColorBeams', [1 1 1]*0.35, 'sizeBeams', 0.35);
axis equal
axis off
view( -30,   40);

save('modelTremuri.mat', 'modelTremuri');
save('modelOpensees.mat', 'modelOpensees');


       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       