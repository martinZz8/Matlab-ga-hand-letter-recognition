% Function performs transofrmations on 'unknownCloud' based on 'X' vector
function [transformedCloud] = fitnessFunBase(X, unknownCloud, isAngleInDegree)
% translation (on axis X and Y)
tform = rigidtform3d(eye(3,3), [X(1), X(2), 0]);
translatedCloud = pctransform(unknownCloud, tform);
% rotation (by axis Z)
rotatedCloud = rotatePointCloud(translatedCloud, 0, 0, X(3), isAngleInDegree);
% change of scale (on axis X and Y)
tform = affinetform3d([X(4) 0 0 0; 0 X(5) 0 0; 0 0 1 0; 0 0 0 1]);
transformedCloud = pctransform(rotatedCloud, tform);