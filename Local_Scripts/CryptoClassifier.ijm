dir1 = getDirectory("Choose Source Directory ");

dir2 = getDirectory("Choose Destination Directory ");

list = getFileList(dir1);

setBatchMode(true);

print("Running please wait...")

for (i=0; i<list.length; i++) {

              showProgress(i+1, list.length);

              filename = dir1 + list[i];

              if (endsWith(filename, ".tiff") && matches(filename, ".*DAPI.*")) {

                             open(filename);

                             ImageID=File.name;
                             
                             background = 0;

                             run("Clear Results");
                             
                             run("Set Scale...", "distance=484.0010 known=75 unit=µm global");

                             run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'"+ImageID+"', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");

                             selectImage("Label Image");

                             selectImage(ImageID);
                             
                             roiManager("Combine");
                             
                             run("Make Inverse");
                             
                             run("Measure");
                             
                             background = getResult("Mean", 0);
                             //background_final = ${background} * 0.9
                             
                             selectImage(ImageID);
                             close();
                             selectImage("Label Image");
                             close();
                             
                             open(filename);
                             
                             run("Subtract...", "value=" + background);
                             
                             saveAs("jpeg", dir2 + ImageID + "_background_removed.jpeg");
                             
                             run("Clear Results");

                             run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'"+ImageID+"', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");

                             roiManager("Measure");
                             
                             setResult("Mean", nResults, background);

                             saveAs("Results", dir2 + ImageID + ".csv");
                             
                             selectImage("Label Image");
                             
                             roiManager("Show All with labels");
                             
                             saveAs("jpeg", dir2 + ImageID + ".jpeg");
                             
                             selectImage(ImageID);

                             close();
                             
                             selectImage("Label Image");
                             close();

                             print("Processed " + ImageID);
                             

              }

}

print("Completed Batch Processing :)")

setBatchMode(false);