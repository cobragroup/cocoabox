function [outArg] = cocoa_statInf_compute(statAnalysis,data,groupIndicator,varargin)
% cocoa_statInf_compute - computing statistical analysis from matrices of other 1d features.
%
% Syntax:
%   [outArg] = cocoa_statInf_compute(statAnalysis,feature,groupIndicator,varargin);
%
% Example: 
%   [outArg] = cocoa_statInf_compute(statAnalysis,feature,groupIndicator,varargin);
% 
% Inputs:
%   statAnalysis - string that defines type of analysis;
%         'p-value_mask' for comparing groups element by element in
%         connetivity
%         'ROC' - for comparison groups by 1d feature; 
%           builds ROC curve for classifier based on threshold; 
%           compares mean of feature in groups.
%   data - connectivity matrices or feature to process
%   groupIndicator - N subjects x K groups logical matrix; 
%        groupIndicator(i,j) checks if subject i belongs to group j
% 
% Optional Input:
%   'groupComparison' - group comparison, 
%       'MW' for non-parametric test,
%       'ttest' for parametric t-test.
%   'multiCorrection' - correction for multiple comparison
%       'Bonferroni','FDR','FWE','none'
%   'alpha' - threshold value for p-value masking approach.
%   'symmetry' - indicator of matrix symmetry. Default is 0 (asymmetric), 
%           1 means symmetric.
% 
% Outputs:
%   outArg - structure of output arguments. Fields depend on analysis.
%
% 
% Toolboxes required: 
% Other m-files required: 
%   cocoa_RocComp.m
%   cocoa_compute_pvalue_mask.m
% Subfunctions: 
% MAT-files required: 
     
%% Parsing

def_groupComparison = 'MW';
exp_groupComparison = {'ttest','MW'};

def_multiCorrection = 'none';
exp_multiCorrection = {'Bonferroni','FDR','FWE','none'}; %

def_alpha = 0.001;

% adding parser
p = inputParser;

ValidData = @(x) isnumeric(x);

addRequired(p, 'feature', ValidData);
addRequired(p, 'groupIndicator', @(x) islogical(x));
addOptional(p, 'groupComparison', def_groupComparison, @(x) any(validatestring(x, exp_groupComparison)));
addOptional(p, 'multiCorrection', def_multiCorrection, @(x) any(validatestring(x, exp_multiCorrection)));
addOptional(p, 'alpha', def_alpha, ValidData);
addParameter(p,'symmetry',0,@isnumeric);


p.KeepUnmatched = true;

parse(p,data,groupIndicator,varargin{:})                



%% Computations
switch statAnalysis
    case 'p-value_mask'
        grpComp = p.Results.groupComparison;
        multiCorect = p.Results.multiCorrection;
        alpha = p.Results.alpha;
        symm = p.Results.symmetry;
        [pvalMask,grpMeanFC, grpDiff] = cocoa_compute_pvalue_mask(data,groupIndicator,grpComp,multiCorect,alpha,symm);
        
        outArg.statAnalysis = 'p-value_mask';
        outArg.pvalMask = pvalMask;
        outArg.grpMeanFC = grpMeanFC;
        outArg.grpDiff = grpDiff;
        outArg.treshold = mat2str(alpha);
        outArg.multiCorect = multiCorect;
        outArg.grpComp = grpComp;
        
    case 'ROC'
        if size(data,2)>1
            error('Too many features per subject.');
        else
            labels = groupIndicator(:,1)';
            [AUC, sens, spec, oa, idMaxOa, idMaxOaPos, bins] = cocoa_RocComp(data', labels, 'toPlot',0);

            firstGroup = data(labels)';
            secondGroup = data(~labels)';
            pVal = cocoa_stat_test2(firstGroup,secondGroup, 'method', p.Results.groupComparison);

            outArg.statAnalysis = 'ROC';
            outArg.AUC = AUC;
            outArg.sens = sens;
            outArg.spec = spec;
            outArg.oa = oa;
            outArg.idMaxOa = idMaxOa;
            outArg.idMaxOaPos = idMaxOaPos;
            outArg.bins = bins;

            outArg.pVal = pVal;
            outArg.group1 = firstGroup;
            outArg.group2 = secondGroup;
            outArg.groupComp = p.Results.groupComparison;
        end        
end
        




end





