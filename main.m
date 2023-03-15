%% settings
close all;
clear;
clc;
% Change 'useMediaPipe' setting to 'true' or 'false'. It determines whether to use MediaPipe or OpenPose data.
useMediaPipe = false;
isArchiveDir = true;
%% load templates
tempFolderName = "templates/OpenPose/";
if useMediaPipe == true
    tempFolderName = "templates/MediaPipe/";
end
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
datasetLocation = "dataset/OpenPose/";
if useMediaPipe == true
    datasetLocation = "dataset/MediaPipe/";
end
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
% options for pt-ds algorithm
lb = [-320; -240; -180; 0.75; 0.75];
ub = [320; 240; 180; 1.25; 1.25];
% lb = [-160; -120; -90; 0.75; 0.75];
% ub = [160; 120; 90; 1.25; 1.25];
minSurrogatePointsVector = [10, 20, 40, 60, 80, 100, 120];
maxFunctionEvaluationsVector = [60, 100, 150, 250, 350];
metricVector = ["manhattan", "euclidean"];
keyFuncSet = ["manhattan", "euclidean"];
%initPointsMtx = [0, 0, 0, 1, 1]; %'InitialPoints', initPointsMtx
valueFuncSetChoose = {
    {
        @(X, uc, tc) fitnessFun1(X, uc, tc);
        @(X, uc, tc) fitnessFun2(X, uc, tc);
    };
    {
        @(X, uc, tc) fitnessFun1All(X, uc, tc);
        @(X, uc, tc) fitnessFun2All(X, uc, tc);
    }
};
valueFuncSet = valueFuncSetChoose{1};
if useMediaPipe == true
    valueFuncSet = valueFuncSetChoose{2};
end
metricMap = containers.Map(keyFuncSet,valueFuncSet);
for metric=metricVector
    fitnessFunHandle = metricMap(metric);
    for minSurrPoints=minSurrogatePointsVector
        for maxFunEvals=maxFunctionEvaluationsVector
            % BYPASS COND
            % ... Checking if results in specific folder are present (by checking only the number of elements inside specific folder)
            % Prepare parent folder name and inner folder name
            parentFolderName = "archive/surrogate/OpenPose/1"; %initial val: archive
            if useMediaPipe == true
                parentFolderName = "archive/surrogate/MediaPipe/1";
            end
            innerFolderName =   "minSurrPoints="+minSurrPoints+...
                                "_maxFunEvals="+maxFunEvals+...
                                "_metric="+metric;
            % NOTE: comment this condition if you want to redo the computations
            if isFolderCreatedNotEmpty(parentFolderName, innerFolderName)
               continue;
            end
            % START OF SPECIFIC SCRIPT
            % NOTE: Run 'parpool' or 'parpool('local')' when 'UseParallel' is set to 'true' (when parallel pools aren't set in settings to create automatically).
            disp("---- START of minSurrPoints=" + minSurrPoints + ";maxFunEvals=" + maxFunEvals + ";metric=" + metric + " script ----");
            allNumOfUsedPersons = 0;
            allProperlyRecognizedLettersCount = 0;
            % Prepare 'optimizationOptions' structure
            optimizationOptions = optimoptions( ...
                'surrogateopt', ...
                'Display', 'off', ...
                'PlotFcn', @plotfcn, ...
                'MinSurrogatePoints', minSurrPoints, ...
                'MaxFunctionEvaluations', maxFunEvals, ...
                'UseParallel', true, ...
                'UseVectorized', false ...
            );
            % start the timer
            tStart = tic;
            % run the patternsearch algorithm for every letter and every person
            for i=1:letterNum
                disp("Letter: "+templateNames{i});
                numOfUsedPersons = 0;
                properlyRecognizedLettersCount = 0;
                for j=1:personsNum
                    if ~isempty(unknownClouds{i,j})
                        fitnessFunLambda = @(X) fitnessFunHandle(X, unknownClouds{i,j}, templateClouds);
                        rng default;
                        [Xmin, Jmin] = surrogateopt(fitnessFunLambda, lb, ub, [], [], [], [], [], optimizationOptions);
                        [~, ~, winingTemplateIndex] = fitnessFunHandle(Xmin, unknownClouds{i,j}, templateClouds);
                        recognizedClass = templateNames{winingTemplateIndex, 1};
                        recognizedLetters(i,j) = recognizedClass;
                        numOfUsedPersons = numOfUsedPersons + 1;
                        if recognizedClass == templateNames{i}
                            properlyRecognizedLettersCount = properlyRecognizedLettersCount + 1;
                        end
                        %disp(templateNames{i}+") Recognized class: "+recognizedClass);
                    end
                end
                if numOfUsedPersons > 0
                    letterRecognitionAccuracy(i) = (properlyRecognizedLettersCount/numOfUsedPersons)*100;
                end
                allNumOfUsedPersons = allNumOfUsedPersons + numOfUsedPersons;
                allProperlyRecognizedLettersCount = allProperlyRecognizedLettersCount + properlyRecognizedLettersCount;
            end
            %% stop the timer and print time results
            tEnd = toc(tStart);
            tEndMin = floor(tEnd / 60);
            tEndSec = floor(mod(tEnd, 60));
            elapsedTimeStr = "Elapsed time: "+tEndMin+" min "+tEndSec+" sec; In seconds: "+tEnd+" sec";
            disp(elapsedTimeStr);
            %% count the whole accuracy
            wholeAccuracy = 0;
            if allNumOfUsedPersons > 0
                wholeAccuracy = (allProperlyRecognizedLettersCount/allNumOfUsedPersons)*100;
            end
            %disp("letter acc:"+letterRecognitionAccuracy);
            %disp("whole acc: "+wholeAccuracy);
            %% prepare folder for saving results
            disp("Saving results to files ...");
            % if you want to write to current directory - set 'isArchiveDir' to false (boolean value)
            description = innerFolderName;
            if isArchiveDir
                mkdir(parentFolderName, innerFolderName);
            end
            %% save results to .xlsx file
            currentFolderName = "";
            if isArchiveDir
                currentFolderName = parentFolderName+"/"+innerFolderName;
            end
            fileName = "results.xlsx"; %delete(fileName);
            fileNameToSave = getProperFileName(fileName, currentFolderName);
            saveResults(fileNameToSave, string(templateNames), personsNum, recognizedLetters, [letterRecognitionAccuracy; wholeAccuracy], description, elapsedTimeStr);
            %% save confusion matrix to .xlsx file
            fileName = "confusionMatrix.xlsx"; %delete(fileName);
            fileNameToSave = getProperFileName(fileName, currentFolderName);
            saveConfusionMatrix(fileNameToSave, string(templateNames), recognizedLetters, true, description, elapsedTimeStr);
            % END OF SPECIFIC SCRIPT
            disp("---- END of minSurrPoints=" + minSurrPoints + ";maxFunEvals=" + maxFunEvals + ";metric=" + metric + " script ----");
        end
    end 
end
disp("**---- END OF SCRIPT ----**");