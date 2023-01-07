function [rowIdx, colIdx] = findFirstIndexInMatrix(matrix, characterStrToFind)
rowIdx = 0; colIdx = 0;
canEnd = false;
[rowNum, colNum] = size(matrix);
for i=1:rowNum
    for j=1:colNum
        if characterStrToFind == matrix(i,j)
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