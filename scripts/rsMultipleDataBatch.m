function [] = rsMultipleDataBatch()
    effectivenessLocationVector = [
        struct("metric", "manhattan", "location", "C9"), ...
        struct("metric", "euclidean", "location", "C34") ...
    ];
    timeLocationVector = [
        struct("metric", "manhattan", "location", "M17"), ...
        struct("metric", "euclidean", "location", "M42") ...
    ];
    % Save effectivenesses
    for e=effectivenessLocationVector
        readAndSaveDataBatch(e.metric, true, e.location);
    end
    % Save times
    for t=timeLocationVector
        readAndSaveDataBatch(t.metric, false, t.location);
    end
    disp("All saved!");