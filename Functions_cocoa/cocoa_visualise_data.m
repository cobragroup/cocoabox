function [] = cocoa_visualise_data(data,varargin)
% COBRASW_VISUALIZE_DATA generates figures of visualized data based on
% selected data range and method
%
% Syntax:
%       [] = cocoa_visualise_data(data,varargin);
%
% Example:
%   data = rand(100,100,100);
%   subsetDim1 = [0 0 0 .... 1 1 1]; ...logical vector
%   subsetDim2 = [0 0 0 .... 1 1 1]; ...logical vector
%   subsetDim3 = [0 0 0 .... 1 1 1]; ...logical vector
%   method = 'summarised';
%   [] = cocoa_visualize_data(data,'method',method,'subsetDim1',subsetDim1,
%                  'subsetDim2',subsetDim2, 'subsetDim3',subsetDim3);
%
% Inputs:
%   data - matrix of time courses (time points, regions, realisations)
%   subsetDim1 (optional) - logical vector of size(data,1). 0 to remove,
%                           1 to retain. (default ones(size(data,1),1))
%   subsetDim2 (optional) - logical vector of size(data,2). 0 to remove,
%                           1 to retain. (default ones(size(data,2),1))
%   subsetDim3 (optional) - logical vector of size(data,3). 0 to remove,
%                           1 to retain. (default ones(size(data,3),1))
%   method (optional) - 'individual' plot individual regions,
%   'summarised' shows all regions as an image (default 'individual')
%   figPrefix (optional) - Prefix for figure names and titles (def '')
%
% Outputs:
%
% Toolboxes required:
% Other m-files required:
% subset_data.m
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


%% Handle default values for a visualization range
if size(data,1) <=500
    subsetDim1Def = ones(size(data,1),1);
else
    subsetDim1Def = [ones(500,1);zeros(size(data,1)-500,1)];
end

if size(data,2) <=10
    subsetDim2Def = ones(size(data,2),1);
else
    subsetDim2Def = [ones(10,1);zeros(size(data,2)-10,1)];
end

if size(data,3) <=5
    subsetDim3Def = ones(size(data,3),1);
else
    subsetDim3Def = [ones(5,1);zeros(size(data,3)-5,1)];
end

p = inputParser;
addRequired(p,'data',@(x) ndims(x)==3);
addOptional(p,'subsetDim1',subsetDim1Def,@(x)validateattributes(x,...
    {'logical'},{'nonempty'}))
addOptional(p,'subsetDim2',subsetDim2Def,@(x)validateattributes(x,...
    {'logical'},{'nonempty'}))
addOptional(p,'subsetDim3',subsetDim3Def,@(x)validateattributes(x,...
    {'logical'},{'nonempty'}))
addOptional(p,'method','individual',@(x) any(validatestring(x,{'individual','summarised'})))
addOptional(p,'figPrefix','')

parse(p,data,varargin{:})

%% Subset of data based on input values
XInd = find(p.Results.subsetDim1 == 1);
YInd = find(p.Results.subsetDim2 == 1);
ZInd = find(p.Results.subsetDim3 == 1);

%% Plotting the data
stackedDef = 15;

method = p.Results.method;
if (length(ZInd)*ceil(length(YInd)/stackedDef) >30) && all(method == 'individual')
    disp('Too many figures to show -> switching to method Summarised.')
    method = 'summarised';
end

switch method
    case 'individual'
        nFigs2 = floor(sum(p.Results.subsetDim2)/stackedDef);
        if rem(sum(p.Results.subsetDim2),stackedDef) ~= 0
            nFigs2 = nFigs2 + 1;
        end
        
        for i = 1:length(ZInd)
            for j = 1:nFigs2
                if nFigs2 ==1
                    T = array2table(data(XInd,YInd,ZInd(i)));
                    timeSeriesLabel    = cell(length(YInd), 1);
                    timeSeriesLabel(:) = {'Region '};
                    timeSeriesNumber    = string(YInd);
                    T.Properties.VariableNames = strcat(timeSeriesLabel,timeSeriesNumber);
                    figure('name',[p.Results.figPrefix 'Visualised data for realisation ' num2str(ZInd(i)) ' (Figure: ' num2str(j) ' of ' num2str(nFigs2) ')'])
                    s = stackedplot(T,'LineWidth',1);
                    xlabel('Time points (-)')
                    for k = 1:length(YInd)
                        s.AxesProperties(k).YLimits = [min(data(XInd,YInd,ZInd),[],'all') max(data(XInd,YInd,ZInd),[],'all')];
                    end
                    
                elseif j == nFigs2
                    T = array2table(data(XInd,YInd(j*stackedDef-(stackedDef-1):end),ZInd(i)));
                    timeSeriesLabel    = cell(length(YInd(j*stackedDef-(stackedDef-1):end)), 1);
                    timeSeriesLabel(:) = {'Region '};
                    timeSeriesNumber    = string(YInd(j*stackedDef-(stackedDef-1):end));
                    T.Properties.VariableNames = strcat(timeSeriesLabel,timeSeriesNumber);
                    figure('name',[p.Results.figPrefix 'Visualised data for realisation ' num2str(ZInd(i)) ' (Figure: ' num2str(j) ' of ' num2str(nFigs2) ')'])
                    s = stackedplot(T,'LineWidth',1);
                    xlabel('Time points (-)')
                    for k = 1:length(YInd(j*stackedDef-(stackedDef-1):end))
                        s.AxesProperties(k).YLimits = [min(data(XInd,YInd,ZInd),[],'all') max(data(XInd,YInd,ZInd),[],'all')];
                    end
                                 
                else
                    T = array2table(data(XInd,YInd(j*stackedDef-(stackedDef-1):j*stackedDef),ZInd(i)));
                    timeSeriesLabel    = cell(length(YInd(j*stackedDef-(stackedDef-1):j*stackedDef)), 1);
                    timeSeriesLabel(:) = {'Region '};
                    timeSeriesNumber    = string(YInd(j*stackedDef-(stackedDef-1):j*stackedDef));
                    T.Properties.VariableNames = strcat(timeSeriesLabel,timeSeriesNumber);
                    figure('name',[p.Results.figPrefix 'Visualised data for realisation ' num2str(ZInd(i)) ' (Figure: ' num2str(j) ' of ' num2str(nFigs2) ')'])
                    s = stackedplot(T,'LineWidth',1);
                    xlabel('Time points (-)')
                    for k = 1:length(YInd(j*stackedDef-(stackedDef-1):j*stackedDef))
                        s.AxesProperties(k).YLimits = [min(data(XInd,YInd,ZInd),[],'all') max(data(XInd,YInd,ZInd),[],'all')];
                    end                
                end
                title(['Visualised data for realisation ' num2str(ZInd(i)) '    (Figure: ' num2str(j) ' of ' num2str(nFigs2) ')'])
            end
        end
        
    case 'summarised'
        figure('name',[p.Results.figPrefix 'Data_summary'])
        data_res = data(XInd,YInd,ZInd);
        data_res = reshape(data_res,[sum(p.Results.subsetDim1) sum(p.Results.subsetDim2)*sum(p.Results.subsetDim3)]);
        imagesc(data_res)
        colorbar;
        ylabel('Time points (-)')
        xticks(1+sum(p.Results.subsetDim2)/2:sum(p.Results.subsetDim2):sum(p.Results.subsetDim2)*sum(p.Results.subsetDim3))
        realisationLabel    = cell(length(ZInd), 1);
        realisationLabel(:) = {'Realisation '};
        realisationNumber    = string(ZInd);
        title('Data summary for selected time points, regions and realisations.')
        xticklabels(strcat(realisationLabel, realisationNumber))
        xtickangle(45)
end
