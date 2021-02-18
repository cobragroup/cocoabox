function [pmasked, critp] = cocoa_comparCorr(pvals, varargin)
% The function will perfomr the correction for multiple comparisons
% 
% Syntax:
%   [critp, pmasked] = cocoa_comparCorr(pvals, varargin)
% 
% Example:
%   [critp, pmasked] = cocoa_comparCorr(pvals, 'method', 'FWE', 'alpha', '0.01')
% 
% Inputs:
%   pvals   - vector of pvalues
%   method  - 'FWE' - Hochenberg FWE correction (default)
%           - 'FDR' - Benjamini Hochenberg FDR correction
%           - 'Bonferroni' - conservative FWE correction 
%           - 'none' - will only threshold the pvalues based on alpha
%   alpha	- alpha - level of control (0.05 for 5% - default)
% 
% Outputs:
%   pmasked - masked pvalues 0/1 for statistically notsignificant / significant values 
%   critp   - modified alpha level
% 
% Toolboxes required:
% 
% Other m-files required:
% 
% Subfunctions:
%   BH_corr
%   Bonferroni_corr
%   Hochenberg_corr
%   no_corr
% 
% MAT-files required:
% 


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


%% PARSING
def_method = 'FWE';
exp_method = {'Bonferroni', 'FDR', 'FWE', 'none'};

def_alpha = 0.05;

p = inputParser;
addRequired(p, 'pvals', @(x) isnumeric(x));
addOptional(p, 'method', def_method, @(x) any(validatestring(x,exp_method)));
addOptional(p, 'alpha', def_alpha, @(x) isnumeric(x));

p.KeepUnmatched = true;
parse(p, pvals, varargin{:});

%% EVAL CORRECTION

switch p.Results.method
    case 'FWE'
        [critp, pmasked] = Hochenberg_corr(pvals, p.Results.alpha);
    case 'Bonferroni'
        [critp, pmasked] = Bonferroni_corr(pvals, p.Results.alpha);
    case 'FDR'
        [critp, pmasked] = BH_corr(pvals, p.Results.alpha);
    case 'none'
        [critp, pmasked] = no_corr(pvals, p.Results.alpha);
end


% Bonferroni correction
    function [critp, pmasked] = Bonferroni_corr(pvals,alpha)
        % Bonferroni correction
        % [critp, pmasked] = Bonferroni_corr(pvals)
        %
        % accepts only pvalues smaller than alpha/no.tests
        
        npvals = length(pvals);
        critp = alpha / npvals;
        pmasked = pvals < critp;
    end

% Hochenberg FWE Procedure
    function [critp, pmasked] = Hochenberg_corr(pvals, alpha)
        % FWE Hochenberg procedure
        % [critp, pmasked] = Hochenberg_corr(pvals, alpha)
        %
        % 1. sort pval in ascending order
        % 2. for a given alpha R is the largest k such that P_k <= alpha/(no.tests - k + 1)
        % 3. Reject H_1 ... H_R
        
        npvals = length(pvals);
        pSorted = sort(pvals);
        pRank = 1:length(pSorted);
        
        critp = find((pSorted < (alpha ./ (npvals - pRank +1)) == 0));
        
        switch ~isempty(critp)
            case 1 
                critp = pSorted(critp(1));
            case 0 
                critp = alpha;
                disp('All values are statistically significant')
        end
            
        pmasked = pvals < critp;
        
    end


% Benjamini Hochenberg FDR correction
    function [critp, pmasked] = BH_corr(pvals, alpha)
        % Benjamini-Hocheberg procedure
        % [critp, pmasked] = BH_corr(pvals, alpha)
        %
        % 1. sort pval in ascending order
        % 2. assign ranks to pvals 1...n
        % 3. calculate individual p-vals BH critical value using the formula
        %   (individual p-rank / total number of tests) * the false discovery rate
        % 4. compare original p-vals to the critical BH; find the largest p-value
        % that is smaller than the critical valuefa

        % artificial function check
        % pvals = abs(rand(1,100)-0.2)*0.1;
        % alpha = 0.05;

        npvals = length(pvals);
        pSorted = sort(pvals);
        pRank = 1:length(pSorted);


        critp = find((pSorted < (pRank / npvals * alpha)) == 0);
        
        switch ~isempty(critp)
            case 1 
                critp = pSorted(critp(1));
            case 0 
                critp = alpha;
                disp('All values are statistically significant')
        end
        
        pmasked = pvals < critp;
    end

% No correction, just threshold existing pvalues
    function [critp, pmasked] = no_corr(pvals, alpha)
        % The masked matrix are just thresholded pvalues, based on
        % alpha-level
        critp = alpha;
        pmasked = pvals < alpha;
    end


end