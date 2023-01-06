function [target] = renderSkeleton(source, skeletonData)
target = source;
[nodesCount, c] = size(skeletonData);
circleRadius = 8;
lineWidth = 10;
if nodesCount > 4
    for nodeIndex=1:4
        target = insertShape(target,'line',[skeletonData(nodeIndex, 1) skeletonData(nodeIndex, 2), skeletonData(nodeIndex+1, 1) skeletonData(nodeIndex+1, 2)],'color','green','LineWidth',lineWidth, 'Opacity', 1.0);
    end
end
if nodesCount > 5
    target = insertShape(target,'line',[skeletonData(1, 1) skeletonData(1, 2), skeletonData(6, 1) skeletonData(6, 2)],'color','green','LineWidth',lineWidth, 'Opacity', 1.0);
end
if nodesCount > 8
    for nodeIndex=6:8
        target = insertShape(target,'line',[skeletonData(nodeIndex, 1) skeletonData(nodeIndex, 2), skeletonData(nodeIndex+1, 1) skeletonData(nodeIndex+1, 2)],'color','green','LineWidth',lineWidth, 'Opacity', 1.0);
    end
end
if nodesCount > 9
    target = insertShape(target,'line',[skeletonData(1, 1) skeletonData(1, 2), skeletonData(10, 1) skeletonData(10, 2)],'color','green','LineWidth',lineWidth, 'Opacity', 1.0);
end
if nodesCount > 12
    for nodeIndex=10:12
        target = insertShape(target,'line',[skeletonData(nodeIndex, 1) skeletonData(nodeIndex, 2), skeletonData(nodeIndex+1, 1) skeletonData(nodeIndex+1, 2)],'color','green','LineWidth',lineWidth, 'Opacity', 1.0);
    end
end
if nodesCount > 13
    target = insertShape(target,'line',[skeletonData(1, 1) skeletonData(1, 2), skeletonData(14, 1) skeletonData(14, 2)],'color','green','LineWidth',lineWidth, 'Opacity', 1.0);
end
if nodesCount > 16
    for nodeIndex=14:16
        target = insertShape(target,'line',[skeletonData(nodeIndex, 1) skeletonData(nodeIndex, 2), skeletonData(nodeIndex+1, 1) skeletonData(nodeIndex+1, 2)],'color','green','LineWidth',lineWidth, 'Opacity', 1.0);
    end
end
if nodesCount > 17
    target = insertShape(target,'line',[skeletonData(1, 1) skeletonData(1, 2), skeletonData(18, 1) skeletonData(18, 2)],'color','green','LineWidth',lineWidth, 'Opacity', 1.0);
end
if nodesCount > 20
    for nodeIndex=18:20
        target = insertShape(target,'line',[skeletonData(nodeIndex, 1) skeletonData(nodeIndex, 2), skeletonData(nodeIndex+1, 1) skeletonData(nodeIndex+1, 2)],'color','green','LineWidth',lineWidth, 'Opacity', 1.0);
    end
end
for nodeIndex=1:nodesCount
    if nodeIndex == 1
        target = insertShape(target,'FilledCircle',[skeletonData(nodeIndex, 1) skeletonData(nodeIndex, 2) circleRadius],'color','blue','LineWidth',1, 'Opacity', 1.0);
    else
        target = insertShape(target,'FilledCircle',[skeletonData(nodeIndex, 1) skeletonData(nodeIndex, 2) circleRadius],'color','red','LineWidth',1, 'Opacity', 1.0);
    end
end