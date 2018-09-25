# coral-atlas  

## Global reef mapping projects
The global coral atlas project is a collaboration between a number of organisations, with the aim to map every coral reef in the world. Partners include:  
	* [Paul G. Allen Philanthropies](http://www.pgaphilanthropies.org/)  
	* [Planet](https://www.planet.com/)  
	* [Carnegie Institution for Science](https://carnegiescience.edu/)  
	* [Remote sensing Research Center at University of Queensland](https://sees.uq.edu.au/remote-sensing-research-centre)  
	* [Institute of Marine Biology at University of Hawaii](http://www.himb.hawaii.edu/)  

## Code relating to global reef mapping projects  

### Accuracy resampling
Scripts in `/accuracy_resample` aim to supplement traditional accuracy metrics with confidence intervals and confidence maps based on resampling techniques.  
Early stages, only the .dbf data is there at the moment - the rest of the shapefile data needed to project the data into space will be absent until further into the project.  It's there so you can determine the data structure needed and then run on other data.  
  
A basis for the resampling methods can be found in the following paper and repo:
Lyons, M. B., Keith, D. A., Phinn, S. R., Mason, T. J., & Elith, J. (2018). A comparison of resampling methods for remote sensing classification and accuracy assessment. Remote Sensing of Environment, 208, 145-153.  
https://github.com/mitchest/rs-accuracy-variance  

### Variable importance
Just a stub - will eventually be used to decide on relative importance of mapping variables