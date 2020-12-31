function [data, labels, labstring] = cocoa_InputParsing(fileName, varargin)
% This function will parse the input matlab file and reformat it to the purpose of this pipeline
% 
% Syntax:
%   [data, labels, labstring] = cocoa_InputParsing(fileName, varargin)
% 
% Example:
%   [data, labels, labstring] = cocoa_InputParsing('data.mat', 'labelsName', 'labels.mat')
% 
% Inputs:
%   fileName - path to the file you want to load either
%            - 3d connectivity matrix timepoints x ROI
%            - structure with two fields - one wih 3d matrix and one with
%            vector of labels
%            - two variables : 3d data array and vector of labels
%   lebelsName  - if there is only 3D array present in the filename, you have to provide labels filename
%               - as a vector of labels - either 0/1 or a vector of
%               cellstrings - in thet case, they will be transformed into
%               0/1 labels in alphabetical order of labels
% Outputs:
%   data        - 3d array of data timepoints x ROI
%   labels      - 0/1 vector of labels
%   labstring   - if labels are in a form of string, labstring coontains the names of two categories
%     
% Toolboxes required:
% 
% Other m-files required: 
% 
% Subfunctions: 
%   twoVarsInSpace
%   resolveLabels
%   struc2var
%   Nstruct2var
%   twoFilesInSpace
% 
% MAT-files required: 
% 

%% Parsing - controlling the string
p = inputParser;

validName = @(x) ischar(x) | isstring(x);

expLabelsName = NaN;

addRequired(p, 'fileName', validName);
addOptional(p, 'labelsName', expLabelsName);

parse(p, fileName, varargin{:})

fileParts = whos(matfile(fileName)); % look into the file withou touching

if ~isnan(p.Results.labelsName)
    labelParts = whos(matfile(p.Results.labelsName)); 
end

%%
% lets try to define all possible combinations of inputs
switch sum(isnan(p.Results.labelsName)) % only one file provided
    
    case 1 % 1 file -> structure with two fields - data and labels
        
%% 2 variables in space
        if length(fileParts) == 2 % 
        [data, labels] = twoVarsInSpace(fileName, fileParts);
        [labels, labstring] = resolveLabels(labels, data);

%% structure with 2 fieldnames
        elseif strcmp(fileParts.class, 'struct') % structure in matfile
            load(fileName) % load the file
            loadedStruct = eval(fileParts.name);
            
            if numel(fieldnames(loadedStruct )) == 2
                fNames = fieldnames(loadedStruct);
                
                % if there is one 3D array + one vector in the structure
                switch length(loadedStruct)
                    case 1
                        [data, labels] = struc2var(loadedStruct, fNames);
                        [labels, labstring] = resolveLabels(labels, data);
                    
                    % if the structure is N-dimensional - N = number of subjects
                    otherwise 
                        % this is to find which field is label and which the timepoints
                        if strcmp(class(loadedStruct(1).(fNames{1})), 'double') && length(unique(loadedStruct(1).(fNames{1}))) > 2
                           
                            dataId = 1; labelsId = 2;
                            [data, labels] = Nstruct2var(dataId, labelsId, loadedStruct, fNames);
                            [labels, labstring] = resolveLabels(labels, data);
                           
                        end
                        
                        if strcmp(class(loadedStruct(1).(fNames{2})), 'double') && length(unique(loadedStruct(1).(fNames{2}))) > 2
                            
                            dataId = 2; labelsId = 1;
                            [data, labels] = Nstruct2var(dataId, labelsId, loadedStruct, fNames);
                            [labels, labstring] = resolveLabels(labels, data);

                        end
                        
                        
                end

            else
                error('The structure may only have two fields')
            end
            
            
        else % error
            error('You have to provide either two mat files with data and labels; or one file containiny two variables - data and labels or a structure with two fields')
            
        end
        
%% 2 files - one with data; one with labels        
    case 0 
        [data, labels] = twoFilesInSpace(fileName, p.Results.labelsName);
        [labels, labstring] = resolveLabels(labels, data);

end

%% Control the dimensions
if size(data,3) ~= length(labels)
    error('Data must me in a timepoints x ROI x subject array!')
end    
   
% labels is a row vector
if size(labels,2) < size(labels,1)
    labels = labels';
end



end

%% Two variables are loaded in one mat file
function [data,labels] = twoVarsInSpace(fileName, fileParts)
    sizes = arrayfun(@(x) length(x.size), fileParts)';
    names = arrayfun(@(x) (x.name), fileParts, 'UniformOutput', false)';
            
    load(fileName)
    data = eval(names{sizes == 3});
    labels = eval(names{sizes == 2});
end

%% Dealing with the string in labels
function [labels, uLabs] = resolveLabels(labs, data)
        
    uLabs = sort(unique(string(labs)));
    
    if length(uLabs) ~= 2 % if there are more than two distinct labels
        error('Only two groups of elements are supported')
    end
    
    labels = zeros(1,size(data,3));
    labels(strcmp(string(labs), uLabs(2))) = 1;
end

%% Load data in structure where there is one 3D array and one vector
function [data, labels] = struc2var(loadedStruct, fNames)
    sizes = [length(size(loadedStruct.(fNames{1}))), length(size(loadedStruct.(fNames{2})))];
    dataId = find(sizes == 3);
    
    if isnan(dataId) || length(dataId) ~=1
        error('Data array has to be three dimensional');
    end

	labelsId = find(sizes == 2);               
	if isnan(labelsId) || length(labelsId) ~=1
    	error('Data array has to be three dimensional');
    end

    data = loadedStruct.(fNames{dataId});
    labels = loadedStruct.(fNames{labelsId});
end

%% Load the data from struture with N fields, where N = number of subjects
function [data, labels] = Nstruct2var(dataId, labelsId, loadedStruct, fNames)
    data = arrayfun(@(x) x.(fNames{dataId}), loadedStruct, 'UniformOutput', false) ;
    data = cat(3, data{:});

    labels = arrayfun(@(x) x.(fNames{labelsId}), loadedStruct, 'UniformOutput', false);

%     uLabs = unique(string(arrayfun(@(x) x.(fNames{labelsId}), loadedStruct, 'UniformOutput', false)));
%     if length(ulabs) ~= 2 % if there are more than two distinct labels
%         error('Only two groups of elements are supported')
%     end
%     labels = zeros(1,size(data,3));
%     labels(strcmp(string(labs), uLabs(2))) = 1;
end

%% Load the data if two inputs are given 
function [data, labels] = twoFilesInSpace(fileName, labelsName)
    
	fileParts = whos(matfile(fileName));
	labelsParts = whos(matfile(labelsName));
        
    if length(fileParts.size) == 3 || length(labelsParts.size) == 3
        if length(fileParts.size) == 3
            trueFileName = fileName;
            trueFileParts = fileParts;
            trueLabelsName = labelsName;
            trueLabelsParts = labelsParts;
            
        else
            trueFileName = labelsName;
            trueFileParts = labelsParts;
            trueLabelsName = fileName;
            trueLabelsParts = fileParts;
        end
    else
        error('no file with the 3D array present')
    end
    
    load(trueFileName)
    load(trueLabelsName)
    
    data = eval(trueFileParts.name);
    labels = eval(trueLabelsParts.name);
     
end