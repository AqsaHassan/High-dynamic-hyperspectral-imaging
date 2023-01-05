
clc; clear; close all

roof = double(intmax('uint16'));

pos = [184 297 76 189; 171 310 336 451; 165 288 601 739; 170 296 896 1021; ...
165 288 1194 1314; 162 285 1518 1629; 471 567 87 192; 453 570 336 453; ...
453 573 609 729; 447 570 903 1008; 453 570 1188 1320; 441 564 1497 1614; ...
732 855 81 192; 732 846 342 456; 732 852 615 732; 738 849 894 1011; ...
729 840 1197 1317; 720 834 1497 1611; 1017 1122 87 204; 1017 1131 345 456; ...
1014 1128 621 735; 1005 1122 888 1005; 1002 1122 1191 1302; 996 1113 1497 1608; ...
1310 1323 721 976; 1674 1797 552 1167];

col = [115 82 68; 195 149 128; 93 123 157; 91 108 65; 130 129 175; 99 191 171; ...
220 123 46; 72 92 168; 194 84 97; 91 59 104; 161 189 62; 229 161 40; 42 63 147; ...
72 149 72; 175 50 57; 238 200 22; 188 84 150; 0 137 166; 235 235 231; 201 202 201; ...
161 162 162; 120 121 121; 83 85 85; 50 50 51; 0 0 0; 0 0 0];

%% Get the corrected cube

pathC = '/Users/gtrumpy/Desktop/CVCL/research/HScamera/firstTEST/cubes/corr/';
headC = 'ff_ColorChecker_VNIR_1800_SN00841_HSNR2_9998us_2020-09-21T152112_rad.hdr';

hcube = hypercube([pathC headC]);
CUBEcorr = hcube.DataCube;
bands = hcube.Wavelength;

spectra = zeros(186,26);

for i=1:26
    
    subCUBE = CUBEcorr(pos(i,1):pos(i,2),pos(i,3):pos(i,4),:);
    
    spectrum = squeeze(mean(subCUBE,[1 2]));
    
    spectra(:,i) = spectrum/roof;
    
end

dlmwrite([pathC 'spectra.txt'],[bands spectra],'\t')

plot(bands,spectra(:,1),'LineWidth',2,'Color',col(1,:)/255)
hold on

for i=2:26
    
    plot(bands,spectra(:,i),'LineWidth',2,'Color',col(i,:)/255)
    
end

%% Get the raw cube

pathR = '/Users/gtrumpy/Desktop/CVCL/research/HScamera/firstTEST/cubes/raw/';
headR = 'ff_ColorChecker_VNIR_1800_SN00841_HSNR2_9998us_2020-09-21T152112.hdr';

hcube = hypercube([pathR headR]);
CUBEraw = hcube.DataCube;
bands = hcube.Wavelength;

spectra = zeros(186,26);

for i=1:26
    
    subCUBE = CUBEraw(pos(i,1):pos(i,2),pos(i,3):pos(i,4),:);
    
    spectrum = squeeze(mean(subCUBE,[1 2]));
    
    spectra(:,i) = spectrum/roof;
    
end

dlmwrite([pathR 'spectra.txt'],[bands spectra],'\t')

for i=1:26
    
    plot(bands,spectra(:,i),'*','MarkerEdgeColor',col(i,:)/255)
    
end

%% Get BabelColor

pathBC = '/Users/gtrumpy/Desktop/CVCL/research/HScamera/firstTEST/';
fileBC = 'BabelColorSpectra.txt';

babel = importdata([pathBC fileBC]);

for i=1:24
    
    plot(babel(:,1),babel(:,i+1),'o','MarkerEdgeColor',col(i,:)/255)
    
end
