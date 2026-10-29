% ECA3606 / ECA36 DIGITAL IMAGE PROCESSING
% Register Number: 1921260022
% Experiment 8: Frequency-Domain Enhancement: 2-D DFT, Low-Pass and High-Pass Filters
% Extracted from the uploaded laboratory manual.

clc; clear; close all;
  I = im2double(imread('cameraman.tif'));
  [M, N] = size(I);

  %% Part A: 2-D DFT, spectrum and phase
  F = fft2(I);
  Fc = fftshift(F);
  figure('Name','2-D DFT');
  subplot(2,3,1); imshow(I);                       title('Image');
  subplot(2,3,2); imshow(log(1+abs(F)), []);       title('|F| uncentred (log)');
  subplot(2,3,3); imshow(log(1+abs(Fc)), []);      title('|F| centred (log)');
  subplot(2,3,4); imshow(angle(Fc), []);           title('Phase angle');
  subplot(2,3,5); imshow(real(ifft2(abs(F))), []); title('Magnitude only');
  subplot(2,3,6); imshow(real(ifft2(exp(1i*angle(F)))), []); title('Phase only');

  %% Part B: Low-pass and high-pass filtering
  [u, v] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
  D = sqrt(u.^2 + v.^2);                  % distance from the centre
  D0 = 30; n = 2;






  H{1} = double(D <= D0);                 % ideal
  H{2} = 1 ./ (1 + (D./D0).^(2*n));       % Butterworth, order n
  H{3} = exp(-(D.^2) ./ (2*D0^2));        % Gaussian
  names = {'Ideal', 'Butterworth', 'Gaussian'};

  figure('Name','Low-pass filtering');
  for k = 1:3
      g = real(ifft2(ifftshift(Fc .* H{k})));
      subplot(2,3,k);   imshow(H{k}); title([names{k} ' LPF, D_0 = 30']);
      subplot(2,3,k+3); imshow(g);    title([names{k} ' LPF output']);
  end

  figure('Name','High-pass filtering');
  for k = 1:3
      Hhp = 1 - H{k};
      g = real(ifft2(ifftshift(Fc .* Hhp)));
      subplot(2,3,k);   imshow(Hhp);   title([names{k} ' HPF']);
      subplot(2,3,k+3); imshow(g, []); title([names{k} ' HPF output']);
  end

  %% Part C: Butterworth LPF as a surface
  figure('Name','BLPF surface');
  mesh(u(1:4:end,1:4:end), v(1:4:end,1:4:end), H{2}(1:4:end,1:4:end));
  xlabel('u'); ylabel('v'); zlabel('H(u,v)'); title('Butterworth LPF, n = 2');
