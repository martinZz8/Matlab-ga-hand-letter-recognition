function [cx, cy, cz] = getPointCloudCoG(sourceCloud)
cx = 0;
cy = 0;
cz = 0;
for i=1:sourceCloud.Count
    cx = cx+sourceCloud.Location(i, 1);
    cy = cy+sourceCloud.Location(i, 2);
    cz = cz+sourceCloud.Location(i, 3);
end
cx = cx/sourceCloud.Count;
cy = cy/sourceCloud.Count;
cz = cz/sourceCloud.Count;