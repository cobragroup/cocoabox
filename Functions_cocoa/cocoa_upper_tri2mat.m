function [mat] = cocoa_upper_tri2mat(vec)
% cocoa_upper_tri2mat - Input vector and get back a symmetric matrix with zeros on diagonal
%
% Syntax:
%   mat = cocoa_upper_tri2mat(vec)
%
% Example: 
%   mat = cocoa_upper_tri2mat(vec)
% 
% Inputs:
%   vec - vector consisted of elements from upper triangle (not indcluding
%       diagonal)
% 
% Outputs:
%   mat - symmetrical matris, 0 on diagonal
% 
% Toolboxes required: 
% Other m-files required: 
% Subfunctions: 
% MAT-files required: 


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


dim = ceil(sqrt(2*size(vec,2)));
mat = triu(ones(dim),1);

id = 1;
for i = 1:size(mat,1)
    for j = 1:size(mat,2)
        if mat(i,j) == 1
            mat(i,j) = vec(id);
            id = id+1;
        end
    end
end

mat = mat+mat';

end
