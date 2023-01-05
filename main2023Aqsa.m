clear; close all;
load('mat_files/data_Aqsa2023');
%load('mat_files/data_filters.mat');
%load('mat_files/linearity_data.mat');

% for cropped image
% digital_numbers = digital_numbers(:, :, 133 : 774, :);
% radiances = radiances(:, :, 133 : 774, :);

n_exp = 2;
n_rows = 3976;
n_cols = 1800;
n_bands = 186;

% radiances corresponding to digital_count > upper_threshold will not be
% considered while taking the mean.
% this variable is used in LUT formation.
linearity_upper_threshold = 45000;

% this variable is used in rad_combine
compensated_linearity_upper_threshold = 45000;

% Whether to use tablet mask defined in rad_combine or not
use_mask_tablet = false;

%linearity_correction;
%nd_compensation;
rad_combine;
%eq_compensation;
% spectral_interpolation;
% filling_saturated_pixels_with_max;
run('MATLABscripts\HySpex_colorIMGcalc_modified.m');
% missing_data_map;
clearvars -except radiances_mean digital_numbers radiances ;





