function [cloud] = loadSkeleton(skeletonFile)
skeletonData = importdata(skeletonFile);
[nodesCount, ~] = size(skeletonData);
cloud = pointCloud([skeletonData zeros(nodesCount, 1)]);
% [cx, cy, cz] = getPointCloudCoG(cloud);
% tform = rigid3d(eye(3,3), [-cx, -cy, -cz]);
% cloud = pctransform(cloud, tform);