function [X]=cocoa_VAR1generator(A,T)
%cocoa_Thresh - Generator of vector autoregressive process of order 1. 
%               (VAR(1) process) with generating matrix A, length of time
%               series T and white noise. (X_t=A*X_(t-1)+E_t)
%
%
% Syntax:  [X] = cocoa_VAR1generator(A,T))
%

%
% Inputs:
%    A - Square real matrix with biggest (in absolute value) eigenvalue
%        less than 1 (for stationarity of the process)
%    T - Size of the sample (length of time series)
%   
% Outputs:
%    X - Time series (sampled data) of size T x n (T-rows, n-columns)


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


if (size(A,1)~=size(A,2))
    error('Input must be a square matrix')
end
n=size(A,1);
X=zeros(n,T);
X(:,1)=randn(n,1);

max_eig=max(abs(eig(A)));

if (max_eig>=1)
    error('Eigenvalues of A must be less than 1')
end



for i=2:1:T
X(:,i)=A*X(:,i-1)+randn(n,1);
end

X=transpose(X);

