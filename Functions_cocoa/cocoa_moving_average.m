function [dataMov] = cocoa_moving_average(data,wSize,method)
% COCOA_MOVING_AVERAGE performs a moving average temporal filtering based on
% selected window size and averaging method
%
% Syntax:
%   [dataMov] = cocoa_moving_average(data,wSize,method)
%
% Example:
%   data = rand(100,100);
%   wSize = 5;
%   method = ''mean';
%   [dataMov] = cocoa_moving_average(data,wSize,method)
%
% Inputs:
%   data - matrix of time courses (time points, time series)
%   wSize - Size of the window (number) for moving average
%                              filtering of time series (default 0, i.e.
%                              not applying moving average filtering)
%   method - Moving average method 'mean' or 'median'
%
% Outputs:
%   dataMov: matrix of preprocessed time courses
%         (time points, time series)
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


switch method
    case 'mean'
        dataMov = movmean(data,wSize,2);
    case 'median'
        dataMov = movmedian(data,wSize,2);
        
end

