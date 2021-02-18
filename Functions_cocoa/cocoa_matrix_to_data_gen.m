function [X]=cocoa_matrix_to_data_gen(A,T,num_subj)
%cocoa_Thresh - Generator of vector autoregressive process of order 1 
%               (VAR(1) process) with generating matrix A 
%               (each subject is generated with the same matrix A) length of time
%               series T, number of subjects (num_subj) and white noise E_t. 
%               (X_t=A*X_(t-1)+E_t)
%
%
% Syntax:  [X] = cocoa_matrix_to_data_gen(A,T,num_subj)
%
%
% Inputs:
%    A - Square real matrix with biggest (in absolute value) eigenvalue
%        less than 1 (for stationarity of the process)
%    T - Size of the sample (length of time series)
%    num_subj - Number of subjects
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


X=zeros(T,size(A,1),num_subj);


for i=1:1:num_subj

    X(:,:,i)=cocoa_VAR1generator(A,T);  
end