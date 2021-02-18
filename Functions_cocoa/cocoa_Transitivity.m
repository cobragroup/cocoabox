function T=cocoa_Transitivity(A)
%cocoa_Transitivity - Transitivity of graph 
%
% Syntax:  [T] = cocoa_Transitivity(A)
%
%
% Inputs:
%    A - adjacency matrix of undirected graph (symetric binary matrix with zero diagonal)
%
% Outputs:
%    T - Transitivity
% Other m-files required: cocoa_Triangles.m, cocoa_Degree.m


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


t=cocoa_Triangles(A);
k=cocoa_Degree(A);
T=2*sum(t)/((k)*transpose(k-1)); 