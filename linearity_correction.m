% this script requires linearity_data.mat and radiance/digital numbers 
% file to be loaded first.

% 16-bits range of digital numbers data.
dn_range = 0:65535;

% getting corresponding exposure times against each digital number value.
interp_exps = interp1(response, exps, dn_range, "spline");

% linear regression model function. It takes exposure as input and gives
% corresponding digital number as output.
ideal_linearity_fn = @(ex) (ex*slope)+intercept;

% getting digital numbers against each exposure time that we got for our
% dn_range.
dn_lookup = ideal_linearity_fn(interp_exps);


%Now we are creating LUT from dn_range to scaling factor in digital
%numbers/radiances. The first column is the digital range that we need to
%fill radiance value against. The second column is the scaling factor that
%the radiance will need to be multiplied by with in order to scale it in
%the same way as digital numbers are scaled.
dn_scaling_factor_LUT = [dn_range', (dn_lookup./dn_range)'];

% since our sensor is linear uptill upper_threshold. So we do not want to
% change radiance values against those digital numbers. Hence we make the
% scaling factor as 1.
dn_scaling_factor_LUT(1:linearity_upper_threshold, 2)= 1;

% We take our 4D digital numbers cube. linearize it into 1D. And assign the
% corresponding scaling factor in its place and make the new
% scaling_factors_flat array.
% interp1 usage inspiration for LUT mapping taken from here: 
% https://se.mathworks.com/matlabcentral/answers/224135-replace-values-in-matrix-with-values-based-on-look-up-table-without-loop
scaling_factors_flat = interp1(dn_scaling_factor_LUT(:,1), dn_scaling_factor_LUT(:,2), double(digital_numbers(:)), 'nearest');

% making the flattened scaling factors array into 4D cube.
scaling_factors = reshape(scaling_factors_flat, n_exp, n_rows, n_cols, n_bands);

% Multiplying the scaling factors with radiances.
radiances = scaling_factors .* radiances;

clearvars dn_lookup dn_range dn_scaling_factor_LUT interp_exps scaling_factors scaling_factors_flat
