function [graph_props]=cocoa_graph_prop_undir(matrices,label,dens,p)
%cocoa_graph_prop_undir - Script for computation graph theoretical
%properties of (symetric )connectivity matrix. Input is set of matrices of two
%categories (category is given by "label".)  Matrices are first thresholded
%to density "dens", graph properties (containing: Clustering coefficient, 
%Characteristic pathlength, Small-world coefficient, Efficiency, Transsitivity
% and Assortativity) are then computed. 
%                         
%
% Syntax:  [graph_props]=cocoa_graph_prop_undir(data,label,dens,p)
%
%
% Inputs:
%    matrices - set of matrices (dimension x dimension x number of subjects)
%    label - indicator of the group (number of subjects x 2) "(0,1)" =
%    firste group, "(1,0)" = second ggroup
%    dens - thresholding density (percentage of nonzero elements)
%    p - p-value for statistal comparison of difference between groups in
%    each GT property
%
% Outputs:
%  graph_props - structure containing results of GT properties 
%  graph_props.Cluster_coef_A...Clustering coefficient of matrices in first group
%  graph_props.Cluster_coef_B...Clustering coefficient of matrices in second group
%  graph_props.Pathlength_A...Characteristic pathlength of matrices in first group
%  graph_props.Pathlength_B..Characteristic pathlength of matrices in second group
%  graph_props.SW_A...Small-world coeffciient of matrices in first group
%  graph_props.SW_B...Small-world coeffciient of matrices in second group
%  graph_props.Transitivity_A...Transitivity of matrices in first group
%  graph_props.Transitivity_B...Transitivity of matrices in second group
%  graph_props.Efficiency_A...Efficiency of matrices in first group
%  graph_props.Efficiency_B...Efficiency of matrices in second group
%  graph_props.Assortativity_A...Assortativity of matrices in first group
%  graph_props.Assortativity_B...Assortativity of matrices in second group
%  graph_props.significant_props...Properties with a significant difference across groups         
%    
%

% Other m-files required: cocoa_Cluster.m, cocoa_Pathlength.m, cocoa_Thresh.m, 
%                         cocoa_Transitivity.m, cocoa_Efficiency.m,
%                         cocoa_Assortativity.M, cocoa_ERmodel.m





    [n,n2,num_subj]=size(matrices);
    subj=sum(label);
    num_groupA=subj(1);
    num_groupB=subj(2);


    Cluster_coef_A=zeros(num_groupA,1);
    Cluster_coef_B=zeros(num_groupB,1);
    Pathlength_A=zeros(num_groupA,1);
    Pathlength_B=zeros(num_groupB,1);
    SW_A=zeros(num_groupA,1);
    SW_B=zeros(num_groupB,1);
    Transitivity_A=zeros(num_groupA,1);
    Transitivity_B=zeros(num_groupB,1);
    Efficiency_A=zeros(num_groupA,1);
    Efficiency_B=zeros(num_groupB,1);
    Assortativity_A=zeros(num_groupA,1);
    Assortativity_B=zeros(num_groupB,1);

    indA=1;
    indB=1;

    N=100;
    Cluster_ER=0;
    Pathlength_ER=0;
    for i=1:1:N
       ER=cocoa_ERmodel(n,dens);
       Cluster_ER=Cluster_ER+cocoa_Cluster(ER);
       Pathlength_ER=Pathlength_ER+cocoa_Pathlength(ER);  
    end

    Cluster_ER=Cluster_ER/N;
    Pathlength_ER=Pathlength_ER/N;
    
    for i=1:1:num_subj
    M=matrices(:,:,i);
    M=cocoa_Thresh(M,dens);
    group=label(i,:);
    
    
  
        switch group(1)
       
            case 1
            Cluster_coef_A(indA)=cocoa_Cluster(M);
            Pathlength_A(indA)=cocoa_Pathlength(M);
            SW_A(indA)=(cocoa_Cluster(M)/Cluster_ER)/(cocoa_Pathlength(M)/Pathlength_ER);
            Transitivity_A(indA)=cocoa_Transitivity(M);
            Efficiency_A(indA)=cocoa_Efficiency(M);
            Assortativity_A(indA)=cocoa_Assortativity(M);
            indA=indA+1;

    
            case 0
            Cluster_coef_B(indB)=cocoa_Cluster(M);
            Pathlength_B(indB)=cocoa_Pathlength(M);
            SW_B(indB)=(cocoa_Cluster(M)/Cluster_ER)/(cocoa_Pathlength(M)/Pathlength_ER);
            Transitivity_B(indB)=cocoa_Transitivity(M);
            Efficiency_B(indB)=cocoa_Efficiency(M);
            Assortativity_B(indB)=cocoa_Assortativity(M);
            indB=indB+1;

        
        end    
        
       
end
    graph_props.Cluster_coef_A=Cluster_coef_A;
    graph_props.Cluster_coef_B=Cluster_coef_B;
    graph_props.Pathlength_A=Pathlength_A;
    graph_props.Pathlength_B=Pathlength_B;
    graph_props.SW_A=SW_A;
    graph_props.SW_B=SW_B;
    graph_props.Transitivity_A=Transitivity_A;
    graph_props.Transitivity_B=Transitivity_B;
    graph_props.Efficiency_A=Efficiency_A;
    graph_props.Efficiency_B=Efficiency_B;
    graph_props.Assortativity_A=Assortativity_A;
    graph_props.Assortativity_B=Assortativity_B;
    
    
    graph_props.properties=["Clustering coefficient";"Characteristic pathlength";"Small-world coefficient";"Transitivity";"Efficiency";"Assortativity"];
    graph_props.significance=[cocoa_stat_test2(Cluster_coef_A',Cluster_coef_B'),cocoa_stat_test2(Pathlength_A',Pathlength_B'),cocoa_stat_test2(SW_A',SW_B'),cocoa_stat_test2(Transitivity_A',Transitivity_B'),cocoa_stat_test2(Efficiency_A',Efficiency_B'),cocoa_stat_test2(Assortativity_A',Assortativity_B')]; 
    
    graph_props.significant_props=properties( graph_props.significance<p);
    
    

end