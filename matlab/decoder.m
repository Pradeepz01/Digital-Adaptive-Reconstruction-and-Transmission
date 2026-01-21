% Decoder Script
% Locates project root dynamically to find input/output folders
currentFile = mfilename('fullpath');
[matlabDir, ~, ~] = fileparts(currentFile);
projectRoot = fileparts(matlabDir);

dataDir = fullfile(projectRoot, 'data');
outputDir = fullfile(projectRoot, 'output');

% Step 5: Huffman Decoding
load(fullfile(dataDir, 'huffman_encoded.mat'));
load(fullfile(dataDir, 'shuffle_keys.mat'));

decodedData = struct();
decodedImgs = zeros(rows, cols, 3);
for i = 1:3
    chName = ["red", "green", "blue"];
    decodedVec = huffmandeco(encodedData.(chName(i)), dicts.(chName(i)));
    decoded = double(decodedVec) / 255;
    decodedData.(chName(i)) = decoded;
    decodedImgs(:,:,i) = reshape(decoded, rows, cols);
end
disp('Huffman decoding done.');

figure('Name', 'Decoded Channels');
subplot(1,3,1), imshow(decodedImgs(:,:,1)), title('Red Decoded');
subplot(1,3,2), imshow(decodedImgs(:,:,2)), title('Green Decoded');
subplot(1,3,3), imshow(decodedImgs(:,:,3)), title('Blue Decoded');

% Step 6: Reconstruction
finalImage = zeros(rows, cols, 3);
for i = 1:3
    chName = ["red", "green", "blue"];
    reshaped = zeros(rows * cols, 1);
    reshaped(shuffleKey.(chName(i))) = decodedData.(chName(i));
    finalImage(:,:,i) = reshape(reshaped, rows, cols);
end
reconstructedImg = uint8(finalImage * 255);
imwrite(reconstructedImg, fullfile(outputDir, 'final_reconstructed_image.png'));
disp('Final image reconstructed and saved.');
