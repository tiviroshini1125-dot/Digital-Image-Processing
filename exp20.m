% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 20: Texture Analysis using Statistical Moments and the Gray-Level Co- occurrence Matrix
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  cam = imread('cameraman.tif');
  bag = imread('bag.png');
  P = {cam(1:64, 1:64), bag(1:64, 1:64), im2uint8(checkerboard(8))};
  names = {'Smooth (sky)', 'Coarse (fabric)', 'Regular (checkerboard)'};
  figure('Name','Texture samples');
  for k = 1:3
      subplot(1,3,k); imshow(P{k}); title(names{k});
  end

  %% Histogram-based statistical descriptors
  fprintf('%-24s %7s %7s %7s %8s %7s %8s\n', ...
          'Region', 'Mean', 'StdDev', 'R', 'Mu3', 'Unif', 'Entropy');
  for k = 1:3
      z   = double(P{k}(:));
      m   = mean(z); s = std(z);
      R   = 1 - 1/(1 + s^2/255^2);             % relative smoothness
      mu3 = mean((z - m).^3) / 255^2;          % normalised third moment
      p   = imhist(P{k}) / numel(z);
      U   = sum(p.^2);                           % uniformity
      e   = entropy(P{k});
      fprintf('%-24s %7.2f %7.2f %7.4f %8.3f %7.4f %8.3f\n', names{k}, m, s, R, mu3, U, e);






  end

  %% GLCM (co-occurrence) descriptors, averaged over 0, 45, 90, 135 degrees
  offsets = [0 1; -1 1; -1 0; -1 -1];
  fprintf('\n%-24s %9s %12s %8s %12s\n', 'Region', 'Contrast', 'Correlation', ...
          'Energy', 'Homogeneity');
  for k = 1:3
      glcm = graycomatrix(P{k}, 'Offset', offsets, 'NumLevels', 8, 'Symmetric', true);
      g = graycoprops(glcm, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
      fprintf('%-24s %9.3f %12.3f %8.3f %12.3f\n', names{k}, mean(g.Contrast), ...
              mean(g.Correlation, 'omitnan'), mean(g.Energy), mean(g.Homogeneity));
  end

  %% Local texture maps
  figure('Name','Local texture measures');
  subplot(2,2,1); imshow(bag);                    title('bag.png');
  subplot(2,2,2); imshow(rangefilt(bag), []);     title('Local range');
  subplot(2,2,3); imshow(stdfilt(bag), []);       title('Local standard deviation');
  subplot(2,2,4); imshow(entropyfilt(bag), []);   title('Local entropy');
