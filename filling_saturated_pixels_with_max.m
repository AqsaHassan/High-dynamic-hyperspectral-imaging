% since at some locations # of valid entries were zero which produced NaN
% when divided by, we are replacing those NaNs by the maximum number 
% of radiance which is present for those particular wavelengths across all
% the image.

% maximum value of radiances for each wavelength
max_values_per_wavelength = squeeze(max(radiances_mean, [], [1, 2]));

% find where 0 is present
[r, c, b] = ind2sub(size(radiances_mean), find(radiances_mean == 0));

for i = 1 :  n_bands
    curr_r = r(b == i);
    curr_c = c(b == i);

    % if no NaN was found for this particular band then skip
    if isempty(curr_r)
        continue;
    end

    % converting back to linear indices for ease of filling up
    % radiances_mean
    lin_idx = sub2ind(size(radiances_mean), curr_r, curr_c, ones(size(curr_r, 1), 1)*i);

    % filling up radiances_mean with maximum values
    radiances_mean(lin_idx) = max_values_per_wavelength(i);
end