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

