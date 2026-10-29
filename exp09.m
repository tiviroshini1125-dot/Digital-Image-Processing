% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 9: Noise Models: Gaussian, Poisson, Salt-and-Pepper, Speckle, Uniform and Exponential Noise
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  I = imread('cameraman.tif');
  Id = im2double(I);

  %% Part A: Adding noise
  Ng = imnoise(I, 'gaussian', 0, 0.01);
  Np = imnoise(I, 'poisson');
  Nsp = imnoise(I, 'salt & pepper', 0.05);
  Nsk = imnoise(I, 'speckle', 0.04);
  Nu = im2uint8(Id + 0.4*(rand(size(Id)) - 0.5));           % uniform, a = -0.2, b = 0.2
  Ne = im2uint8(Id - 0.05*log(1 - rand(size(Id))));         % exponential, mean 0.05







  noisy = {Ng, Np, Nsp, Nsk, Nu, Ne};
  labels = {'Gaussian', 'Poisson', 'Salt & pepper', 'Speckle', 'Uniform', 'Exponential'};
  figure('Name','Noise models');
  for k = 1:6
      subplot(2,3,k); imshow(noisy{k});
      title(sprintf('%s (%.1f dB)', labels{k}, psnr(noisy{k}, I)));
      fprintf('%-14s PSNR = %.2f dB\n', labels{k}, psnr(noisy{k}, I));
  end

  %% Part B: Estimating noise PDFs from a flat patch
  flat = uint8(128 * ones(200));
  P = {imnoise(flat, 'gaussian', 0, 0.005), ...
        imnoise(flat, 'salt & pepper', 0.05), ...
        im2uint8(0.5 + 0.4*(rand(200) - 0.5)), ...
        im2uint8(0.3 - 0.08*log(1 - rand(200)))};
  pn = {'Gaussian', 'Salt & pepper', 'Uniform', 'Exponential'};
  figure('Name','Noise histograms');
  for k = 1:4
      subplot(2,2,k); imhist(P{k}); title([pn{k} ' noise histogram']);
  end
