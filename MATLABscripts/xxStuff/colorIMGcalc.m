
clc; clear; close all

%% Get the cube and other data

f = msgbox('Select the header of the flat-fielded cube');
movegui(f,'north')
[headN,pathCB] = uigetfile('*.hdr');
close(f)

hcube = hypercube([pathCB headN]);
CUBE = hcube.DataCube(:,:,1:119);
[m,n,bandN] = size(CUBE);
bands = hcube.Wavelength(1:119);

pathTB = [pwd filesep 'tools' filesep];

% choose an illuminant
listILL = dir(fullfile([pathTB 'sources'],'*.txt'));
c = listdlg('PromptString','Select an illuminant:',...
                           'SelectionMode','single',...
                           'InitialValue',4, ...
                           'ListString',{listILL.name});
fullill = importdata([pathTB 'sources' filesep listILL(c).name]);
illName = erase(listILL(c).name,'.txt');

% choose an observer
listOBS = dir(fullfile([pathTB 'observers'],'*.txt'));
c = listdlg('PromptString','Select an observer:',...
                           'SelectionMode','single',...
                           'InitialValue',3, ...
                           'ListString',{listOBS.name});
fullCMFs = importdata([pathTB 'observers' filesep listOBS(c).name]);
obsName = erase(listOBS(c).name,'.txt');

% choose a destination RGB space
listDCS = dir(fullfile([pathTB 'colorSpaces_ICC'],'*.icc'));
c = listdlg('PromptString','Select a destination RGB space:',...
                           'SelectionMode','single',...
                           'InitialValue',3, ...
                           'ListString',{listDCS.name});
DCS = iccread([pathTB 'colorSpaces_ICC' filesep listDCS(c).name]);

%% calculate the RGB2XYZ transformation matrix

wtP = DCS.Header.Illuminant';
gamma = DCS.MatTRC.GreenTRC.Params;
redChr = DCS.MatTRC.RedMatrixColumn';
greenChr = DCS.MatTRC.GreenMatrixColumn';
blueChr = DCS.MatTRC.BlueMatrixColumn';

R_x = redChr(1)/sum(redChr);
R_y = redChr(2)/sum(redChr);
G_x = greenChr(1)/sum(greenChr);
G_y = greenChr(2)/sum(greenChr);
B_x = blueChr(1)/sum(blueChr);
B_y = blueChr(2)/sum(blueChr);

S = [(R_x/R_y) (G_x/G_y) (B_x/B_y); 1 1 1; ...
    ((1-R_x-R_y)/R_y) ((1-G_x-G_y)/G_y) ((1-B_x-B_y)/B_y)] \ wtP;
RGBtoXYZ = [S(1)*(R_x/R_y) S(2)*(G_x/G_y) S(3)*(B_x/B_y); S(1) S(2) S(3); ...
    S(1)*((1-R_x-R_y)/R_y) S(2)*((1-G_x-G_y)/G_y) S(3)*((1-B_x-B_y)/B_y)];

%% calculate the whitepoint from the full illuminant and observer spectra

FULLsp_tristREF = fullCMFs(:,2:end).*fullill(:,2);
FULLtristREF = sum(FULLsp_tristREF,1);
RGBref = RGBtoXYZ\FULLtristREF';
RGBref = (RGBref/max(RGBref)).^(1/gamma);

%% calculation of the RGB image

roof = double(intmax('uint16'));

lincube = reshape(double(CUBE)/roof,[],bandN);

ill = interp1(fullill(:,1),fullill(:,2),bands,'spline');

CMFs_x = interp1(fullCMFs(:,1),fullCMFs(:,2),bands,'spline');
CMFs_y = interp1(fullCMFs(:,1),fullCMFs(:,3),bands,'spline');
CMFs_z = interp1(fullCMFs(:,1),fullCMFs(:,4),bands,'spline');
CMFs = [CMFs_x CMFs_y CMFs_z];

sp_tristREF = CMFs.*ill;
tristREF = sum(sp_tristREF,1);
linWT = (RGBtoXYZ\tristREF')./max(RGBtoXYZ\tristREF');
WT = linWT.^(1/gamma);

trist = lincube * sp_tristREF;

linRGB = (RGBtoXYZ\trist')./max(RGBtoXYZ\tristREF');

RGB_gamma = linRGB.^(1/gamma);

imRGB = reshape(RGB_gamma',m,n,3);

imRGBwt = imRGB./repmat(reshape(WT,1,1,3),[m n]) ...
    .*repmat(reshape(RGBref,1,1,3),[m n]);

CUBEname = erase(headN,'.hdr');
imwrite(uint16(imRGBwt*roof), ...
    [pathCB 'colorIMG_' CUBEname '_' illName '_' obsName '.tif'],'tif')

f = warndlg(sprintf(['For the correct visualization of the tiff file,' ...
    ' assign the %s profile!'],listDCS(c).name));
waitfor(f);
