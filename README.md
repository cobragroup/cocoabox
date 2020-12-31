# Cocoabox

Cocoabox (Complex Connectivity Analysis toolbox) is a library of software modules for modeling and analysis of complex systems, implemented in MATLAB. It makes the analysis of complex systems simple by combining a set of tools for advanced data analysis usually available in separate libraries (dimension reduction, visualisation, estimation of linear and nonlinear dependence, theoretical analysis of graphs, and more). Its modular architecture makes it easily adaptable to the needs of various application areas. 

Future versions will include further modules, as well as additional parameter options for existing modules.

## Requirements
MATLAB. Recommended version: 2020b.

## Usage
Download the entire repo and run `cocoabox.mlapp` to analyse your data within a user interface. For instructions on using the GUI, see the [GUI User Manual](https://github.com/cobragroup/cocoabox#gui-user-manual) below.

Alternatively, select relevant MATLAB functions and use them in your analyses. The functions are divided into two folders - "Functions_cocoa" and "Functions_external" - and documented directly in their headers. 

## Authors 
Jaroslav Hlinka, Lucia Jajcay, Barbora Bučková, Stanislav Jiříček, Jakub Kořenek, Anna Pidnebesna, David Tomeček

Institute of Computer Science, Czech Academy of Sciences

COBRA group - http://cobra.cs.cas.cz 

## Contact
Jaroslav Hlinka - hlinka@cs.cas.cz

This software is made available under the AGPL 3.0 licence. For other licensing options including more permissive licenses, please contact the ICS CAS using the contact email address above.

## How to cite
If using this software for academic work, please cite it in your publications as:

Hlinka, J. et al. (2020) Cocoabox, GitHub repository, https://github.com/cobragroup/cocoabox.

BibTex:
```
@software{cocoabox, 
author = {Hlinka, Jaroslav and Jajcay, Lucia and Bučková, Barbora and Jiříček, Stanislav and Kořenek, Jakub and Pidnebesna, Anna and Tomeček, David}, 
title = {{Cocoabox}}, 
year = {2020}, 
url = {https://github.com/cobragroup/cocoabox},
version = {0.1}, 
 }
```

## Acknowledgment
This work was supported by project TN01000024 of the Technological Agency of the Czech Republic.



-------------------

# GUI User Manual

## General

The Cocoabox GUI can be used for different kinds of analyses on different types of data. For the purposes of this manual, let's suppose that you have resting-state fMRI measurements of two groups of subjects, would like to compute their connectivity matrices, and see whether there is a statistically significant difference between the two groups. 

Each tab on the left side of the GUI window presents a step of the data analysis pipeline. We recommend going through the tabs in the default order (top to bottom), as described below. Some of the steps (e.g. Preprocessing) are optional - you may choose to skip them, depending on your data and objective. Optional steps can be distinguished by a darker grey tab-background colour. Visualisations can be generated at various steps of the analysis.

Pressing a button (e.g. "Label data", "Compute") performs the given operation or analysis using the parameter values specified above the button. The default values for each parameter can be changed by the user.

## Data preparation

The input data is currently expected to be:
- preprocessed
- representing two groups of subjects
- sorted by the group (with data for group 1 coming first, followed by data for group 2)
- stored in a 3D matrix (timepoints * ROIs * subjects)
- of equal length for both groups (same number of timepoints)

Create a subfolder named "Data" within the main cocoabox folder, and move the .mat file there. 

## Analysis steps (GUI tabs)

### Data import

`Import data` -> load .mat file with the data to be analysed

#### Data labeling
Enter dataset and group labels (optional, to be used in visualisations), and the subject count for each group. 

#### Subset selection (optional)
To select a subset of the data, enter the indices of Timepoints, Regions, and/or Realisations (subjects) in the respective text fields (as comma-separated lists, numeric ranges, or a combination of the two), and use the switch button to indicate whether they are to be included or excluded. 

`Reset` -> return to original data. (To create a new subset of the original data, click on `Reset` first).

*Note: Make sure current dimensions of your data (displayed in the text area at the bottom of the GUI window) agree with the expected dimensions before proceeding to the next step.*

### Preprocessing (optional)

*Coming soon*

### Dimensionality reduction (optional)

Reduces dimensionality of the data using the selected decomposition or clustering method. 

**Parameters:**
- **Method**: PCA (default), ICA, NNMF (non-negative matrix factorisation), k-means clustering
- **Number of components** (for decomposition) / **Number of clusters** (for clustering)
- **Dimension**: temporal, spatial (k-means: only temporal)

`Reset` -> undo dimensionality reduction.

*Note: Dimensionality reduction should be performed on normalised data.*

#### Visualisation (optional)

**Parameters:**
- **Method**: individual (default), summarised

The "individual" method will plot each region separately. The time series of each subject will be displayed on a separate figure, and split into several figures if their count exceeds 15. If more than 30 figures are to be shown, the method will automatically change to "summarised". Method "summarised" will create a single plot for all regions.

Optionally: change the default indices of Timepoints, Components/Clusters, and/or Realisations (subjects) to be visualised in the respective text fields (as comma-separated lists, numeric ranges, or a combination of the two), and use the switch button to indicate whether those are to be included or excluded. 

*Note: If you are working with a subset of the original data, the indices to be visualised refer to the subset, not to the original data (i.e. the subset to be visualised is a subset of the subset).*

### Connectivity matrices

Computes the selected functional or effective connectivity measure.

*Note: Clicking on "Compute" repeatedly will overwrite previous results, allowing you to try various connectivity measures.*

#### Visualisation (optional)

**Options:**
- first matrix (default) - connectivity matrix of the first realisation (subject)
- number of matrices + Matrices count - specify the number of matrices to be visualised. Entering "10", for example, will visualise the connectivity matrices of the first and last 5 realisations (subjects).
- selected matrices + Matrices - enter the indices of connectivity matrices to be visualised (as comma-separated lists, numeric ranges, or a combination of the two).

*Note: If you are working with a subset of the original data, the indices to be visualised refer to the subset, not to the original data (i.e. the subset to be visualised is a subset of the subset).* 

### Statistical inference

Performs statistical analysis to compare group connectivity. The parameters to be specified depend on the statistical analysis method selected at the top.

#### Method: p-value masking

For element-wise comparison of group connectivity. Finds regions with significant differences between groups. The group mean values of every element are compared using the selected group comparison test. 

**Parameters:**
- **Group comparison test**: Mann-Whitney U-test (deault; non-parametric), t-test (parametric)
- **Multiple correction method**: FWE (default; Hochberg procedure), FDR (Benjamini-Hochberg procedure), Bonferroni, none (no multiple correction)
- **alpha threshold** (default: 0.05)

#### Method: ROC 

For comparing group connectivity by a 1-dimensional feature. For the selected feature, the ROC curve is computed for classification based on a set of thresholds. AUC (Area Under Curve) is calculated. The group mean values of the feature are compared using the Mann-Whitney U-test. 

**Features:**
- global connectivity (default) - averaged connectivity per subject
- typicality of functional connectivity - computed as the Pearson correlation between every realisation's (subject's) connectivity matrix and the gold standard matrix; needs gold standard matrix
- mask connectivity - selects elements based on a mask; needs mask matrix
- average mask connectivity - averaged connectivity per subject, after masking; needs mask matrix 
- PCA - coefficient of the first PCA component of every realisations (subject's) connectivity matrix 	

*Note: For some of the features, uploading an additional matrix - a Boolean mask or a "gold standard" matrix (the TFC matrix of the control group) is necessary. The additional matrix should be 2D (regions * regions), and saved in the "Data" subfolder of the main cocoabox folder.*

### Graph theory analysis (optional)

Computes the following graph theoretical properties of (symmetric) connectivity matrices: clustering coefficient, characteristic path length, small-world coefficient, efficiency, transitivity, and assortativity. Performs a statistical comparison of the difference between the two groups (for each graph theoretical property), using a statistical test.

**Parameters:**

- **threshold density** - the thresholding density (percentage of nonzero elements) to which the input connectivity matrices are first thresholded before the graph theoretical properties are computed (default: 0.25)
- **alpha threshold** - p-value for the statistical test (default: 0.05)

*Note: Graph theory analysis currently only works for symmetrical matrices. If the connectivity matrices are not symmetric, all components of this tab are automatically disabled.*
