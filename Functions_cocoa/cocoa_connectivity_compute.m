function [connMat, pvalMat, other] = cocoa_connectivity_compute(timeSeries, connMeasure, param)
% cocoa_connectivity_compute - Connectivity measure calculation.
% Comute one of set of connectivity measures.
%
% Syntax:
%   [fcMatrix,pvalMatrix] = cocoa_connectivity_compute(timeSeries,'cor_spearman');
%   [fcMatrix,pvalMatrix] = cocoa_connectivity_compute(timeSeries);
%
% Example: 
%   timeSeries = rand(1000,10);
%   [connectivityMatrix, pvalMatrix] = cocoa_connectivity_compute(timeSeries,'cor_spearman');
%   [connectivityMatrix, pvalMatrix] = cocoa_connectivity_compute(timeSeries);
%
% Inputs:
%   timeSeries: time series, time x ROI x patient
%   connMeasure (optional): 
%                   'cor_pearson' for Pearson's correlation
%                   'cor_spearman' for Spearman's correlation  
%                   'MI_knn' Mutual Information with k nearest neibourghs
%                   estimate
%                   'part_cor' for partial correlation
%                   default: Pearson correlation
%   param (optional): potentially needed information for connectivity calculation
%               param.kNeigh - k for k nearest neibourghs for MI_knn
% 
% Outputs:
%   connMat: connectivity matrix ROI pairwise, for every patient
%   pvalMat: corresponding p-value matrix (if available)
%   other: potentially usefull information
%          other.sym - indicator if matrix is symmetric
%
% 
% Toolboxes required: 
% Other m-files required: 
%   cocoa_corr.m,
% Subfunctions: 
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



switch nargin
    case 2
        param = [];
    case 1
        param = [];
        connMeasure = 'cor_pearson';
end

[~,numRoi,numSubs] = size(timeSeries);
other = [];

switch connMeasure

    case 'cor_pearson'
        connMat = zeros([numRoi,numRoi,numSubs]);
        pvalMat = zeros([numRoi,numRoi,numSubs]);
                       
        disp('Pearson Correlation computation, subjects:');
        f = waitbar(0,'Please wait...');
        for sub = 1:numSubs
            fprintf('%4.f,', sub);
            waitbar(sub/numSubs,f,['Realizations: ' mat2str(sub)]);
            if mod(sub, 20) == 0 || sub == numSubs
                fprintf('\n');
            end
            
            [connMat(:,:,sub),pvalMat(:,:,sub)] = cocoa_corr(timeSeries(:,:,sub),'Pearson');
        end
        close(f);
        other.sym = 1;
        
    case 'cor_spearman'
        connMat = zeros([numRoi,numRoi,numSubs]);
        pvalMat = zeros([numRoi,numRoi,numSubs]);

        disp('Spearman Correlation computation, subjects:');
        f = waitbar(0,'Please wait...');
        for sub = 1:numSubs
            fprintf('%4.f,', sub);
            waitbar(sub/numSubs,f,['Realizations: ' mat2str(sub)]);
            if mod(sub, 20) == 0 || sub == numSubs
                fprintf('\n');
            end
            
            [connMat(:,:,sub),pvalMat(:,:,sub)] = cocoa_corr(timeSeries(:,:,sub),'Spearman');
        end
        close(f);
        other.sym = 1;

    case 'part_cor'
        connMat = zeros([numRoi,numRoi,numSubs]);
        pvalMat = zeros([numRoi,numRoi,numSubs]);

        disp('Partial Pearson Correlation computation, subjects:');
        f = waitbar(0,'Please wait...');
        for sub = 1:numSubs
            fprintf('%4.f,', sub);
            waitbar(sub/numSubs,f,['Realizations: ' mat2str(sub)]);
            if mod(sub, 20) == 0 || sub == numSubs
                fprintf('\n');
            end
            
            [connMat(:,:,sub),pvalMat(:,:,sub)] = cocoa_partCorr(timeSeries(:,:,sub));
        end
        close(f);
        other.sym = 1;
        
    case 'GC'
        connMat = zeros([numRoi,numRoi,numSubs]);
        pvalMat = zeros([numRoi,numRoi,numSubs]);

        disp('Granger Causality computation, subjects:');
        f = waitbar(0,'Please wait...');
        for sub = 1:numSubs
            fprintf('%4.f,', sub);
            waitbar(sub/numSubs,f,['Realizations: ' mat2str(sub)]);
            if mod(sub, 20) == 0 || sub == numSubs
                fprintf('\n');
            end

            [connMat(:,:,sub)] = cocoa_GrangerCausality(timeSeries(:,:,sub)');
        end
        close(f);
        other.sym = 0;        
        
    case 'MI_knn'
        connMat = zeros([numRoi,numRoi,numSubs]);
        pvalMat = [];
        
        disp('Mutual Information computation, subjects:');
        f = waitbar(0,'Please wait...');
        
        for sub = 1:numSubs
            fprintf('%4.f,', sub);
            waitbar(sub/numSubs,f,['Realizations: ' mat2str(sub)]);
            if mod(sub, 20) == 0 || sub == numSubs
                fprintf('\n');
            end
            
            [connMat(:,:,sub)] = cocoa_MIknn(timeSeries(:,:,sub), param);
        end
        close(f);
        other.sym = 1;

%   Hidden in GUI       
    case 'corrStat'
        connMat = zeros([numRoi,numRoi,numSubs]);
        pvalMat = zeros([numRoi,numRoi,numSubs]);
                       
        for sub = 1:numSubs
            [connMat(:,:,sub),pvalMat(:,:,sub)] = corr(timeSeries(:,:,sub));
        end
        other.sym = 1;
        
    otherwise
        error('Unexpected connectivity measure!')
end

end