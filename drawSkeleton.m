function [y] = drawSkeleton(frame, skeletonData)
imshow(frame);
[H, W, D] = size(frame);
hold on;
imshow(renderSkeleton(frame, skeletonData));
% [nodesCount, c] = size(skeletonData);
% for nodeIndex=1:nodesCount
%     if nodeIndex == 1
%         plot(skeletonData(nodeIndex, 1), skeletonData(nodeIndex, 2), 'or');
%     else
%         plot(skeletonData(nodeIndex, 1), skeletonData(nodeIndex, 2), 'og');
%     end
% end
% for nodeIndex=1:4
%     plot([skeletonData(nodeIndex, 1) skeletonData(nodeIndex+1, 1)], [skeletonData(nodeIndex, 2) skeletonData(nodeIndex+1, 2)], '-g');
% end
% plot([skeletonData(1, 1) skeletonData(6, 1)], [skeletonData(1, 2) skeletonData(6, 2)], '-g');
% for nodeIndex=6:8
%     plot([skeletonData(nodeIndex, 1) skeletonData(nodeIndex+1, 1)], [skeletonData(nodeIndex, 2) skeletonData(nodeIndex+1, 2)], '-g');
% end
% plot([skeletonData(1, 1) skeletonData(10, 1)], [skeletonData(1, 2) skeletonData(10, 2)], '-g');
% for nodeIndex=10:12
%     plot([skeletonData(nodeIndex, 1) skeletonData(nodeIndex+1, 1)], [skeletonData(nodeIndex, 2) skeletonData(nodeIndex+1, 2)], '-g');
% end
% plot([skeletonData(1, 1) skeletonData(14, 1)], [skeletonData(1, 2) skeletonData(14, 2)], '-g');
% for nodeIndex=14:16
%     plot([skeletonData(nodeIndex, 1) skeletonData(nodeIndex+1, 1)], [skeletonData(nodeIndex, 2) skeletonData(nodeIndex+1, 2)], '-g');
% end
% plot([skeletonData(1, 1) skeletonData(18, 1)], [skeletonData(1, 2) skeletonData(18, 2)], '-g');
% for nodeIndex=18:20
%     plot([skeletonData(nodeIndex, 1) skeletonData(nodeIndex+1, 1)], [skeletonData(nodeIndex, 2) skeletonData(nodeIndex+1, 2)], '-g');
% end
hold off;