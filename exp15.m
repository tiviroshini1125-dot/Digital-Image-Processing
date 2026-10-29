% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 15: Lossless Compression: Entropy, Huffman, Arithmetic and Run-Length Coding
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  I = imread('cameraman.tif');

  %% Part A: Entropy and Huffman coding (Communications Toolbox)
  p    = imhist(I) / numel(I);
  sym = find(p > 0) - 1;                     % gray levels that occur







  prob = p(p > 0);
  H    = -sum(prob .* log2(prob));           % entropy, bits/pixel
  dict = huffmandict(sym, prob);             % Huffman code book
  code = huffmanenco(double(I(:)), dict);
  dec = huffmandeco(code, dict);
  Lavg = numel(code) / numel(I);             % average code length
  fprintf('Entropy H             = %.4f bits/pixel\n', H);
  fprintf('Average code length   = %.4f bits/pixel\n', Lavg);
  fprintf('Coding efficiency     = %.2f %%\n', 100*H/Lavg);
  fprintf('Compression ratio     = %.3f\n', 8/Lavg);
  fprintf('Lossless (decoded = original): %d\n', isequal(dec(:), double(I(:))));
  [~, ord] = sort(prob, 'descend');
  disp('Code words of the five most probable levels:');
  for k = 1:5
      fprintf(' level %3d    p = %.4f   code = %s\n', dict{ord(k),1}, ...
              prob(ord(k)), num2str(dict{ord(k),2}, '%d'));
  end

  %% Part B: Run-length coding of a binary image
  BW   = imread('text.png');
  x    = reshape(BW', 1, []);                % raster scan, row by row
  s    = [true, diff(x) ~= 0];               % start of each run
  val = x(s);                                % value of each run
  runs = diff([find(s), numel(x)+1]);        % length of each run
  rec = repelem(val, runs);                  % decoder
  bitsPerRun = ceil(log2(max(runs) + 1));
  CRrle = numel(x) / (numel(runs)*bitsPerRun + 1);
  fprintf('\nRun-length coding of text.png\n');
  fprintf('Number of runs        = %d\n', numel(runs));
  fprintf('Bits per run length   = %d\n', bitsPerRun);
  fprintf('Compression ratio     = %.2f\n', CRrle);
  fprintf('Lossless (decoded = original): %d\n', isequal(rec, x));
  disp('First 20 run lengths:'); disp(runs(1:20));

  %% Part C: Arithmetic coding of a short sequence (Communications Toolbox)
  seq    = [1 2 1 1 3 1 2 1 1 1 3 2 1 1];
  counts = accumarray(seq(:), 1)';           % symbol frequencies
  acode = arithenco(seq, counts);
  dseq   = arithdeco(acode, counts, numel(seq));
  fprintf('\nArithmetic coding: %d symbols -> %d bits (%.2f bits/symbol)\n', ...
          numel(seq), numel(acode), numel(acode)/numel(seq));
  fprintf('Decoded correctly: %d\n', isequal(seq, dseq));


 Note: Parts A and C require the Communications Toolbox (huffmandict, huffmanenco, huffmandeco, arithenco,
 arithdeco). Part B uses only base MATLAB.
