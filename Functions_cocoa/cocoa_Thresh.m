function B=cocoa_Thresh(A,dens)
%cocoa_Thresh - Thresholding of (square) matrix A to binary matrix B with
%               selected density dens. Use primary for "graph" thresholding
%               weighted -> unweighted
%               diagonal elements set to zero (no loops in graph)
%
% Syntax:  [B] = cocoa_Thresh(A,dens)
%

%
% Inputs:
%    A - Square matrix (adjacency matrix of weighted graph)
%    dens - density of resulting matrix/graph (percentage of nonzero elements/edges)
% Outputs:
%    B - Thresholded, binarized matrix



n=length(A(:,1));
Y=zeros(1,n*n-n);
B=zeros(n);
w=1;
for i=1:1:n
   for j=1:1:n
       if i~=j
           Y(w)=A(i,j);
w=w+1;
       end
   end
end
Ysort=sort(Y);
Thld=Ysort(floor(1+n*(n-1)*(1-dens)));
B(A<Thld)=0;
B(A>=Thld)=1;
for j=1:1:n
    B(j,j)=0;
end

