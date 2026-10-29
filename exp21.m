% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 21: Pattern Recognition: Template Matching and Minimum-Distance Classification
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  I = imread('coins.png');

  %% Part A: Correlation-based template matching
  figure; imshow(I);
  title('Drag a rectangle around one small coin, then double-click inside it');
  T = imcrop;                                    % template chosen by the user
  c = normxcorr2(T, I);
  pk = imregionalmax(c) & c > 0.75;              % strong local maxima = matches
  [yp, xp] = find(pk);
  figure('Name','Template matching');
  subplot(1,3,1); imshow(T); title('Template');
  subplot(1,3,2); surf(c); shading flat; title('Normalised cross-correlation');
  subplot(1,3,3); imshow(I); hold on; title(sprintf('%d matches (\\gamma > 0.75)', numel(yp)));
  for k = 1:numel(yp)
      rectangle('Position', [xp(k)-size(T,2)+1, yp(k)-size(T,1)+1, size(T,2), size(T,1)], ...
                'EdgeColor', 'r', 'LineWidth', 2);
  end

  %% Part B: Minimum-distance classifier for coin recognition
  bw = imfill(imbinarize(I), 'holes');
  bw = bwareaopen(bw, 100);
  s = regionprops(bw, I, 'Area', 'MeanIntensity', 'Centroid');






  X = [[s.Area]' [s.MeanIntensity]'];            % pattern vectors [area, mean gray]
  Xn = (X - mean(X)) ./ std(X);                  % normalised features
  [~, ord] = sort(X(:,1));
  m1 = mean(Xn(ord(1:2), :), 1);                 % prototype, class 1 (two smallest)
  m2 = mean(Xn(ord(end-1:end), :), 1);           % prototype, class 2 (two largest)
  d1 = Xn*m1' - 0.5*(m1*m1');                    % decision functions
  d2 = Xn*m2' - 0.5*(m2*m2');
  cls = 1 + (d2 > d1);
  label = {'Dime', 'Nickel'};
  figure('Name','Minimum-distance classifier'); imshow(I); hold on;
  for k = 1:numel(s)
      text(s(k).Centroid(1), s(k).Centroid(2), label{cls(k)}, 'Color', 'y', ...
           'FontWeight', 'bold', 'HorizontalAlignment', 'center');
  end
  title(sprintf('Class 1 (dime): %d    Class 2 (nickel): %d', sum(cls==1), sum(cls==2)));
  figure('Name','Feature space');
  plot(X(cls==1,1), X(cls==1,2), 'bo', X(cls==2,1), X(cls==2,2), 'rs', ...
       'MarkerSize', 8, 'LineWidth', 1.5);
  xlabel('Area (pixels)'); ylabel('Mean intensity'); legend(label); grid on;
  title('Pattern vectors of the coins');
