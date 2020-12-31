function [t]=cocoa_Triangles(A)
%cocoa_Triangles - Number of triangles (cycles of length 3) around each
%                  node in the graph
%
% Syntax:  [t] = cocoa_Triangles(A)
%
%
% Inputs:
%    A - adjacency matrix of undirected graph (symetric binary matrix with zero diagonal)

%
% Outputs:
%    t - Vector of number of triangles around each node
n=size(A);
t=zeros(1,n(1));
B=A*A*A;
for i=1:1:n(1)
t(i)= 0.5*B(i,i);   
end 