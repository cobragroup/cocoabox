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

