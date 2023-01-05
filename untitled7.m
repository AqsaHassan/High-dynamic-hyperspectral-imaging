
I=radiances_mean;
%J = imadjust(I);
a=2;% this value is a scaling constant for illumination of the image
Ib=mean(radiances_mean(:));%background intensity(can be taken as average of the image)
im4=(I./(I+(Ib/a)));

for i = 1:186
    im4(:,:,i) = imadjust(im4(:,:,i));
end
run('MATLABscripts\HySpex_colorIMGcalc_modified.m')

photographic_tonemapped_contrast_dark = hdrimread('MATLABscripts\photograpgic_tonemapped_contrast_hyperspectral.hdr');

for i = 1:186
    im4(:,:,i) = imadjust(im4(:,:,i),[0.05, 1]);
end
run('MATLABscripts\HySpex_colorIMGcalc_modified.m')

photographic_tonemapped_contrast_light = hdrimread('MATLABscripts\photograpgic_tonemapped_contrast_hyperspectral.hdr');

% white map loading
% white_map = rgb2gray(imread("manual_white_mask.png"));
% %%
% %% creation of final image
% final_img = zeros(size(img));
% 
% % converting linear indices to rows and columns indices for 2nd region (mid region)
% lin_idx = find(white_map == 105);
% [r2, c2] = ind2sub(size(white_map), lin_idx);
% 
% % converting linear indices to rows and columns indices for 1st region (dark region)
% lin_idx = find(white_map == 179);
% [r1, c1] = ind2sub(size(white_map), lin_idx);
% 
% % converting linear indices to rows and columns indices for 3rd region (light region)
% lin_idx = find(white_map == 226);
% [r3, c3] = ind2sub(size(white_map), lin_idx);
% 
% 
% X1 = uint16([r1, c1]);
% X2 = uint16([r2, c2]);
% X3 = uint16([r3, c3]);
% 
% 
% 
% for i = 1 : size(X2, 1)
%     curr_X2 = X2(i, :);
% 
%     % distances of 2nd region (mid region) from 1st (dark) and 3rd (light) regions
%     dist_x1 = pdist2(curr_X2, X1);
%     dist_x3 = pdist2(curr_X2, X3);
% 
%     % getting least distance
%     [min_dist_x1, min_dist_x1_idx] = min(dist_x1);
%     [min_dist_x3, min_dist_x3_idx] = min(dist_x3);
% 
%     % getting the corresponding pixel from which there was minimum distance
%     min_dist_x1_rc = X1(min_dist_x1_idx, :);
%     min_dist_x3_rc = X3(min_dist_x3_idx, :);
% 
%     % calculating weights according to distance from light and dark region.
%     % weights are inversely proportional to their distance
%     x1_w = 1 - min_dist_x1 / (min_dist_x1 + min_dist_x3);
%     x3_w = 1 - min_dist_x3 / (min_dist_x1 + min_dist_x3);
% 
%     % calculating transitory region
%     final_img(curr_X2(1), curr_X2(2), :) = x1_w .* photographic_tonemapped_contrast_dark(curr_X2(1), curr_X2(2), :) ...
%         + x3_w .* photographic_tonemapped_contrast_light(curr_X2(1), curr_X2(2), :);
% 
%     display(i);
% end

% %% filling light and dark region
% 
% % replicating white_map values to 3d to match linear indices with img.
% white_map_3d_extended = repmat(white_map, [1, 1, 3]);
% 
% % linear index for light
% lin_idx_light = find(white_map_3d_extended == 226);
% final_img(lin_idx_light) = photographic_tonemapped_contrast_light(lin_idx_light);
% 
% lin_idx_dark = find(white_map_3d_extended == 179);
% final_img(lin_idx_dark) = photographic_tonemapped_contrast_dark(lin_idx_dark);
% 
% % gamma encoding
% img_dark = GammaTMO(img_tonemapped_CC, 2.42, 0, 0);
% img_light = GammaTMO(photographic_tonemapped, 2.42, 0, 0);
% %final_img = GammaTMO(final_img, 2.42, 0, 0);
% 
% imshow(final_img);
% 
% img_tonemapped_CC = ColorCorrection(final_img, 0.5);
% img_tonemapped_euclidean = GammaTMO(final_img, 2.42, 0, 0);

%%
%% creation of final image
% white map loading
white_map = imread("D:\aqsa_ali_internship\cosi-internship\colorIMG_light_region_white_CIE2degCMFs.tif");
white_map = white_map(:,133:774,:);

% normalizing white map between 0 to 1
white_map = im2double(white_map);

% converting white_map to gray scale values
white_map = rgb2gray(white_map);

final_img_weighting = (photographic_tonemapped_contrast_dark .*photographic_tonemapped_contrast_light .* (max(white_map(:)) - white_map))./(max(white_map(:)) - min(white_map(:)));

final_img_weighting = GammaTMO(final_img_weighting, 2.42, 0, 0);


figure;
imshow(final_img_weighting);



