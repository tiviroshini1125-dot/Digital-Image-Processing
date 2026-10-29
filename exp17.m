% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 17: Transform Coding: DCT-Based (JPEG) Image Compression
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  I = imread('cameraman.tif');
  X = double(I) - 128;                      % level shift
  T = dctmtx(8);                            % 8x8 DCT basis matrix

  %% Part A: Energy compaction of the block DCT
  C = blockproc(X, [8 8], @(b) T * b.data * T');
  figure('Name','Block DCT');
  subplot(1,2,1); imshow(I); title('Original');
  subplot(1,2,2); imshow(log(1+abs(C)), []); title('8x8 block DCT (log magnitude)');

  %% Part B: JPEG-style quantisation at different quality factors
  Q50 = [16 11 10 16 24 40 51 61;     12 12 14 19 26 58 60 55;
         14 13 16 24 40 57 69 56;     14 17 22 29 51 87 80 62;
         18 22 37 56 68 109 103 77;   24 35 55 64 81 104 113 92;
         49 64 78 87 103 121 120 101; 72 92 95 98 112 100 103 99];
  quality = [90 50 25 10];
  figure('Name','DCT compression');
  fprintf('Quality    Non-zero coeffs  Approx. CR   PSNR (dB)\n');
  for k = 1:numel(quality)
      q = quality(k);







        if q < 50, s = 5000/q; else, s = 200 - 2*q; end
        Q = max(floor((Q50*s + 50)/100), 1);                  % scaled table
        Cq = blockproc(X, [8 8], @(b) round((T*b.data*T') ./ Q));
        Xr = blockproc(Cq, [8 8], @(b) T' * (b.data .* Q) * T);
        R = uint8(Xr + 128);
        CR = numel(I) / nnz(Cq);
        fprintf('%5d %15d %14.2f %11.2f\n', q, nnz(Cq), CR, psnr(R, I));
        subplot(2,2,k); imshow(R);
        title(sprintf('Quality %d, PSNR = %.1f dB', q, psnr(R, I)));
  end

  %% Part C: Standard JPEG files
  for q = [90 50 10]
      fname = sprintf('cameraman_q%d.jpg', q);
      imwrite(I, fname, 'Quality', q);
      d = dir(fname);
      fprintf('JPEG quality %2d: %6d bytes, CR = %.2f\n', q, d.bytes, numel(I)/d.bytes);
  end
