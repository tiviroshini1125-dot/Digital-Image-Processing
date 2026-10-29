% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 19: Boundary Representation: Chain Codes and Topological/Regional Descriptors
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  BW = imread('blobs.png');

  %% Part A: Boundary tracing
  [B, L] = bwboundaries(BW, 'noholes');
  figure('Name','Boundaries');
  imshow(label2rgb(L, @jet, [.5 .5 .5])); hold on;
  for k = 1:numel(B)
      plot(B{k}(:,2), B{k}(:,1), 'w', 'LineWidth', 1.5);
  end
  title(sprintf('%d boundaries traced', numel(B)));

  %% Part B: Freeman 8-direction chain code of the largest object







  len = cellfun(@(b) size(b,1), B);
  [~, idx] = max(len);
  b = B{idx};
  d = diff(b);                                        % steps [d_row d_col]
  dirs = [0 1; -1 1; -1 0; -1 -1; 0 -1; 1 -1; 1 0; 1 1];   % codes 0..7
  cc = zeros(1, size(d,1));
  for k = 1:size(d,1)
      [~, cc(k)] = ismember(d(k,:), dirs, 'rows');
  end
  cc = cc - 1;
  fd = mod(diff([cc cc(1)]), 8);                      % first difference
  fprintf('Chain code length        = %d\n', numel(cc));
  fprintf('Chain code (first 30)    : %s\n', num2str(cc(1:30), '%d'));
  fprintf('First difference (30)    : %s\n', num2str(fd(1:30), '%d'));
  figure('Name','Largest object'); imshow(BW); hold on;
  plot(b(:,2), b(:,1), 'r', 'LineWidth', 2);
  plot(b(1,2), b(1,1), 'go', 'MarkerSize', 10, 'LineWidth', 2);
  title('Boundary used for the chain code (start = green)');

  %% Part C: Regional and topological descriptors
  st = regionprops('table', BW, 'Area', 'Perimeter', 'Eccentricity', ...
                   'Solidity', 'EulerNumber');
  st.Circularity = 4*pi*st.Area ./ st.Perimeter.^2;
  st.Holes = 1 - st.EulerNumber;
  disp(st);
  fprintf('Euler number of the whole image (8-conn.) = %d\n', bweuler(BW, 8));
