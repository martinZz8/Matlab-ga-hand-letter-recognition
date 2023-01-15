% Uses standard subtract to establish dimension between two points (manhattan metric)
function [J, transformedCloud, winningTemplateIndex] = fitnessFun1(X, unknownCloud, templateClouds)
[transformedCloud] = fitnessFunBase(X, unknownCloud);

% exclude last point in last index (duplicated point on smallest finger)
templatesCount = numel(templateClouds)-1;
Js = zeros(templatesCount, 1);
for templateIndex=1:templatesCount
    tempC = templateClouds{templateIndex}.Location;
    tempC = tempC(1:templatesCount,1:2);
    transC = transformedCloud.Location;
    transC = transC(1:templatesCount,1:2);
    Js(templateIndex, 1) = sum(abs(tempC - transC), 'all');
end
[J, winningTemplateIndex] = min(Js);