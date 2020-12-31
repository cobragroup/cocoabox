
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