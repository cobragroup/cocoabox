function E=cocoa_Efficiency(A)
%cocoa_Efficiency - Efficiency of graph
%
% Syntax:  [E] = cocoa_Efficiency(A)
%
%
% Inputs:
%    A - adjacency matrix of undirected graph (symetric binary matrix with zero diagonal)

%
% Outputs:
%    E - Efficiency

E=mean(mean(1./cocoa_Distance_matrix_2(A),'omitnan'),'omitnan');
