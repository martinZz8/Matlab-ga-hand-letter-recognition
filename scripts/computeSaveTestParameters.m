% Example invocations:
% OpenPose: computeSaveTestParameters("BO10:BS14", "BW19:CA23", false)
% MediaPipe: computeSaveTestParameters("...", "...", true)
function [] = computeSaveTestParameters(effectivenessRange, timeRange, useMediaPipe)
    % n, sum and NaNCounter computation function
    function [n, sum, nanCounter] = computeNSumNanCounter(mtx)
        [rowSize, colSize] = size(mtx);
        n = 0;
        sum = 0;
        for i=1:rowSize
            for j=1:colSize
                if (~isnan(mtx(i,j)))
                    n = n + 1;
                    sum = sum + mtx(i,j);
                end
            end
        end
        nanCounter = (rowSize*colSize) - n;
    end
    % median computation function
    function [median] = computeMedian(mtx, n)
        srotedVc = sort(mtx(:));
        if (bitand(n, 1) == 0) % check if 'n' is even (like 'n%2==0')
            idx1 = n/2;
            idx2 = idx1 + 1;
            median = (srotedVc(idx1) + srotedVc(idx2))/2;
        else
            idx1 = (n+1)/2;
            median = srotedVc(idx1);
        end
    end
    % standard deviation computation function
    function [stDev] = computeStandardDeviation(mtx, mean)
        [rowSize, colSize] = size(mtx);
        diffSum = 0;
        pN = 0;
        for i=1:rowSize
            for j=1:colSize
                if (~isnan(mtx(i,j)))
                    toAdd = (mtx(i,j) - mean)^2;
                    diffSum = diffSum + toAdd;
                    pN = pN + 1;
                end
            end
        end
        stDev = sqrt(diffSum/pN);
    end
	%% Constants
    searchInDirName_ = "archive/particle_swarm/OpenPose/1";
    if useMediaPipe == true
        searchInDirName_ = "archive/particle_swarm/MediaPipe/1";
    end
    %% Read data from .xlsx file
    fileReadPath = searchInDirName_+"/RESULTS1.xlsx";
	strEff = readmatrix(fileReadPath, 'Range', effectivenessRange, 'OutputType','string');
    strTm = readmatrix(fileReadPath, 'Range', timeRange, 'OutputType','string');
    % Parse red data to double (and discard dashes)
    dEff = str2double(strEff);
    dTm = str2double(strTm);
    %% Compute effectiveness values
    % Min
    minEff = min(dEff, [], 'all');
    % Max
    maxEff = max(dEff, [], 'all');
    % Mean
    [n, sum, ~] = computeNSumNanCounter(dEff);
    meanEff = sum/n;
    % Median
    medianEff = computeMedian(dEff, n);
    % Standard deviation
    stDevEff = computeStandardDeviation(dEff, meanEff);
    %% Compute time values
    % Min
    minTm = min(dTm, [], 'all');
    % Max
    maxTm = max(dTm, [], 'all');
    % Mean
    [n, sum, ~] = computeNSumNanCounter(dTm);
    meanTm = sum/n;
    % Median
    medianTm = computeMedian(dTm, n);
    % Standard deviation
    stDevTm = computeStandardDeviation(dTm, meanTm);
    %% Save data to .txt file
    fileWritePath = searchInDirName_+"/computedVals.txt";
    % Create effectiveness description
    effDesc = "Effectiveness: min="+minEff+", max="+maxEff+", mean="+round(meanEff, 2)+", median="+round(medianEff, 2)+", stDev="+round(stDevEff, 2);
    disp(effDesc);
    % Create time description
    tmDesc = "Times: min="+minTm+", max="+maxTm+", mean="+round(meanTm, 2)+", median="+round(medianTm, 2)+", stDev="+round(stDevTm, 2);
    disp(tmDesc);
    % Write descriptions to specified file
    writelines([effDesc, tmDesc], fileWritePath);
    disp("Done!");
end