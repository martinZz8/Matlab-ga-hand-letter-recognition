function [rowIdx, colIdx] = findFirstIndexInMatrix(matrix, characterToFind)
rowIdx = 0; colIdx = 0;
canEnd = false;
[rowNum, colNum] = size(matrix);
for i=1:rowNum
    for j=1:colNum
        if characterToFind == matrix{i,j}
            rowIdx = i;
            colNum = j;
            canEnd = true;
            break;
        end
    end
    if canEnd
        break;
    end
end