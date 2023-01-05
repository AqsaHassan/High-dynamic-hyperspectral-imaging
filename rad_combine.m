% this file generates mean radiance cube by using digital numbers and
% radiances got from hyspex files. For a single location (at a particular row 
% column, and wavelength of the image), the mean is taken by first summing
% up the valid (under threshold and not inside tablet mask) radiances
% across exposures and then dividing by number of valid radiances.
% this script requires digital numbers and radiances 4D cube already
% loaded. It also requires upper_threshold, n_exp, n_bands, n_rows, and
% n_cols to be defined.

% mask_flat is a 2D boolean matrix of dimension (# of exp, # of rowsx # of
% cols x # of bands). This mask represents which radiances values should be
% considered and which should be not according to the upper threshold
% defined above. In order to do this, I first convert digital_numbers to a
% single column such that its dimension is (# of exp x # of rows x # of
% cols x # of bands). Then I reshape it to (# of exp, # of rowsx # of
% cols x # of bands) and then apply the threshold.
mask_flat = reshape(digital_numbers(:), n_exp, n_rows*n_cols*n_bands) <= compensated_linearity_upper_threshold;

% % mask_tablet corresponds to mask where tablet is present in different
% exposures. The mask value in those portion is 0.
mask_tablet = ones(size(digital_numbers));
if use_mask_tablet
%     before cropping 731x900
%     mask_tablet(8:12, 1:232, 401:end, :) = 0;
%     mask_tablet(13:15, 1:731, 405:end, :) = 0;
%     mask_tablet(16:18, 1:731, 405:end, :) = 0;
%     mask_tablet(16:18, 1:345, 248:end, :) = 0;

% after cropping 731x686
      mask_tablet(8:12, 1:231, 268:end, :) = 0;

      mask_tablet(13:15, 1:731, 272:end, :) = 0;
 
      mask_tablet(16:18, 1:731, 272:end, :) = 0;
 
      mask_tablet(16:18, 1:345, 117:end, :) = 0;

end

% mask tablet reshaped to dimension of (# of exp, # of rowsx # of
% cols x # of bands). The logic is same as for mask_flat.
mask_tablet = reshape(mask_tablet(:), n_exp, n_rows*n_cols*n_bands);

% final mask is created by ANDing tablet mask and the mask obtained through
% upper threshold.
final_mask_flat = mask_tablet & mask_flat;

% radiances flattened. dimensions of (n_exp, n_rows*n_cols*n_bands)
radiances_masked_flat = reshape(radiances(:), n_exp, n_rows*n_cols*n_bands) .* final_mask_flat;

% number of valid entries flattened. dimensions of (1, n_rows*n_cols*n_bands)
% each number is number of valid entries (within threshold) in each
% location. we just apply range condition and them sum across exposure dimension
% which would give us number of entries satisfying the condition.
n_valid_entries_flat = sum(final_mask_flat, 1);

% taking average for each pixel location across the exposure dimension.
% note that the division is done according to how many entries were not
% suppressed by the final mask.
radiances_mean = sum(radiances_masked_flat, 1) ./ n_valid_entries_flat;

% since at some locations # of valid entries were zero which produced NaN
% when divided by, we are replacing those NaNs by 0.
radiances_mean(n_valid_entries_flat == 0) = 0;

% reshaping back to 3D cube of dimension (# of rows, # of columns, # of bands)
radiances_mean = reshape(radiances_mean, size(radiances, 2:4));

clearvars final_mask_flat mask_flat mask_tablet radiances_masked_flat;
