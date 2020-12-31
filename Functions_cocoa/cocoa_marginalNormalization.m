function [data_uninorm] = cocoa_marginalNormalization(data)
% COCOA_MARGINALNORMALIZATION transform each column distribution of input
% data matrix to normal distribution
%
% Syntax:
%   [data_uninorm] = cocoa_marginalNormalization(data)
%
% Example:
%   data = rand(100,100);
%   [data_uninorm] = cocoa_marginalNormalization(data)
%
% Inputs:
%   data - matrix of time courses (time points, time series)
%
% Outputs:
%   data_uninorm: matrix of preprocessed time courses
%         (time points, time series)
%
%
%
% Toolboxes required:
% Other m-files required:
% MAT-files required:

[Nsamples,Nvariables] = size(data); 

data_uninorm=zeros(size(data));
for ivariables =1:Nvariables
    [~, IX]=sort(data(:,ivariables),1);
    ranking(IX)=1:Nsamples;
    normal_sample=sort(randn(Nsamples, 1));
    data_uninorm(:,ivariables) = normal_sample(ranking);
end 

end
