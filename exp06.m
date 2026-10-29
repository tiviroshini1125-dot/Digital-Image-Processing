% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 6: Histogram Processing: Equalisation, CLAHE and Histogram Matching
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  I   = imread('pout.tif');
  Jeq = histeq(I, 256);                          % global equalisation
  Jcl = adapthisteq(I, 'ClipLimit', 0.02);       % CLAHE
  ref = imread('coins.png');
  Jsp = imhistmatch(I, ref);                     % histogram matching

  imgs   = {I, Jeq, Jcl, Jsp};
  titles = {'Original', 'Equalised', 'CLAHE', 'Matched to coins.png'};
  figure('Name','Histogram processing');
  for k = 1:4
      subplot(4,2,2*k-1); imshow(imgs{k}); title(titles{k});
      subplot(4,2,2*k);   imhist(imgs{k}); title(['Histogram: ' titles{k}]);
  end

  %% Histogram equalisation from first principles
  nk = imhist(I);                      % counts n_k
  pr = nk / numel(I);                  % normalised histogram p_r(r_k)
  cdf = cumsum(pr);                    % cumulative distribution
  T   = uint8(round(255 * cdf));       % s_k = (L-1) * sum p_r(r_j)
  Jm = T(double(I) + 1);               % map every pixel through T
  figure('Name','Manual equalisation');
  subplot(1,3,1); plot(0:255, T, 'LineWidth', 1.5); axis([0 255 0 255]); axis square;
  xlabel('r_k'); ylabel('s_k'); title('Transformation T(r)');
  subplot(1,3,2); imshow(Jm); title('Manual equalisation');
  subplot(1,3,3); imhist(Jm); title('Histogram');







  fprintf('Std. deviation: original = %.2f, equalised = %.2f\n', std2(I), std2(Jm));
  fprintf('Dynamic range : original = [%d %d], equalised = [%d %d]\n', ...
          min(I(:)), max(I(:)), min(Jm(:)), max(Jm(:)));
