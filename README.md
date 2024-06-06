![](https://img.shields.io/badge/Automation-Fiji_ImageJ-blue) ![](https://img.shields.io/badge/Stable_Local_build-v1.3-green) ![](https://img.shields.io/badge/Stable_Mycoserv_build-WIP-orange)
# CryptoClassifier: an open-source automated ImageJ analysis pipeline for Cryptococcus microscopy image analysis
## Table of contents
* [Introduction](#Introduction)
* [Installation](#Installation)
* [Running locally on your machine](#Running-on-your-local-machine)
* [Running remotely on Mycoserv](#Running-remotely-on-Mycoserv)
* [Flowchart of CryptoClassifier processes](#Visual-flowchart-of-CryptoClassifier-macro)

## Introduction
Microscopy image analysis is crucial in many biological research areas, especially for studying human pathogens like Cryptococcus. However, manual analysis can be time-consuming, prone to human error, and often not accurately reproducible between different users in the lab. The aim of CryptoClassifier is to automate microscopy image analysis, utilising Fiji/ImageJ. It is designed to streamline the process, accurately classify morphologies such as titan cells, yeast cells, or titanides, and enhance reproducibility and openness in research practices.

The ImageJ macro (CryptoClassifier.ijm) automatically removes background fluorescence, detects cells and provides relevant data on a per image basis, allowing for the analysis of images of varying quality with no extra user input. The macro will output 3 files per image:
* .csv file (contains all identified cell data, each row = individual cell).
* StarDist masking .jpeg with labels (allows for manual checking and cross referencing with the .csv file).
* Background fluorescence removed .jpeg (allows for easy check of image quality).

To aid with data processing, a Local_Data_Cleanup.R script has been created to process all the .csv files generated, extract relevant data and rename column headers to a more easily human readable format/name. To aid with data analysis, a Local_EDA_Vis.R script has been created to carry out exploratory data analysis and visualisation, generating statistics and graphs for proportions of titan cells, yeast cells, and titanides per condition/image set.

## Installation
Project is created with:
* Fiji/ImageJ
* StarDist (ImageJ Package)
* CSBDeep (ImageJ Package)
* R

To use the macro on your local machine download all files from the Local_Scripts folder or run the following code:
```
$ wget -O https://github.com/Jack-Gregory-Bioinformatics/CryptoClassifier.git
```
To run the macro on your local machine you also need to have StarDist and CSBDeep downloaded to ImageJ. If not downloaded you can solve this by opening ImageJ and selecting:
```
Toolbar -> Help -> Update -> Manage Update Sites -> (Now search + select 'StarDist' and 'CSBDeep')
```
To ensure that your ImageJ results output gives full data, open ImageJ and select:
```
Toolbar -> Analyse -> Set Measurements -> (Ensure that Feret's Diameter = TRUE, Shape Descriptors = TRUE, and Display Label = TRUE)
```
To use the pipeline on the Mycoserv server you need not download files, the pipeline is set up already (Work in Progress).

## Running on your local machine
To run this pipeline on your local machine, run the ImageJ macro (CryptoClassifier.ijm) using ImageJ by selecting:
```
Toolbar -> Plugins -> Macros -> Run -> (select the 'CryptoClassifier.ijm' macro from where you saved it)
```
* A file browser will pop-up, prompting you for an input directory (the folder containing your microscopy images), select the input directory from your machines files.
* After this another file browser will pop-up, prompting you for an output directory (the folder where the output will be saved), select or make a new output directory.

The macro will now be run on all '.tiff' files in the input directory that also include 'DAPI' in their file name (this can be edited based on your fluorescent dye used within the macro).

To run the R scripts, a local R environment needs to be available. This can be acheived by downloading R and RStudio, a helpful guide is here (https://www.dataquest.io/blog/installing-r-on-your-computer/). The R scripts can then be opened within RStudio and run to process all the .csv files.
* These current R scripts are setup to process and graph with Cryptococcus neoformans morphology in mind (namely to show titan cells). Feel free to edit the scipts per your own use case (as per the MIT license).
* You will need to edit the R scripts where prompted to set your working directory to the same location as the ImageJ macro output folder.

## Running remotely on Mycoserv
Work in Progress

* Utilises the scripts written in the Mycoserv_Scipts folder via a batch file.
* Allows for running on the Mycoserv and is run via the command line.

```
$ FCI.bat <input_directory> <output-directory>

```

## Visual flowchart of CryptoClassifier macro


This is a basic flowchart of the stages that are being processed on each image. It does not include or summarise the R scripts for data cleanup or EDA/visualisation.
![Overview of .ijm macro](https://github.com/JackUoE/ImageJ-Microscopy-Automation/blob/main/image.jpg?raw=true)
