function [tc] = cocoa_outlierCorrection(tc0,k)
% COCOA_OUTLIERCORRECTION finds outliers in time course vector and replaces
% them with time course mean
%
% Syntax:
%   [tc] = cocoa_outlierCorrection(tc0,k)
%
% Example:
%   tc0 = rand(100,1);
%   k = 3;
%   [tc] = cocoa_outlierCorrection(tc0,k)
%
% Inputs:
%   tc0 - time course vector (time points)
%   k - k * IQR threshold to define outliers in the data
%
%
% Outputs:
%   tc: vector of data corrected for outliers
%         (time points)
%
% Toolboxes required:
% Other m-files required:
% MAT-files required:

tc = tc0;
for i = 1:size(tc0,2)
    tc01 = tc0(:,i);
    
    q1 = median(tc01(find(tc01<median(tc01))));
    q3 = median(tc01(find(tc01>median(tc01))));
    
    ind1 = find(tc01<q1-(q3-q1)*k);
    ind2 = find(tc01>q3+(q3-q1)*k);
    tc(ind1,i) = mean(tc01);
    tc(ind2,i) = mean(tc01);
end
end