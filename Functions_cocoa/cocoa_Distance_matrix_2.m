
function D=cocoa_Distance_matrix_2(A)
%cocoa_Distance_matrix - Matrix of distances between all nodes in graph
% distance between disconnected nodes = Inf
%
% Syntax:  [D] = cocoa_Distance_matrix_2(A)
%
%
% Inputs:
%    A - adjacency matrix of undirected graph (symetric binary matrix with zero diagonal)

%
% Outputs:
%    D - Distance matrix

s=size(A);
n=s(1);
D=zeros(size(A));
A(A~=0)=1;          %thresholding (binarizing) of A to zero/nonzero values

D=A;              %D - distance matrix (alocation)
                  %A(A==1) node pairs connected by path of length 1

L=A*A;            % A^k(A^k>1)  node pairs connected by path of length k


Cond=(L~=0)&(D==0);
length=2;
while (any(Cond(:)))
Cond=(L~=0)&(D==0); 
D(Cond)=length;
L=L*A;
length=length+1;
end

D(D==0)=Inf;  

for i=1:1:n
D(i,i)=NaN;    
end

