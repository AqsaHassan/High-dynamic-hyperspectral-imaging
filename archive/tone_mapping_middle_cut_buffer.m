% close all;
img = imread('img_for_tonemapping.tif');

img_d = im2double(img);

light_start_idx = 430;
buffer_length = 10;


% %  for light patch
light_patch = img_d(:, light_start_idx - buffer_length:end, :);

'light patch start from ' 
light_start_idx - buffer_length

new_light_patch = zeros(size(light_patch));

alpha_light = 0.3;
new_light_patch(light_patch < 0.5) = 0.5.*((light_patch(light_patch < 0.5)./0.5).^alpha_light);
new_light_patch(light_patch >= 0.5) = 1 - (0.5.*(((1-light_patch(light_patch >= 0.5))./0.5).^alpha_light));


% % for dark patch

dark_patch = img_d(:, 1 : light_start_idx + buffer_length, :);

'dark patch end at '
light_start_idx + buffer_length

new_dark_patch = zeros(size(dark_patch));

alpha_dark = 0.2;
new_dark_patch(dark_patch < 0.5) = 0.5.*((dark_patch(dark_patch < 0.5)./0.5).^alpha_dark);
new_dark_patch(dark_patch >= 0.5) = 1 - (0.5.*(((1-dark_patch(dark_patch >= 0.5))./0.5).^alpha_dark));


new_img = zeros(size(img_d));

new_img(:, 1 : light_start_idx + buffer_length, :) = new_dark_patch;
new_img(:, light_start_idx - buffer_length: end, :) = new_light_patch;

white_img = imread('for_tonemapping_white.tif');

white_img_d = im2double(white_img);

buffer_patch_weights = white_img_d(:, light_start_idx - buffer_length : light_start_idx + buffer_length, :);

buffer_dark_patch = new_dark_patch(:, end - 2*buffer_length : end, :);
buffer_light_patch = new_light_patch(:, 1 : 2*buffer_length + 1, :);

new_img_2 = new_img;

new_img_2(:, light_start_idx - buffer_length : light_start_idx + buffer_length, :) = ...
buffer_light_patch .* buffer_patch_weights + buffer_dark_patch .* (1 - buffer_patch_weights);

figure;
imshow(new_img_2);
