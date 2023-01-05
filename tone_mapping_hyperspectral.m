% This script applies tonemapping on hyperspectral data. Reinhard is
% applied on individual bands and displayed.

load("check.mat");
%% tonemapping light region
L = lum_hyperspectral(radiances_mean);
pAlpha = ReinhardAlpha(L);
pWhite = ReinhardWhitePoint(L);

reinhard_tone_mapped_hyperspectral = ReinhardTMO_hyperspectral(radiances_mean, pAlpha, pWhite, 'bilateral');
run('MATLABscripts\HySpex_colorIMGcalc_modified.m')

img = hdrimread('MATLABscripts\Reinhard_tonemapped_hyperspectral.hdr');
% img_light = ColorCorrection(img , 0.5);

imshow(img);

