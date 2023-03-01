function [] = rsMultipleDataBatch()
    effectivenessLocationVector = [
        struct("annealingFcn", "annealingboltz", "initTemp", "50", "metric", "manhattan", "location", "C11"), ...
        struct("annealingFcn", "annealingboltz", "initTemp", "50", "metric", "euclidean", "location", "C42"), ...
        struct("annealingFcn", "annealingboltz", "initTemp", "100", "metric", "manhattan", "location", "AA11"), ...
        struct("annealingFcn", "annealingboltz", "initTemp", "100", "metric", "euclidean", "location", "AA42"), ...
        struct("annealingFcn", "annealingboltz", "initTemp", "150", "metric", "manhattan", "location", "AY11"), ...
        struct("annealingFcn", "annealingboltz", "initTemp", "150", "metric", "euclidean", "location", "AY42"), ...
        struct("annealingFcn", "annealingfast", "initTemp", "50", "metric", "manhattan", "location", "BW11"), ...
        struct("annealingFcn", "annealingfast", "initTemp", "50", "metric", "euclidean", "location", "BW42"), ...
        struct("annealingFcn", "annealingfast", "initTemp", "100", "metric", "manhattan", "location", "CU11"), ...
        struct("annealingFcn", "annealingfast", "initTemp", "100", "metric", "euclidean", "location", "CU42"), ...
        struct("annealingFcn", "annealingfast", "initTemp", "150", "metric", "manhattan", "location", "DS11"), ...
        struct("annealingFcn", "annealingfast", "initTemp", "150", "metric", "euclidean", "location", "DS42") ...
    ];
    timeLocationVector = [
        struct("annealingFcn", "annealingboltz", "initTemp", "50", "metric", "manhattan", "location", "O20"), ...
        struct("annealingFcn", "annealingboltz", "initTemp", "50", "metric", "euclidean", "location", "O51"), ...
        struct("annealingFcn", "annealingboltz", "initTemp", "100", "metric", "manhattan", "location", "AM20"), ...
        struct("annealingFcn", "annealingboltz", "initTemp", "100", "metric", "euclidean", "location", "AM51"), ...
        struct("annealingFcn", "annealingboltz", "initTemp", "150", "metric", "manhattan", "location", "BK20"), ...
        struct("annealingFcn", "annealingboltz", "initTemp", "150", "metric", "euclidean", "location", "BK51"), ...
        struct("annealingFcn", "annealingfast", "initTemp", "50", "metric", "manhattan", "location", "CI20"), ...
        struct("annealingFcn", "annealingfast", "initTemp", "50", "metric", "euclidean", "location", "CI51"), ...
        struct("annealingFcn", "annealingfast", "initTemp", "100", "metric", "manhattan", "location", "DG20"), ...
        struct("annealingFcn", "annealingfast", "initTemp", "100", "metric", "euclidean", "location", "DG51"), ...
        struct("annealingFcn", "annealingfast", "initTemp", "150", "metric", "manhattan", "location", "EE20"), ...
        struct("annealingFcn", "annealingfast", "initTemp", "150", "metric", "euclidean", "location", "EE51") ...
    ];
    % Save effectivenesses
    for e=effectivenessLocationVector
        readAndSaveDataBatch(e.annealingFcn, e.initTemp, e.metric, true, e.location);
    end
    % Save times
    for t=timeLocationVector
        readAndSaveDataBatch(e.annealingFcn, e.initTemp, e.metric, false, e.location);
    end
    disp("All saved!");