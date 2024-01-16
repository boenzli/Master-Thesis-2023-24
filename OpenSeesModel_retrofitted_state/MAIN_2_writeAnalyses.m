%% Matlab script to transform the Tremuri model into an OpenSees model
% Author: Dr. Igor Tomic
% Date latest version: 15.01.2024
% Project: Master Thesis, Parish House St. Lawrence church Petrinja, Croatia

clc
close all
clear all

%% options
%%%% change this to the folder where you have Opensees.exe and Macroelement3d.ddl
analysisFolder = 'C:\Users\aline\OneDrive\Dokumente\EPFL\12_Master_Thesis\13_RetrofittedModel';  
addpath('Tremuri_import_and_plot_functions');
% the project name gives the name to the tcl files
projectName = 'Parish_house_3';  

% file containing all information of the model (must contain the model in a variable
% with the same name)
modelFile = 'modelOpensees.mat';


%% load files
% addpath('Tremuri_import_and_plot_functions');
load(modelFile);
eval(['model = ',modelFile(1:end-4),';']);


%% make directories for input and output
currentDir = pwd;
if ~exist('inputFiles', 'dir')
    mkdir('inputFiles');
end
if ~exist('outputFiles', 'dir')
    mkdir('outputFiles');
end
cd('outputFiles');
if ~exist('Modal', 'dir')
    mkdir('Modal');
end
cd('..');

%% write input files and keep track of them
inputFiles = writeOpenseesTcl(model, 'ignoreDrift', 1, 'projectName', projectName, 'massDistribution', 'Standard', ...
    'inputPath', [currentDir, '\inputFiles'], 'outputPath', [currentDir, '\outputFiles'], 'wallToWallConnection', '1 2 3 4 5 6', 'floorToWallConnection', '1 2 3 4 5 6');

save('inputFiles.mat', 'inputFiles');



