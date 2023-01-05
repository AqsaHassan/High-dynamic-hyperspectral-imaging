% this script does linear interpolation in spectral dimension across each
% spatial pixel location of our mean radiance cube.

% getting mask which has true at the spatial and spectral position in
% radiance cube where there were at least one exposure against which there
% was a valid value of radiance.
final_mask = reshape(n_valid_entries_flat, size(radiances, 2:4));
final_mask = final_mask > 0;

b = radiances_mean;

% traversing each spatial position
for r = 1:n_rows
    for c = 1:n_cols

        % get current spectrum behind each spatial position
        current_spectrum = squeeze(radiances_mean(r, c, :));
        
        % get a mask which says which values are valid in the current
        % spectrum and which are not.
        valid_mask = squeeze(final_mask(r, c, :));

        % get valid radiances from current spectrum
        valid_rad = current_spectrum(valid_mask);

        % get wavelengths against valid radiances in current spectrum
        valid_wavelength = wavelengths(valid_mask);

        % get wavelengths against which there were no valid radiances in
        % current spectrum
        missing_wavelengths = wavelengths(~valid_mask);

        % do nothing and continue if there are no invalid wavelengths .i.e.
        % all wavelengths are already filled.
        if isempty(missing_wavelengths)
            continue;
        end

        % interpolate for missing wavelengths in current spectrum. Note
        % that some values will require extrapolations. This will generate
        % NaNs in those positions and the RGB image will have black pixels
        % over there.
        recovered_missing_rad = interp1(valid_wavelength, valid_rad, missing_wavelengths);

        % replacing NaNs by 0
        recovered_missing_rad(isnan(recovered_missing_rad)) = 0;

        %placing the interpolated radiances to their respective wavelength
        %location
        current_spectrum(~squeeze(final_mask(r, c, :))) = recovered_missing_rad;

        % updating mean radiance cube
        radiances_mean(r, c, :) = reshape(current_spectrum, 1,1,n_bands);
    end
end
 
clearvars current_spectrum recovered_missing_rad missing_wavelengths valid_wavelength valid_rad valid_mask current_spectrum final_mask