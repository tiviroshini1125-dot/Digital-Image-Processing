% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 13: Region-Based Segmentation: Thresholding, Region Growing and Watershed
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  I = imread('coins.png');

  %% Part A: Iterative global thresholding and Otsu
  T = mean(double(I(:)));
  done = false; iter = 0;
  while ~done
      iter = iter + 1;
      Tnext = 0.5*(mean(double(I(I > T))) + mean(double(I(I <= T))));
      done = abs(T - Tnext) < 0.5;
      T = Tnext;
  end
  BWi   = I > T;
  level = graythresh(I);
  BWo   = imbinarize(I, level);
  fprintf('Iterative threshold = %.2f after %d iterations\n', T, iter);
  fprintf('Otsu threshold       = %.2f\n', 255*level);

  %% Part B: Adaptive thresholding under uneven illumination
  R   = imread('rice.png');
  BWg = imbinarize(R);
  BWa = imbinarize(R, 'adaptive', 'Sensitivity', 0.4);







  figure('Name','Thresholding');
  subplot(2,3,1); imshow(I);   title('coins.png');
  subplot(2,3,2); imshow(BWi); title(sprintf('Iterative, T = %.0f', T));
  subplot(2,3,3); imshow(BWo); title('Otsu');
  subplot(2,3,4); imshow(R);   title('rice.png');
  subplot(2,3,5); imshow(BWg); title('Global (Otsu)');
  subplot(2,3,6); imshow(BWa); title('Adaptive');

  %% Part C: Seeded region growing
  figure; imshow(I); title('Click a seed point inside a coin');
  [c, r] = ginput(1);
  BWr = grayconnected(I, round(r), round(c), 40);
  figure('Name','Region growing');
  imshow(labeloverlay(I, BWr)); title('Region grown from seed (tolerance 40)');

  %% Part D: Marker-controlled watershed
  bw = imfill(BWo, 'holes');
  Dt = -bwdist(~bw);
  Dt = imimposemin(Dt, imextendedmin(Dt, 2));
  Lw = watershed(Dt);
  Lw(~bw) = 0;
  cc = bwconncomp(bw);
  fprintf('Number of coins detected = %d\n', cc.NumObjects);
  figure('Name','Watershed');
  subplot(1,2,1); imshow(bw); title('Filled Otsu mask');
  subplot(1,2,2); imshow(label2rgb(Lw, 'jet', 'k', 'shuffle')); title('Watershed regions');
