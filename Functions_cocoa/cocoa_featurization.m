function [feature] = cocoa_featurization(connMatrix,varargin)
% cocoa_featurization - computing features for connectivity matrices.
%
% Syntax:
%   [feature] = cocoa_featurization(connMatrix,varargin);
%
% Example: 
%   [feature] = cocoa_featurization(connMatrix,'method','PCA','nComp',1);
% 
% Inputs:
%   connMatrix - set of connectivity matrices for subjects; 
%         Number of ROI x Number of ROI x Number of subjects
%   'method' - dimension reduction/featurization method
%       'PCA' - first (or more) PCA components
%       'GlobConn' - averaged connectivity per subject
%       'TFC' - Typicality of Functional Connectivity (needs gold standard)
%       'MaskConn' - turns to 0 not-selected elements (needs mask)
%       'AvgMaskConn' - compute average elements after masking (needs mask)
%       'SelectFeatures' - store only selected elements (for ML)
%   
%   'addMatrix' - additional matrix for computation;
%        could be mask for masking (consist of 0 or 1) or 
%        typical connectivity for TFC; can be mask for 'SelectFeatures'.
% 
%   'nComp' - number of compunents for PCA; default 1.
%   'symmetry' - indicator of matrix symmetry. Default is 0 (asymmetric), 
%           1 means symmetric.
% 
% Outputs:
%   feature - double matrix N subjects x M features. By default M = 1.
%
% 
% Toolboxes required: 
% Other m-files required: 
%   PCA.m
%   cocoa_cor_matr
% Subfunctions: 
%   triuvec
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


%% Parsing

p = inputParser;

def_method = 'PCA';
exp_methods = {'PCA','TFC','GlobConn','MaskConn','AvgMaskConn','SelectFeatures','none'};
checkMethod = @(x) any(validatestring(x,exp_methods));

addRequired(p,'connMatrix',@(x) ndims(x)==3);
addOptional(p,'method',def_method,checkMethod);
addOptional(p,'addMatrix',[],@isnumeric);
addParameter(p,'nComp',1,@isnumeric);
addParameter(p,'symmetry',0,@isnumeric);

p.KeepUnmatched = true;

parse(p,connMatrix,varargin{:});

%% Computations 

dimRedMethod = p.Results.method;
symm = p.Results.symmetry;

switch dimRedMethod

    case 'PCA'
        for iS = 1:size(connMatrix,3)
            if symm
                tsMatrix(iS,:) = triuvec(connMatrix(:,:,iS))';
            else
                tsMatrix(iS,:) = [triuvec(connMatrix(:,:,iS))' triuvec(connMatrix(:,:,iS)')'];
            end
        end
        tsMatrix = tsMatrix';

        Zpca = PCA(tsMatrix, p.Results.nComp); % [Zpca, U, mu, eigVecs] = PCA();
        Components = Zpca';
%         Loadings = pinv(U)';
        
        feature = Components;


    case 'TFC'

% FC for healthy controls ESO190(1:90), stringent preprocessing is here:
% https://drive.google.com/file/d/1WzWVR-l-_1sE-uJyLpio-p8i4P_Ub4Qd/view?usp=sharing
%         load('Data/idealFC.mat');
        if isempty(p.Results.addMatrix)
            error('Missing connectivity for comparison.');
        else
            for iS = 1:size(connMatrix,3)
                feature(iS,1) = cocoa_cor_matr(connMatrix(:,:,iS),p.Results.addMatrix);
            end
        end
        
    case 'GlobConn'
        for iS = 1:size(connMatrix,3)
            tt = cocoa_dd(connMatrix(:,:,iS),nan);
            tt(isnan(tt)) = [];
            feature(iS,1) = mean(tt(:));
        end        
        
        
    case 'MaskConn'
        if isempty(p.Results.addMatrix)
            error('Missing connectivity for comparison.');
        else        
            for iS = 1:size(connMatrix,3)
                feature(:,:,iS) = connMatrix(:,:,iS).*p.Results.addMatrix;
            end             
        end        
        
    case 'AvgMaskConn'
        if isempty(p.Results.addMatrix)
            error('Missing connectivity for comparison.');
        else        
            for iS = 1:size(connMatrix,3)
                tt = connMatrix(:,:,iS);
                feature(iS,1) = mean(tt(p.Results.addMatrix>0));
            end             
        end
        
    case 'SelectFeatures'
        if isempty(p.Results.addMatrix)
            error('Missing mask for selection.');
        else        
            for iS = 1:size(connMatrix,3)
                tt = connMatrix(:,:,iS);
                feature(iS,:) = tt(p.Results.addMatrix>0);
            end             
        end           
        
    case 'none'
        feature = connMatrix;

end      
        
    function vec=triuvec(mat)
        mat=triu(mat+eps);
        zer=~eye(size(mat));
        mat=mat.*zer;
        vec=mat(mat~=0);
    end
end










