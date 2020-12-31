function   [r] = cocoa_Assortativity(A)
%cocoa_Assortativity - Assortativity of graph
%
% Syntax:  [r] = cocoa_Assortativity(A)
%
%
% Inputs:
%    A - adjacency matrix of undirected graph (symetric binary matrix with zero diagonal)

%
% Outputs:
%    r - Assortativity
% Other m-files required: cocoa_Degree.m, cocoa_corr.m
Deg_vec=cocoa_Degree(A);
[i,j]=find(A);

a=Deg_vec(i);
b=Deg_vec(j);


r = cocoa_corr(a',b');

end