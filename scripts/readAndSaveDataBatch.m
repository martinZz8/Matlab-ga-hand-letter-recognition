% Example invocation: readAndSaveDataBatch("manhattan", true, 'C9'); OR readAndSaveDataBatch("manhattan", false, 'M17');
function [] = readAndSaveDataBatch(metric, isEffectiveness, locationToSave)
	% Data
	searchInDirName_ = "archive/ga/1";
	innerFileName_ = "results_1.xlsx";
	rowItemName = "gen";
	columnItemName = "pop";
	rowItemsVector = [10,30,70,100];
	columnItemsVector = [10,20,60,100,300,500,1000];
	containsFunc = @(X) contains(X, "metric="+metric);
	function [dt] = readEffectiveness(filePath)
		dt = readmatrix(filePath, 'Range', 'L18:L18', 'OutputType','double');
    end
	function [dt] = readTime(filePath)
		mt = readmatrix(filePath, 'Range', 'A20:A20', 'OutputType','string');
		sT = split(mt, ":");
		sT = split(sT(3), "sec");
		dt = str2double(strtrim(sT(1)));
    end
	readDataFunc = @(X) readEffectiveness(X);
	if ~isEffectiveness
		readDataFunc = @(X) readTime(X);
    end
	saveDataFunc = @(dt) writematrix(dt, searchInDirName_+"/RESULTS1.xlsx", 'AutoFitWidth', false, 'Range', locationToSave);
	% Preparing result matrix
    resultData = zeros(length(rowItemsVector), length(columnItemsVector));
    % Read and process data
    d1 = dir(searchInDirName_);
    for i=1:length(d1)
        innerDirName = convertCharsToStrings(d1(i).name);
        if containsFunc(innerDirName)
            % Prepare params for row and column
            rowParam = NaN;
            colParam = NaN;
            params = split(innerDirName, "_");
            for n=1:length(params)
                if contains(params(n), rowItemName)
                    m = split(params(n), "=");
                    rowParam = str2double(m(2));
                elseif contains(params(n), columnItemName)
                    m = split(params(n), "=");
                    colParam = str2double(m(2));
                end
            end
            % Get data from .xlsx file
            d2 = dir(searchInDirName_+"/"+innerDirName);
            for j=1:length(d2)
                innerFileName = d2(j).name;
                if (innerFileName_ == innerFileName && ~isnan(rowParam) && ~isnan(colParam))
                    %disp(rowParam+ " " + colParam);
                    [~, rowIdx] = findFirstIndexInMatrix(rowItemsVector,rowParam);
                    [~, coldIdx] = findFirstIndexInMatrix(columnItemsVector,colParam);                   
                    fName = searchInDirName_+"/"+innerDirName+"/"+innerFileName;
                    if (rowIdx ~= 0) && (coldIdx ~= 0)
                        resultData(rowIdx,coldIdx) = readDataFunc(fName);
                    end
                    break
                end
            end
        end
    end
    % Save the data to specific matrix
    %disp("Result to save:");
    %disp(resultData);
    saveDataFunc(resultData);
    disp("Done");
end