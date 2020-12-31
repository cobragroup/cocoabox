function [logicalVector] = cocoa_logicalVector(userInput,dataLength,action)
%cocoa_logicalVector - transform user input (string) into a logical vector 
%
% Syntax:  [logicalVector] = cocoa_logicalVector(userInput,dataLength,action)
%
% Example: 
%    userInput = '1    5,3:17;r, 7  z , 62]';
%    dataLength = 298;    
%    action = 'include';
%    [logicalVector] = cocoa_logicalVector(userInput,dataLength,action)
%
% Inputs:
%    userInput - string input entered into a GUI text field by the user  
%    dataLength - length of the given dimension of input data (the one that
%    we want to create a subset of, by using the logical vector)
%    action - 'include'/'exclude' (what to do with the specified indices)
%
% Outputs:
%    logicalVector - logical vector of points to be included in (1) or excluded from (0) further analyses 
%


% Get indices of data points to include or exclude.
userInput = erase(userInput,{'[',']','"'});
userInput = split(userInput, {',',' ',';','.'});

indices = [];
for nCell = 1:length(userInput)
    cellNumeric = str2num(userInput{nCell});
    indices = [indices cellNumeric];
end

indices = unique(sort(indices));

% Include/exclude the specified indices.
if action == 'include'
    logicalVector = zeros(dataLength,1);
    logicalVector(indices) = 1;
elseif action == 'exclude'
    logicalVector = ones(dataLength,1);
    logicalVector(indices) = 0;
end

logicalVector = logicalVector(1:dataLength);
logicalVector = logical(logicalVector);

end