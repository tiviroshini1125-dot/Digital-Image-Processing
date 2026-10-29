% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 18: Wavelet Subband Coding
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  X = double(imread('cameraman.tif'));

  %% Part A: Single-level 2-D DWT
  [cA1, cH1, cV1, cD1] = dwt2(X, 'haar');
  figure('Name','Level-1 subbands');
  subplot(2,2,1); imshow(cA1, []);      title('Approximation');
  subplot(2,2,2); imshow(abs(cH1), []); title('Horizontal detail');
  subplot(2,2,3); imshow(abs(cV1), []); title('Vertical detail');
  subplot(2,2,4); imshow(abs(cD1), []); title('Diagonal detail');
  X1 = idwt2(cA1, cH1, cV1, cD1, 'haar');
  fprintf('Level-1 reconstruction error (max) = %.2e\n', max(abs(X1(:) - X(:))));

  %% Part B: Two-level decomposition (subband pyramid)
  [C, S] = wavedec2(X, 2, 'haar');
  A2 = appcoef2(C, S, 'haar', 2);
  [H2, V2, D2] = detcoef2('all', C, S, 2);
  [H1, V1, D1] = detcoef2('all', C, S, 1);
  g   = @(m) mat2gray(abs(m));
  L2 = [g(A2) g(H2); g(V2) g(D2)];
  pyr = [L2 g(H1); g(V1) g(D1)];
  figure('Name','Two-level pyramid'); imshow(pyr); title('2-level Haar subband pyramid');
  Xr = waverec2(C, S, 'haar');







  fprintf('Level-2 reconstruction error (max) = %.2e\n', max(abs(Xr(:) - X(:))));

  %% Part C: Compression by keeping the largest coefficients
  keep = [0.20 0.10 0.05 0.02];
  Cs   = sort(abs(C), 'descend');
  figure('Name','Wavelet compression');
  for k = 1:numel(keep)
      thr = Cs(round(keep(k)*numel(C)));
      Ct = C .* (abs(C) >= thr);
      Xc = waverec2(Ct, S, 'haar');
      p   = psnr(uint8(Xc), uint8(X));
      fprintf('Coefficients kept = %4.0f %%   PSNR = %.2f dB\n', 100*keep(k), p);
      subplot(2,2,k); imshow(uint8(Xc));
      title(sprintf('%.0f%% coefficients, %.1f dB', 100*keep(k), p));
  end


 Note: This experiment requires the Wavelet Toolbox (dwt2, idwt2, wavedec2, waverec2, appcoef2, detcoef2).
