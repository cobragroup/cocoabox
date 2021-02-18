function [dataDemean] = cocoa_demean(data,method)
% COCOA_DEMEAN performs demeaning of imput data based on selected method.
%
% Syntax:
%   [dataDemean] = cocoa_demean(data,method)
%
% Example:
%   data = rand(100,100);
%   method = 'col';
%   [dataDemean] = cocoa_demean(data,method);
%
% Inputs:
%   data - matrix of time courses (time points, time series)
%
%   method - 'col' demean each column individually, 'global'
%            subtracts global signal from each time course,
%            'globalOrth' orthogonalize each time course to
%            global signal (default 'no')
%
% Outputs:
%   dataDemean: matrix of preprocessed time courses
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
    case 'col'
        demean = mean(data,1);
        dataDemean = data - demean;
    case 'global'
        demean = mean(data,2);
        dataDemean = data - demean;
    case 'globalOrth'
        demean = mean(data,2);
        W=pinv([ones(size(data,1),1) demean])*data;
        dataDemean = data - repmat(W(2,:),size(data,1),1).*repmat(demean,1,size(data,2));        
end

