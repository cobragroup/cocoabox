function [partCorr,pval] = cocoa_partCorr(timeSeries)
% cocoa_partCorr - partial correlation computed through precision matrix.
%
% Syntax:
%   [partCorr] = cocoa_partCorr(timeSeries);
%
% Example: 
%   timeSeries = rand(1000,10);
%   [partCorr] = cocoa_partCorr(timeSeries);
%
% Inputs:
%   timeSeries: time series, time x ROI 
% 
% Outputs:
%   partCorr: partial correlation, computed through precision matrix
%   pval: p-values (null hypothesis: the results of the observations are
%       independent and multivariate normally distributed)
%
% 
% Toolboxes required: 
% Other m-files required: 
% Subfunctions: 
%   sample_dist
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


corrM = cocoa_corr(timeSeries); % correlation

presM = inv(corrM); % precision matrix
diagonal = diag(diag(presM));

partCorr = cocoa_dd(-diagonal^(-1/2)*presM*diagonal^(-1/2),1);

% p-values https://encyclopediaofmath.org/wiki/Partial_correlation_coefficient

[N,m] = size(timeSeries);
tStat = cocoa_dd(sqrt(N-m)*partCorr./sqrt(1-partCorr.^2));

bin_width = 0.001;
[x, dist] = sample_dist(max(abs(tStat(:))), N-m);

pv = @(z,x,dist) sum(dist(x < -abs(z)) * bin_width) + (sum(dist(x >= abs(z)) * bin_width));
pval = reshape(arrayfun(@(z) pv(z,x,dist),tStat(:)),m,m);


function [x, dist] = sample_dist(z, varargin)
   
    % sample the student distribution
    df = varargin{:};
    bound = max(ceil(abs(z)), 6);
    x = -bound : bin_width : bound;

    dist = (gamma ((df + 1) / 2)) / (gamma (df / 2)) * (1 / sqrt (df * pi)) .* 1 ./ (1 + (x .^ 2 / df)) .^ ((df + 1) / 2);
end

end

