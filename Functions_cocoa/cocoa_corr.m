function [correlation,pvalue] = cocoa_corr(firstTS,arg1,arg2)
% cocoa_corr - linear cross-correlation and corresponding p-value.
%
% Syntax:  [correlation,pvalue] = cocoa_corr(firstTS,secondTS, correlation type)
%       or [correlation,pvalue] = cocoa_corr(firstTS,correlation type)
%       or [correlation,pvalue] = cocoa_corr(firstTS)  
%
% Example: 
%   A = rand(100);
%   B = rand(100);
%   [correlation,pValue] = cocoa_corr(A,B,'Spearman');
%   [correlation,pValue] = cocoa_corr(A,'Pearson');
%   [correlation,pValue] = cocoa_corr(A,B);
% 
% Inputs:
%   firstTS: time series (time x region), real values matrix
%   arg1 (optional): 
%       either another time series (time x region), real values matrix
%       or correlation type ('Pearson' or 'Spearman')
%   arg2 (optional): correlation type ('Pearson' or 'Spearman')
% 
% Outputs:
%   correlation: corr(firstTS,secondTS,'type',type)
%   pvalue: corresponding p-value matrix
%
% 
% Toolboxes required: 
% Other m-files required: 
% Subfunctions: 
% MAT-files required: 


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


switch nargin
    case 1
        secondTS = firstTS;
        type = 'Pearson';
    case 2
        if isnumeric(arg1)
            secondTS = arg1;
            type = 'Pearson';
        else
            secondTS = firstTS;
            type = arg1;
        end
    case 3
        secondTS = arg1;
        type = arg2;
end

switch type
    case 'Pearson'
        workFirstTS = firstTS;
        workSecondTS = secondTS;
    case 'Spearman'
        % Spearman correlation is Pearson corr on ranks
        workFirstTS = zeros(size(firstTS));
        workSecondTS = zeros(size(secondTS));

        % rank from small to high element in every column
        for i = 1:size(firstTS,2)
            [~,Ind] = sort(firstTS(:,i),'ascend');
            workFirstTS(Ind,i) = 1:size(firstTS,1);
        end
        workFirstTS(isnan(firstTS)) = nan;
        for i = 1:size(secondTS,2)
            [~,Ind] = sort(secondTS(:,i),'ascend');
            workSecondTS(Ind,i) = 1:size(secondTS,1);
        end
        workSecondTS(isnan(firstTS)) = nan;
        
end

correlation = zeros(size(workFirstTS,2),size(workSecondTS,2));
pvalue = zeros(size(workFirstTS,2),size(workSecondTS,2));
for i = 1:size(workFirstTS,2)
    for j = 1:size(workSecondTS,2)
        [R,P] = corrcoef(workFirstTS(:,i),workSecondTS(:,j),'Rows','complete');
        correlation(i,j) = R(2,1);
        pvalue(i,j) = P(2,1);
    end
    
end

end











