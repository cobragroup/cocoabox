function [correlation,pValue] = cocoa_cor_matr(A,B,sym,type)
% cocoa_cor_matr - correlation between matrices.
% If matrices are symmetric, then between upper triangles 
% (without the diagonal), otherwise - between the whole matrices 
% except diagonal.
%
% Syntax:
%   [fcMatrix,pvalMatrix] = cocoa_compute_connectivity_measure('cor_spearman', timeSeries);
%
% Example: 
%   A = rand(100);
%   B = rand(100);
%   [correlation,pValue] = cocoa_cor_matr(A,B,0,'Spearman');
% 
% Inputs:
%   A,B - matrices to compare (the same size)
%   sym (optional) - 0 if matrix is asymmetric, any number other if symmetric
%                   default value "1" (symmetric)
%   type (optional) - type of correlation ('Pearson'/'Spearman')
%                   default "Pearson"
% 
% Outputs:
%   correlation: correlation between matrices A and B as vectors
%   pValue: corresponding p-value 
%
% 
% Toolboxes required: 
% Other m-files required: 
%   cocoa_corr.m,
%   cocoa_dd.m,
%   cocoa_triuvec.m
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


if nargin==2
    sym = 1;
    type = 'Pearson';
elseif nargin == 3
    type = 'Pearson';
end

if sym
    [correlation,pValue] = cocoa_corr(triuvec(A),triuvec(B),type);
else
    At = cocoa_dd(A,nan); Bt = cocoa_dd(B,nan); 
    [correlation,pValue] = cocoa_corr(At(:),Bt(:),type);
end


        
function vec=triuvec(mat)
    mat=triu(mat+eps);
    zer=~eye(size(mat));
    mat=mat.*zer;
    vec=mat(mat~=0);
end
end