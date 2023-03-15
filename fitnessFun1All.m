% Uses standard subtract to establish dimension between two points (manhattan metric)
function [J, transformedCloud, winningTemplateIndex] = fitnessFun1All(X, unknownCloud, templateClouds)
[transformedCloud] = fitnessFunBase(X, unknownCloud, true);

templatesCount = numel(templateClouds);
Js = zeros(templatesCount, 1);
for templateIndex=1:templatesCount
    tempC = templateClouds{templateIndex}.Location(:,1:2);
    transC = transformedCloud.Location(:,1:2);
    Js(templateIndex, 1) = sum(abs(tempC - transC), 'all');
end
[J, winningTemplateIndex] = min(Js);