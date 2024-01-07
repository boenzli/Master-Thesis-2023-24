clc
clear all
close all
%% Matlab script to establish basic properties for postprocessing
% Author: Aline Bönzli
% Date: 12.12.2023
% Project: Master Thesis, Parish House St. Lawrence church Petrinja

analysisFolder = 'C:\Users\aline\OneDrive\Dokumente\EPFL\12_Master_Thesis\08_OpenSees_Model';
cd (analysisFolder)
%% Set basic node numbers

% Node numbers of the walls
wall_1_nodes = [1:9 11:18];
wall_2_nodes = [19:27 61 65 69];
wall_3_nodes = [28:39 72 75 78];
wall_4_nodes = [40:42 58 62 66 81 84 87];
wall_5_nodes = [43:51 71 74 77 88:90];
wall_6_nodes = [59 63 67 80 83 86 91 94 97];
wall_7_nodes = [52:54 60 64 68 79 82 85 93 96 99];
wall_8_nodes = [100:102 70 73 76];
wall_9_nodes = [55 56 57];
wall_10_nodes = [92 95 98];

wall_all_nodes = {wall_1_nodes, wall_2_nodes, wall_3_nodes, wall_4_nodes, wall_5_nodes, wall_6_nodes, wall_7_nodes, wall_8_nodes, wall_9_nodes, wall_10_nodes};

% Other node numbers
fictitious_node_nums = 1301:1315;

% Support nodes
support_nodes = [13 66 14 67 15 16 17 68 18 69 25 76 26 77 27 78 36 85 37 38 38 86 39 87 42 90 49 97 50 98 51 99 54 102 57 55 56];

sn_W1 = [13 14 15 16 17 18];
sn_W2 = [69 25 26 27];
sn_W3 = [78 36 37 38 39];
sn_W4 = [87 42 66];
sn_W5 = [90 49 50 51 77];
sn_W6 = [67 97 86];
sn_W7 = [68 54 99 85];
sn_W8 = [102 76];
sn_W9 = 57;
sn_W10 = 98;

% Roof nodes
roofnodes = [1 2 3 5 6 61 19 20 21 72 28 29 30 31 81 40 58 88 43 44 45 71 59 91 80 60 52 93 79 100 70 92];

% Base nodes
basenodes = [13:18 25:27 36:39 42 49:51 54 57 66 67:69 76:78 85:87 90 97:99 102];

%% Set basic element numbers

% Element numbers of the piers of the walls
wall_1_piers = [5:7 9 10 15:20];
wall_2_piers = [28:30 34:36];
wall_3_piers = [42:46 51:55];
wall_4_piers = [62:64 67:69];
wall_5_piers = [75:79 83:87];
wall_6_piers = [90:92 95:97];
wall_7_piers = [101:104 108:111];
wall_8_piers = [113 114 116 117];
wall_9_piers = [118 119];
wall_10_piers = [120 121];

wall_X_piers = {wall_1_piers, wall_3_piers, wall_5_piers, wall_8_piers};
wall_Y_piers = {wall_2_piers, wall_4_piers, wall_6_piers, wall_7_piers, wall_9_piers, wall_10_piers};
wall_all_piers = {wall_1_piers, wall_2_piers, wall_3_piers, wall_4_piers, wall_5_piers, wall_6_piers, wall_7_piers, wall_8_piers, wall_9_piers, wall_10_piers};

%Element numbers of the spandrels of the walls
wall_1_spandrels = [1:4 11:14 21:24];
wall_2_spandrels = [25 26 31 32 37];
wall_3_spandrels = [38:41 47:50 56:59];
wall_4_spandrels = [60 61 65 66 70 71];
wall_5_spandrels = [72:74 80:82];
wall_6_spandrels = [88 89 93 94];
wall_7_spandrels = [98:100 105:107];
wall_8_spandrels = [112 115];

wall_X_spandrels = {wall_1_spandrels, wall_3_spandrels, wall_5_spandrels, wall_8_spandrels};
wall_Y_spandrels = {wall_2_spandrels, wall_4_spandrels, wall_6_spandrels, wall_7_spandrels};
wall_all_spandrels = {wall_1_spandrels, wall_2_spandrels, wall_3_spandrels, wall_4_spandrels, wall_5_spandrels, wall_6_spandrels, wall_7_spandrels, wall_8_spandrels};

wall_all_elems = 1:121;
%% Save results
fname="modelParameters";
save(fname,'-v7.3');
cd ("C:\Users\aline\OneDrive\Dokumente\EPFL\12_Master_Thesis\08_OpenSees_Model")
