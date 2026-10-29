% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 12: Edge Detection and Edge Linking using the Hough Transform
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  I = imread('circuit.tif');
  methods = {'roberts', 'prewitt', 'sobel', 'log', 'canny'};
  figure('Name','Edge detectors');
  subplot(2,3,1); imshow(I); title('Original');
  for k = 1:5
      E = edge(I, methods{k});
      subplot(2,3,k+1); imshow(E); title(upper(methods{k}));
      fprintf('%-8s : %6d edge pixels\n', methods{k}, nnz(E));
  end

  [Gmag, Gdir] = imgradient(I, 'sobel');
  figure('Name','Gradient');
  subplot(1,2,1); imshow(Gmag, []); title('Gradient magnitude');
  subplot(1,2,2); imshow(Gdir, []); title('Gradient direction (degrees)');

  %% Edge linking by the Hough transform
  BW = edge(I, 'canny');
  [H, theta, rho] = hough(BW);
  P = houghpeaks(H, 10, 'Threshold', ceil(0.3*max(H(:))));
  lines = houghlines(BW, theta, rho, P, 'FillGap', 5, 'MinLength', 7);
  figure('Name','Hough transform');
  subplot(1,2,1);







  imshow(mat2gray(H), 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit');
  axis on; axis normal; hold on;
  xlabel('\theta (degrees)'); ylabel('\rho');
  plot(theta(P(:,2)), rho(P(:,1)), 's', 'Color', 'r');
  title('Hough accumulator and peaks');
  subplot(1,2,2); imshow(I); hold on; title('Linked line segments');
  for k = 1:length(lines)
      xy = [lines(k).point1; lines(k).point2];
      plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'g');
  end
  fprintf('Number of line segments found = %d\n', length(lines));
