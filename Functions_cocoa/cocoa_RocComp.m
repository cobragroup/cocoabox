function [AUC, sens, spec, oa, idMaxOa, idMaxOaPos, bins] = cocoa_RocComp(score, labels, varargin)
% Computing the parameters for ROC Curve plotting
% [AUC, sens, spec, oa, bins] = cocoa_RocComp(score, labels)
% 
% score...  - row vector of score; either from logistic regression or just a
% value of parameter
% labels... - 0/1 labels 
% to_plot... plot the ROC image?
% 
% Returns
% AUC...        Area Under the Curve
% sens...       Sensitivity for a set of thresholds
% spec...       Specificity for a set of thresholds
% oa...         Overal accuracy for the set of thresholds
% idMaxOa...    Maximal accuracy reached with sens & spec > 0.5
% idMaxOaPos... Number of bin with maximal accuracy
% bins...       A set of thresholds for which the upper are computed

%% Parsing
validScore = @(x) isnumeric(x) & (size(x,1) < size(x,2));
validLabels = @(x) length(unique(x)) == 2 & (size(x,1) < size(x,2));
plotDef = 1;
plotExp = [0,1];

p = inputParser;

addRequired(p, 'score', validScore);
addRequired(p, 'labels', validLabels);
addOptional(p,'toPlot', plotDef, @(x) ~isempty(intersect(plotExp, x)));

p.KeepUnmatched = true;
parse(p, score, labels, varargin{:});

%% We need to ensure, that the category with smaller mean is going to have a label of 0
if mean(score(labels)) < mean(score(~labels))
    labels = ~labels;
end

%% Compupte ROC parameters
[scSorted, scRank] = sort(score);
scLabels = labels(scRank);

binWidth = 0.001;
bins = min(score):binWidth:max(score);
nbins = length(bins);

threshMat = repmat(scSorted, nbins, 1) > bins';
scLabels = repmat(scLabels, nbins ,1);

TP = (sum(threshMat == scLabels & scLabels == 1, 2));
TN = (sum(threshMat == scLabels & scLabels == 0, 2));
FP = (sum(threshMat ~= scLabels & scLabels == 0, 2));
FN = (sum(threshMat ~= scLabels & scLabels == 1, 2));

sens = TP./(TP + FN); sens(isnan(sens)) = 0;
spec = TN./(TN + FP); spec(isnan(spec)) = 0;
oa  = (TP+TN)./(TP+TN+FP+FN);

%% AUC as a mean of two different approximations
FPR = 1-spec;
diffFPR1 = [1;FPR(1:end-1)] - FPR(1:end);
diffFPR2 = FPR(1:end) - [FPR(2:end);0];

AUC1 = sum(sens .* diffFPR1);
AUC2 = sum(sens .* diffFPR2);
AUC = (AUC1 + AUC2)/2;

%% Getting the maximal accuracy for a point with at least 50% senditivity
% AND specificity
idMaxOa = find(sens > 0.5 & spec > 0.5);

switch isempty(idMaxOa)
    case 0
         idMaxOaTemp = find(oa(idMaxOa) == max(oa(idMaxOa)));
         idMaxOaPos = idMaxOa(idMaxOaTemp(1));
         idMaxOa = oa(idMaxOaPos);
    case 1
        idMaxOa = NaN;
        idMaxOaPos = NaN; 
end

%% Plotting
if p.Results.toPlot == 1
        col = [55, 119, 113]/255; % line color for plotting

    figure; 
    plot(1-spec,sens, 'LineWidth',3,'color',col);

    % If a point of maximum accuracy was found it will be plotted
    if ~isempty(idMaxOa)
        hold on;
        plot(1-spec(idMaxOaPos), sens(idMaxOaPos),'ko', 'MarkerFaceColor',[0,0,0], 'Markersize', 12)
        hold off   
        h = get(gca, 'Children');
        l = legend(h(1), strcat('Accuracy = ', num2str(idMaxOa)));
        l.Box = 'off'; l.Location = 'southeast'; l.FontSize = 14;    
    end

    xlabel('False positive rate','FontSize',14); xticks(0:0.2:1); 
    ylabel('True positive rate','FontSize',14); yticks(0:0.2:1); 
    set(gca, 'FontSize', 14)
    title({('ROC for Classification by Threshold'),strcat('AUC = ',num2str(round(AUC,2)))});
end


end

