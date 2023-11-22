![](https://img.shields.io/badge/Automation-Fiji_ImageJ-blue) ![](https://img.shields.io/badge/Stable_Local_build-v1.3-green) ![](https://img.shields.io/badge/Stable_Mycoserv_build-WIP-orange)
# ImageJ-Microscopy-Automation
## Table of contents
* [Introduction](#Intro)
* [Installation](#Installation)
* [Start-Local](#Start-Local)
* [Start-Mycoserv](#Start-Mycoserv)

## Intro
The scope of this project is to automate microscopy image analysis utilising Fiji/ImageJ.

The ImageJ macro (FCI_v*.ijm) automatically removes background fluorescence, detects cells and provides relevant data on a per image basis, allowing for the analysis of images of varying quality with no extra user input. The macro will output 3 files per image:
* .csv file (contains all identified cell data, each row = individual cell)
* StarDist masking .jpeg with labels (allows for manual checking and cross referencing with the .csv file)
* Background fluorescence removed .jpeg (allows for easy check of image quality)

To aid with data processing, a Data_Cleanup.R script has been created to process all the .csv files generated, extract relevant data and rename column headers to a human readable format. To aid with data analysis, a EDA_Vis.R script has been created to carry out exploratory data analysis and visualisation.

![Alt text](C:/Users/jbg209/OneDrive - University of Exeter/Documents/2023_24_PhD_Year_1/04_ImageJ_Automation/04_Method_1.drawio.svg)

## Installation
Project is created with:
* Fiji/ImageJ
* StarDist (ImageJ Package)
* CSBDeep (ImageJ Package)
* R

To use the macro on your local machine download all files from the Local_Scripts folder or run the following code:
```
$ wget -O https://github.com/JackUoE/ImageJ-Microscopy-Automation.git
```
To use the pipeline on the Mycoserv you need not download files, the pipeline is set up already (WIP).

## Start-Local
To run this pipeline on your local machine, run the ImageJ macro (FCI_v*.ijm) via Fiji/ImageJ by selecting Tooldbar -> Plugins -> Macros -> Run and then select the 'FCI_v*.ijm' macro from where you saved it.
* You will be prompted for an input directory (The folder containing your images)
* You will be prompted for an output directory (The folder where the output will be saved)

The macro will now be run on all '.tiff' files in the input directory that also include 'DAPI' in their file name.

To run the R scripts, a local R environment needs to be available. This can be acheived by downloading R and RStudio. The R scripts can then be opened within RStudio and run to process all the .csv files.

## Start-Mycoserv
WIP

* Utilises the code blocks written in the Mycoserv_Scipts folder
* Allows for running on the Mycoserv and is run via the command line

```
$ FCI.bat <input_directory> <output-directory>

```