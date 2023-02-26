% Example invocation: readAndSaveDataBatch("archive/pattern_search/1", "results_1.xlsx", "maxIt", "funEv", [10,30,50,80,100,120], [200,500,1000,2000,2500],
% @(X) (contains(X, "plM=GPSPositiveBasis2N") && contains(X, "plOA=Consecutive")),
% @(X) readmatrix(X, 'Range', 'L18:L18', 'OutputType','double'),
% @(X) writematrix(X, "archive/pattern_search/1/RESULTSX.xlsx", 'Range', 'C11')
%);
% readAndSaveDataBatch("archive/pattern_search/1", "results_1.xlsx", "maxIt", "funEv", [10,30,50,80,100,120], [200,500,1000,2000,2500], @(X) (contains(X, "plM=GPSPositiveBasis2N") && contains(X, "plOA=Consecutive")), @(X) readmatrix(X, 'Range', 'L18:L18', 'OutputType','double'), @(X) writematrix(X, "archive/pattern_search/1/RESULTSX.xlsx", 'Range', 'C11'));
function [] = readAndSaveDataBatch(searchInDirName_, innerFileName_, rowItemName, columnItemName, rowItemsVector, columnItemsVector, containsFunc, readDataFunc, saveDataFunc)
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
                if (innerFileName_ == innerFileName)
                    disp(rowParam+ " " + colParam);
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
    disp(resultData);
    saveDataFunc(resultData);