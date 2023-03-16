function [targetPointCloud] = rotatePointCloud(sourcePointCloud, angleOX, angleOY, angleOZ, isAngleInDegree)
% get center of gravity
[cx, cy, cz] = getPointCloudCoG(sourcePointCloud);
% translation by [-cx, -cy, -cz]
tform = rigidtform3d(eye(3,3), [-cx, -cy, -cz]); 
translatedCloud = pctransform(sourcePointCloud, tform);
countSin = @sin;
countCos = @cos;
% specify trigonometric funtions based on degrees (if 'isAngleInDegree' is set)
if isAngleInDegree
    countSin = @sind;
    countCos = @cosd;
end
% rotation by angleOX
%tform = rigidtform3d([rad2deg(angleOX),0,0]);
tform = rigidtform3d([ ...
    1, 0, 0; ...
    0, countCos(angleOX), -countSin(angleOX); ...
    0, countSin(angleOX), countCos(angleOX) ...
    ], [0, 0, 0]); % OX
rotatedCloud = pctransform(translatedCloud, tform);
% rotation by angleOY
%tform = rigidtform3d([0,rad2deg(angleOY),0]);
tform = rigidtform3d([ ...
    countCos(angleOY), 0, countSin(angleOY); ...
    0, 1, 0; ...
    -countSin(angleOY), 0, countCos(angleOY) ...
    ], [0, 0, 0]); % OY
rotatedCloud = pctransform(rotatedCloud, tform);
% rotation by angleOZ
%tform = rigidtform3d([0,0,rad2deg(angleOZ)]);
tform = rigidtform3d([ ...
    countCos(angleOZ), -countSin(angleOZ), 0; ...
    countSin(angleOZ), countCos(angleOZ), 0; ...
    0, 0, 1 ...
    ], [0, 0, 0]); % OZ
rotatedCloud = pctransform(rotatedCloud, tform);
% translation by [cx, cy, cz]
tform = rigidtform3d(eye(3,3), [cx, cy, cz]); 
targetPointCloud = pctransform(rotatedCloud, tform);