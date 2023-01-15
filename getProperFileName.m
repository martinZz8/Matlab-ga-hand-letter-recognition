function [properFileName] = getProperFileName(fileName, parentFolderName)
if parentFolderName ~= ""
    nextFileName = getNextFileName(fileName, parentFolderName+"/");
    properFileName = parentFolderName + "/" + nextFileName;
else
    nextFileName = getNextFileName(fileName, "");
    properFileName = nextFileName;
end