% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 2: Colour Models and Visualisation of Colour Components
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  RGB = imread('peppers.png');
  R = RGB(:,:,1); G = RGB(:,:,2);           B = RGB(:,:,3);
  Z = zeros(size(R), 'uint8');

  %% (a) RGB components: tinted images and intensity maps
  figure('Name','RGB components');
  subplot(2,4,1); imshow(RGB);           title('Original');
  subplot(2,4,2); imshow(cat(3,R,Z,Z)); title('Red component');
  subplot(2,4,3); imshow(cat(3,Z,G,Z)); title('Green component');
  subplot(2,4,4); imshow(cat(3,Z,Z,B)); title('Blue component');
  subplot(2,4,6); imshow(R);             title('R as intensity');
  subplot(2,4,7); imshow(G);             title('G as intensity');
  subplot(2,4,8); imshow(B);             title('B as intensity');

  %% (b) CMY model
  CMY = imcomplement(RGB);
  figure('Name','CMY model');
  subplot(1,4,1); imshow(CMY);                  title('CMY image');
  subplot(1,4,2); imshow(CMY(:,:,1));           title('Cyan');
  subplot(1,4,3); imshow(CMY(:,:,2));           title('Magenta');






  subplot(1,4,4); imshow(CMY(:,:,3));       title('Yellow');

  %% (c) HSV and YCbCr models
  HSV = rgb2hsv(RGB);
  YCC = rgb2ycbcr(RGB);
  figure('Name','HSV and YCbCr');
  subplot(2,3,1); imshow(HSV(:,:,1)); title('Hue');
  subplot(2,3,2); imshow(HSV(:,:,2)); title('Saturation');
  subplot(2,3,3); imshow(HSV(:,:,3)); title('Value');
  subplot(2,3,4); imshow(YCC(:,:,1)); title('Y (luma)');
  subplot(2,3,5); imshow(YCC(:,:,2)); title('Cb');
  subplot(2,3,6); imshow(YCC(:,:,3)); title('Cr');

  %% (d) One pixel expressed in different models
  r = 200; c = 300;
  fprintf('Pixel (%d,%d)\n', r, c);
  fprintf('RGB   = [%d %d %d]\n', RGB(r,c,:));
  fprintf('CMY   = [%d %d %d]\n', CMY(r,c,:));
  fprintf('HSV   = [%.3f %.3f %.3f]\n', HSV(r,c,:));
  fprintf('YCbCr = [%d %d %d]\n', YCC(r,c,:));

  %% (e) Colour enhancement in HSV: boost saturation
  HSV2 = HSV;
  HSV2(:,:,2) = min(1.5*HSV(:,:,2), 1);
  figure('Name','Saturation boost');
  subplot(1,2,1); imshow(RGB);            title('Original');
  subplot(1,2,2); imshow(hsv2rgb(HSV2)); title('Saturation x 1.5');
