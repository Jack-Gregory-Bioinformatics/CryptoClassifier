importClass(Packages.ij.IJ);
importClass(Packages.ij.io.DirectoryChooser);

// Constants
var DISTANCE = 484.0010;
var UNIT = "µm";
var KNOWN = 75;

// Function to run Stardist2D
function runStardist2D(inputImageID) {
    run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'" + inputImageID + "', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
}

// Function to process and save an image
function processAndSaveImage(inputFolder, outputFolder, ImageID) {
    selectImage("Label Image");
    selectImage(ImageID);
    roiManager("Combine");
    run("Make Inverse");
    run("Measure");
    var background = getResult("Mean", 0);

    selectImage(ImageID);
    close();
    selectImage("Label Image");
    close();

    open(inputFolder + ImageID);
    run("Subtract...", "value=" + background);
    saveAs("jpeg", outputFolder + ImageID + "_background_removed.jpeg");

    run("Clear Results");
    runStardist2D(ImageID);

    selectImage("Label Image");
    roiManager("Show All with labels");
    saveAs("jpeg", outputFolder + ImageID + ".jpeg");
    roiManager("Measure");
    setResult("Mean", nResults, background);
    saveAs("Results", outputFolder + ImageID + ".csv");
    close();
}

// Function to validate the input and output folders
function validateFolders(inputFolder, outputFolder) {
    var inputDir = new java.io.File(inputFolder);
    var outputDir = new java.io.File(outputFolder);

    if (!inputDir.exists() || !inputDir.isDirectory()) {
        IJ.log("Input folder does not exist or is not a directory.");
        IJ.log("Please provide a valid input folder path.");
        exit();
    }

    if (!outputDir.exists() || !outputDir.isDirectory()) {
        IJ.log("Output folder does not exist or is not a directory.");
        IJ.log("Please provide a valid output folder path.");
        exit();
    }
}

var inputFolder = getArgument("inputFolder");
var outputFolder = getArgument("outputFolder");

validateFolders(inputFolder, outputFolder);

var list = getFileList(inputFolder);
Array.print(list);

setBatchMode(true);

IJ.log("Running, please wait...");

for (var i = 0; i < list.length; i++) {
    showProgress(i + 1, list.length);
    var filename = inputFolder + list[i];

    if (endsWith(filename, ".tiff")) {
        open(filename);
        var ImageID = File.name;

        run("Clear Results");
        run("Set Scale...", "distance=" + DISTANCE + " known=" + KNOWN + " unit=" + UNIT + " global");

        runStardist2D(ImageID);
        processAndSaveImage(inputFolder, outputFolder, ImageID);

        IJ.log("Processed " + ImageID);
    }
}

IJ.log("Completed Batch Processing :)");

// Save log file for debugging purposes
IJ.saveAs("Text", outputFolder + "log.txt");

setBatchMode(false);
