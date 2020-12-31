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

dataDiff = data(2:end,:) - data(1:end-1,:);
end

