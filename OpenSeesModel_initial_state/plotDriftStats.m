function plotDriftStats(analysis,elements,ElementName,ElementType,Results)
% plotDriftStats Plots the maximum different drifts of a set of elements 
%   This function plots the maximum shear, flexural and total drift of a
%   for each element part of the set "elements". It will also retrurn the
%   plotted maximum drifts. The plots indicate the element with the maximum
%   drift as well as the elements that present a dirft above their drift
%   limit, meaning that they yielded.
%   analysis = processed analysis data
%   elements = array containing the relevant array numbers
%   ElementName = string telling at what part of the building we are
%                 looking (example: "Wall 1")
%   ElementType = string telling whether the elements are "piers" or
%                 "spandrels"

maxdriftF_wall = zeros(1,length(elements));     % To store the max flexural drifts for each element
maxdriftS_wall = zeros(1,length(elements));     % To store the max shear drifts for each element
maxdriftT_wall = zeros(1,length(elements));     % To store the max total drifts for each element

mindriftF_wall = zeros(1,length(elements));     % To store the min flexural drifts for each element
mindriftS_wall = zeros(1,length(elements));     % To store the min shear drifts for each element
mindriftT_wall = zeros(1,length(elements));     % To store the min total drifts for each element

maxAbsdriftF_wall = zeros(1,length(elements));  % To store the max absolute flexural drifts for each element
maxAbsdriftS_wall = zeros(1,length(elements));  % To store the max absolute shear drifts for each element
maxAbsdriftT_wall = zeros(1,length(elements));  % To store the max absolute total drifts for each element
labels_wall = strings(1,length(elements));      % To store the plotting labels for each element

for j = 1:1:length(elements)
    labels_wall(j) = strcat(ElementType," ",num2str(elements(j)));

    % Extraction of the drifts of element i from the output values of the analysis
    driftF = analysis(4).element(elements(j)).driftF*100;
    dirftS = analysis(4).element(elements(j)).driftS*100;
    driftTot = driftF + dirftS;
    
    % Finding the maximum of each drift for the given element i
    maxdriftF = max(driftF);
    maxdriftS = max(dirftS);
    maxdriftT = max(driftTot);
    % Storing the maximum drifts in the summary vector of maximum drifts
    maxdriftF_wall(j) = maxdriftF ;
    maxdriftS_wall(j) = maxdriftS ;
    maxdriftT_wall(j) = maxdriftT ;

    % Finding the minimum of each drift for the given element j
    mindriftF = min(driftF);
    mindriftS = min(dirftS);
    mindriftT = min(driftTot);
    % Storing the minimum drifts in the summary vector of minimum drifts
    mindriftF_wall(j) = mindriftF ;
    mindriftS_wall(j) = mindriftS ;
    mindriftT_wall(j) = mindriftT ;

    % Finding the maximum absolute value of each drift for the given element j
    maxAbsdriftF = max(abs(driftF));
    maxAbsdriftS = max(abs(dirftS));
    maxAbsdriftT = max(abs(driftTot));
    
    % Storing the maximum absolute drifts in the summary vector of maximum absolute drifts
    maxAbsdriftF_wall(j) = maxAbsdriftF ;
    maxAbsdriftS_wall(j) = maxAbsdriftS ;
    maxAbsdriftT_wall(j) = maxAbsdriftT ;
    
end
ylimit = max(maxAbsdriftT_wall);

% Plotting the maximum absolute drift values
figure()
subplot(2,1,1)
    bar(labels_wall,maxAbsdriftF_wall)
    hold on
    [maxValue, maxIndex] = max(maxAbsdriftF_wall);
    bar(labels_wall(maxIndex),maxValue,'y')
    title (strcat("Maximum absolute flexure drifts of ",ElementName));
    ylabel ("Drift [%]");
    ylim([0,ylimit])
subplot(2,1,2)
    bar(labels_wall,maxAbsdriftS_wall)
    hold on
    [maxValue, maxIndex] = max(maxAbsdriftS_wall);
    bar(labels_wall(maxIndex),maxValue,'y')
    title (strcat("Maximum absolute shear drifts of ",ElementName));
    ylabel ("Drift [%]");     
    ylim([0,ylimit])
fileName = strcat('Flex_Shear_Drift_',ElementName,'.png'); % Specify the filename for saving the PNG file
baseShearYPath = fullfile(Results, fileName); % Combine the location and filename
saveas(gcf, baseShearYPath, 'png'); % Save the figure as a PNG file


% Plotting the stacked up absolute drifts
maxAbsdrift=cat(1, maxAbsdriftS_wall, maxAbsdriftF_wall);
figure()
bar(labels_wall,maxAbsdrift.','stacked')
title (strcat("Absolute drifts of ",ElementName));
ylabel ("Drift [%]");
legend('Absolute shear drift','Absolute flexure drift')

fileName = strcat('Total_Drift_',ElementName,'.png'); % Specify the filename for saving the PNG file
baseShearYPath = fullfile(Results, fileName); % Combine the location and filename
saveas(gcf, baseShearYPath, 'png'); % Save the figure as a PNG file


end