function [fig] = cocoa_connectivity_visual(connMatr,info,varargin)
% cocoa_connectivity_visual - Connectivity measure visualisation.
%
% Syntax:
%   [fig] = cocoa_connectivity_visual(connMatr,info,varargin);
%
% Example: 
%   [fig] = cocoa_connectivity_visual(connMatr,info);
%   [fig] = cocoa_connectivity_visual(connMatr,info,'Nmat',13);
%   [fig] = cocoa_connectivity_visual(connMatr,info,'selMatr',[10 2 13 33 145]);
%
% Inputs:
%   connMatr: N regions x N regions x M realisations
%   info: structure with information about connectivity measures and so on
%   Nmat (optional): number of matrices to show. Predefined value Nmat = 1
%       in case of bigger Nmat, half of matrices will be shown from the
%       beginning of the dataset, the rest - from the end.
%   selectMatr (optional): indeces of matrices to show. Predefined is [1].
% 
% Outputs:
%   fig - figure with images of a few connectivity matrices (depending on
%       input parameters)
% 
% Toolboxes required: 
% Other m-files required: 
%   cocoa_fullName.m,
% Subfunctions: 
% MAT-files required: 

%% Parsing

def_matrSet = [1];

% adding parser
p = inputParser;

ValidData = @(x) isnumeric(x);

addRequired(p, 'connMatr', ValidData);
addRequired(p, 'info', @(x) isstruct(x));
addOptional(p, 'Nmat', 1, ValidData);
addOptional(p, 'selectMatr', def_matrSet, ValidData);

p.KeepUnmatched = true;

parse(p,connMatr,info,varargin{:})                



%% Computations
fn = @cocoa_fullName;

cmap = load('cocoa_cmap.mat'); % loading custom color - blinded friendly colormap
cmap = cmap.cmap;

if length(p.Results.selectMatr)>=p.Results.Nmat
    selMatr = p.Results.selectMatr;
    Nmat = length(selMatr);
    if max(selMatr)>size(connMatr,3)
        warning('Too high realization number');
        selMatr(selMatr>size(connMatr,3)) = [];
        Nmat = length(selMatr);
    end
else
    Nmat = p.Results.Nmat;
    N1 = floor(Nmat/2);
    N2 = Nmat - N1;
    selMatr = [1:N1, size(connMatr,3)-N2+1:size(connMatr,3)];
end

connMeasure = fn(info.connectivity.measure);
dataset = fn(info.data.dataset);

nF1 = round(sqrt(Nmat)); % rows of figure
nF2 = floor(Nmat/nF1)+1*(mod(Nmat,nF1)~=0); % columns of figure

fig = figure('Name',[fn(dataset) ' ' fn(connMeasure)],'pos',[10 10 400*nF2 300*nF1]);
for iMat = 1:Nmat

    ax(iMat) = subplot(nF1,nF2,iMat);
    imagesc(connMatr(:,:,selMatr(iMat)))
    title({fn(connMeasure), ['Realization ' mat2str(selMatr(iMat))]},'Interpreter','none')
    caxis([-1 1])
    colormap(cmap);
    colorbar

end


end