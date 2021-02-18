
function [fig]=cocoa_viz_graph(results,info)
%cocoa_viz_graph - Visualization of graph theretical properties comparison
%of two groups of subjetcs. Speciific visualization function for cocoa.
%
% Syntax:  [fig]=cocoa_viz_graph(results,info)
%
%
% Inputs:
%    result - result structure (cocoa pipeline)
%    info - info structure (cocoa pipeline)
%
% Outputs: fig - figure/scheme of GT properties comparison
%    
%
% 
% Other m-files required: bplot.m


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


fig=figure('Name', 'Graph-theoretical analysis','Position', [10 10 900 900]);
subplot(3,2,1)
    hold on;
    bplot(results.graph.Cluster_coef_A',1,'outliers');
    bplot(results.graph.Cluster_coef_B',3,'outliers');
    hold off;
    box on;
    axis([0 4, min([results.graph.Cluster_coef_A' results.graph.Cluster_coef_B']) max([results.graph.Cluster_coef_A' results.graph.Cluster_coef_B'])]);
    xticks([1 3]);
    xticklabels({(info.data.groupNames{1}),(info.data.groupNames{2})});
    title({ ('Clustering coefficient'), ['p = ',num2str(results.graph.significance(1))]})
subplot(3,2,2)
    hold on;
    bplot(results.graph.Pathlength_A',1,'outliers');
    bplot(results.graph.Pathlength_B',3,'outliers');
    hold off;
    box on;
    axis([0 4, min([results.graph.Pathlength_A' results.graph.Pathlength_B']) max([results.graph.Pathlength_A' results.graph.Pathlength_B'])]);
    xticks([1 3]);
    xticklabels({(info.data.groupNames{1}),(info.data.groupNames{2})});
    title({ ('Characteristic pathlength'), ['p = ',num2str(results.graph.significance(2))]})
subplot(3,2,3)
    hold on;
    bplot(results.graph.SW_A',1,'outliers');
    bplot(results.graph.SW_B',3,'outliers');
    hold off;
    box on;
    axis([0 4, min([results.graph.SW_A' results.graph.SW_B']) max([results.graph.SW_A' results.graph.SW_B'])]);
    xticks([1 3]);
    xticklabels({(info.data.groupNames{1}),(info.data.groupNames{2})});
    title({ ('Small-world coefficient'), ['p = ',num2str(results.graph.significance(3))]})
subplot(3,2,4)
    hold on;
    bplot(results.graph.Efficiency_A',1,'outliers');
    bplot(results.graph.Efficiency_B',3,'outliers');
    hold off;
    box on;
    axis([0 4, min([results.graph.Efficiency_A' results.graph.Efficiency_B']) max([results.graph.Efficiency_A' results.graph.Efficiency_B'])]);
    xticks([1 3]);
    xticklabels({(info.data.groupNames{1}),(info.data.groupNames{2})});
    title({ ('Efficiency'), ['p = ',num2str(results.graph.significance(4))]})
subplot(3,2,5)
    hold on;
    bplot(results.graph.Transitivity_A',1,'outliers');
    bplot(results.graph.Transitivity_B',3,'outliers');
    hold off;
    box on;
    axis([0 4, min([results.graph.Transitivity_A' results.graph.Transitivity_B']) max([results.graph.Transitivity_A' results.graph.Transitivity_B'])]);
    xticks([1 3]);
    xticklabels({(info.data.groupNames{1}),(info.data.groupNames{2})});
    title({ ('Transitivity'), ['p = ',num2str(results.graph.significance(5))]})
subplot(3,2,6)
    hold on;
    bplot(results.graph.Assortativity_A',1,'outliers');
    bplot(results.graph.Assortativity_B',3,'outliers');
    hold off;
    box on;
    axis([0 4, min([results.graph.Assortativity_A' results.graph.Assortativity_B']) max([results.graph.Assortativity_A' results.graph.Assortativity_B'])]);
    xticks([1 3]);
    xticklabels({(info.data.groupNames{1}),(info.data.groupNames{2})});   
    title({ ('Assortativity'), ['p = ',num2str(results.graph.significance(6))]})

    
set(findall(gcf,'Type','text','-depth',inf),'FontName','times','FontSize',14)
set(findall(gcf,'Type','axes','-depth',inf),'FontName','times','FontSize',12)


    
    
end