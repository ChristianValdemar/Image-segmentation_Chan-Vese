% BA-project - Segmentation of fluorescent microscopy images of living cells
% By Christian Valdemar Hansen
% University of Southern Denmark
% Advisor: Achim Schroll
% Co-Advisor: Niels Christian Overgaard

% Call the Chan-Vese method in the following way:
% phi = chanvese(I,n,my,lambda1,lambda2,maxsize)
% Where:
% I is the Image 
% n is the number of iterations
% my, lambda1 and lambda2 are parameters for Chan-Vese
% maxsize is the max number of pixels on the long edge on the output image
% Now select some points with the cursor on the image,
%   end selection by pressing enter.
% The initial contour will pass through the seleceted points.
% The output is the final level set equation.
% The user can stop the iteration by pressing the OK button in the window.

clear all;
close all;


% Example with two objects
I = imread('Images/dog2.jpg');
phi = chanvese(I,1000,1,1,1,200);

