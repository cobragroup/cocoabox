function [data_uninorm] = cocoa_marginalUniform(data)
% COCOA_MARGINALUNIFORM function transforms each column of input data
% matrix to have a uniform distribution
%
% Syntax:
%   [data_uninorm] = cocoa_marginalUniform(data)
%
% Example:
%   data = rand(100,100);
%   [data_uninorm] = cocoa_marginalUniform(data)
%
% Inputs:
%   data - matrix of time courses (time points, time series)
%
%
% Outputs:
%   data_uninorm: matrix of transformed time courses to have uniform
%   distribution (time points, time series)
%
%
%
% Toolboxes required:
% Other m-files required:
% MAT-files required:

[Nsamples,Nvariables] = size(data); 

data_uninorm=zeros(size(data));
for ivariables =1:Nvariables
    if std(data(:,ivariables))
        [~, IX]=sort(data(:,ivariables),1);
        ranking(IX)=1:Nsamples;
        normal_sample=0:1/(Nsamples-1):1;%sort(randn(Nsamples, 1));
        data_uninorm(:,ivariables) = normal_sample(ranking);
    end
end 

end
