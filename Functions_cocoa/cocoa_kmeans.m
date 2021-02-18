function [Centroids,Loadings] = cocoa_kmeans(data,nClust)
%COCOA_KMEANS K-means clustering algorithm of a time-domain input data
%
% Syntax:
%   [Centroids,Loadings] = cocoa_kmeans(data,nClust);
%
% Example:
%   data = rand(100,100);
%   nClust = 5;
%   [Centroids,Loadings] = cocoa_kmeans(data,nClust);
%
% Inputs:
%   data - matrix of time courses (dimensions, time points)
%
%   nClust - number of clusters to cluster input data in.
%
% Outputs:
%   Centroids: Center TC of each cluster (nClust x time points)
%            
%   Loadings: Each dimension contribution to Centroid (number of time series x
%             number of centroids)
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


%% Setting parameters
maxIterations = 100;
limit = 1e-7;

%% Centroid initialisation
Centroids = data(randperm(size(data,1),nClust),:);

%% Compute centroids
for i=1:maxIterations
    Indices = zeros(size(data,1), 1);
    
    % Assign data to nearest centroid
    for j = 1:size(data,1)
        k = 1;
        minDistance = sum((data(j,:) - Centroids(1,:)) .^ 2);
        for m = 2:size(Centroids,1)
            distance = sum((data(j,:) - Centroids(m,:)) .^ 2);
            if distance < minDistance
                minDistance = distance;
                k = m;
            end
        end
        Indices(j) = k;
        
    end
    
    % Recompute centroids
    for n=1:nClust
        dataClust = data(Indices==n,:);
        Centroids(n, :) = sum(dataClust)/size(dataClust,1);
    end
    
    if i == 1
        centPrev = norm(Centroids);
    else
        centChange = abs((norm(Centroids) - centPrev))/norm(Centroids);
        centPrev = norm(Centroids);
        if centChange < limit
            break
        end
    end
end

%% Compute output loading matrix
Loadings = zeros(length(Indices),nClust);
for i = 1:size(Centroids,1)
    Loadings(Indices==i,i) = 1/sum(Indices==i);
end

end


