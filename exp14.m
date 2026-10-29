% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 14: Morphological Processing: Dilation, Erosion, Opening, Closing and Boundary Extraction
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  %% Part A: Binary dilation and erosion
  BW = imread('text.png');
  se = strel('square', 3);
  figure('Name','Dilation and erosion');
  subplot(1,3,1); imshow(BW);               title('Original');
  subplot(1,3,2); imshow(imdilate(BW, se)); title('Dilation (3x3)');
  subplot(1,3,3); imshow(imerode(BW, se)); title('Erosion (3x3)');

  %% Part B: Opening and closing as a morphological filter
  A = logical(imread('circles.png'));
  N = A; idx = rand(size(A)) < 0.03; N(idx) = ~N(idx);     % binary noise
  sd = strel('disk', 3);
  O = imopen(N, sd);
  OC = imclose(O, sd);
  figure('Name','Opening and closing');
  subplot(2,2,1); imshow(A); title('Original');
  subplot(2,2,2); imshow(N); title('Noisy');
  subplot(2,2,3); imshow(O); title('Opening');
  subplot(2,2,4); imshow(OC); title('Opening followed by closing');

  %% Part C: Boundary extraction beta(A) = A - (A eroded by B)
  Bd = A & ~imerode(A, strel('square', 3));
  figure('Name','Boundary extraction'); imshow(Bd); title('Boundary of circles.png');








  %% Part D: Gray-scale morphology and top-hat
  G = imread('cameraman.tif');
  R = imread('rice.png');
  sg = strel('disk', 3);
  figure('Name','Gray-scale morphology');
  subplot(2,3,1); imshow(G);               title('Original');
  subplot(2,3,2); imshow(imdilate(G, sg)); title('Dilation');
  subplot(2,3,3); imshow(imerode(G, sg)); title('Erosion');
  subplot(2,3,4); imshow(imopen(G, sg));   title('Opening');
  subplot(2,3,5); imshow(imclose(G, sg)); title('Closing');
  subplot(2,3,6); imshow(imtophat(R, strel('disk', 15))); title('Top-hat of rice.png');
