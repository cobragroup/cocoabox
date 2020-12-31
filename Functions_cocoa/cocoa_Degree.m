function [d]=cocoa_Degree(A)
%cocoa_Degree - Vector of graph node degrees
%
% Syntax:  [d] = cocoa_Degree(A)
%
%
% Inputs:
%    A - adjacency matrix of undirected graph (symetric binary matrix with zero diagonal)

%
% Outputs:
%    d - Vector of graph node degrees
n=size(A);
d=zeros(1,n(1));
for i=1:1:n(1)
d(i)=sum(A(i,:));  
end  