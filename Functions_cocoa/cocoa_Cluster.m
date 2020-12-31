function [C]=cocoa_Cluster(A)
%cocoa_Cluster - Clustering coefficient of graph
%
% Syntax:  [C] = cocoa_Cluster(A)
%
%
% Inputs:
%    A - adjacency matrix of undirected graph (symetric binary matrix with zero diagonal)

%
% Outputs:
%    C - Clusterring coefficient
% Other m-files required: cocoa_Triangles.m, cocoa_Degree.m

d=size(A);
C=0;
T=cocoa_Triangles(A);
D=cocoa_Degree(A);
for i=1:1:d(1)
    if D(i)>=2 
 C=C+(2*T(i))/(D(i)*(D(i)-1)); 

    end
end  
C=C/d(1);