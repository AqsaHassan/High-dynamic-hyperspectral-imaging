
clc; clear; close all

pathCB = 'LinearityCheck_16bit/';
CUBEset = dir(fullfile(pathCB, '*.hdr'));

sprgtp = 10;
sprgbm = 20;

wlN = 74;

responce = zeros(size(CUBEset));

for i=1:size(CUBEset,1)
    hcube = hypercube([pathCB CUBEset(i).name]);
    line = mean(hcube.DataCube,1);
    responce(i) = mean(line(:,sprgtp:sprgbm,wlN),2);
end

exps = (4300:10000:224300)';

regression = fitlm(exps(1:14),responce(1:14));
slope =  table2array(regression.Coefficients(2,1));
intercetta =  table2array(regression.Coefficients(1,1));
linea = @(ex) (ex*slope)+intercetta;

% fplot(linea,[0 exps(end)],'r','LineWidth',2)
% hold on
plot(exps,responce,'-ob','LineWidth',1)
set(gca,'YLim',[0 65535])
set(gca,'FontSize',20)
xlabel('Exposure (µs)')
ylabel('DN-16bit')

saveas(gcf, 'check.png');