function [nextFileName] = getNextFileName(fileName, parentPathToFile)
nextFileNumber = getLastFileNameNumber(fileName, parentPathToFile) + 1;
splittedfileName = fileName.split(".");
splittedfileName(1) = splittedfileName(1)+"_"+num2str(nextFileNumber);
nextFileName = join(splittedfileName,'.');