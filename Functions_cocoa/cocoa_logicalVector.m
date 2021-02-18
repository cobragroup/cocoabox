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


% This file is part of Cocoabox. Cocoabox (Complex Connectivity Analysis 
% toolbox) is a library of software modules for modeling and analysis of 
% complex systems.
%
% Cocoabox is a free software: you can redistribute it and/or modify it 
% under the terms of the GNU Affero General Public License as published 
% by the Free Software Foundation, either version 3 of the License, 
% or (at your option) any later version.
% 
% Cocoabox is distributed in the hope that it will be useful, but WITHOUT 
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
% FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public 
% License for more details.
% 
% URL:          https://github.com/cobragroup/cocoabox
% Authors:      The full list of authors is available in the README file.
% Copyright:    Copyright (c) 2020, Institute of Computer Science of 
%               the Czech Academy of  Sciences
% License:      GNU AFFERO GENERAL PUBLIC LICENSE (AGPL) 3.0.
%               For license details see the LICENSE file. 
%               For other licensing options including more permissive 
%               licenses, please contact the first author (hlinka@cs.cas.cz) 
%               or e-mail licensing@cs.cas.cz.


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