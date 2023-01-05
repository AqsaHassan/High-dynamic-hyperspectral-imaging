
clc; clear; close all

roof = double(intmax('uint16'));

%% read dark cube

f = msgbox('Select the header of the dark cube');
movegui(f,'north')
[headN,pathCB] = uigetfile('*.hdr');
close(f)

hcube = hypercube([pathCB headN]);
darkCUBE = hcube.DataCube;

%% read object cube

f = msgbox('Select the header of the object cube');
movegui(f,'north')
[headN,pathCB] = uigetfile([pathCB '*.hdr']);
close(f)

hcube = hypercube([pathCB headN]);
objCUBE = hcube.DataCube;

%% create the dark frame

darkLINE = mean(darkCUBE,1);

darkFRAME = repmat(darkLINE,size(objCUBE,1),1,1);

%% create the dark frame

imshow(uint16(objCUBE(:,:,round(size(objCUBE,3)/2))))
title('localize the white - drag-and-drop inside its top and bottom edges');
h = imrect;
posW = getPosition(h);
close

whiteCUBE = objCUBE(round(posW(2)):round(posW(2)+posW(4)),:,:);

whiteLINE = mean(whiteCUBE,1);

whiteFRAME = repmat(whiteLINE,size(objCUBE,1),1,1);

%% flat field and save new files

ffCUBE = (double(objCUBE)-darkFRAME)./(whiteFRAME-darkFRAME);

nameOUT = ['ff_' erase(headN,[".hdr","_raw"])];

ffhcube = hypercube(uint16(ffCUBE*roof),hcube.Wavelength);

enviwrite(ffhcube,[pathCB nameOUT])
