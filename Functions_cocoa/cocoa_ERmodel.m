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


