function [M]=cocoa_ER_matrix_set_VAR1(m,n,D,s,Symmetry, Autocorrelation)
%cocoa_Thresh - Generator of random (Erdos-Renyi model based) set of matrices M with
%               optional density (percentage of nonzero elements). Each
%               matrix A from M is normalized by constant s/max(abs(eig(A))) 
%               (s is optional parameter) such as eigenvalues of A are less than 1. 
%               VAR(1) process  generated by such matrix is then stationary.
%              
%               
%
% Syntax:  [M]=cocoa_ER_matrix_set_VAR1(m,n,D,s,Symmetry, Autocorrelation)
%

%
% Inputs:
%    m - number of matrices in set
%    n - Dimension of the matrix A (nxn)
%    D - Density of matrix A (percentage of nonzero elements).
%    s - Normalizing parameter in (0,1) specifying the biggest eigenvalue
%        of A (after normalization max(abs(eig(A)))=s)
%    Symmetry - Optional parameter, option 'sym' - all matrices in M are
%               symmetric or not (option 'not_sym').
%    Autocorrelation - Optional parameter, option 'autocorr' - all matrices in M are
%               autocorrelated or not (option 'not_autocorr').
%   
% Outputs:
%    M - Set of square matrices (dimension nxn) with density D and biggest
%    eigenvalue (in absolute value) s. (Generating matrix of stationary
%    VAR(1) process. size(M)= n x n x m


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


if (s>=1)
    error('Input s must be a number in (0,1)')
end


 if ~exist('Symmetry','var')
      Symmetry = 'not_sym';
 end
 
  if ~exist('Autocorrelation','var')
      Autocorrelation = 'autocorr';
  end

M=zeros(n,n,m);


for j=1:1:m  

switch Symmetry
     case 'sym'
        A=rand(n);
        A=(A+A')/2 ;
     case 'not_sym'
        A=rand(n);
end



switch Autocorrelation
    case 'autocorr'
        for i=1:1:n
            A(i,i)=1; 
        end

    case'not_autocorr'
        for i=1:1:n
            A(i,i)=0; 
        end
end

Asort=sort(reshape(A,[1,n*n])); 
Thld=Asort(floor(n*n*(1-D))); 
A(A<=Thld)=0;
A(A>Thld)=1;




lambda=max(abs(eig(A)));

if(lambda~=0)
    A=s/lambda*A;
else
   warning('All eigenvalues of A are equal to 0');
            
end

M(:,:,j)=A;
end

