function [updName] = cocoa_fullName(shortName)
% cocoa_fullName - replace internal short text markers with their full
% description
%
% Syntax:
%   [updName] = cocoa_fullName(shortName);
%
% Example: 
%   fullConnectivityMeasure = cocoa_fullName('cor_pearson');
%
% Inputs:
%   shortName: text-marker used in functions for internal work
% 
% Outputs:
%   updName: text without shortcuts
%
% 
% Toolboxes required: 
% Other m-files required: 
% Subfunctions: 
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


    switch shortName
        case 'MW'
            updName = 'Mann Whitney rank test';
        case 'GlobConn'
            updName = 'Global connectivity';
        case 'MaskConn'
            updName = 'Masked connectivity';
        case 'AvgMaskConn'
            updName = 'Averaged masked connectivity';
        case 'cor_pearson'
            updName = 'Pearson correlation';
        case 'cor_spearman'
            updName = 'Spearman correlation';
        case 'MI_knn'
            updName = 'Mutual Information (kNN)';
        case 'GC'
            updName = 'Granger Causality';
        case 'corrStat'
            updName = 'Pearson correlation';
        case 'part_cor'
            updName = 'Partial Pearson correlation';
        otherwise 
            updName = shortName;
    end
end
