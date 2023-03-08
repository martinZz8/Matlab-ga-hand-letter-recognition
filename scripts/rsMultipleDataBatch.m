% 'useMediaPipe': pass 'true' or 'false' to determine which data to move
function [] = rsMultipleDataBatch(useMediaPipe)
    effectivenessLocationVector = [
        struct("metric", "manhattan", "location", "C9"), ...
        struct("metric", "euclidean", "location", "C37") ...
    ];
    timeLocationVector = [
        struct("metric", "manhattan", "location", "M18"), ...
        struct("metric", "euclidean", "location", "M46") ...
    ];
    % Save effectivenesses
    for e=effectivenessLocationVector
        readAndSaveDataBatch(e.metric, true, e.location, useMediaPipe);
    end
    % Save times
    for t=timeLocationVector
        readAndSaveDataBatch(t.metric, false, t.location, useMediaPipe);
    end
    disp("All saved!");