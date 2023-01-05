% this script compensates for equalizer filter in the mean radiance cube.
% this script requires data filter to be loaded first and radiance mean
% cube already calculated. It also requires n_bands, n_rows, and n_cols
% already defined.

% equalization compensation. first make the wavelength dimension as first,
% then make it 2D with dimension of (# of wavelenghts, # of rows x # of
% columns). then divide each column by filter transmitivity to get the
% compensation.
radiances_mean = reshape(permute(radiances_mean, [3, 1, 2]), n_bands, n_rows*n_cols) ./ interp_EQ_filter;

% some values of the filter might have 0 transmitivity producing NaN after
% division. Replacing those NaNs by 0.
radiances_mean(interp_EQ_filter == 0) = 0;

% Getting back radiances mean into its original structure of dimension 
% (# of rows, # of columns, # of bands)
radiances_mean = permute(reshape(radiances_mean, n_bands, n_rows, n_cols), [2, 3, 1]);

% plotting mean wavelengths spectrum for the whole image.
% plot(wavelengths, squeeze(mean(radiances_mean, [1, 2], 'omitnan')),'b');
% saveas(gcf, 'radiances mean new with nans removed and eq compensated.png');
