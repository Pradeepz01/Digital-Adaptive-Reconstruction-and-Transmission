% Step 1: Load and Normalize Image
img = imread('input/nyk.jpg');
img = double(img) / 255;
[rows, cols, ~] = size(img);

% Step 2: Save and Show RGB Channels
writematrix(img(:,:,1), 'output/red_channel.txt');
writematrix(img(:,:,2), 'output/green_channel.txt');
writematrix(img(:,:,3), 'output/blue_channel.txt');
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
    channel = readmatrix("output/" + chName(i) + "_channel.txt");
    vec = channel(:);
    idx = randperm(numel(vec));
    shuffledVec = vec(idx);
    reshaped = reshape(shuffledVec, size(channel));
    writematrix(reshaped, "output/" + chName(i) + "_shuffled.txt");
    shuffleKey.(chName(i)) = idx;
    shuffledImages(:,:,i) = reshaped;
end
save('data/shuffle_keys.mat', 'shuffleKey', 'rows', 'cols', 'timeSeed');
disp('Channels shuffled and saved.');
figure('Name', 'Shuffled Channels');
subplot(1,3,1), imshow(shuffledImages(:,:,1)), title('Red Shuffled');
subplot(1,3,2), imshow(shuffledImages(:,:,2)), title('Green Shuffled');
subplot(1,3,3), imshow(shuffledImages(:,:,3)), title('Blue Shuffled');

% Step 4: Huffman Encoding
load('data/shuffle_keys.mat');
encodedData = struct();
dicts = struct();
for i = 1:3
    chName = ["red", "green", "blue"];
    mat = readmatrix("output/" + chName(i) + "_shuffled.txt");
    Q = 8;  % Quantization factor
    vec = uint8(round(mat(:) * 255 / Q) * Q);
    [symbols, ~, idx] = unique(vec);
    probs = histcounts(idx, 1:length(symbols)+1) / numel(vec);
    dict = huffmandict(symbols, probs);
    encoded = huffmanenco(vec, dict);
    encodedData.(chName(i)) = encoded; dicts.(chName(i)) = dict;
end
save('data/huffman_encoded.mat', 'encodedData', 'dicts');
disp('Huffman encoding complete.');
