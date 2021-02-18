function [data_uninorm] = cocoa_marginalUniform(data)
% COCOA_MARGINALUNIFORM function transforms each column of input data
% matrix to have a uniform distribution
%
% Syntax:
%   [data_uninorm] = cocoa_marginalUniform(data)
%
% Example:
%   data = rand(100,100);
%   [data_uninorm] = cocoa_marginalUniform(data)
%
% Inputs:
%   data - matrix of time courses (time points, time series)
%
%
% Outputs:
%   data_uninorm: matrix of transformed time courses to have uniform
%   distribution (time points, time series)
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


[Nsamples,Nvariables] = size(data); 

data_uninorm=zeros(size(data));
for ivariables =1:Nvariables
    if std(data(:,ivariables))
        [~, IX]=sort(data(:,ivariables),1);
        ranking(IX)=1:Nsamples;
        normal_sample=0:1/(Nsamples-1):1;%sort(randn(Nsamples, 1));
        data_uninorm(:,ivariables) = normal_sample(ranking);
    end
end 

end
