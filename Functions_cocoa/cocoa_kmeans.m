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


