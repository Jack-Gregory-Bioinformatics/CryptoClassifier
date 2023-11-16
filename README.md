# ImageJ-Microscopy-Automation
## Table of contents
* [Introduction](#Intro)
* [Installation](#Installation)
* [Start](#Start)

## Intro
The scope of this project is to automate microscopy image analysis utilising Fiji/ImageJ.

The ImageJ macro (FCI_v*.ijm) automatically removes background fluorescence, detects cells and provides relevant data on a per image basis, allowing for the analysis of images of varying quality with no extra user input. The macro will output 3 files per image:
* .csv file (contains all identified cell data, each row = individual cell)
* StarDist masking .jpeg with labels (allows for manual checking and cross referencing with the .csv file)
* Background fluorescence removed .jpeg (allows for easy check of image quality)

## Installation
Project is created with:
* Fiji/ImageJ
* StarDist (ImageJ Package)
* CSBDeep (ImageJ Package)
* R

```
$ pip install pytorch

```
	
## Start
To run this pipeline on your local machine, download and run the ImageJ macro (FCI_v*.ijm).
* You will be prompted for an input directory (The folder containing your images)
* You will be prompted for an output directory (The folder where the output will be saved)

```
$ python main.py

```