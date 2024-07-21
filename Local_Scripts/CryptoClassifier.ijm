//Dialog box creation
Dialog.create("CryptoClassifier");
Dialog.addDirectory("Input directory",getDirectory("Choose Source Directory "));
Dialog.addDirectory("Output directory",getDirectory("Choose Destination Directory "));
Dialog.addCheckbox("Z-Stack", false);
Dialog.addCheckbox("Multi-channel", false);
Dialog.addMessage("Specify channels below:");
Dialog.addSlider("BF Mono:", 0, 4, 0);
Dialog.addSlider("DAPI:", 0, 4, 1);
Dialog.addSlider("PI:", 0, 4, 2);
Dialog.addHelp("https://github.com/Jack-Gregory-Bioinformatics/CryptoClassifier");
Dialog.show();

dir1  = Dialog.getString();
dir2  = Dialog.getString();
z_stack_boolean = Dialog.getCheckbox();
multi_ch_boolean = Dialog.getCheckbox();
BF_ch = Dialog.getNumber();
DAPI_ch = Dialog.getNumber();
PI_ch = Dialog.getNumber();
list = getFileList(dir1);

setBatchMode(true);

print("Running please wait...")

if (z_stack_boolean==false) {
	
	for (i=0; i<list.length; i++) {

              showProgress(i+1, list.length);

              filename = dir1 + list[i];

              if (endsWith(filename, ".tiff") && matches(filename, ".*DAPI.*")) {
              	
              				 open(filename);
              				
              				 ImageID=File.name;
              				 ImageID_minus_extension=substring(ImageID,0,lengthOf(ImageID)-4);
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

                             selectImage(ImageID);

                             close();

                             selectImage("Label Image");

                             close();

                             open(filename);

                             run("Subtract...", "value=" + background);

                             saveAs("jpeg", dir2 + ImageID_minus_extension + "_background_removed.jpeg");

                             run("Clear Results");

                             run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'"+ImageID+"', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
                             
                             roiManager("Measure");
                             
                             setResult("Mean", nResults, background);

                             saveAs("Results", dir2 + ImageID_minus_extension + "DAPI.csv");

                             selectImage("Label Image");
                             
                             roiManager("Show All with labels");

                             saveAs("jpeg", dir2 + ImageID_minus_extension + ".jpeg");

                             selectImage(ImageID);

                             close();

                             selectImage("Label Image");

                             close();

                             print("Processed " + ImageID);
              }
	}
	
}
else {

	for (i=0; i<list.length; i++) {

              showProgress(i+1, list.length);

              filename = dir1 + list[i];

              if (endsWith(filename, ".vsi")) {
              	
              				 run("Bio-Formats Importer", "open=[" + filename + "] autoscale color_mode=Default rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT series_1");
                             
                             ImageID=File.name;
                             
                             ImageID_minus_extension=substring(ImageID,0,lengthOf(ImageID)-4);
                             
                             // Get the list of open images
                             imageList = getList("image.titles");
        					 
                             // Loop through the image list to find and select the BF channel (C=0)
                             for (j=0; j<imageList.length; j++) {
            					 if (matches(imageList[j], ImageID + ".* - C=0.*")) {
                					 selectImage(imageList[j]);
                					 close();
                					 break;
            					 }
        					 }
        					 // Loop through the image list to find and select the DAPI channel (C=1)
        					 for (j=0; j<imageList.length; j++) {
            					 if (matches(imageList[j], ImageID + ".* - C=1.*")) {
                					 selectImage(imageList[j]);
                					
                					 run("Z Project...", "projection=[Sum Slices]");
                					
									 run("Subtract Background...", "rolling=30");
									
									 run("Clear Results");
									
									 run("Command From Macro", "command=[de.csbdresden.stardist.StarDist2D], args=['input':'SUM_" + imageList[j] + "', 'modelChoice':'Versatile (fluorescent nuclei)', 'normalizeInput':'true', 'percentileBottom':'1.0', 'percentileTop':'99.8', 'probThresh':'0.5', 'nmsThresh':'0.4', 'outputType':'Both', 'nTiles':'1', 'excludeBoundary':'2', 'roiPosition':'Automatic', 'verbose':'false', 'showCsbdeepProgress':'false', 'showProbAndDist':'false'], process=[false]");
                             		
                             		 roiManager("Measure");
                             		 
                                     saveAs("Results", dir2 + ImageID_minus_extension + "_DAPI.csv");
                             		 
                                     selectImage("Label Image");
                             		 
                                     roiManager("Show All with labels");
                             		 
                                     saveAs("jpeg", dir2 + ImageID_minus_extension + ".jpeg");
                             		
                             		 selectImage(imageList[j]);
                             		 close();
                             		
                             		 selectImage("SUM_" + imageList[j]);
                             		 close();
                             		 selectImage("Label Image");
                             		 close();
                             		 print("Processed " + ImageID);
                					 break;
            					 }
        					 }
              }
	}
}
print("Completed Batch Processing :)");
close("*");