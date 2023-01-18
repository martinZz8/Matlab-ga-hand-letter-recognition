% Create numerous/percentage confusion matrix, that has in:
% - row: results that should be acquired
% - column: acquired result
function [] = saveConfusionMatrix(fileName, lettersVector, resultMatrix, isPercentage, description, elapsedTimeStr)
% write information on data type
dataTypeToWrite = "numerous values";
if isPercentage
    dataTypeToWrite = "percentage values";
end
writematrix(dataTypeToWrite, fileName, 'Range', 'A1');
% write description of column vector
writematrix("predicted values", fileName, 'Range', 'A3');
% write letters column vector
writematrix(lettersVector, fileName, 'Range', 'B3');
% write description of row vector
writematrix("actual values", fileName, 'Range', 'C1');
% write letters row vector
writematrix(lettersVector', fileName, 'Range', 'C2');
% create the confusion matrix
[rowNum, colNum] = size(resultMatrix);
confusionMatrix = zeros(rowNum);
for i=1:rowNum
    actLetter = lettersVector(i);
    for j=1:colNum
        [foundRowIdx, ~] = findFirstIndexInMatrix(lettersVector, actLetter);
        colIdx = foundRowIdx;
        [foundRowIdx, ~] = findFirstIndexInMatrix(lettersVector, resultMatrix(i,j));
        rowIdx = foundRowIdx;
        %disp("row:"+rowIdx+" col:"+colIdx);
        if rowIdx > 0 && colIdx > 0
            confusionMatrix(rowIdx, colIdx) = confusionMatrix(rowIdx, colIdx) + 1;
        end
    end
end
% recalculate confusionMatrix if it's percentage
if isPercentage
    for i=1:rowNum
        for j=1:rowNum
            confusionMatrix(i,j) = (confusionMatrix(i,j)/colNum)*100;
        end
    end
end
% write confusion matrix
writematrix(confusionMatrix, fileName, 'Range', 'C3');
% write description
additionRowNum = length(lettersVector)+4;
writematrix(description, fileName, 'Range', "A"+string(additionRowNum), 'AutoFitWidth', false);
% write elapsed time info
writematrix(elapsedTimeStr, fileName, 'Range', "A"+string(additionRowNum+1), 'AutoFitWidth', false);