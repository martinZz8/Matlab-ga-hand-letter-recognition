function [isTrue] = isFolderCreatedNotEmpty(fNameToSearchIn, fName)
    isTrue = false;
    d = dir(fNameToSearchIn);
    for i=1:length(d)
        strItName = convertCharsToStrings(d(i).name);
        if (strItName == fName)
            d2 = dir(fNameToSearchIn+"/"+fName);
            if (length(d2) > 2) % the two first inner elements are folders: '.' and '..' (they are always present)
                isTrue = true;
                break;
            end
        end
    end