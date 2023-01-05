% global dehazing with local and global gamma mapping
% this script uses the whole white paper image as weights
close all;

% loading hdr image
img = hdrimread('../image_for_tonemapping_without_gamma.hdr');

% white map loading
white_map = imread("../colorIMG_light_region_white_CIE2degCMFs.tif");
white_map = white_map(:,133:774,:);

% % One variation: applying gaussian filter on img to use as mask;
% mask_size = [10, 10];
% white_map = img;
% white_map(:, :, 1) = medfilt2(white_map(:, :, 1), mask_size);
% white_map(:, :, 2) = medfilt2(white_map(:, :, 2), mask_size);
% white_map(:, :, 3) = medfilt2(white_map(:, :, 3), mask_size);
% white_map = imgaussfilt(white_map, 50);

% % Second variation: getting illumination map
% white_map = imread("img_for_tonemapping.tif");
% white_map = white_map(:,133:774,:);
% white_map = imcomplement(white_map);
% [~, white_map] = imreducehaze(white_map,'Method','approxdcp','ContrastEnhancement', 'none');
% white_map = imcomplement(white_map);

% normalizing white map between 0 to 1
white_map = im2double(white_map);

% converting white_map to gray scale values
white_map = rgb2gray(white_map);

% dehazing
img = imcomplement(img);
img = imreducehaze(img);
img = imcomplement(img);


%% tonemapping light region
L = lum(img);
pAlpha = ReinhardAlpha(L);
pWhite = ReinhardWhitePoint(L);

img_light = ReinhardTMO(img, pAlpha, pWhite, 'bilateral');
img_light = ColorCorrection(img_light , 0.45);

%% tonemapping dark region
L = lum(img);
pAlpha = ReinhardAlpha(L);
pWhite = ReinhardWhitePoint(L);

img_dark = ReinhardTMO(img, pAlpha, pWhite, 'bilateral');
img_dark = ColorCorrectionSigmoid(img_dark,0.85, 0.9, 0.7);


%% creation of final image
final_img = (img_light .* white_map + img_dark .* (max(white_map(:)) - white_map))./(max(white_map(:)) - min(white_map(:)));

final_img = GammaTMO(final_img, 2.42, 0, 0);


figure;
imshow(final_img);

