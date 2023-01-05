% this script applies tonemapping on linear normalized RGB hdr img
warning('off','all');
% close all;

% loading hdr image
img = hdrimread('linRGBnormPenimage.hdr');
img_tone_hyp = hdrimread('Reinhard_tone_mapped_linRGBnormPenimage.hdr');
Penphotographic_tonemapped = hdrimread('photograpgic_tonemapped_hyperspectral_linRGBnormPenimage.hdr');
%% tonemapping Reinhard
pAlpha = ReinhardAlpha(L);
pWhite = ReinhardWhitePoint(L);
reinhard_tonemappednothyper_linRGBnormPenimage = ReinhardTMO(img, pAlpha, pWhite, 'bilateral');
img = ColorCorrection(reinhard_tonemappednothyper_linRGBnormPenimage , 0.45);
imghyper= ColorCorrection(img_tone_hyp, 0.65);
Penphotographic_tonemapped_CC = ColorCorrection(Penphotographic_tonemapped, 0.95);

figure
imshow(reinhard_tonemappednothyper_linRGBnormPenimage)
figure
imshow(img)
figure
imshow(img_tone_hyp)
figure
imshow(imghyper)

figure
imshow(Penphotographic_tonemapped)
figure
imshow(Penphotographic_tonemapped_CC)
% %% tonemapping dark region
% % dehazing
% dark_img = imcomplement(img);
% dark_img = imreducehaze(dark_img);
% dark_img = imcomplement(dark_img);
% 
% L = lum(dark_img);
% pAlpha = ReinhardAlpha(L);
% pWhite = ReinhardWhitePoint(L);
% 
% img_dark = ReinhardTMO(img, pAlpha, pWhite, 'bilateral');
% img_dark = ColorCorrectionSigmoid(img_dark,0.85, 0.9, 0.7);
% 
% %% creation of final image
% final_img = zeros(size(img));
% 
% % converting linear indices to rows and columns indices for 2nd region (mid region)
% lin_idx = find(white_map == 105);
% [r2, c2] = ind2sub(size(white_map), lin_idx);
