function [dataNorm] = cocoa_normalize_data(data,method)
% COCOA_NORMALIZE_DATA perfoms a normalization of each column of input data
% matrix based on selected method
%
% Syntax:
%   [dataNorm] = cocoa_normalize_data(data,method)
%
% Example:
%   data = rand(100,100);
%   method = 'var1';
%   [dataNorm] = cocoa_normalize_data(data,method)
%
% Inputs:
%   data - matrix of time courses (time points, time series)
%   method - 'var1' demean and normalize each time course by
%                          its standard deviation, '01' between range (0 1)
%                          and '-11' between range (-1 1) (default 'no')
%
% Outputs:
%   dataNorm: matrix of normalised time series
%         (time points, time series)
%
% Toolboxes required:
% Other m-files required:
% MAT-files required:

switch method
    case 'var1'
        dataNorm=(data-mean(data))./std(data);
    case '01'
        dataNorm = (data-min(data))./(max(data)-min(data));
    case '-11'
        dataNorm=(data-mean(data))./max(abs(data-mean(data)));
end

