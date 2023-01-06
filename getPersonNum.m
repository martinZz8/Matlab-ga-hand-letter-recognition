function [num] = getPersonNum(str)
newStr = str.split("_");
newStr = newStr(1).split("P");
num = str2double(newStr(2));