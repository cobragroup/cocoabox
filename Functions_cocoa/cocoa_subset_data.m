function [dataSubset] = cocoa_subset_data(data,subsetDim1,subsetDim2,subsetDim3)
% COCOA_SUBSET_DATA is a subfunction of cocoa_preprocessing. This function creates
% a subset of data based on input logical vectors.
%
% Syntax:
%   [dataSubset] = cocoa_subset_data(data,subsetDim1,subsetDim2,subsetDim3)
%
% Example:
%   data = rand(100,100,100);
%   subsetDim1 = [0 0 0 .... 1 1 1]; ...logical vector
%   subsetDim2 = [0 0 0 .... 1 1 1]; ...logical vector
%   subsetDim3 = [0 0 0 .... 1 1 1]; ...logical vector
%   [dataSubset] = cocoa_subset_data(data,subsetDim1,subsetDim2,subsetDim3)
%
% Inputs:
%   data - matrix of time courses (time points, time series)
%   subsetDim1 - logical vector of size(data,1). 0 to remove,
%                1 to retain. (default ones(size(data,1),1))
%   subsetDim2 - logical vector of size(data,2). 0 to remove,
%                1 to retain. (default ones(size(data,2),1))
%   subsetDim3 - logical vector of size(data,3). 0 to remove,
%                1 to retain. (default ones(size(data,3),1))
%
% Outputs:
%   dataSubset: matrix of subsetted data
%         (subset/time points, subset/time series, subset/realizations)
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


%% Subset
dataSubset = data(subsetDim1(:)==1,subsetDim2(:)==1,subsetDim3(:)==1);
end

