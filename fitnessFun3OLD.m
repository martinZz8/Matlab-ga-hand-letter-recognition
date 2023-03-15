% Uses standard subtract to establish dimension between two points (manhattan metric)
function [J, transformedCloud, winningTemplateIndex] = fitnessFun3OLD(X, unknownCloud, templateClouds)
[transformedCloud] = fitnessFunBase(X, unknownCloud, false);

templatesCount = numel(templateClouds);
Js = zeros(templatesCount, 1);
for templateIndex=1:templatesCount
    Js(templateIndex, 1) = HausdorffDist(templateClouds{templateIndex}.Location, transformedCloud.Location);
end
[J, winningTemplateIndex] = min(Js);