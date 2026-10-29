% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 4: Relationships between Pixels: Neighbours, Connectivity and Distance Measures
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  %% Part A: Neighbourhoods of a pixel
  A = magic(5);
  disp('A ='); disp(A);
  r = input('Enter row index (2 to 4): ');
  c = input('Enter column index (2 to 4): ');
  fprintf('Pixel value p(%d,%d) = %d\n', r, c, A(r,c));
  N4 = [A(r-1,c), A(r+1,c), A(r,c-1), A(r,c+1)];
  ND = [A(r-1,c-1), A(r-1,c+1), A(r+1,c-1), A(r+1,c+1)];
  N8 = [N4, ND];
  disp('N4(p) ='); disp(N4);
  disp('ND(p) ='); disp(ND);
  disp('N8(p) ='); disp(N8);

  %% Part B: 4- and 8-connectivity
  BW = logical([1 1 0 0 0 0;
                1 1 0 0 1 0;
                0 0 1 0 1 0;
                0 0 0 1 0 0;
                0 1 0 0 0 1;
                0 1 0 0 0 1]);
  CC4 = bwconncomp(BW, 4);
  CC8 = bwconncomp(BW, 8);






  fprintf('Connected components, 4-connectivity: %d\n', CC4.NumObjects);
  fprintf('Connected components, 8-connectivity: %d\n', CC8.NumObjects);

  %% Part C: Distance between two pixels selected on an image
  I = imread('cameraman.tif');
  figure; imshow(I); title('Click on two pixels');
  [x, y] = ginput(2);
  x = round(x); y = round(y);
  hold on; plot(x, y, 'r+-', 'MarkerSize', 12, 'LineWidth', 1.5);
  De = sqrt((x(1)-x(2))^2 + (y(1)-y(2))^2);     % Euclidean
  D4 = abs(x(1)-x(2)) + abs(y(1)-y(2));          % city-block
  D8 = max(abs(x(1)-x(2)), abs(y(1)-y(2)));      % chessboard
  fprintf('p = (%d,%d), q = (%d,%d)\n', x(1), y(1), x(2), y(2));
  fprintf('Euclidean distance De = %.4f\n', De);
  fprintf('City-block distance D4 = %d\n', D4);
  fprintf('Chessboard distance D8 = %d\n', D8);

  %% Part D: Distance maps from a single pixel
  P = false(101); P(51,51) = true;
  figure('Name','Distance maps');
  subplot(1,3,1); imshow(bwdist(P,'euclidean'), []); title('Euclidean (De)');
  subplot(1,3,2); imshow(bwdist(P,'cityblock'), []); title('City-block (D4)');
  subplot(1,3,3); imshow(bwdist(P,'chessboard'), []); title('Chessboard (D8)');
