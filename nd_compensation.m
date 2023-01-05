% This script compensates the neutral density filter from the first
% radiance cube in the 4D radiances. Note that this updates the radiance
% 4D cube.
% This script requires digital number and radiances 4D cubes and filters
% data to be loaded first. It also requires n_bands, n_cols, and n_rows to
% be already defined.

% loading the first exposure radiance cube which was taken with nd filter.
s1_with_nd = squeeze(radiances(1, :, :, :));

% We first make the wavelength dimension to be the first one using permute.
% We then reshape this 3D cube to 2D matrix with dimensions of (# of bands,
% # of rows x # of columns). So each column is the spectrum at each spatial
% pixel. We then divide the nd filter (with # of bands values) with each
% column for compensation. Note that we are doing this to avoid using
% loops.
nd_compensated_rad_flat = reshape(permute(s1_with_nd,[3,1,2]), n_bands, n_rows * n_cols) ./ interp_nd_filter;

% % not writing this line because there seems to be no inf or nan this
% time. I also tried running the old script too and there is no nan or inf
% over there either.
% applied_mask(interp_nd_filter == 0) = 0;

% We first reshape our flattened radiances to a 3D cube where the first
% dimension is of wavelength (since that's where we flattened the data
% from). We then switch back the wavelength dimension to be the last one.
nd_compensated_rad = permute(reshape(nd_compensated_rad_flat, n_bands, n_rows, n_cols), [2, 3, 1]);

% updating the 4D radiance cube with compensated radiance cube.
radiances(1, :, :, :) = nd_compensated_rad;

% plotting the average of each wavelength in the whole image of compensated
% cube.
% plot(wavelengths, squeeze(mean(nd_compensated_rad, [1, 2], 'omitnan')),'b');

clearvars nd_compensated_rad nd_compensated_rad_flat s1_with_nd;