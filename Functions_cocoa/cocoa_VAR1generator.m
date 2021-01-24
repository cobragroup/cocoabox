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

