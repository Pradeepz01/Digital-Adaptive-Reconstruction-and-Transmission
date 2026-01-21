% Encoder Script
% Locates project root dynamically to find input/output folders
currentFile = mfilename('fullpath');
[matlabDir, ~, ~] = fileparts(currentFile);
projectRoot = fileparts(matlabDir);

% Step 1: Load and Normalize Image
inputPath = fullfile(projectRoot, 'input', 'nyk.jpg');
img = imread(inputPath);
img = double(img) / 255;
[rows, cols, ~] = size(img);

% Step 2: Save and Show RGB Channels
outputDir = fullfile(projectRoot, 'output');
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

writematrix(img(:,:,1), fullfile(outputDir, 'red_channel.txt'));
writematrix(img(:,:,2), fullfile(outputDir, 'green_channel.txt'));
writematrix(img(:,:,3), fullfile(outputDir, 'blue_channel.txt'));
disp('Image channels saved to text files.');

figure('Name', 'Original & RGB Channels');
subplot(2,2,1), imshow(img), title('Original Image');
subplot(2,2,2), imshow(img(:,:,1)), title('Red Channel');
subplot(2,2,3), imshow(img(:,:,2)), title('Green Channel');
subplot(2,2,4), imshow(img(:,:,3)), title('Blue Channel');

% Step 3: Shuffle Channels
timeNow = datetime('now');
timeSeed = hour(timeNow) + minute(timeNow);
rng(timeSeed); % Dynamic seed
shuffleKey = struct();
shuffledImages = zeros(rows, cols, 3);
for i = 1:3
    chName = ["red", "green", "blue"];
    channel = readmatrix(fullfile(outputDir, chName(i) + "_channel.txt"));
    vec = channel(:);
    idx = randperm(numel(vec));
    shuffledVec = vec(idx);
    reshaped = reshape(shuffledVec, size(channel));
    writematrix(reshaped, fullfile(outputDir, chName(i) + "_shuffled.txt"));
    shuffleKey.(chName(i)) = idx;
    shuffledImages(:,:,i) = reshaped;
end

dataDir = fullfile(projectRoot, 'data');
if ~exist(dataDir, 'dir')
    mkdir(dataDir);
end
save(fullfile(dataDir, 'shuffle_keys.mat'), 'shuffleKey', 'rows', 'cols', 'timeSeed');
disp('Channels shuffled and saved.');

figure('Name', 'Shuffled Channels');
subplot(1,3,1), imshow(shuffledImages(:,:,1)), title('Red Shuffled');
subplot(1,3,2), imshow(shuffledImages(:,:,2)), title('Green Shuffled');
subplot(1,3,3), imshow(shuffledImages(:,:,3)), title('Blue Shuffled');

% Step 4: Huffman Encoding
load(fullfile(dataDir, 'shuffle_keys.mat'));
encodedData = struct();
dicts = struct();
for i = 1:3
    chName = ["red", "green", "blue"];
    mat = readmatrix(fullfile(outputDir, chName(i) + "_shuffled.txt"));
    Q = 8;  % Quantization factor
    vec = uint8(round(mat(:) * 255 / Q) * Q);
    [symbols, ~, idx] = unique(vec);
    probs = histcounts(idx, 1:length(symbols)+1) / numel(vec);
    dict = huffmandict(symbols, probs);
    encoded = huffmanenco(vec, dict);
    encodedData.(chName(i)) = encoded; dicts.(chName(i)) = dict;
end
save(fullfile(dataDir, 'huffman_encoded.mat'), 'encodedData', 'dicts');
disp('Huffman encoding complete.');
