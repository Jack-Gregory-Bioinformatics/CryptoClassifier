importClass(Packages.ij.IJ);
importClass(Packages.ij.io.DirectoryChooser);

var inputFolder = getArgument("INPUT_FOLDER");
var outputFolder = getArgument("OUTPUT_FOLDER");

// Verify that the input folder exists
var inputDir = new java.io.File(inputFolder);
if (!inputDir.exists() || !inputDir.isDirectory()) {
    IJ.log("Input folder does not exist or is not a directory.");
    IJ.log("Please provide a valid input folder path.");
    exit();
}

// Verify that the output folder exists
var outputDir = new java.io.File(outputFolder);
if (!outputDir.exists() || !outputDir.isDirectory()) {
    IJ.log("Output folder does not exist or is not a directory.");
    IJ.log("Please provide a valid output folder path.");
    exit();
}

var list = getFileList(inputFolder);
Array.print(list);

setBatchMode(true);

IJ.log("Running please wait...");

for (var i = 0; i < list.length; i++) {
    showProgress(i + 1, list.length);

    var filename = inputFolder + list[i];

    if (endsWith(filename, ".tiff")) {
        open(filename);

        var ImageID = File.name;
        var background = 0;

        run("Clear Results");
        run("Set Scale...", "distance=484.0010 known=75 unit=µm global");

        run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'" + ImageID + "', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");

        selectImage("Label Image");
        selectImage(ImageID);
        roiManager("Combine");
        run("Make Inverse");
        run("Measure");
        background = getResult("Mean", 0);

        selectImage(ImageID);
        close();
        selectImage("Label Image");
        close();

        open(filename);
        run("Subtract...", "value=" + background);
        saveAs("jpeg", outputFolder + ImageID + "_background_removed.jpeg");

        run("Clear Results");
        run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'" + ImageID + "', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");

        selectImage("Label Image");
        roiManager("Show All with labels");
        saveAs("jpeg", outputFolder + ImageID + ".jpeg");
        roiManager("Measure");
        setResult("Mean", nResults, background);
        saveAs("Results", outputFolder + ImageID + ".csv");
        close();

        IJ.log("Processed " + ImageID);
    }
}

IJ.log("Completed Batch Processing :)");

// Save log file for debugging purposes
IJ.saveAs("Text", outputFolder + "log.txt");

setBatchMode(false);