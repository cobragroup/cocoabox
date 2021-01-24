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

X=zeros(T,size(A,1),num_subj);


for i=1:1:num_subj

    X(:,:,i)=cocoa_VAR1generator(A,T);  
end