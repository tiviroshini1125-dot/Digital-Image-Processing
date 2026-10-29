% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 10: Restoration using Spatial Filters: Mean, Order-Statistic and Adaptive (Wiener) Filters
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  I   = imread('cameraman.tif');
  Ng = imnoise(I, 'gaussian', 0, 0.01);
  Nsp = imnoise(I, 'salt & pepper', 0.10);
  Npp = I; Npp(rand(size(I)) < 0.05) = 0;      % pepper-only noise
  noisy = {Ng, Nsp, Npp};
  nname = {'Gaussian noise', 'Salt & pepper noise', 'Pepper noise'};
  fname = {'Arithmetic mean', 'Geometric mean', 'Median', 'Max', 'Min', 'Adaptive Wiener'};
  psnrTable = zeros(3, 6);

  for n = 1:3
      X = noisy{n};
      out = cell(1, 6);
      out{1} = imfilter(X, fspecial('average', 3), 'replicate');
      out{2} = uint8(exp(imfilter(log(double(X)+1), ones(3)/9, 'replicate')) - 1);
      out{3} = medfilt2(X, [3 3], 'symmetric');
      out{4} = ordfilt2(X, 9, ones(3), 'symmetric');    % max filter
      out{5} = ordfilt2(X, 1, ones(3), 'symmetric');    % min filter
      out{6} = wiener2(X, [5 5]);
      figure('Name', nname{n});
      subplot(2,4,1); imshow(I); title('Original');







       subplot(2,4,2); imshow(X); title({nname{n}, sprintf('%.2f dB', psnr(X, I))});
       for k = 1:6
           psnrTable(n,k) = psnr(out{k}, I);
           subplot(2,4,k+2); imshow(out{k});
           title({fname{k}, sprintf('%.2f dB', psnrTable(n,k))});
       end
  end
  T = array2table(psnrTable, 'VariableNames', matlab.lang.makeValidName(fname), ...
                  'RowNames', nname);
  disp('PSNR (dB) after filtering:'); disp(T);
