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
