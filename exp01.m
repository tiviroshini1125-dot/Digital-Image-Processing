% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 1: Reading, Displaying and Converting Images (Colour to Gray-scale to Binary)
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  RGB = imread('peppers.png');            % built-in colour test image
  info = imfinfo('peppers.png');
  fprintf('File format : %s\n', info.Format);
  fprintf('Bit depth   : %d bits/pixel\n', info.BitDepth);
  fprintf('Size of RGB image : %d x %d x %d\n', size(RGB));

  G = rgb2gray(RGB);                           % colour -> gray-scale
  fprintf('Size of gray image : %d x %d,       class: %s\n', size(G), class(G));

  % Gray-scale conversion from the luminance equation






  Gm = uint8(0.2989*double(RGB(:,:,1)) + 0.5870*double(RGB(:,:,2)) ...
           + 0.1140*double(RGB(:,:,3)));
  fprintf('Max. difference rgb2gray vs. equation = %d\n', ...
          max(abs(double(G(:)) - double(Gm(:)))));

  level = graythresh(G);                  % Otsu threshold in [0,1]
  BW1 = imbinarize(G, 0.5);               % gray-scale -> binary, fixed T
  BW2 = imbinarize(G, level);             % gray-scale -> binary, Otsu T
  fprintf('Otsu threshold = %.4f (%d on 0-255 scale)\n', level, round(255*level));

  figure('Name','Image conversions');
  subplot(2,2,1); imshow(RGB); title('Colour image');
  subplot(2,2,2); imshow(G);   title('Gray-scale image');
  subplot(2,2,3); imshow(BW1); title('Binary image (T = 0.5)');
  subplot(2,2,4); imshow(BW2); title(sprintf('Binary image (Otsu, T = %.2f)', level));

  imwrite(G, 'peppers_gray.png');           % save the result
  imwrite(BW2, 'peppers_binary.png');
