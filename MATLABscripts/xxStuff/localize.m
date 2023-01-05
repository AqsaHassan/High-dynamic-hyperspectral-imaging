clc;clear;close all;

img = imread('/Users/gtrumpy/Desktop/CVCL/research/HScamera/firstTEST/cubes/raw/colorIMG_ff_ColorChecker_VNIR_1800_SN00841_HSNR2_9998us_2020-09-21T152112_CIE_D50.tif');

pos = zeros(26,4);

for i=1:26
    
imshow(img,'InitialMagnification',100)
h = imrect;
posRF = getPosition(h);
close

pos(i,:) = [round(posRF(2)),round(posRF(2)+posRF(4)),round(posRF(1)),round(posRF(1)+posRF(3))];

end