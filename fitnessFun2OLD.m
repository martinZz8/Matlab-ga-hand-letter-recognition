% Uses euclidean function to establish dimension between two points (euclidean metric)
function [J, transformedCloud, winningTemplateIndex] = fitnessFun2(X, unknownCloud, templateClouds)
[transformedCloud] = fitnessFunBase(X, unknownCloud);

% exclude last point in last index (duplicated point on smallest finger)
templatesCount = numel(templateClouds) - 1;
Js = zeros(templatesCount, 1);
for templateIndex=1:templatesCount
    diffsCloud = abs(templateClouds{templateIndex}.Location - transformedCloud.Location);
    for i=1:length(diffsCloud)
        euclideanLength = sqrt(diffsCloud(i,1)^2 + diffsCloud(i,2)^2);
        Js(templateIndex, 1) = Js(templateIndex, 1) + euclideanLength;
    end
end
[J, winningTemplateIndex] = min(Js);