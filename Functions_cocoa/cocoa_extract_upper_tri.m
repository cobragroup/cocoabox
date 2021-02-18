function [vec] = cocoa_extract_upper_tri(mat)
% cocoa_extract_upper_tri - Input matrix and get the upper triangular in the vector
%
% Syntax:
%   vec = extract_upper_tri(mat)
%
% Example: 
%   vec = extract_upper_tri(mat)
% 
% Inputs:
%   mat - matrix  
% 
% Outputs:
%   vec - vector consisted of elements from upper triangle (not indcluding
%       diagonal)
% 
% Toolboxes required: 
% Other m-files required: 
% Subfunctions: 
%   extract
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


switch length(size(mat))
    case 2
        vec = extract(mat);
    case 3
        for i = 1:size(mat,3)
            vec(i,:) = extract(mat(:,:,i));
        end

        
    otherwise 
        disp('there is a problem')
end


function vec1 = extract(something)
    pk = reshape(triu(ones(size(something)),1)',[],1)';
    vec1 = reshape(something',[],1)';
    vec1(pk==0) = [];
end
        
end

