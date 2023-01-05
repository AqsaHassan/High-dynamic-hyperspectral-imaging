% loading hdr image
img = hdrimread('linRGBnormPenimage.hdr');
I=img;
a=2;% this value is a scaling constant for illumination of the image
Ib=mean(I(:));%background intensity(can be taken as average of the image)
linRgb_photo_tm=(I./(I+(Ib/a)));


img2 = ColorCorrection(linRgb_photo_tm , 0.95);
figure
imshow(linRgb_photo_tm)
figure
imshow(img2)