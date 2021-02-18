function [dataDownsampled] = cocoa_downsample_data(data,factor,method)
% COCOA_DOWNSAMPLE_DATA downsamples 2D matrix along 1st dimension by factor and
% selected downsampling method.
%
% Syntax:
%   [dataDownsampled] = cocoa_downsample_data(data,factor,method)
%
% Example:
%   data = rand(100,100);
%   factor = 3;
%   method = 'mean'
%   [dataDownsampled] = cocoa_downsample_data(data,factor,method)
%
% Inputs:
%   data - matrix of time courses (time points, time series)
%   factor - factor of downsampling (number) (default 1, i.e. no downsampling)
%   method - 'subset' for taking the first value, 'mean' or 'median' (default 'mean')
%
% Outputs:
%   dataDownsampled: matrix of downsample time courses
%         (downsampled time points, time series)
%
%
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


divVec = factor*ones(1,fix(size(data,1)/factor));
if sum(divVec) ~= size(data,1)
    divVec = [divVec size(data,1)-sum(divVec)];
end

dataCell = mat2cell(data,divVec,ones(1,size(data,2)));
clear data

switch method
    case 'subset'
        dataDownsampled = cellfun(@(x)(x(1)),dataCell,'UniformOutput',false);
    case 'mean'
        dataDownsampled = cellfun(@mean,dataCell);
    case 'median' 
        dataDownsampled = cellfun(@median,dataCell);
end


