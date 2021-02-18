function [Components,Loadings] = cocoa_dimension_reduction(data,varargin)
% cocoa_DIMENSION_REDUCTION - Dimension reduction of time-domain
% and connectivity matrices data.
%
% Syntax:
%   [Components,Loadings] = cocoa_dimension_reduction(data,'type',type,'method',method,'nComp',nComp,'dim',dim);
%
% Example:
%   data = rand(100,100,100);
%   [Components,Loadings] = cocoa_dimension_reduction(data,'type','TCs','method','pca','nComp',15,'dim','col');
%
% Inputs:
%   data - matrix of time courses (time points, time series, realizations) or
%          matrix of functional connectivity matrices (time series,
%          time series, realizations)
%   type (optional) - 'TCs' for time courses data,
%                     'ConnMat' for functional connectivity matrices data
%                     ('Connmat' option not supported yet)
%                     (default = 'TCs')
%   method (optional) - 'pca' - principal component analysis, 'fastica' -
%                      independent component analysis using Fast ICA
%                      algorithm, 'nnmz' - non-negative matrix
%                      factorization, 'kmeans' - k-means clustering
%                      (default = 'pca')
%   nComp (optional) - Number of components to retain (default = number of
%                      dimensions)
%   dim (optional) - dimension to be reduced, 'col' columns, 'row' rows
%
%
% Outputs:
%   Components: for 'TCs' Time points x Components x Subject
%               for 'ConnMat' Time series x Components
%   Loadings: Each dimension contribution to Component (number of Time series x
%             number of components)
%
%
% Toolboxes required:
%   NMF Library
%   pca_ica
% Other m-files required:
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


%% Parsing input arguments
p = inputParser;
defMethod = 'pca';
validMethods = {'pca','fastica','nnmf','kmeans'};
checkMethod = @(x) any(validatestring(x,validMethods));

defType = 'TCs';
validTypes = {'TCs','ConnMat'};
checkType = @(x) any(validatestring(x,validTypes));

defDim = 'col';
validDims = {'row','col'};
checkDims = @(x) any(validatestring(x,validDims));

addRequired(p,'data',@(x) ndims(x)==3);
addOptional(p,'method',defMethod,checkMethod);
addOptional(p,'type',defType,checkType);
addOptional(p,'dim',defDim,checkDims);
addParameter(p,'nComp',size(data,2),@isnumeric);

parse(p,data,varargin{:})

%% Size of the data
[sizeDim1, sizeDim2, sizeDim3] = size(data);

nComp = p.Results.nComp;
if nComp > sizeDim2
    nComp = sizeDim2;
    warning('Number of components/clusters is larger than number of Regions --> setting number of components to number of Regions.');
end
    %% Call dimension reduction method
Components = [];
Loadings = [];
switch p.Results.type
    
    case 'TCs'
        data_cat = permute(data,[1 3 2]);
        data_cat = reshape(data_cat,[],size(data,2),1);
        % Prepare data for selected dimension to reduce
        if p.Results.dim == 'col'
            data_cat = data_cat';
        end
        
        switch p.Results.method
            case 'pca'
                % Compute principal components on concat data
                [Zpca, U] = PCA(data_cat,nComp);
                if p.Results.dim == 'col'
                    Components_cat = Zpca';
                    Loadings = pinv(U)';
                else
                    Loadings = Zpca';
                    Components_cat = pinv(U)';
                end
                Components = permute(reshape(Components_cat,[sizeDim1,sizeDim3,nComp]),[1 3 2]);
                
            case 'fastica'
                [Zica, W, T] = fastICA(data_cat,nComp);
                if p.Results.dim == 'col'
                    Components_cat = Zica';
                    Loadings = pinv(T\W')';
                else
                    Loadings = Zica';
                    Components_cat = pinv(T\W')';
                end
                Components = permute(reshape(Components_cat,[sizeDim1,sizeDim3,nComp]),[1 3 2]);
                
            case 'nnmf'
                options.alg = 'hals';
                [w_nmf, ~] = nmf_als(data_cat, nComp, options);
                
                if p.Results.dim == 'col'
                    Components_cat = w_nmf.H';
                    Loadings = pinv(w_nmf.W)';
                else
                    Loadings = w_nmf.H';
                    Components_cat = pinv(w_nmf.W)';
                end
                Components = permute(reshape(Components_cat,[sizeDim1,sizeDim3,nComp]),[1 3 2]);
                
            case 'kmeans'
                if p.Results.dim == 'row'
                    data_cat = data_cat';
                    warning('Only k-means clustering in a time domain allowed --> Changing to time domain dimension reduction.')
                end
                [Centroids,Loadings] = cocoa_kmeans(data_cat,nComp);
                Components_cat = Centroids';
                Components = permute(reshape(Components_cat,[sizeDim1,sizeDim3,nComp]),[1 3 2]);
                
            otherwise
                warning('Dimension reduction method not recognized.');
        end
        
    case 'ConnMat'
        warning('ConnMat parameter of cococa_dimension_reduction.m function is not supported yet.')
        Components = [];
        Loadings = [];
        %         switch p.Results.method
        %             case 'pca'
        %                 for i = 1:size(data,3)
        %                     data_cat(i,:) = [triuvec(data(:,:,i))' triuvec(data(:,:,i)')'];
        %                 end
        %                 if p.Results.dim == 'row'
        %                     data_cat = data_cat';
        %                 end
        %
        %                 [Zpca, U, mu, eigVecs] = PCA(data_cat,nComp);
        %                 if p.Results.dim == 'col'
        %                     Components = Zpca';
        %                     Loadings = pinv(U)';
        %                 else
        %                     Loadings = Zpca';
        %                     Components = pinv(U)';
        %                 end
        %
        %             case 'fastica'
        %                 for i = 1:size(data,3)
        %                     data_cat(i,:) = [triuvec(data(:,:,i))' triuvec(data(:,:,i)')'];
        %                 end
        %                 if p.Results.dim == 'row'
        %                     data_cat = data_cat';
        %                 end
        %                 [Zica, W, T, mu] = fastICA(data_cat,nComp);
        %                 if p.Results.dim == 'col'
        %                     Components = Zica';
        %                     Loadings = pinv(T\W')';
        %                 else
        %                     Loadings = Zica';
        %                     Components = pinv(T\W')';
        %                 end
        %
        %             case 'nnmf'
        %                 %%%% TEMPORALY PCA INSTEAD OF NNMF %%%%%
        %                 for i = 1:size(data,3)
        %                     data_cat(i,:) = [triuvec(data(:,:,i))' triuvec(data(:,:,i)')'];
        %                 end
        %                 if p.Results.dim == 'col'
        %                     data_cat = data_cat';
        %                 end
        %
        %                 [Zpca, U, mu, eigVecs] = PCA(data_cat,nComp);
        %                 if p.Results.dim == 'col'
        %                     Components = Zpca';
        %                     Loadings = pinv(U)';
        %                 else
        %                     Loadings = Zpca';
        %                     Components = pinv(U)';
        %                 end
        %                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %             case 'kmeans'
        %                 %%%% TEMPORALY PCA INSTEAD OF KMEANS %%%%%
        %                 for i = 1:size(data,3)
        %                     data_cat(i,:) = [triuvec(data(:,:,i))' triuvec(data(:,:,i)')'];
        %                 end
        %                 if p.Results.dim == 'col'
        %                     data_cat = data_cat';
        %                 end
        %
        %                 [Zpca, U, mu, eigVecs] = PCA(data_cat,nComp);
        %                 if p.Results.dim == 'col'
        %                     Components = Zpca';
        %                     Loadings = pinv(U)';
        %                 else
        %                     Loadings = Zpca';
        %                     Components = pinv(U)';
        %                 end
        %                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %         end
        
end

    function vec=triuvec(mat)
        mat=triu(mat+eps);
        zer=~eye(size(mat));
        mat=mat.*zer;
        vec=mat(mat~=0);
    end

end
