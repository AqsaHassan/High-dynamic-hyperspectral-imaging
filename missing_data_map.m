% this file generates heat map which shows how much missing spectrum values
% are there behind each pixel.

% hdr rgb image against which heatmap is to be shown. This will be used for
% overlaying heatmap.
hdr_img = imread('MATLABscripts/colorIMG_check_CIE2degCMFs.tif');

% # of valid entries in each pixel/wavelength location.
n_valid_entries = reshape(n_valid_entries_flat, [n_rows, n_cols, n_bands]);

% creating map against each pixel which assigns each spatial pixel location
% number of zero values in spectrum.
valid_entries_map = sum(n_valid_entries == 0, 3);

% plotting
alpha = ones(size(valid_entries_map)) .* 0.5;
imshow(hdr_img);
hold on
overlay_img = imshow( valid_entries_map );
caxis auto  
colormap( overlay_img.Parent, jet );
colorbar( overlay_img.Parent );
set( overlay_img, 'AlphaData', alpha );