% Function gets biggest number of file in currect directory. It searches
% for files in manner: {fileName}_{fileVersion}.{fileExtension}
% input:
%       fileName - name of the file with extention, but without the number
function [num] = getLastFileNameNumber(fileName)
biggestNum = 0;
num = biggestNum;
splittedText = fileName.split(".");
if length(splittedText) > 1
    d = dir(splittedText(1)+"*."+splittedText(2));
    for i=1:length(d)
        name = convertCharsToStrings(d(i).name);
        splittedText2 = name.split(".");
        splittedText3 = splittedText2(1).split("_");
        fileNum = str2double(splittedText3(2));
        %disp(i+") fileNum: "+fileNum);
        % OLD VERSION WITH FILE NAMES LIKE: results1.xlsx
        % -- ver 1 --
        % extractAfter starts from specified index (from 0) and gets characters to the end of string
        %fileNum = str2double(extractAfter(splittedText2(1),strlength(splittedText2(1))-1));
        % -- ver 2 (better) --
        %splittedText3 = splittedText2(1).split(splittedText(1)); %split by initial fileName without the extension
        %fileNum = str2double(splittedText3(2));
        if ~isnan(fileNum)
            if fileNum > biggestNum
                biggestNum = fileNum;
            end
        end
    end
    num = biggestNum;
end