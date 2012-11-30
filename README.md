randomforest-wrapper-matlab
===========================

Simple MATLAB wrapper for the randomForest R package. The wrapper takes a MxN matrix representing the measurements of N features on M objects together with M object labels and passes this data to the R randomForest package to train a random forest model. The resulting model is passed back to MATLAB for further analysis in MATLAB. The communication with MATLAB is performed via (temporary) text files for robustn communication between R and MATLAB.

The main advantage of this wrapper over the randomforest-matlab implementation is that I found the randomforest-matlab to be relatively unstable, while the R package seems to be rock solid. By adding a minimal layer to the original R package I aim to retain this stability in the R implementation. The current implementation is very simple and does not include all desired information in the returned RF model structure. The returned model mimics the structure returned by the randomforest-matlab package.

Note that the code assumes R is installed locally and that the R package randomForest is also available in this installation.