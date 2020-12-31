function [P]=cocoa_Pathlength(A)
%cocoa_Pathlength - Characteristic parth length of graph
%
% Syntax:  [P] = cocoa_Pathlength(A)
%
%
% Inputs:
%    A - adjacency matrix of undirected graph (symetric binary matrix with zero diagonal)

%
% Outputs:
%    P - Characteristic pathlength
% Other m-files required: cocoa_Distance_matrix
P=mean(mean(cocoa_Distance_matrix(A),'omitnan'),'omitnan');
