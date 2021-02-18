function [X]=cocoa_matrices_to_data_gen(M,T)
%cocoa_Thresh - Generator of vector autoregressive process of order 1. 
%               (VAR(1) process) with generating matrices M 
%               (each subject is generated with matrix A from set of matrices M) length of time
%               series T, number of subjects (num_subj) and white noise E_t. 
%               (X_t=A*X_(t-1)+E_t)
%
%
% Syntax:  [X] = cocoa_matrices_to_data_gen(M,T)
%
%
% Inputs:
%    M - Set of square real matrix with biggest (in absolute value) eigenvalue
%        less than 1 (for stationarity of the process). 
%        Size of M = n x n x number of subjets (n x n - dimension of each square matrix)
%        
%        
%    T - Size of the sample (length of time series)
%   
% Outputs:
%    X - Time series (sampled data) of size T x n x num_subj


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


X=zeros(T,size(M,1),size(M,3));


for i=1:1:size(M,3)
    X(:,:,i)=cocoa_VAR1generator(M(:,:,i),T);  
end