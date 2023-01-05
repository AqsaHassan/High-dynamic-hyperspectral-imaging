hdr_image_linear = hdrread('linRGBnormPenimage.hdr');
figure
imshow(hdr_image_linear);

%PQ encoding equation from advance high dynamic range imaging book,chap 9
ln = hdr_image_linear;
c1 = 0.8359;
c2 = 18.8516;
c3 = 18.6875;
m = 78.8434;
n = 0.1593;

ntr = ln.^(1/m)- c1;
dtr = c2-(c3*(ln.^(1/m)));

ld_1 = ntr./dtr;



final_ld = (max(ld_1,0)).^(1/n);

%ld = (((ln.^(1/m))- c1)./(c2-(c3*(ln.^(1/m))))).^(1/n);

hdrwrite(final_ld,'PQ_linRGBnormHDRPenimage.hdr')

figure
imshow(final_ld)

% rgb = tonemap(hdr_image);
% figure
% imshow(rgb)