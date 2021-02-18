function [A] = cocoa_dd(A,k)
% cocoa_dd - remove diagonal and puth there chosen number
%
% Syntax:
%   [A] = cocoa_dd(A,k);
%   [A] = cocoa_dd(A);
%
% Example: 
%   A = rand(10);
%   [A] = cocoa_dd(A,nan);
%   [A] = cocoa_dd(A);
%   [A] = cocoa_dd(A,13);
%
% Inputs:
%   A: matrix Nx(m*N) - one squared matrix or few merged squared matcies
%   k: value to put on the diagonal (all diagonals, if m>1)
% 
% Outputs:
%   A: matrix with value k on diagonal (predefined k = 0)
%
% 
% Toolboxes required: 
% Other m-files required: 
% Subfunctions: 
%   deleteDiagonal
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


if nargin<2
   k = 0;
end
   
    A = deleteDiagonal(A,k);
    
    
function [clA] = deleteDiagonal(A, val)
% Delete diagonal elements from the matrix A
% change them into 'val'

if nargin<2
    val = 0;
end

sizeA = size(A);
p = sizeA(2)/sizeA(1);

clA = A;

for i=1:p
    for j=1:sizeA(1)
        clA(j,(i-1)*sizeA(1)+j) = val;
    end
end


end    
end
