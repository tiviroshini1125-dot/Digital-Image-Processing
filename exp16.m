% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 16: Bit-Plane Decomposition and Lossless Predictive Coding
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  I = imread('cameraman.tif');

  %% Part A: Bit-plane decomposition
  figure('Name','Bit planes');
  for b = 1:8
      subplot(2,4,b); imshow(logical(bitget(I, b)));
      title(sprintf('Bit plane %d', b-1));
  end
  R4 = bitand(I, uint8(240));        % keep the 4 most significant planes
  R2 = bitand(I, uint8(192));        % keep the 2 most significant planes
  figure('Name','Reconstruction from MSB planes');
  subplot(1,3,1); imshow(I); title('Original (8 planes)');
  subplot(1,3,2); imshow(R4); title(sprintf('Planes 7-4 (%.1f dB)', psnr(R4, I)));
  subplot(1,3,3); imshow(R2); title(sprintf('Planes 7-6 (%.1f dB)', psnr(R2, I)));

  %% Part B: Lossless predictive coding (previous-pixel predictor)
  X = double(I);
  E = X;
  E(:, 2:end) = X(:, 2:end) - X(:, 1:end-1);     % encoder: prediction error
  Xr = cumsum(E, 2);                              % decoder
  pI = imhist(I) / numel(I);             pI = pI(pI > 0);
  pE = histcounts(E(:), -255.5:255.5);   pE = pE(pE > 0) / numel(E);
  HI = -sum(pI .* log2(pI));
  HE = -sum(pE .* log2(pE));







  fprintf('Entropy of image            = %.4f bits/pixel\n', HI);
  fprintf('Entropy of prediction error = %.4f bits/pixel\n', HE);
  fprintf('Achievable CR (image)       = %.3f\n', 8/HI);
  fprintf('Achievable CR (error)       = %.3f\n', 8/HE);
  fprintf('Lossless reconstruction     = %d\n', isequal(Xr, X));
  figure('Name','Predictive coding');
  subplot(1,3,1); imshow(I); title('Original');
  subplot(1,3,2); imshow(E, [-50 50]); title('Prediction error');
  subplot(1,3,3); histogram(E(:), -100:100); title('Histogram of error'); xlabel('e');
