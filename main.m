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
lb = [-320; -240; -180; 0.75; 0.75];
ub = [320; 240; 180; 1.25; 1.25];
% NOTE: Run 'parpool' or 'parpool('local')' when 'UseParallel' is set to 'true' (when parallel pools aren't set in settings to create automatically)
optimizationOptions = optimoptions('ga', 'Display', 'off', 'MaxGenerations', 10, 'PopulationSize', 100, 'UseParallel', true, 'UseVectorized', false);
% run the ga algorithm for every letter and every person
for i=1:letterNum
    disp("Letter: "+templateNames{i});
    properlyRecognizedLettersCount = 0;
    for j=1:personsNum
        fitnessFunLambda = @(X) fitnessFun(X, unknownClouds{i,j}, templateClouds);
        rng default;
        [Xmin, Jmin] = ga(fitnessFunLambda, length(lb), [], [], [], [], lb, ub, [], [], optimizationOptions);
        [~, ~, winingTemplateIndex] = fitnessFun(Xmin, unknownClouds{i,j}, templateClouds);
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
%% count the whole accuracy
wholeAccuracy = (allProperlyRecognizedLettersCount/(letterNum*personsNum))*100;
%disp("letter acc:"+letterRecognitionAccuracy);
%disp("whole acc: "+wholeAccuracy);
%% save results to .xlsx file
fileName = "results.xlsx"; %delete(fileName);
nextFileName = getNextFileName(fileName);
saveResults(nextFileName, string(templateNames), personsNum, recognizedLetters, [letterRecognitionAccuracy; wholeAccuracy]);
%% save confusion matrix to .xlsx file
fileName = "confusionMatrix.xlsx"; %delete(fileName);
nextFileName = getNextFileName(fileName);
saveConfusionMatrix(nextFileName, string(templateNames), recognizedLetters, true);
disp("---- End of script ----");