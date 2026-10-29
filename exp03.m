% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 3: Sampling, Quantization and Image Interpolation
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  I = imread('cameraman.tif');                 % 256 x 256, 8-bit

  %% Part A: Spatial resolution (sampling)
  f = [1 2 4 8];
  figure('Name','Sampling');
  for k = 1:numel(f)
      Is = I(1:f(k):end, 1:f(k):end);                 % down-sample
      Id = imresize(Is, size(I), 'nearest');          % enlarge for display
      subplot(2,2,k); imshow(Id);
      title(sprintf('%d x %d samples', size(Is,1), size(Is,2)));
  end

  %% Part B: Intensity resolution (quantization)
  L = [256 64 16 8 4 2];
  figure('Name','Quantization');
  for k = 1:numel(L)
      step = 256 / L(k);
      Iq = uint8(floor(double(I)/step) * (255/(L(k)-1)));   % L levels spread over 0-255
      subplot(2,3,k); imshow(Iq);
      title(sprintf('%d levels (%d bits)', L(k), log2(L(k))));






  end

  %% Part C: Interpolation methods
  small = imresize(I, 0.25);                          % 64 x 64
  Nn = imresize(small, 4, 'nearest');
  Bl = imresize(small, 4, 'bilinear');
  Bc = imresize(small, 4, 'bicubic');
  figure('Name','Interpolation');
  subplot(2,2,1); imshow(small); title('64 x 64 input');
  subplot(2,2,2); imshow(Nn); title(sprintf('Nearest (%.2f dB)', psnr(Nn, I)));
  subplot(2,2,3); imshow(Bl); title(sprintf('Bilinear (%.2f dB)', psnr(Bl, I)));
  subplot(2,2,4); imshow(Bc); title(sprintf('Bicubic (%.2f dB)', psnr(Bc, I)));
  fprintf('PSNR nearest = %.2f dB, bilinear = %.2f dB, bicubic = %.2f dB\n', ...
          psnr(Nn, I), psnr(Bl, I), psnr(Bc, I));
