function [tc] = cocoa_outlierCorrection(tc0,k)
% COCOA_OUTLIERCORRECTION finds outliers in time course vector and replaces
% them with time course mean
%
% Syntax:
%   [tc] = cocoa_outlierCorrection(tc0,k)
%
% Example:
%   tc0 = rand(100,1);
%   k = 3;
%   [tc] = cocoa_outlierCorrection(tc0,k)
%
% Inputs:
%   tc0 - time course vector (time points)
%   k - k * IQR threshold to define outliers in the data
%
%
% Outputs:
%   tc: vector of data corrected for outliers
%         (time points)
%
% Toolboxes required:
% Other m-files required:
% MAT-files required:


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


tc = tc0;
for i = 1:size(tc0,2)
    tc01 = tc0(:,i);
    
    q1 = median(tc01(find(tc01<median(tc01))));
    q3 = median(tc01(find(tc01>median(tc01))));
    
    ind1 = find(tc01<q1-(q3-q1)*k);
    ind2 = find(tc01>q3+(q3-q1)*k);
    tc(ind1,i) = mean(tc01);
    tc(ind2,i) = mean(tc01);
end
end