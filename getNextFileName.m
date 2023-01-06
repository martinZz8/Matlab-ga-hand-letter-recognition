function [nextFileName] = getNextFileName(fileName)
nextFileNumber = getLastFileNameNumber(fileName) + 1;
splittedfileName = fileName.split(".");
splittedfileName(1) = splittedfileName(1)+"_"+num2str(nextFileNumber);
nextFileName = join(splittedfileName,'.');