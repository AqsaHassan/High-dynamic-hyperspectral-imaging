%Photographic tonemapping function(read from book at page no. 244)



I=radiances_mean;
%J = imadjust(I);
a=2;% this value is a scaling constant for illumination of the image
Ib=mean(radiances_mean(:));%background intensity(can be taken as average of the image)
im4=(I./(I+(Ib/a)));
im4 = imadjust(im4);
run('MATLABscripts\HySpex_colorIMGcalc_modified.m')



photographic_tonemapped = hdrimread('MATLABscripts\photograpgic_tonemapped_hyperspectral_gamma1.hdr');
photographic_tonemapped_CC = ColorCorrection(photographic_tonemapped, 0.65);
photographic_tonemapped_CCS = ColorCorrectionSigmoid(photographic_tonemapped,0.85, 0.9, 0.7);

% dehazing
img = imcomplement(photographic_tonemapped);
img = imreducehaze(img);
img = imcomplement(img);

img_tonemapped_CC = ColorCorrection(img, 0.5);


% white map loading
white_map = rgb2gray(imread("manual_white_mask.png"));
%%
%% creation of final image
final_img = zeros(size(img));

% converting linear indices to rows and columns indices for 2nd region (mid region)
lin_idx = find(white_map == 105);
[r2, c2] = ind2sub(size(white_map), lin_idx);

% converting linear indices to rows and columns indices for 1st region (dark region)
lin_idx = find(white_map == 179);
[r1, c1] = ind2sub(size(white_map), lin_idx);

% converting linear indices to rows and columns indices for 3rd region (light region)
lin_idx = find(white_map == 226);
[r3, c3] = ind2sub(size(white_map), lin_idx);


X1 = uint16([r1, c1]);
X2 = uint16([r2, c2]);
X3 = uint16([r3, c3]);



for i = 1 : size(X2, 1)
    curr_X2 = X2(i, :);

    % distances of 2nd region (mid region) from 1st (dark) and 3rd (light) regions
    dist_x1 = pdist2(curr_X2, X1);
    dist_x3 = pdist2(curr_X2, X3);

    % getting least distance
    [min_dist_x1, min_dist_x1_idx] = min(dist_x1);
    [min_dist_x3, min_dist_x3_idx] = min(dist_x3);

    % getting the corresponding pixel from which there was minimum distance
    min_dist_x1_rc = X1(min_dist_x1_idx, :);
    min_dist_x3_rc = X3(min_dist_x3_idx, :);

    % calculating weights according to distance from light and dark region.
    % weights are inversely proportional to their distance
    x1_w = 1 - min_dist_x1 / (min_dist_x1 + min_dist_x3);
    x3_w = 1 - min_dist_x3 / (min_dist_x1 + min_dist_x3);

    % calculating transitory region
    final_img(curr_X2(1), curr_X2(2), :) = x1_w .* img_tonemapped_CC(curr_X2(1), curr_X2(2), :) ...
        + x3_w .* photographic_tonemapped(curr_X2(1), curr_X2(2), :);

    display(i);
end

%% filling light and dark region

% replicating white_map values to 3d to match linear indices with img.
white_map_3d_extended = repmat(white_map, [1, 1, 3]);

% linear index for light
lin_idx_light = find(white_map_3d_extended == 226);
final_img(lin_idx_light) = photographic_tonemapped(lin_idx_light);

lin_idx_dark = find(white_map_3d_extended == 179);
final_img(lin_idx_dark) = img_tonemapped_CC(lin_idx_dark);

% gamma encoding
img_dark = GammaTMO(img_tonemapped_CC, 2.42, 0, 0);
img_light = GammaTMO(photographic_tonemapped, 2.42, 0, 0);
final_img = GammaTMO(final_img, 2.42, 0, 0);

imshow(final_img);

photographic_tonemapped = GammaTMO(photographic_tonemapped, 2.42, 0, 0);
photographic_tonemapped_CC = GammaTMO(photographic_tonemapped_CC, 2.42, 0, 0);
img = GammaTMO(img, 2.42, 0, 0);
img_tonemapped_CC_G = GammaTMO(img_tonemapped_CC, 2.42, 0, 0);

montage({photographic_tonemapped, photographic_tonemapped_CC,img, img_tonemapped_CC})


%%
% 
% 
% montage({photographic_tonemapped, photographic_tonemapped_CC, photographic_tonemapped_CCS, img })