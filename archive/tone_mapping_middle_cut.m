% close all;
img = imread('img_for_tonemapping.tif');

img_d = im2double(img);

light_start_idx = 430;


% %  for light patch
light_patch = img_d(:, light_start_idx: end, :);

new_light_patch = zeros(size(light_patch));

alpha_light = 0.3;
new_light_patch(light_patch < 0.5) = 0.5.*((light_patch(light_patch < 0.5)./0.5).^alpha_light);
new_light_patch(light_patch >= 0.5) = 1 - (0.5.*(((1-light_patch(light_patch >= 0.5))./0.5).^alpha_light));


% % for dark patch

dark_patch = img_d(:, 1 : light_start_idx - 1, :);

new_dark_patch = zeros(size(dark_patch));

alpha_dark = 0.2;
new_dark_patch(dark_patch < 0.5) = 0.5.*((dark_patch(dark_patch < 0.5)./0.5).^alpha_dark);
new_dark_patch(dark_patch >= 0.5) = 1 - (0.5.*(((1-dark_patch(dark_patch >= 0.5))./0.5).^alpha_dark));


new_img = zeros(size(img_d));

new_img(:, 1 : light_start_idx - 1 , :) = new_dark_patch;
new_img(:, light_start_idx: end, :) = new_light_patch;

imshow(new_img);
