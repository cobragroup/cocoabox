function [dataPreproc,preprocSteps] = cocoa_preprocessing(data,varargin)
% COCOA_PREPROCESSING - Preprocessing time series data for subsequent
% analysis.
%
% Syntax:
%   [dataPreproc] = cocoa_preprocessing(data,'subsetDim1',subsetDim1,
%                  'subsetDim2',subsetDim2, subsetDim3',subsetDim3);
%
% Example:
%   data = rand(100,100,100);
%   subsetDim1 = [0 0 0 .... 1 1 1]; ...logical vector
%   subsetDim2 = [0 0 0 .... 1 1 1]; ...logical vector
%   subsetDim3 = [0 0 0 .... 1 1 1]; ...logical vector
%   [dataPreproc] = cocoa_preprocessing(data,'subsetDim1',subsetDim1,
%                  'subsetDim2',subsetDim2, 'subsetDim3',subsetDim3);
%
% Inputs:
%   data - matrix of time courses (time points, time series, realizations)
%   subsetDim1 (optional) - logical vector of size(data,1). 0 to remove,
%                           1 to retain. (default ones(size(data,1),1))
%   subsetDim2 (optional) - logical vector of size(data,2). 0 to remove,
%                           1 to retain. (default ones(size(data,2),1))
%   subsetDim3 (optional) - logical vector of size(data,3). 0 to remove,
%                           1 to retain. (default ones(size(data,3),1))
%   downsample (optional) - factor of downsampling (number) (default 1, i.e.
%                           no downsampling)
%   downsampleMethod (optional) - 'subset' for taking the first value,
%                           'mean' or 'median' (default 'mean')
%   movingAverage (optional) - Size of the window (number) for moving average
%                              filtering of time series (default 0, i.e.
%                              not applying moving average filtering)
%   movingAverageMethod (optional) - Moving average method 'mean' or
%                                    'median' (default 'mean')
%   demean (optional) - 'col' demean each column individually, 'global'
%                        subtracts global signal from each time course,
%                        'globalOrth' orthogonalize each time course to
%                        global signal (default 'no')
%   normalize (optional) - 'var1' demean and normalize each time course by
%                          its standard deviation, '01' between range (0 1)
%                          and '-11' between range (-1 1) (default 'no')
%   difference (optional) - 'yes' returns 1st difference of each time
%                           course (default 'no')
%   distribution (optional) - transform distrubution to 'normal' or
%                             'uniform' (default 'no')
%   outlierCorrection (optional) - 'yes' find outliers as k * interquartile range
%                                  and replace by time cource mean (default
%                                  'no')
%   outlierCorrectionThreshold (optional) - Threshold k to define outliers
%                                           in the data (default k = 3)
%   preprocSteps (optional) - cell-array with previously performed
%                             preprocessing steps
%
%
% Outputs:
%   dataPreproc: matrix of preprocessed time courses
%         (subset/time points, subset/time series, subset/realizations)
%
%
%
% Toolboxes required:
% Other m-files required:
%   subset_data.m
%   downsample_data.m
%   moving_average.m
%   demean.m
%   normalize_data.m
%   difference_data.m
%   marginalNormalization.m
%   marginalUniform.m
%   outlierCorrection.m
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


p = inputParser;
addRequired(p,'data',@(x) ndims(x)==3);
addOptional(p,'subsetDim1',ones(size(data,1),1),@(x)validateattributes(x,...
    {'logical'},{'nonempty'}))
addOptional(p,'subsetDim2',ones(size(data,2),1),@(x)validateattributes(x,...
    {'logical'},{'nonempty'}))
addOptional(p,'subsetDim3',ones(size(data,3),1),@(x)validateattributes(x,...
    {'logical'},{'nonempty'}))
addParameter(p,'downsample',1,@isnumeric);
addOptional(p,'downsampleMethod','subset',@(x) any(validatestring(x,{'subset','mean','median'})))
addParameter(p,'movingAverage',0,@isnumeric);
addOptional(p,'movingAverageMethod','mean',@(x) any(validatestring(x,{'mean','median'})))
addOptional(p,'demean','no',@(x) any(validatestring(x,{'no','col','global','globalOrth'})))
addOptional(p,'normalize','no',@(x) any(validatestring(x,{'no','var1','01','-11'})))
addOptional(p,'difference','no',@(x) any(validatestring(x,{'no','yes'})))
addOptional(p,'distribution','no',@(x) any(validatestring(x,{'no','normal','uniform'})))
addOptional(p,'outlierCorrection','no',@(x) any(validatestring(x,{'no','yes'})))
addParameter(p,'outlierCorrectionThreshold',3,@isnumeric);
addOptional(p,'preprocSteps',{})

parse(p,data,varargin{:})
preprocSteps = p.Results.preprocSteps;
%% Preprocess data
dataPreproc = data;

% Subset of data
dataPreproc = cocoa_subset_data(dataPreproc,p.Results.subsetDim1,p.Results.subsetDim2,p.Results.subsetDim3);

% Downsample
dataTmp = [];
if p.Results.downsample >= 2
    for i = 1:size(dataPreproc,3)
        dataTmp(:,:,i) = cocoa_downsample_data(dataPreproc(:,:,i),p.Results.downsample,p.Results.downsampleMethod);
    end
    dataPreproc = dataTmp;
    preprocSteps = [preprocSteps; 'downsample'];
end

% Moving average
if p.Results.movingAverage >=2
    for i = 1:size(dataPreproc,3)
        dataPreproc(:,:,i) = cocoa_moving_average(dataPreproc(:,:,i),p.Results.movingAverage, p.Results.movingAverageMethod);
    end
        preprocSteps = [preprocSteps; 'moving average'];
end

% Demean
if ~strcmp(p.Results.demean,'no')
    for i = 1:size(dataPreproc,3)
        dataPreproc(:,:,i) = cocoa_demean(dataPreproc(:,:,i),p.Results.demean);
    end
        preprocSteps = [preprocSteps; 'demean'];
end

% Normalize
if ~strcmp(p.Results.normalize,'no')
    for i = 1:size(dataPreproc,3)
        dataPreproc(:,:,i) = cocoa_normalize_data(dataPreproc(:,:,i),p.Results.normalize);
    end
        preprocSteps = [preprocSteps; 'normalize'];
end

% 1st Difference
dataTmp = [];
if ~strcmp(p.Results.difference,'no')
    for i = 1:size(dataPreproc,3)
        dataTmp(:,:,i) = cocoa_difference_data(dataPreproc(:,:,i),p.Results.difference);
    end
    dataPreproc = dataTmp;
    preprocSteps = [preprocSteps; '1st difference'];
end

% Distribution marginalNormalization
if strcmp(p.Results.distribution,'normal')
    for i = 1:size(dataPreproc,3)
        dataPreproc(:,:,i) = cocoa_marginalNormalization(dataPreproc(:,:,i));
    end
    preprocSteps = [preprocSteps; 'normal distribution'];
end

% Distribution marginalUniform
if strcmp(p.Results.distribution,'uniform')
    for i = 1:size(dataPreproc,3)
        dataPreproc(:,:,i) = cocoa_marginalUniform(dataPreproc(:,:,i));
    end
    preprocSteps = [preprocSteps; 'uniform distribution'];
end

% Outlier correction
if ~strcmp(p.Results.outlierCorrection,'no')
    for i = 1:size(dataPreproc,3)
        for j = 1:size(dataPreproc,2)
            dataPreproc(:,j,i) = cocoa_outlierCorrection(dataPreproc(:,j,i),p.Results.outlierCorrectionThreshold);
        end
    end
    preprocSteps = [preprocSteps; 'outlier correction'];

end
end

