% Uses standard subtract to establish dimension between two points (manhattan metric)
function [J, transformedCloud, winningTemplateIndex] = fitnessFun3(X, unknownCloud, templateClouds)
[transformedCloud] = fitnessFunBase(X, unknownCloud, false);

templatesCount = numel(templateClouds);
Js = zeros(templatesCount, 1);
for templateIndex=1:templatesCount
    tempC = templateClouds{templateIndex}.Location;
    [numPoints,~] = size(tempC);
    newNumPoints = numPoints - 1; % exclude last point in last index (duplicated point on smallest finger)
    tempC = tempC(1:newNumPoints,1:2);
    transC = transformedCloud.Location;
    transC = transC(1:newNumPoints,1:2);
    Js(templateIndex, 1) = HausdorffDist(tempC, transC);
end
[J, winningTemplateIndex] = min(Js);