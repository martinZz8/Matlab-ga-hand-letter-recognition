function [J, transformedCloud, winningTemplateIndex] = fitnessFun(X, unknownCloud, templateClouds)
tform = rigidtform3d(eye(3,3), [X(1), X(2), 0]);
translatedCloud = pctransform(unknownCloud, tform);
[cx, cy, cz] = getPointCloudCoG(translatedCloud);
rotatedCloud = rotatePointCloud(translatedCloud, cx, cy, cz, 0, 0, X(3));
tform = affinetform3d([X(4) 0 0 0; 0 X(5) 0 0; 0 0 1 0; 0 0 0 1]);
transformedCloud = pctransform(rotatedCloud, tform);

templatesCount = numel(templateClouds);
Js = zeros(templatesCount, 1);
for templateIndex=1:templatesCount
    Js(templateIndex, 1) = sum(abs(templateClouds{templateIndex}.Location - transformedCloud.Location), 'all');
end
[J, winningTemplateIndex] = min(Js);