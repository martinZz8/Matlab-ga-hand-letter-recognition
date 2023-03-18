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
recognizedLetters = strings(letterNum,personsNum); %string(zeros(letterNum,personsNum))
recognizedLetters(:,:) = "-";
letterRecognitionAccuracy = zeros(letterNum,1);
% options for pt-ds algorithm
x0 = [0, 0, 0, 1, 1];
lb = [-320; -240; -180; 0.75; 0.75];
ub = [320; 240; 180; 1.25; 1.25];
% lb = [-160; -120; -90; 0.75; 0.75];
% ub = [160; 120; 90; 1.25; 1.25];
maxFunctionEvaluationsVector = [200, 500, 1000, 2000, 2500];
maxIterationsVector = [10, 30, 50, 80, 100, 120];
pollMethodVector = ["GPSPositiveBasis2N", "GPSPositiveBasisNp1", "MADSPositiveBasis2N", "MADSPositiveBasisNp1", "OrthoMADSPositiveBasis2N", "OrthoMADSPositiveBasisNp1"];
pollOrderAlgorithmVector = ["Consecutive", "Random", "Success"]; %works only with GPS and GSS pollMethod
metricVector = ["manhattan", "euclidean"];
keyFuncSet = ["manhattan", "euclidean"];
%MeshExpansionFactor (double)
%MeshContractionFactor (double)
%AccelerateMesh (true, false)
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
    for maxFunEvals=maxFunctionEvaluationsVector
        for maxInterations=maxIterationsVector
            for pollMethod=pollMethodVector
                pollOrderAlgorithmCounter = 0;
                for pollOrderAlgorithm=pollOrderAlgorithmVector
                    % Prepare 'optimizationOptions' structure
                    optimizationOptions = optimoptions( ...
                        'patternsearch', ...
                        'Display', 'off', ...
                        'Algorithm', "classic", ...
                        'PollMethod', pollMethod, ...
                        'MaxFunctionEvaluations', maxFunEvals, ...
                        'MaxIterations', maxInterations, ...
                        'UseParallel', true, ...
                        'UseVectorized', false ...
                    );
                    % 1ST BYPASS COND (optional with adjusting 'optimizationOptions' structure)
                    % ... Check if pollMethod is 'GPS'. If so, set the 'PollOrderAlgorithm' option. Otherwise perform 'patternsearch' only once for vector 'pollOrderAlgorithmVector'.
                    if contains(pollMethod, "GPS")
                       optimizationOptions =  optimoptions(optimizationOptions, 'PollOrderAlgorithm', pollOrderAlgorithm);
                    else
                        if pollOrderAlgorithmCounter > 0
                            break;
                        end
                    end
                    pollOrderAlgorithmCounter = pollOrderAlgorithmCounter + 1;
                    % 2ND BYPASS COND
                    % ... Checking if results in specific folder are present (by checking only the number of elements inside specific folder)
                    % Prepare parent folder name and inner folder name
                    parentFolderName = "archive/pattern_search/OpenPose/1"; %initial val: archive
                    if useMediaPipe == true
                        parentFolderName = "archive/pattern_search/MediaPipe/1";
                    end
                    innerFolderName =   "funEv="+maxFunEvals+...
                                        "_maxIt="+maxInterations+...
                                        "_plM="+pollMethod+...
                                        "_plOA="+pollOrderAlgorithm+...
                                        "_metric="+metric;
                    % NOTE: comment this condition if you want to redo the computations
                    if isFolderCreatedNotEmpty(parentFolderName, innerFolderName)
                       continue;
                    end
                    % START OF SPECIFIC SCRIPT
                    % ... NOTE: Run 'parpool' or 'parpool('local')' when 'UseParallel' is set to 'true' (when parallel pools aren't set in settings to create automatically).
                    disp("---- START of maxFunEvals=" + maxFunEvals + ";maxIterations=" + maxInterations + ";poolMethod=" + pollMethod + ";poolOrderAlgorithm=" + pollOrderAlgorithm + ";metric=" + metric + " script ----");
                    allNumOfUsedPersons = 0;
                    allProperlyRecognizedLettersCount = 0;
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
                                [Xmin, Jmin] = patternsearch(fitnessFunLambda, x0, [], [], [], [], lb, ub, [], optimizationOptions);
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
                            letterRecognitionAccuracy(i) = round((properlyRecognizedLettersCount/numOfUsedPersons)*100, 2);
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
                        wholeAccuracy = round((allProperlyRecognizedLettersCount/allNumOfUsedPersons)*100, 2);
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
                    disp("---- END of maxFunEvals=" + maxFunEvals + ";maxIterations=" + maxInterations + ";poolMethod=" + pollMethod + ";poolOrderAlgorithm=" + pollOrderAlgorithm + ";metric=" + metric + " script ----");
                end
            end
        end
    end 
end
disp("**---- END OF SCRIPT ----**");