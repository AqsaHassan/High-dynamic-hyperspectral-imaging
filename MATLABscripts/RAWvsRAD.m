
clc; clear; close all

roof = double(intmax('uint16'));

%% read raw cube

pathRAW = '/Users/gtrumpy/Desktop/CVCL/research/HScamera/CCpassportTEST/cubes/raw/';
headRAW = 'ColorChecker_VNIR_1800_SN00841_HSNR2_9998us_2020-09-21T152112_raw.hdr';

hcube = hypercube([pathRAW headRAW]);
bands = hcube.Wavelength;
rawCUBE = hcube.DataCube(1626:1785,:,:);
rawLINE = squeeze(mean(rawCUBE,1));
rawSPECTR = mean(rawLINE(1200:end,:),1)';

%% read rad cube

pathRAD = '/Users/gtrumpy/Desktop/CVCL/research/HScamera/CCpassportTEST/cubes/corr/';
headRAD = 'ColorChecker_VNIR_1800_SN00841_HSNR2_9998us_2020-09-21T152112_raw_rad.hdr';

hcube = hypercube([pathRAD headRAD]);
radCUBE = hcube.DataCube(1626:1785,:,:);
radLINE = squeeze(mean(radCUBE,1));
radSPECTR = mean(radLINE(1200:end,:),1)';

%% plot

figure,plot(bands,rawSPECTR,'r','LineWidth',2)
hold on
plot(bands,radSPECTR,'b','LineWidth',2)
set(gca,'FontSize',20)
xlabel('wavelength (nm)')
ylabel('DN-16bit')
legend('raw data','radiance')