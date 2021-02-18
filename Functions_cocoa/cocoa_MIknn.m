function [connMat,other] = cocoa_MIknn(timeSeries, param)
%cocoa_MIknn - Mutual Infromation calculation; pairwise, unconditional.
% Syntax:
%   [connMat,other] = cocoa_MIknn(timeSeries, param);
%
% Example: 
%   timeSeries = rand(1000,10);
%   param.kNeigh = 5;
%   [connMat,other] = cocoa_MIknn(timeSeries, param);
%
% Inputs:
%   timeSeries: time series, time x ROI x patient
%   param (optional): potentially needed information for connectivity calculation
%               param.kNeigh - k for k nearest neibourghs for MI_knn
% 
% Outputs:
%   connMat: connectivity matrix ROI pairwise, for every patient
%
% 
% Toolboxes required: 
% Other m-files required: 
% Subfunctions: 
%       MIknn
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


    if isempty(param)
        kNeigh = min(3,round(size(timeSeries,1)*0.05));
    else
        kNeigh = param.kNeigh;
    end

    numRoi = size(timeSeries,2);
    
    for chanFirst = 1:numRoi-1
        connMat(chanFirst,chanFirst) = MIknn(timeSeries(:,[chanFirst, chanFirst]),kNeigh);
        for chanSecond = chanFirst+1:numRoi
            connMat(chanFirst,chanSecond) = MIknn(timeSeries(:,[chanFirst, chanSecond]),kNeigh);
            connMat(chanSecond,chanFirst) = connMat(chanFirst,chanSecond);
        end
    end
        
function MI = MIknn (data,K)

MI=[];
if (K < size(data,1))
	for k = K
		mi_sum = 0.0;
		for i=1:size(data,1)

			% find k=th nearest neighbor in 2d
			dist = max(abs(data - repmat(data(i, :), size(data,1), 1)), [], 2);
			sdist = sort(dist);
  
			kth_dist = sdist(k+1);
  
			% find no. of neighbors in both dims closer or same distance from ref pt
			num_x = sum(abs(data(:,1) - data(i,1)) <= kth_dist) - 1;
			num_y = sum(abs(data(:,2) - data(i,2)) <= kth_dist) - 1;
  
			%fprintf('ref %d dist %g nghb_x %d nghb_y %d\n', i, kth_dist, num_x, num_y);
			mi_sum = mi_sum + psi(num_x) + psi(num_y);
		end
		mi = psi(k) + psi(size(data,1)) - mi_sum / size(data,1);
		MI=[MI,mi];
	end
end

end        
        
end