% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 5: Gray-Level Transformations: Negative, Log, Power-Law, Contrast Stretching and Intensity Slicing
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  I = imread('pout.tif');                      % low-contrast image
  r = im2double(I);

  s_neg = 1 - r;                         % negative s = L-1-r
  s_log = mat2gray(log(1 + r));          % log transformation (scaled)
  s_g04 = r .^ 0.4;                      % power law, gamma < 1
  s_g25 = r .^ 2.5;                      % power law, gamma > 1
  s_cs = imadjust(I, stretchlim(I), []); % contrast stretching

  figure('Name','Gray-level transformations');






  subplot(2,3,1); imshow(r);     title('Original');
  subplot(2,3,2); imshow(s_neg); title('Negative');
  subplot(2,3,3); imshow(s_log); title('Log');
  subplot(2,3,4); imshow(s_g04); title('Gamma = 0.4');
  subplot(2,3,5); imshow(s_g25); title('Gamma = 2.5');
  subplot(2,3,6); imshow(s_cs); title('Contrast stretched');

  %% Transformation curves
  rr = linspace(0, 1, 256);
  figure('Name','Transformation functions');
  plot(rr, 1-rr, rr, log(1+rr)/log(2), rr, rr.^0.4, rr, rr.^2.5, rr, rr, 'k--');
  legend('Negative','Log','\gamma = 0.4','\gamma = 2.5','Identity', ...
         'Location','southeast');
  xlabel('Input level r'); ylabel('Output level s'); grid on; axis square;

  %% Contrast stretching of a colour image
  RGB = imread('peppers.png');
  figure('Name','Colour contrast stretching');
  subplot(1,2,1); imshow(RGB); title('Input');
  subplot(1,2,2); imshow(imadjust(RGB, [0.2 0.8], [])); title('imadjust [0.2 0.8]');

  %% Intensity-level slicing
  A = 0.40; B = 0.70;
  slice1 = r; slice1(r >= A & r <= B) = 1;     % highlight band, keep background
  slice2 = double(r >= A & r <= B);            % binary slice
  figure('Name','Intensity-level slicing');
  subplot(1,3,1); imshow(r);      title('Original');
  subplot(1,3,2); imshow(slice1); title('Band highlighted');
  subplot(1,3,3); imshow(slice2); title('Binary slice');
