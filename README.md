## Digital Adaptive Reconstruction and Transmission

This project demonstrates a MATLAB-based source coding and reconstruction pipeline
for image transmission.

### Pipeline
1. RGB channel separation
2. Randomized pixel permutation (obfuscation)
3. Huffman source coding
4. Decoding and inverse permutation
5. Image reconstruction and quality evaluation (PSNR, SSIM)

### Notes
- Focuses on source coding and reconstruction
- No explicit channel noise model
- Near-lossless reconstruction depending on quantization factor
