function [] = saveResults(fileName, lettersVector, personsNum, resultMatrix, lettersAccuracyVector)
% write letters column vector
writematrix(lettersVector, fileName, 'Range', 'A2');
% write persons row vector
personsMatrix = string(zeros(1,personsNum+1));
for i=1:personsNum
    personsMatrix(1,i) = "P"+i;
end
personsMatrix(1,personsNum+1) = "acc (percentage)";
writematrix(personsMatrix, fileName, 'Range', 'B1');
% write result matrix
writematrix(resultMatrix, fileName, 'Range', 'B2');
% write accuracy matrix
startChar = char(double('A')+personsNum+1);
writematrix(lettersAccuracyVector, fileName, 'Range', startChar+"2");