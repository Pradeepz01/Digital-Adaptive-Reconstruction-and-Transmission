% Step 7: Visualization and Quality Metrics
% Visualize Original vs Final Image
originalImg = imread('input/nyk.jpg');
finalImage = imread('output/final_reconstructed_image.png');

figure('Name', 'Original vs Final Image');
subplot(1,2,1), imshow(originalImg), title('Original Image');
subplot(1,2,2), imshow(finalImage), title('Final Reconstructed');

% Convert to double for PSNR/SSIM calculation
originalImgDouble = im2double(originalImg);
finalImageDouble = im2double(finalImage);

% PSNR & SSIM
psnrValue = psnr(finalImageDouble, originalImgDouble);
ssimValue = ssim(finalImageDouble, originalImgDouble);
fprintf('PSNR: %.2f dB\n', psnrValue);
fprintf('SSIM: %.4f\n', ssimValue);
