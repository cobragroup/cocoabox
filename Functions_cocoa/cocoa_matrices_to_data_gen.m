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



X=zeros(T,size(M,1),size(M,3));


for i=1:1:size(M,3)
    X(:,:,i)=cocoa_VAR1generator(M(:,:,i),T);  
end