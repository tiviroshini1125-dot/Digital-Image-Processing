% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 11: Frequency-Domain Restoration: Notch and Band-Reject Filtering, Inverse, Wiener and Lucy–Richardson Deblurring
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  I = im2double(imread('cameraman.tif'));
  [M, N] = size(I);

  %% Part A: Periodic noise removal
  [x, y] = meshgrid(1:N, 1:M);
  In = I + 0.2*sin(2*pi*(x/8 + y/8));          % sinusoidal interference
  F = fftshift(fft2(In));
  [u, v] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
  D0 = 10; n = 4; uk = N/8; vk = M/8;          % impulses at (+32,+32), (-32,-32)
  Dk1 = sqrt((u-uk).^2 + (v-vk).^2);
  Dk2 = sqrt((u+uk).^2 + (v+vk).^2);
  Hnr = (1 ./ (1 + (D0./Dk1).^(2*n))) .* (1 ./ (1 + (D0./Dk2).^(2*n)));   % notch reject
  D   = sqrt(u.^2 + v.^2);
  C0 = sqrt(uk^2 + vk^2); W = 10;
  Hbr = 1 - exp(-((D.^2 - C0^2) ./ (D*W)).^2);                            % band reject
  gNotch = real(ifft2(ifftshift(F .* Hnr)));
  gBand = real(ifft2(ifftshift(F .* Hbr)));

  figure('Name','Periodic noise removal');
  subplot(2,3,1); imshow(In);   title(sprintf('Noisy (%.1f dB)', psnr(In, I)));
  subplot(2,3,2); imshow(log(1+abs(F)), []); title('Spectrum: note impulses');






  subplot(2,3,3); imshow(Hnr); title('Notch-reject filter');
  subplot(2,3,4); imshow(gNotch); title(sprintf('Notch output (%.1f dB)', psnr(gNotch, I)));
  subplot(2,3,5); imshow(Hbr); title('Band-reject filter');
  subplot(2,3,6); imshow(gBand); title(sprintf('Band-reject output (%.1f dB)', psnr(gBand, I)));

  %% Part B: Deblurring
  PSF = fspecial('motion', 21, 11);               % motion blur: 21 px at 11 degrees
  blur = imfilter(I, PSF, 'conv', 'circular');
  nvar = 1e-4;
  gb   = imnoise(blur, 'gaussian', 0, nvar);      % blurred and noisy observation
  fInv = deconvwnr(gb, PSF, 0);                   % inverse filter (NSR = 0)
  NSR = nvar / var(I(:));
  fWnr = deconvwnr(gb, PSF, NSR);                 % Wiener filter
  fLR = deconvlucy(gb, PSF, 20);                  % Lucy-Richardson, 20 iterations

  figure('Name','Deblurring');
  subplot(2,3,1); imshow(I);    title('Original');
  subplot(2,3,2); imshow(blur); title('Motion blurred');
  subplot(2,3,3); imshow(gb);   title(sprintf('Blurred + noise (%.1f dB)', psnr(gb, I)));
  subplot(2,3,4); imshow(fInv); title(sprintf('Inverse (%.1f dB)', psnr(fInv, I)));
  subplot(2,3,5); imshow(fWnr); title(sprintf('Wiener (%.1f dB)', psnr(fWnr, I)));
  subplot(2,3,6); imshow(fLR); title(sprintf('Lucy-Richardson (%.1f dB)', psnr(fLR, I)));
