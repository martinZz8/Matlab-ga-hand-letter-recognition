% Uses euclidean function to establish dimension between two points
function [J, transformedCloud, winningTemplateIndex] = fitnessFun2(X, unknownCloud, templateClouds)
tform = rigidtform3d(eye(3,3), [X(1), X(2), 0]);
translatedCloud = pctransform(unknownCloud, tform);
[cx, cy, cz] = getPointCloudCoG(translatedCloud);
rotatedCloud = rotatePointCloud(translatedCloud, cx, cy, cz, 0, 0, X(3));
tform = affinetform3d([X(4) 0 0 0; 0 X(5) 0 0; 0 0 1 0; 0 0 0 1]);
transformedCloud = pctransform(rotatedCloud, tform);

templatesCount = numel(templateClouds);
Js = zeros(templatesCount, 1);
for templateIndex=1:templatesCount
    diffsCloud = abs(templateClouds{templateIndex}.Location - transformedCloud.Location);
    for i=1:length(diffsCloud)
        euclideanLength = sqrt(diffsCloud(i,1)^2 + diffsCloud(i,2)^2);
        Js(templateIndex, 1) = Js(templateIndex, 1) + euclideanLength;
    end
end
[J, winningTemplateIndex] = min(Js);