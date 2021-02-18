function   [r] = cocoa_Assortativity(A)
%cocoa_Assortativity - Assortativity of graph
%
% Syntax:  [r] = cocoa_Assortativity(A)
%
%
% Inputs:
%    A - adjacency matrix of undirected graph (symetric binary matrix with zero diagonal)
%
% Outputs:
%    r - Assortativity
% Other m-files required: cocoa_Degree.m, cocoa_corr.m


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


Deg_vec=cocoa_Degree(A);
[i,j]=find(A);

a=Deg_vec(i);
b=Deg_vec(j);


r = cocoa_corr(a',b');

end