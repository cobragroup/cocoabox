function [updName] = cocoa_fullName(shortName)
% cocoa_fullName - replace internal short text markers with their full
% description
%
% Syntax:
%   [updName] = cocoa_fullName(shortName);
%
% Example: 
%   fullConnectivityMeasure = cocoa_fullName('cor_pearson');
%
% Inputs:
%   shortName: text-marker used in functions for internal work
% 
% Outputs:
%   updName: text without shortcuts
%
% 
% Toolboxes required: 
% Other m-files required: 
% Subfunctions: 
% MAT-files required: 

    switch shortName
        case 'MW'
            updName = 'Mann Whitney rank test';
        case 'GlobConn'
            updName = 'Global connectivity';
        case 'MaskConn'
            updName = 'Masked connectivity';
        case 'AvgMaskConn'
            updName = 'Averaged masked connectivity';
        case 'cor_pearson'
            updName = 'Pearson correlation';
        case 'cor_spearman'
            updName = 'Spearman correlation';
        case 'MI_knn'
            updName = 'Mutual Information (kNN)';
        case 'GC'
            updName = 'Granger Causality';
        case 'corrStat'
            updName = 'Pearson correlation';
        case 'part_cor'
            updName = 'Partial Pearson correlation';
        otherwise 
            updName = shortName;
    end
end
