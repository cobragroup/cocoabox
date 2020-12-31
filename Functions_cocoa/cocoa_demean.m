function [dataDemean] = cocoa_demean(data,method)
% COCOA_DEMEAN performs demeaning of imput data based on selected method.
%
% Syntax:
%   [dataDemean] = cocoa_demean(data,method)
%
% Example:
%   data = rand(100,100);
%   method = 'col';
%   [dataDemean] = cocoa_demean(data,method);
%
% Inputs:
%   data - matrix of time courses (time points, time series)
%
%   method - 'col' demean each column individually, 'global'
%            subtracts global signal from each time course,
%            'globalOrth' orthogonalize each time course to
%            global signal (default 'no')
%
% Outputs:
%   dataDemean: matrix of preprocessed time courses
%         (time points, time series)
%
% Toolboxes required:
% Other m-files required:
% MAT-files required:

switch method
    case 'col'
        demean = mean(data,1);
        dataDemean = data - demean;
    case 'global'
        demean = mean(data,2);
        dataDemean = data - demean;
    case 'globalOrth'
        demean = mean(data,2);
        W=pinv([ones(size(data,1),1) demean])*data;
        dataDemean = data - repmat(W(2,:),size(data,1),1).*repmat(demean,1,size(data,2));        
end

