close all;
mask_tablet = ones(size(digital_numbers));


imshow(imadjust(squeeze(digital_numbers(1, :, :, 40)),[],[],0.4),[0 39145]);

% imshow(imadjust(squeeze(digital_numbers(14, :, :, 40)),[],[],0.4),[0 39145]);
% 
% imshow(imadjust(squeeze(digital_numbers(16, :, :, 40)),[],[],0.4),[0 39145]);


mask_tablet(8:12, 1:231, 268:end, :) = 0;

mask_tablet(13:15, 1:731, 272:end, :) = 0;
 
mask_tablet(16:18, 1:731, 272:end, :) = 0;
 
mask_tablet(16:18, 1:345, 117:end, :) = 0;


figure;
imshow(squeeze(mask_tablet(8, :, :, 50)));
figure;
imshow(squeeze(mask_tablet(13, :, :, 1)));
figure;
imshow(squeeze(mask_tablet(15, :, :, 1)));
figure;
imshow(squeeze(mask_tablet(16, :, :, 1)));



