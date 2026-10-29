% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 7: Spatial Filtering: Smoothing and Sharpening Filters
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  I = im2double(imread('cameraman.tif'));

  %% Smoothing (low-pass) filters
  h3 = fspecial('average', 3);
  h9 = fspecial('average', 9);
  hg = fspecial('gaussian', [9 9], 2);
  S3 = imfilter(I, h3, 'replicate');
  S9 = imfilter(I, h9, 'replicate');
  Sg = imfilter(I, hg, 'replicate');
  figure('Name','Smoothing');
  subplot(2,2,1); imshow(I); title('Original');
  subplot(2,2,2); imshow(S3); title('Box 3x3');
  subplot(2,2,3); imshow(S9); title('Box 9x9');
  subplot(2,2,4); imshow(Sg); title('Gaussian 9x9, \sigma = 2');

  %% Sharpening (high-pass) filters
  hL   = [0 1 0; 1 -4 1; 0 1 0];            % Laplacian mask
  L    = imfilter(I, hL, 'replicate');
  G1   = I - L;                             % Laplacian sharpening
  mask = I - Sg;                            % unsharp mask
  G2   = I + 1.0*mask;                      % unsharp masking (k = 1)
  G3   = I + 3.0*mask;                      % high-boost filtering (k = 3)
  hs   = fspecial('sobel');







  Gx   = imfilter(I, hs', 'replicate');
  Gy   = imfilter(I, hs, 'replicate');
  Gm   = sqrt(Gx.^2 + Gy.^2);           % gradient magnitude
  figure('Name','Sharpening');
  subplot(2,3,1); imshow(I);      title('Original');
  subplot(2,3,2); imshow(L, []); title('Laplacian response');
  subplot(2,3,3); imshow(G1);     title('Laplacian sharpened');
  subplot(2,3,4); imshow(G2);     title('Unsharp masking (k = 1)');
  subplot(2,3,5); imshow(G3);     title('High-boost (k = 3)');
  subplot(2,3,6); imshow(Gm, []); title('Sobel gradient magnitude');
