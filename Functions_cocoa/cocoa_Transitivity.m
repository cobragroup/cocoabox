function T=cocoa_Transitivity(A)
%cocoa_Transitivity - Transitivity of graph 
%
% Syntax:  [T] = cocoa_Transitivity(A)
%
%
% Inputs:
%    A - adjacency matrix of undirected graph (symetric binary matrix with zero diagonal)

%
% Outputs:
%    T - Transitivity
% Other m-files required: cocoa_Triangles.m, cocoa_Degree.m

t=cocoa_Triangles(A);
k=cocoa_Degree(A);
T=2*sum(t)/((k)*transpose(k-1)); 