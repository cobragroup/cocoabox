function [dataSubset] = cocoa_subset_data(data,subsetDim1,subsetDim2,subsetDim3)
% COCOA_SUBSET_DATA is a subfunction of cocoa_preprocessing. This function creates
% a subset of data based on input logical vectors.
%
% Syntax:
%   [dataSubset] = cocoa_subset_data(data,subsetDim1,subsetDim2,subsetDim3)
%
% Example:
%   data = rand(100,100,100);
%   subsetDim1 = [0 0 0 .... 1 1 1]; ...logical vector
%   subsetDim2 = [0 0 0 .... 1 1 1]; ...logical vector
%   subsetDim3 = [0 0 0 .... 1 1 1]; ...logical vector
%   [dataSubset] = cocoa_subset_data(data,subsetDim1,subsetDim2,subsetDim3)
%
% Inputs:
%   data - matrix of time courses (time points, time series)
%   subsetDim1 - logical vector of size(data,1). 0 to remove,
%                1 to retain. (default ones(size(data,1),1))
%   subsetDim2 - logical vector of size(data,2). 0 to remove,
%                1 to retain. (default ones(size(data,2),1))
%   subsetDim3 - logical vector of size(data,3). 0 to remove,
%                1 to retain. (default ones(size(data,3),1))
%
% Outputs:
%   dataSubset: matrix of subsetted data
%         (subset/time points, subset/time series, subset/realizations)
%
% Toolboxes required:
% Other m-files required:
% MAT-files required:

%% Subset
dataSubset = data(subsetDim1(:)==1,subsetDim2(:)==1,subsetDim3(:)==1);
end

