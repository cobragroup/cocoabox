function [pval] = cocoa_stat_test2(a, b, varargin)
% Statistical tests comparing two vectors
%
% Syntax:
%   [pval] = cocoa_stat_test2(a, b, varargin)
%
% Example: 
%   a = round(rand(1,100))* 100
%   b = round(rand(1,100))* 100 + 20
%   [pval] = cocoa_stat_test2(a, b, 'method', 'ttest', 'tail', 'both')
% 
% Inputs:
%    a,b    - row vectors to be compared
%   'method'->'ttest'
%           -> 'MW' (default) Mann Whitney rank test
%   'tail'  - only for ttest    ->'right' a > b
%                               -> 'left' a < b
%                               -> 'both' a != b (default)
% 
% Outputs:
%   pval    - pvalue of the test
% 
% Toolboxes required: 
% 
% Other m-files required: 
% 
% Subfunctions: 
%   mann_whitney
%   ttest2w
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
% pre-defined parameters
def_method = 'MW';
exp_method = {'ttest', 'MW'};

def_tail = 'both';
exp_tail = {'right', 'left', 'both'};

bin_width = 0.001;

% adding parser
p = inputParser;

ValidData = @(x) isnumeric(x);

addRequired(p, 'a', ValidData);
addRequired(p, 'b', ValidData);
addOptional(p, 'method', def_method, @(x) any(validatestring(x, exp_method)));
addOptional(p, 'tail', def_tail, @(x) any(validatestring(x, exp_tail)));

p.KeepUnmatched = true;

parse(p,a,b,varargin{:})                

%% perform testing
switch p.Results.method
    case 'MW'
        [z, x, dist] = mann_whitney(a,b);
    case 'ttest'
        [z, x, dist] = ttest2w(a, b);
end

% compute pvalue 
switch p.Results.tail
    case 'right' % x greater than y
        pval = sum(dist(x < abs(z)) * bin_width);
    case 'left' % x less than y
        pval = sum(dist(x < -abs(z)) * bin_width);
    case 'both'
        pval = sum(dist(x < -abs(z)) * bin_width) + (sum(dist(x >= abs(z)) * bin_width));
end




%% Mann Whitney
function [z, x, dist] = mann_whitney(a,b)

        n1 = length(a);
        n2 = length(b);
        n = n1 + n2;

        [ab_sort, ab_por] = sort([a,b]);
        ab_por = (ab_por <= n1 ); % this is to keep track of which values belong to which set
        tie_ranks = []; % going to be needed for tie correction later

        rank_por = zeros(1,length(ab_sort)); % to be filled with rank

        % assigning the rank
        idx = 1;
        for ranki = unique(ab_sort)
            switch sum(ab_sort == ranki)
                case 1
                    rank_por(ab_sort == ranki) = idx;
                    idx = idx + 1;
                otherwise
                    rank_por(ab_sort == ranki) = mean(idx : (idx -1 + sum(ab_sort == ranki)));
                    idx = idx + sum(ab_sort == ranki);
                    tie_ranks = [tie_ranks, sum(ab_sort == ranki)];
            end
        end

        % summing across groups
        a_rank = sum(rank_por(ab_por));
        b_rank = sum(rank_por(ab_por == 0));

        u1 = a_rank -   (n1 * (n1 + 1)) / (2);
        u2 = b_rank -   (n2 * (n2 + 1)) / (2);

        u = min (u1, u2);

        % we want to approximate with normal distribution
        mu = n1 * n2 / 2;

        if length(unique(ab_sort)) == length(ab_sort)
            su = sqrt((n1 * n2 * (n + 1)) / (12));
        else
            % correction for ties
            su = sqrt( ( (n1 * n2) / (12)) * (n + 1 - sum( (tie_ranks .^ 3 - tie_ranks) ./ (n ^ 2 - n) ) ));
        end

        z = (u - mu)/(su); % z-statistic
    
        % sample normal distribution
        [x, dist] = sample_dist('normal', z);
        
end

%% ttest
function [z, x ,dist] = ttest2w(a, b)   
    c = 0;
    n1 = length(a);
    n2 = length(b);
    m1 = mean(a);
    m2 = mean(b);
    s1_2 = var(a);
    s2_2 = var(b);

    s_star = sqrt(((n1 - 1) * s1_2 + (n2 - 1) * s2_2) / (n1 + n2 -2));

    df = n1 + n2 -2;
    z = (m1 - m2 - c) / (s_star * sqrt(1 / n1 + 1 / n2));

    % sample normal distribution
    [x, dist] = sample_dist('student', z, df);
end

%% sample from appropriate distribution
function [x, dist] = sample_dist(distribution, z, varargin)
    switch distribution
        case 'normal'
            % sample normal distribution
            % pre-define parameters
            clear ndist
            mu = 0;
            sigma2 = 1;
            bound = max(ceil(abs(z)), 6);
            x = -bound : bin_width : bound;
            
            dist = 1 / ( sqrt ( 2 * pi * sigma2 ) ) .* exp( -1 / 2 .* ( ( x - mu ) .^ 2 / sigma2 ) );

        case 'student'
            % sample the student distribution
            df = varargin{:};
            bound = max(ceil(abs(z)), 6);
            x = -bound : bin_width : bound;
            
            dist = (gamma ((df + 1) / 2)) / (gamma (df / 2)) * (1 / sqrt (df * pi)) .* 1 ./ (1 + (x .^ 2 / df)) .^ ((df + 1) / 2);


    end
end




end