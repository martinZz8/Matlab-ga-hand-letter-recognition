function [shiftedCloud] = shiftCloud(cloud)
[cx, cy, cz] = getPointCloudCoG(cloud);
tform = rigidtform3d(eye(3,3), [-cx, -cy, -cz]);
shiftedCloud = pctransform(cloud, tform);