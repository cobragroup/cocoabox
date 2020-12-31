function [dataMov] = cocoa_moving_average(data,wSize,method)
% COCOA_MOVING_AVERAGE performs a moving average temporal filtering based on
% selected window size and averaging method
%
% Syntax:
%   [dataMov] = cocoa_moving_average(data,wSize,method)
%
% Example:
%   data = rand(100,100);
%   wSize = 5;
%   method = ''mean';
%   [dataMov] = cocoa_moving_average(data,wSize,method)
%
% Inputs:
%   data - matrix of time courses (time points, time series)
%   wSize - Size of the window (number) for moving average
%                              filtering of time series (default 0, i.e.
%                              not applying moving average filtering)
%   method - Moving average method 'mean' or 'median'
%
% Outputs:
%   dataMov: matrix of preprocessed time courses
%         (time points, time series)
%
% Toolboxes required:
% Other m-files required:
% MAT-files required:

switch method
    case 'mean'
        dataMov = movmean(data,wSize,2);
    case 'median'
        dataMov = movmedian(data,wSize,2);
        
end

