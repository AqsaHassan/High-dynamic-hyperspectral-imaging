% this script gets tonemapping with a vertical cut

close all;
% clear all;
white_map = imread("colorIMG_light_region_white_CIE2degCMFs.tif");
white_map = white_map(:,133:774,:);
% image = imread('image_for_TMO_Reinhard_CC.png');

% new_image = zeros(size(image));

%Convert the RGB image to a grayscale image and display it.
white_gray = rgb2gray(white_map);

%Calculate two threshold levels.
thresh = multithresh(white_gray,2);

% %Segment the image into three levels using imquantize .

% seg_I = imquantize(white_gray,thresh);

% %Convert segmented image into color image using label2rgb and display it.
% RGB = label2rgb(seg_I); 	 
% figure;
% imshow(RGB)

original_hdr = hdrimread('image_for_tonemapping_without_gamma.hdr');

% hdr_right = original_hdr(:, 241:end, :);
% hdr_left = original_hdr(:, 1:268, :);

white_gray_normalized = im2double(white_gray);
imshow(white_gray_normalized);

final_img = zeros(size(original_hdr));

final_img(:, 1:240, :) = tonemapped_left(:, 1:240, :);
final_img(:, 268:end, :) = tonemapped_right(:, 28:end, :);
final_img(:, 241:268, :) = tonemapped_right(:, 1:28, :).*white_gray_normalized(:, 241:268, :) + tonemapped_left(:, 241:end, :) .* (1 - white_gray_normalized(:, 241:268, :));

figure;
imshow(white_gray_normalized);

figure;
%final_img = GammaTMO(final_img, 2.2, 0, 0);
imshow(final_img);




