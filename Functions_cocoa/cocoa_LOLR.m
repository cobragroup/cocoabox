function [results] = cocoa_LOLR(dataset, labels, varargin)
% Leave-one-out Logistic Regression
%
% Syntax:
%   [results] = cocoa_LOLR(dataset, labels, varargin)
%
% Example: 
%   [results] = cocoa_LOLR(dataset, labels, 'loo_method', 'loo')
% 
% Inputs:
%   dataset     - 2D matrix subjects x features
%   labels      - COLUMN of integer 0/1 labels
%   'loo_method' (optional)     -> 'no' (learning and testing on the same data)
%                               -> 'loo' Leave one out (DEFAULT)
%                               -> 'lto' Leave two out
% 
% Outputs:
%   results     - vector of predictions
% 
% Toolboxes required: 
% 
% Other m-files required: 
% 
% Subfunctions: 
%   cocoa_LR
%   cocoa_LRPredict
% 
% MAT-files required: 
% 


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


%% PARSING
% pre-defined parameters
def_method = 'loo';
exp_method = {'loo', 'lto', 'nocv'};

% adding parser
p = inputParser;

ValidData = @(x) isnumeric(x);
ValidLabel = @(x) length(unique(double(x))) == 2;
ValidMethod = @(x) any(validatestring(x, exp_method));

addRequired(p, 'dataset', ValidData);
addRequired(p, 'labels', ValidLabel);
addOptional(p, 'loo_method', def_method)%, ValidMethod);
                                         
p.KeepUnmatched = true;

parse(p,dataset,labels,varargin{:})

%% Initial variables
nsubj = size(dataset,1);

%% Logistic Regression

switch p.Results.loo_method
    % learning and predicting on the same data - whole dataset
    case 'nocv'
        coeff = cocoa_LR(dataset,labels); % Model
        pred = cocoa_LRPredict(dataset,coeff); % Out of sample prediction

    % learning and predicting on the same data - whole dataset
    case 'loo'      
        pred = nan(1,nsubj);
        for subjecti = 1:size(dataset,1)
            pid = setdiff(1:size(dataset,1),subjecti); % Set index
            coeff = cocoa_LR(dataset(pid,:),labels(pid)); % Model
            pred(subjecti) = cocoa_LRPredict(dataset(subjecti,:),coeff); % Out of sample prediction
        end
        
    % leave two out - leaves one sub ject from each category
    % NEEDS PERFECTLY BALANCED DATA
    case 'lto'       
        % dividing into groups and randoly permutating the samples
        zeroPos = find(labels==0);
        zeroPos = zeroPos(randperm(length(zeroPos)))';
        onePos = find(labels==1);
        onePos = onePos(randperm(length(onePos)))';
        
        pred = zeros(1,size(dataset,1))-1;
        
        for permi = 1:max(length(zeroPos), length(onePos))
            pid = setdiff(1:size(dataset,1),[zeroPos(permi), onePos(permi)]); % Set index
            
            coeff = cocoa_LR(dataset(pid,:),labels(pid)); % Model
            pred(1,[zeroPos(permi), onePos(permi)]) = cocoa_LRPredict(dataset([zeroPos(permi), onePos(permi)],:),coeff); % Out of sample prediction

        end

end
  
results = pred;


%% Logistic Regression raw function
function [coefNew, prediction] = cocoa_LR(dataset, labels)
    % Logistic regression
    %
    % [coefNew, prediction] = cocoa_logr(dataset, labels, varargin)
    % The function is currently using Newton-Rhapson approximation method - may
    % fail  if there is not enough data
    %
    % dataset... subjects x features matrix
    % labels... logicals 0/1
    % Notes: staistical testing of parameters not yet implemented

    %% Initial parameters
    data = [ones(size(dataset,1),1),dataset]; % adding offset to the data

    nsubj = size(data,1);
    nfeat = size(data,2);

    %% Fitting iterative least squares
    coefOld = ones(nfeat,1)*0.1;
    coefNew = zeros(nfeat,1);
    while abs(sum(coefOld - coefNew)) > 1e-6
        R = repmat(coefOld',nfeat,1)*data' .* (1 - repmat(coefOld',nfeat,1)*data');
        R = diag(R(1,:));
        z = data * coefOld - inv(R) * (data * coefOld - labels);
        coefNew = (data' * R * data) \ (data' * R * z);
        coefOld = coefNew;
    end
end

% Prediction on training data - i.e. data used for training
    function [prediction] = cocoa_LRPredict(data,coeff)
        data = [ones(size(data,1),1),data];
        prediction = 1 ./ (1 + exp(- sum(data .* coeff',2)));
    end
    



end

