function [dataNorm] = cocoa_normalize_data(data,method)
% COCOA_NORMALIZE_DATA perfoms a normalization of each column of input data
% matrix based on selected method
%
% Syntax:
%   [dataNorm] = cocoa_normalize_data(data,method)
%
% Example:
%   data = rand(100,100);
%   method = 'var1';
%   [dataNorm] = cocoa_normalize_data(data,method)
%
% Inputs:
%   data - matrix of time courses (time points, time series)
%   method - 'var1' demean and normalize each time course by
%                          its standard deviation, '01' between range (0 1)
%                          and '-11' between range (-1 1) (default 'no')
%
% Outputs:
%   dataNorm: matrix of normalised time series
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
    case 'var1'
        dataNorm=(data-mean(data))./std(data);
    case '01'
        dataNorm = (data-min(data))./(max(data)-min(data));
    case '-11'
        dataNorm=(data-mean(data))./max(abs(data-mean(data)));
end

