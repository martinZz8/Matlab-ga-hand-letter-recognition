%% settings
close all;
clear;
clc;
%% load templates
tempFolderName = "templates/";
tempCloudNames = [
    tempFolderName+"aSkeleton.txt";
    tempFolderName+"bSkeleton.txt";
    tempFolderName+"cSkeleton.txt";
    tempFolderName+"dSkeleton.txt";
    tempFolderName+"eSkeleton.txt";
    tempFolderName+"fSkeleton.txt";
    tempFolderName+"hSkeleton.txt";
    tempFolderName+"iSkeleton.txt";
    tempFolderName+"lSkeleton.txt";
    tempFolderName+"mSkeleton.txt";
    tempFolderName+"nSkeleton.txt";
    tempFolderName+"oSkeleton.txt";
    tempFolderName+"pSkeleton.txt";
    tempFolderName+"rSkeleton.txt";
    tempFolderName+"wSkeleton.txt";
    tempFolderName+"ySkeleton.txt";
    ];
templateClouds = cell(size(tempCloudNames));
templatesCloudsLength = numel(templateClouds);
for i=1:templatesCloudsLength
    templateClouds{i}=shiftCloud(loadSkeleton(tempCloudNames(i)));
end
templateNames = { ...
    'A'; ...
    'B'; ...
    'C'; ...
    'D'; ...
    'E'; ...
    'F'; ...
    'H'; ...
    'I'; ...
    'L'; ...
    'M'; ...
    'N'; ...
    'O'; ...
    'P'; ...
    'R'; ...
    'W'; ...
    'Y'; ...
    };
%% get point cloud of every letter and every person
% don't initialize (or change the number) 'unknownClouds' when number of persons in each dataset/letter folders are other than 10
unknownClouds = cell(templatesCloudsLength,10);
datasetLocation = "dataset/";
for i=1:templatesCloudsLength
    datasetLocationLetter = datasetLocation+templateNames{i}+"/";
    d = dir(datasetLocationLetter+"*.txt");
    %disp("letter: "+templateNames{i});
    for j=1:length(d)
        fileName = convertCharsToStrings(d(j).name);
        unknownCloud = loadSkeleton(datasetLocationLetter+fileName);
        personNum = getPersonNum(fileName);
        %disp(personNum);
        unknownClouds{i,personNum} = shiftCloud(unknownCloud);
    end
end
%% define & solve optmization problem for every letter and every person; also count the accuracy for every letter
% specify the recognizedLetters string matrix
[letterNum, personsNum] = size(unknownClouds);
recognizedLetters = string(zeros(letterNum,personsNum));
letterRecognitionAccuracy = zeros(letterNum,1);
allProperlyRecognizedLettersCount = 0;
% options for ga algorithm
%lb = [-320; -240; -180; 0.75; 0.75];
%ub = [320; 240; 180; 1.25; 1.25];
lb = [-160; -170; -90; 0.75; 0.75];
ub = [160; 170; 90; 1.25; 1.25];
maxGenerations = 10;
populationSize = 100;
metric = "manhattan";
keyFuncSet = ["manhattan", "euclidean"];
valueFuncSet = {
    @(X, uc, tc) fitnessFun1(X, uc, tc);
    @(X, uc, tc) fitnessFun2(X, uc, tc);
};
metricMap = containers.Map(keyFuncSet,valueFuncSet);
% additional ga options
initPopMtx = [0, 0, 0, 1, 1]; %'InitialPopulationMatrix', initPopMtx
%'SelectionFcn', 'selectiontournament' | 'selectionroulette'
% NOTE: Run 'parpool' or 'parpool('local')' when 'UseParallel' is set to 'true' (when parallel pools aren't set in settings to create automatically)
optimizationOptions = optimoptions( ...
    'ga', ...
    'Display', 'off', ...
    'MaxGenerations', maxGenerations, ...
    'PopulationSize', populationSize, ...
    'UseParallel', true, ...
    'UseVectorized', false, ...
    'InitialPopulationMatrix', initPopMtx, ...
    'SelectionFcn', 'selectiontournament' ...
);
% run the ga algorithm for every letter and every person (with specified metric)
fitnessFunHandle = metricMap(metric);
% start the timer
tStart = tic;
for i=1:letterNum
    disp("Letter: "+templateNames{i});
    properlyRecognizedLettersCount = 0;
    for j=1:personsNum
        % OLD
        %fitnessFunLambda = @(X) fitnessFun1(X, unknownClouds{i,j}, templateClouds);
        fitnessFunLambda = @(X) fitnessFunHandle(X, unknownClouds{i,j}, templateClouds);
        rng default;
        [Xmin, Jmin] = ga(fitnessFunLambda, length(lb), [], [], [], [], lb, ub, [], [], optimizationOptions);
        % OLD
        %[~, ~, winingTemplateIndex] = fitnessFun1(Xmin, unknownClouds{i,j}, templateClouds);
        [~, ~, winingTemplateIndex] = fitnessFunHandle(Xmin, unknownClouds{i,j}, templateClouds);
        recognizedClass = templateNames{winingTemplateIndex, 1};
        recognizedLetters(i,j) = recognizedClass;
        if recognizedClass == templateNames{i}
            properlyRecognizedLettersCount = properlyRecognizedLettersCount + 1;
        end
        %disp(templateNames{i}+") Recognized class: "+recognizedClass);
    end
    letterRecognitionAccuracy(i) = (properlyRecognizedLettersCount/personsNum)*100;
    allProperlyRecognizedLettersCount = allProperlyRecognizedLettersCount + properlyRecognizedLettersCount;
end
%% stop the timer and print time results
tEnd = toc(tStart);
tEndMin = floor(tEnd / 60);
tEndSec = floor(mod(tEnd, 60));
elapsedTimeStr = "Elapsed time: "+tEndMin+" min "+tEndSec+" sec; In seconds: "+tEnd+" sec";
disp(elapsedTimeStr);
%% count the whole accuracy
wholeAccuracy = (allProperlyRecognizedLettersCount/(letterNum*personsNum))*100;
%disp("letter acc:"+letterRecognitionAccuracy);
%disp("whole acc: "+wholeAccuracy);
%% prepare folder for saving results
disp("Saving results to files");
% if you want to write to current directory - set 'isArchiveDir' to false (boolean value)
isArchiveDir = false;
description =   "gen="+maxGenerations+...
                "_pop="+populationSize+...
                "_metric="+metric;
folderName = description;
parentFolderName = "archive";
if isArchiveDir
    mkdir(parentFolderName, folderName);
end
%% save results to .xlsx file
currentFolderName = "";
if isArchiveDir
    currentFolderName = parentFolderName+"/"+folderName;
end
fileName = "results.xlsx"; %delete(fileName);
fileNameToSave = getProperFileName(fileName, currentFolderName);
saveResults(fileNameToSave, string(templateNames), personsNum, recognizedLetters, [letterRecognitionAccuracy; wholeAccuracy], description, elapsedTimeStr);
%% save confusion matrix to .xlsx file
fileName = "confusionMatrix.xlsx"; %delete(fileName);
fileNameToSave = getProperFileName(fileName, currentFolderName);
saveConfusionMatrix(fileNameToSave, string(templateNames), recognizedLetters, true, description, elapsedTimeStr);
disp("---- End of script ----");