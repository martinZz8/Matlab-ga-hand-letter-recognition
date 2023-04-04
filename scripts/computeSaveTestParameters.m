% Example invocation: computeSaveTestParameters(C10:G14, K19:O23, false)
function [] = computeSaveTestParameters(effectivenessRange, timeRange, useMediaPipe)
    % n, sum and NaNCounter computation function
    function [n, sum, nanCounter] = computeNSumNanCounter(vc)
        n = 0;
        sum = 0;
        for singleEl=vc
            if ~isnan(singleEl)
                n = n + 1;
                sum = sum + singleEl;
            end
        end
        nanCounter = length(vc) - n;
    end
    % median computation function
    function [median] = computeMedian(vc, n, nanCounter)
        srotedVc = sort(vc(:));
        propN = n - nanCounter;
        if (bitand(propN, 1) == 0) % check if 'n' is even (like 'n%2==0')
            idx1 = propN/2;
            idx2 = idx1 + 1;
            median = (srotedVc(idx1) + srotedVc(idx2))/2;
        else
            idx1 = (propN+1)/2;
            median = srotedVc(idx1);
        end
    end
    % standard deviation computation function
    function [stDev] = computeStandardDeviation(vc, sum, n)
        diffSum = 0;
        for singleEl=vc
            toAdd = pow2(singleEl - sum);
            diffSum = diffSum + toAdd;
        end
        stDev = sqrt(diffSum/n); % use properN
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
    [n, sum, nanCounter] = computeNSumNanCounter(dEff);
    meanEff = sum/n;
    % Median
    medianEff = computeMedian(dEff, n, nanCounter);
    % Standard deviation
    properN = n - nanCounter;
    stDevEff = computeStandardDeviation(dEff, sum, properN);
    %% Compute time values
    % Min
    minTm = min(dTm, [], 'all');
    % Max
    maxTm = max(dTm, [], 'all');
    % Mean
    [n, sum, nanCounter] = computeNSumNanCounter(dTm);
    meanTm = sum/n;
    % Median
    medianTm = computeMedian(dTm, n, nanCounter);
    % Standard deviation
    properN = n - nanCounter;
    stDevTm = computeStandardDeviation(dTm, sum, properN);
    %% Save data to .txt file
    fileWritePath = searchInDirName_+"/computedVals.txt";
    effDesc = "Effectiveness: min="+minEff+", max="+maxEff+", mean="+round(meanEff, 2)+", median="+round(medianEff, 2)+", stDev="+round(stDevEff, 2);
    tmDesc = "Times: min="+minTm+", max="+maxTm+", mean="+round(meanTm, 2)+", median="+round(medianTm, 2)+", stDev="+round(stDevTm, 2);
    writelines([effDesc, tmDesc], fileWritePath);
end