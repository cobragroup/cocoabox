function [dataDiff] = cocoa_difference_data(data)
% COCOA_DIFFERENCE_DATA function computes and return first differences of input
% time series data matrix.
%
% Syntax:
%   [dataDiff] = cocoa_difference_data(data)
%
% Example:
%   data = rand(100,100);
%   [dataDiff] = cocoa_difference_data(data)
%
% Inputs:
%   data - matrix of time courses (time points, time series)
%   difference (optional) - 'yes' returns 1st difference of each time
%                           course (default 'no')
%
% Outputs:
%   dataDiff: matrix of time courses first differences
%         (time points, time series)
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


dataDiff = data(2:end,:) - data(1:end-1,:);
end

