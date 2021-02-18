function [pmat,grpMeanFC, grpDiff] = cocoa_compute_pvalue_mask(connMatrix,groupIndicator,groupComparison,multiCorrection,alpha,symm)
% cocoa_compute_pvalue_mask - computing p-values masks.
%
% Syntax:
%   [pmat,grp_mean_fc, grp_diff] = cocoa_compute_pvalue_mask(connMatrix,groupIndicator,groupComparison,multiCorrection,alpha,symm)
%
% Example: 
%   [pmat,grp_mean_fc, grp_diff] = cocoa_compute_pvalue_mask(connMatrix,groupIndicator,'MW','FDR',0.05,0)
% 
% Inputs:
%   connMatrix - connectivity matrices N regions x N regions x M subjects
%   groupIndicator - N subjects x K groups logical matrix; 
%        groupIndicator(i,j) checks if subject i belongs to group j
%   groupComparison - group comparison, 
%       'MW' for non-parametric test,
%       'ttest' for parametric t-test.
%   multiCorrection - correction for multiple comparison
%       'Bonferroni','FDR','FWE','none'
%   alpha - threshold value for p-value masking approach.
%   symm - indicator of matrix symmetry. Default is 0 (asymmetric), 
%           1 means symmetric.
% 
% 
% Outputs:
%   pmat - p-values for hypothesis "element (i,j) does not differ between
%           groups'
%   grpMeanFC - mean connectivity per group
%   grpDiff - difference between mean connectivities per group
%
% 
% Toolboxes required: 
% Other m-files required: 
%   cocoa_stat_test2.m
%   cocoa_comparCorr.m
%   cocoa_extract_upper_tri.m
%   cocoa_upper_tri2mat.m
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

  
num_groups = size(groupIndicator,2);

tt_p = zeros(size(connMatrix,1), size(connMatrix,2));

% Statistical test

disp('P-value mask computation...');
for i = 1:size(connMatrix,1)
    for j = i:size(connMatrix,2)
        firstGroup = squeeze(connMatrix(i,j,groupIndicator(:,1)))';
        secondGroup = squeeze(connMatrix(i,j,groupIndicator(:,2)))';
        tt_p(i,j) = cocoa_stat_test2(firstGroup,secondGroup, 'method', groupComparison); 

        if symm
            tt_p(j,i) = tt_p(i,j);
        else
            firstGroup = squeeze(connMatrix(j,i,groupIndicator(:,1)))';
            secondGroup = squeeze(connMatrix(j,i,groupIndicator(:,2)))';
            tt_p(i,j) = cocoa_stat_test2(firstGroup,secondGroup, 'method', groupComparison); 
        end

    end 
end 

grpMeanFC = zeros(size(connMatrix,1),size(connMatrix,1),num_groups);
for grp = 1:num_groups
     grpMeanFC(:,:,grp) = mean(connMatrix(:,:,groupIndicator(:,grp)),3); 
end

% Raw effect
if num_groups == 2
    grpDiff = grpMeanFC(:,:,1)-grpMeanFC(:,:,2);
end

% Significance values
pmat.uncor = tt_p;
pmat.treshold = tt_p < alpha;

if ~strcmp(multiCorrection,'none')
    if symm
        pVector = cocoa_extract_upper_tri(tt_p);
        pVal = cocoa_comparCorr(pVector,multiCorrection,'alpha',alpha);
        pmat.(multiCorrection) = cocoa_upper_tri2mat(pVal);
    else
        pVal = cocoa_comparCorr(tt_p(:),multiCorrection);
        pmat.(multiCorrection) = reshape(pVal,size(tt_p,1),size(tt_p,1),'alpha',alpha);
    end
end    


end
