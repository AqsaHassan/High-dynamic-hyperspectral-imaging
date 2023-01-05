

two_percentile = prctile(luminosity_img,1 ,"all")
nintyeight_percentile = prctile(luminosity_img,99 ,"all")

idx_upper_values = find(luminosity_img >  nintyeight_percentile);

[rows_upper, columns_upper] = ind2sub(size(luminosity_img), idx_upper_values);
 
idx_lower_values = find(luminosity_img < two_percentile);

[rows_lower, columns_lower] = ind2sub(size(luminosity_img), idx_lower_values);

upper_mean = mean(luminosity_img(idx_upper_values),'all')*683
lower_mean = mean(luminosity_img(idx_lower_values),"all")*683

ratio_dynamic_range = upper_mean/lower_mean

visualize_lum_upper = zeros(3976, 1800);
visualize_lum_lower = zeros(3976, 1800);

visualize_lum_upper(idx_upper_values) = 1;
visualize_lum_lower(idx_lower_values) = 1;

figure
imshow(visualize_lum_lower)
figure
imshow(visualize_lum_upper)
figure
imshow(luminosity_img)








