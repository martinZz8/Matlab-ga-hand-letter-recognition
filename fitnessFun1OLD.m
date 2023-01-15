% Uses standard subtract to establish dimension between two points (manhattan metric)
function [J, transformedCloud, winningTemplateIndex] = fitnessFun1(X, unknownCloud, templateClouds)
[transformedCloud] = fitnessFunBase(X, unknownCloud);

templatesCount = numel(templateClouds);
Js = zeros(templatesCount, 1);
for templateIndex=1:templatesCount
    Js(templateIndex, 1) = sum(abs(templateClouds{templateIndex}.Location - transformedCloud.Location), 'all');
end
[J, winningTemplateIndex] = min(Js);