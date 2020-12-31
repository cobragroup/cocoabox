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
