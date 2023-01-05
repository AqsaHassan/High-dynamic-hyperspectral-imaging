% this script fuses transitory region by euclidean distance weighting
% this script uses the otsu's segmentation output.
warning('off','all');
% close all;

% loading hdr image
img = hdrimread('../image_for_tonemapping_without_gamma.hdr');

% white map loading
white_map = imread("../colorIMG_light_region_white_CIE2degCMFs.tif");
white_map = white_map(:,133:774,:);

% normalizing white map between 0 to 1
white_map = im2double(white_map);

% converting white_map to gray scale values
white_map = rgb2gray(white_map);

%% tonemapping light region
L = lum(img);
pAlpha = ReinhardAlpha(L);
pWhite = ReinhardWhitePoint(L);

img_light = ReinhardTMO(img, pAlpha, pWhite, 'bilateral');
img_light = ColorCorrection(img_light , 0.45);

% dehazing
img_light = imcomplement(img_light);
img_light = imreducehaze(img_light);
img_light = imcomplement(img_light);


%% tonemapping dark region
L = lum(img);
pAlpha = ReinhardAlpha(L);
pWhite = ReinhardWhitePoint(L);

img_dark = ReinhardTMO(img, pAlpha, pWhite, 'bilateral');
img_dark = ColorCorrectionSigmoid(img_dark,0.85, 0.9, 0.7);

% dehazing
img_dark = imcomplement(img_dark);
img_dark = imreducehaze(img_dark);
img_dark = imcomplement(img_dark);


%% creation of final image
final_img = zeros(size(img));

thresh = multithresh(white_map,2);


lin_idx = find(white_map > thresh(1) & white_map < thresh(2));
% converting linear indices to rows and columns indices for 2nd region (mid region)
[r2, c2] = ind2sub(size(white_map), lin_idx);


lin_idx = find(white_map <= thresh(1));
% converting linear indices to rows and columns indices for 1st region (dark region)
[r1, c1] = ind2sub(size(white_map), lin_idx);


lin_idx = find(white_map >= thresh(2));
% converting linear indices to rows and columns indices for 3rd region (light region)
[r3, c3] = ind2sub(size(white_map), lin_idx);


X1 = uint16([r1, c1]);
X2 = uint16([r2, c2]);
X3 = uint16([r3, c3]);



for i = 1 : size(X2, 1)
    curr_X2 = X2(i, :);

    % distances of 2nd region (mid region) from 1st (dark) and 3rd (light) regions
    dist_x1 = pdist2(curr_X2, X1);
    dist_x3 = pdist2(curr_X2, X3);

    [min_dist_x1, min_dist_x1_idx] = min(dist_x1);
    [min_dist_x3, min_dist_x3_idx] = min(dist_x3);

    min_dist_x1_rc = X1(min_dist_x1_idx, :);
    min_dist_x3_rc = X3(min_dist_x3_idx, :);

    x1_w = 1 - (min_dist_x1 / (min_dist_x1 + min_dist_x3));
    x3_w = 1 - (min_dist_x3 / (min_dist_x1 + min_dist_x3));

    final_img(curr_X2(1), curr_X2(2), :) = x1_w .* img_dark(curr_X2(1), curr_X2(2), :) ...
        + x3_w .* img_light(curr_X2(1), curr_X2(2), :);

    display(i);
end

imshow(final_img);



%% filling light and dark region

% replicating white_map values to 3d to match linear indices with img.
white_map_3d_extended = repmat(white_map, [1, 1, 3]);

% linear index for light
lin_idx_light = find(white_map_3d_extended > thresh(2));
final_img(lin_idx_light) = img_light(lin_idx_light);

lin_idx_dark = find(white_map_3d_extended < thresh(1));
final_img(lin_idx_dark) = img_dark(lin_idx_dark);

% gamma encoding
img_dark = GammaTMO(img_dark, 2.42, 0, 0);
img_light = GammaTMO(img_light, 2.42, 0, 0);
final_img = GammaTMO(final_img, 2.42, 0, 0);

montage({img_light, img_dark, final_img}, 'Size', [1, 3]);
