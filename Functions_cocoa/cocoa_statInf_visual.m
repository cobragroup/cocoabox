function [fig] = cocoa_statInf_visual(infType,statInf,info)
% cocoa_statInf_visual - visualization of statistical analysis computed earlier.
% Two scenarios are avaiblable: 'p-value_mask' and 'ROC'.
%
% Syntax:
%   [fig] = cocoa_statInf_visual(infType,statInf,info);
%
% Example: 
%   [fig] = cocoa_statInf_visual(infType,statInf,info);
% 
% Inputs:
%   infType - structure with info about statistical analysis; 
%       this structure is filled up in pipeline (part of structure 'info')
%       infType.statAnalysis - 'p-value_mask' or 'ROC'
%       infType.feature - object that is processed ('Conn_Matrix','PCA',etc.)
%       optional - differs for different analysis.
% 
%   statInf - structure with output of cocoa_statInf_compute()
%       highly dependent on type of analysis
% 
%   info - information about the whole anaysis, defined in pipeline; used
%       for displaying names of dataset/groups, measures.
% 
% Outputs:
%   fig - figure with boxplots and ROC curve; comparison of two groups.
%
% 
% Toolboxes required: 
% Other m-files required: 
%   bplot.m
% Subfunctions: 
%   visual_pvalue_mask
%   visual_ROC
% MAT-files required: 
%   cocoa_cmap.mat


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


cmap = load('cocoa_cmap.mat'); % loading custom color - blinded friendly colormap
cmap = cmap.cmap;

switch infType.statAnalysis
    case 'p-value_mask'
        [fig] = visual_pvalue_mask(statInf,info);
        
    case 'ROC'
        [fig] = visual_ROC(statInf,info,infType);
end

function [fig] = visual_ROC(statInf,info,infType)

    fn = @cocoa_fullName;
    
    AUC = statInf.AUC;
    sens = statInf.sens;
    spec = statInf.spec;
    oa = statInf.oa;
    idMaxOa = statInf.idMaxOa;
    idMaxOaPos = statInf.idMaxOaPos;
    bins = statInf.bins;

    group1 = statInf.group1;
    group2 = statInf.group2;
    feature = infType.feature;
    dataset = info.data.dataset;
    
    fig = figure('Name',[fn(dataset) ' ' fn(feature)],'pos',[10 10 1300 600]); 
    
    subplot(1,2,1); 
    hold on;
    bplot(group1,1,'outliers');
    bplot(group2,3,'outliers');
    hold off;
    box on;
    axis([0 4, min([group1 group2]) max([group1 group2])]);
    xticks([1 3]);
    xticklabels({fn(info.data.groupNames{1}),fn(info.data.groupNames{2})});
    title({fn(statInf.groupComp), ['p-value ' mat2str(round(statInf.pVal,3))]},'Interpreter','none');
    xlabel('Groups to compare');
    ylabel([fn(feature) ' distribution']);
    
    set(findall(gcf,'Type','text','-depth',inf),'FontName','times','FontSize',14)
    set(findall(gcf,'Type','axes','-depth',inf),'FontName','times','FontSize',14)
    
    %%%%%%%%%%
    subplot(1,2,2);
    plot(1-spec,sens, 'LineWidth',3,'color',cmap(end,:));
    hold on; plot([0 1],[0 1],'k');

    % If a point of maximum accuracy was found it will be plotted
    if ~isempty(idMaxOa)
        hold on;
        plot(1-spec(idMaxOaPos), sens(idMaxOaPos),'ko', 'MarkerFaceColor',[0,0,0], 'Markersize', 10)
        hold off   
        h = get(gca, 'Children');
        l = legend(h(1), strcat('Accuracy = ', num2str(idMaxOa)));
        l.Box = 'off'; l.Location = 'southeast'; l.FontSize = 14;    
    end

    xlabel('False positive rate','FontSize',14); xticks(0:0.2:1); 
    ylabel('True positive rate','FontSize',14); yticks(0:0.2:1); 
    set(gca, 'FontSize', 14)
    title({('ROC for Classification by Threshold'),strcat('AUC = ',num2str(round(AUC,2)))},'Interpreter','none');
end


function [fig] = visual_pvalue_mask(statInf,info)

    fn = @cocoa_fullName;
    
    grpMeanFC = statInf.grpMeanFC;
    grp_diff = statInf.grpDiff;
    multiCorect = statInf.multiCorect;
    grpComp = statInf.grpComp;
    
    if ~strcmp(multiCorect,'none')
        pValue = statInf.pvalMask.(multiCorect);
        corMark = multiCorect;
    else
        pValue = statInf.pvalMask.treshold; 
        alpha = statInf.treshold;
        corMark = ['<' alpha];
    end
    pUnc = statInf.pvalMask.uncor;

    
    connMeasure = fn(info.connectivity.measure);
    Ngroups = info.data.Ngroup;
    dataset = fn(info.data.dataset);
    
    nF1 = 3; % rows of figure
    nF2 = Ngroups ; % columns of figure
    
    fig = figure('Name',[dataset ' ' connMeasure],'pos',[10 10 800 1100]);
    for iNgr = 1:Ngroups

        ax(iNgr) = subplot(nF1,nF2,iNgr);
        imagesc(grpMeanFC(:,:,iNgr))
        title({[connMeasure,' ' fn(info.data.groupNames{iNgr})],' average'},'Interpreter','none')
        caxis([-1 1])
        colormap(cmap)
        colorbar

    end
    
    cnt = Ngroups + 1;
    ax(cnt) = subplot(nF1,nF2,cnt);
    imagesc(ax(cnt),grp_diff)
    title(ax(cnt),{connMeasure,'group difference'},'Interpreter','none')
    colormap(ax(cnt),cmap)
    colorbar(ax(cnt))
    % getting the bigger of min/max values to ensure the colormap is
    % symmetric
    rAbsMax = round(max(abs([max(grp_diff(:)), min(grp_diff(:))]))*100)/100;
    caxis([-rAbsMax, rAbsMax]);

%% Histogram of averaged correlations            
    cnt = cnt+1;
    ax(cnt) = subplot(nF1,nF2,cnt);%[5,6]);
    histogram(ax(cnt),grpMeanFC(:,:,1),...
                'facecolor', cmap(1,:),...
                'edgecolor', [1,1,1],...
                'facealpha', 0.7,...
                'linewidth', 0.2); 
    
    hold on;
    histogram(ax(cnt),grpMeanFC(:,:,2),...
                'DisplayStyle', 'stairs',...
                'edgecolor', cmap(end,:),...
                'facealpha', 0.7,...
                'linewidth', 2);
            
    title(ax(cnt),{['Averaged ',connMeasure],' histogram'},'Interpreter','none')
    l1 = legend(ax(cnt),fn(info.data.groupNames{1}),fn(info.data.groupNames{2}));
    l1.Box = 'off'; % getting rid of the ugly legend box
    xlim([-1 1])        
    hold off;
    
%% Corrected p-values 
    %     cmp_pval = [0 0 1;1 0 0];
    cnt = cnt+1;
    ax(cnt) = subplot(nF1,nF2,cnt);
    imagesc(ax(cnt),pValue)
    
    comap = [cmap(1,:);cmap(size(cmap,1)/2,:)];
    colormap(ax(cnt),comap);
    title(ax(cnt),{fn(grpComp),['p-values (' fn(corMark) ')']},'Interpreter','none')

    hold on; % Creating hidden objects used in legend
    hidden_h(1) = surf(uint8([0 0; 0 0]), 'edgecolor', 'none', 'visible', 'off'); 
    hidden_h(2) = surf(uint8([1 1; 1 1]), 'visible', 'off'); 
    hold off

% Legend and formatting -> ISSUE would be nice to rotate the legend 90° to
% the right
    l = legend(hidden_h, {'\color{black}Not Significant','\color{black}Significant'});
    l.Location = 'southoutside';
    l.Orientation = 'horizontal';
    l.Box = 'off';
    l.TextColor = [0,0,0];

%% Histogram of uncorrected pvalues
    cnt = cnt+1;
    ax(cnt) = subplot(nF1,nF2,cnt);%[5,6]);
    histogram(ax(cnt),pUnc,...
                'facecolor', cmap(50,:),...
                'edgecolor', [1,1,1],...
                'facealpha', 0.7,...
                'linewidth', 0.2); 
    
    title(ax(cnt),{'Uncorrected p-values', 'histogram'},'Interpreter','none')
%     l2 = legend(ax(cnt),grpComp);
%     l2.Box = 'off'; % getting rid of the ugly legend box
    xlim([0 1])        

end


end
