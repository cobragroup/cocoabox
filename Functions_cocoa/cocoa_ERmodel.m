function [ER]=cocoa_ERmodel(n,dens)
%cocoa_ERmodel - Erdos-Renyi random graph generator (undirected, no loops)
% Syntax:  [ER] = cocoa_ERmodel(n,dens)
%
% Example: 
%    [ER] = cocoa_ERmodel(50,0.25)
%       
% Inputs:
%    n - number of graph nodes 
%    dens - density of the resulting graph (percentage of edges)
%    
%
% Outputs:
%    ER - realization of Erdos-Renyi random graph (adjacency matrix)



ER=rand(n);
for i=1:1:n-1 
    ER(i,i)=0;
    for j=i+1:1:n
    ER(j,i)=ER(i,j);   
    end
end
ER(n,n)=0;
Ysort=sort(reshape(ER,[1,n*n]));
YThld=Ysort(floor(n+n*(n-1)*(1-dens))); 
ER(ER<=YThld)=0;
ER(ER>YThld)=1;


