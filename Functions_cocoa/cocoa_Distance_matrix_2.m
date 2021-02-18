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


% This file is part of Cocoabox. Cocoabox (Complex Connectivity Analysis 
% toolbox) is a library of software modules for modeling and analysis of 
% complex systems.
%
% Cocoabox is a free software: you can redistribute it and/or modify it 
% under the terms of the GNU Affero General Public License as published 
% by the Free Software Foundation, either version 3 of the License, 
% or (at your option) any later version.
% 
% Cocoabox is distributed in the hope that it will be useful, but WITHOUT 
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
% FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public 
% License for more details.
% 
% URL:          https://github.com/cobragroup/cocoabox
% Authors:      The full list of authors is available in the README file.
% Copyright:    Copyright (c) 2020, Institute of Computer Science of 
%               the Czech Academy of  Sciences
% License:      GNU AFFERO GENERAL PUBLIC LICENSE (AGPL) 3.0.
%               For license details see the LICENSE file. 
%               For other licensing options including more permissive 
%               licenses, please contact the first author (hlinka@cs.cas.cz) 
%               or e-mail licensing@cs.cas.cz.


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

