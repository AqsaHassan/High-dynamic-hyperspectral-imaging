
clc; clear; close all

roof = double(intmax('uint16'));

%% read dark cube

f = msgbox('Select the header of the dark cube');
movegui(f,'north')
[headN,pathCB] = uigetfile('*.hdr');
close(f)

[darkCUBE,wl] = readMSraw(headN,pathCB);

%% read object cube

f = msgbox('Select the header of the object cube');
movegui(f,'north')
[headN,pathCB] = uigetfile([pathCB '*.hdr']);
close(f)

objCUBE = readMSraw(headN,pathCB);

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

ffCUBE = (objCUBE - darkFRAME)./(whiteFRAME - darkFRAME);

nameOUT = ['ff_' erase(headN,[".hdr","_raw"])];

multibandwrite(uint16(ffCUBE*roof),[pathCB nameOUT '.hyspex'],'bil');
multibandwrite(single(ffCUBE),[pathCB nameOUT '.hyspex'],'bsq');
multibandwrite(ffCUBE,[pathCB nameOUT '.hyspex'],'bsq');


copyfile([pathCB headN],[pathCB nameOUT '.hdr']);