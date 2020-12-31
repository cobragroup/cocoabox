function [dataDownsampled] = cocoa_downsample_data(data,factor,method)
% COCOA_DOWNSAMPLE_DATA downsamples 2D matrix along 1st dimension by factor and
% selected downsampling method.
%
% Syntax:
%   [dataDownsampled] = cocoa_downsample_data(data,factor,method)
%
% Example:
%   data = rand(100,100);
%   factor = 3;
%   method = 'mean'
%   [dataDownsampled] = cocoa_downsample_data(data,factor,method)
%
% Inputs:
%   data - matrix of time courses (time points, time series)
%   factor - factor of downsampling (number) (default 1, i.e. no downsampling)
%   method - 'subset' for taking the first value, 'mean' or 'median' (default 'mean')
%
% Outputs:
%   dataDownsampled: matrix of downsample time courses
%         (downsampled time points, time series)
%
%
%
% Toolboxes required:
% Other m-files required:
% MAT-files required:

divVec = factor*ones(1,fix(size(data,1)/factor));
if sum(divVec) ~= size(data,1)
    divVec = [divVec size(data,1)-sum(divVec)];
end

dataCell = mat2cell(data,divVec,ones(1,size(data,2)));
clear data

switch method
    case 'subset'
        dataDownsampled = cellfun(@(x)(x(1)),dataCell,'UniformOutput',false);
    case 'mean'
        dataDownsampled = cellfun(@mean,dataCell);
    case 'median' 
        dataDownsampled = cellfun(@median,dataCell);
end


